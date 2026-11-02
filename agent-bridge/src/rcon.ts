// Minecraft RCON client. Requests go out one at a time: the server closes
// the connection if a second packet arrives before it has answered the first.
import { connect, type Socket } from "node:net";

const LOGIN = 3;
const COMMAND = 2;
// The server answers a request of an unknown type with "Unknown request",
// after any earlier response, so one is sent after each command to mark
// where a multi-packet response ends
const SENTINEL_TYPE = 0;
const SENTINEL_ID = 0x7fff;
// The server splits a response body into packets of this many characters
const MAX_BODY = 4096;
// The server reads each request into a buffer this size and drops the
// connection if a packet doesn't fit
const MAX_REQUEST = 1460;
const TIMEOUT_MS = 10_000;

type Packet = { id: number; body: string };
type Waiter = { resolve: (p: Packet) => void; reject: (e: Error) => void };
export type Run = (command: string, timeoutMs?: number) => Promise<string>;

export function encode(id: number, type: number, body: string): Buffer {
  const payload = Buffer.from(body, "utf8");
  const buf = Buffer.alloc(14 + payload.length);
  buf.writeInt32LE(10 + payload.length, 0);
  buf.writeInt32LE(id, 4);
  buf.writeInt32LE(type, 8);
  payload.copy(buf, 12);
  return buf;
}

export class Rcon {
  private socket?: Socket;
  private buffer = Buffer.alloc(0);
  private waiting: Waiter[] = [];
  private received: Packet[] = [];
  private queue: Promise<unknown> = Promise.resolve();
  private nextId = 1;

  constructor(
    private host: string,
    private port: number,
    private password: string,
    private timeoutMs = TIMEOUT_MS,
  ) {}

  /** Runs one command and returns the server's response text. */
  run(command: string, timeoutMs?: number): Promise<string> {
    return this.exclusive((run) => run(command, timeoutMs));
  }

  /** Runs fn with no other command in between its own. */
  exclusive<T>(fn: (run: Run) => Promise<T>): Promise<T> {
    const result = this.queue.then(() => fn((command, timeoutMs) => this.runNow(command, timeoutMs)));
    this.queue = result.catch(() => {});
    return result;
  }

  close(reason = new Error("RCON connection closed")) {
    const socket = this.socket;
    this.socket = undefined;
    socket?.destroy();
    const waiting = this.waiting;
    this.waiting = [];
    for (const w of waiting) w.reject(reason);
  }

  private async runNow(command: string, timeoutMs = this.timeoutMs): Promise<string> {
    const request = encode(this.id(), COMMAND, command);
    if (request.length > MAX_REQUEST) {
      throw new Error(`command is ${request.length - 14} bytes; RCON allows ${MAX_REQUEST - 14}`);
    }
    if (!this.socket) await this.open();
    try {
      this.socket!.write(request);
      const parts = [(await this.receive(timeoutMs)).body];
      this.socket!.write(encode(SENTINEL_ID, SENTINEL_TYPE, ""));
      for (;;) {
        const p = await this.receive();
        if (p.id === SENTINEL_ID) return parts.join("");
        // A body of exactly MAX_BODY characters was cut off and continues in
        // this packet; anything shorter ended a message of its own
        if (parts.at(-1)!.length < MAX_BODY) parts.push("\n");
        parts.push(p.body);
      }
    } catch (e) {
      // Reconnect on the next command
      this.close(e as Error);
      throw e;
    }
  }

  private id() {
    this.nextId = this.nextId >= SENTINEL_ID - 1 ? 1 : this.nextId + 1;
    return this.nextId;
  }

  private async open() {
    this.buffer = Buffer.alloc(0);
    this.received = [];
    const socket = connect(this.port, this.host);
    await new Promise<void>((resolve, reject) => {
      const timer = setTimeout(() => {
        socket.destroy();
        reject(new Error(`no RCON server answered at ${this.host}:${this.port}`));
      }, this.timeoutMs);
      socket.once("connect", () => (clearTimeout(timer), resolve()));
      socket.once("error", (e) => (clearTimeout(timer), reject(e)));
    });
    // A late event from an earlier socket must not fail this one's commands
    socket.on("data", (chunk) => this.socket === socket && this.onData(chunk));
    socket.on("close", () => this.socket === socket && this.close());
    socket.on("error", (e) => this.socket === socket && this.close(e));
    this.socket = socket;
    socket.write(encode(this.id(), LOGIN, this.password));
    const reply = await this.receive();
    if (reply.id === -1) {
      this.close();
      throw new Error("RCON login failed: wrong password");
    }
  }

  private onData(chunk: Buffer) {
    this.buffer = Buffer.concat([this.buffer, chunk]);
    while (this.buffer.length >= 4) {
      const length = this.buffer.readInt32LE(0);
      if (this.buffer.length < 4 + length) break;
      const packet = {
        id: this.buffer.readInt32LE(4),
        body: this.buffer.subarray(12, 4 + length - 2).toString("utf8"),
      };
      this.buffer = this.buffer.subarray(4 + length);
      const waiter = this.waiting.shift();
      if (waiter) waiter.resolve(packet);
      else this.received.push(packet);
    }
  }

  private receive(timeoutMs = this.timeoutMs): Promise<Packet> {
    const ready = this.received.shift();
    if (ready) return Promise.resolve(ready);
    return new Promise((resolve, reject) => {
      const timer = setTimeout(
        () => this.close(new Error(`RCON server didn't answer within ${timeoutMs} ms`)),
        timeoutMs,
      );
      this.waiting.push({
        resolve: (p) => (clearTimeout(timer), resolve(p)),
        reject: (e) => (clearTimeout(timer), reject(e)),
      });
    });
  }
}
