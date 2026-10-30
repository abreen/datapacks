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
// The server splits a response body into packets of this many bytes
const MAX_BODY = 4096;

type Packet = { id: number; body: string };

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
  private waiting: ((p: Packet) => void)[] = [];
  private received: Packet[] = [];
  private queue: Promise<unknown> = Promise.resolve();
  private nextId = 1;

  constructor(
    private host: string,
    private port: number,
    private password: string,
  ) {}

  /** Runs one command and returns the server's response text. */
  run(command: string): Promise<string> {
    const result = this.queue.then(() => this.runNow(command));
    this.queue = result.catch(() => {});
    return result;
  }

  close() {
    this.socket?.destroy();
    this.socket = undefined;
  }

  private async runNow(command: string): Promise<string> {
    if (!this.socket) await this.open();
    try {
      const id = this.id();
      this.socket!.write(encode(id, COMMAND, command));
      const parts = [(await this.receive()).body];
      this.socket!.write(encode(SENTINEL_ID, SENTINEL_TYPE, ""));
      for (;;) {
        const p = await this.receive();
        if (p.id === SENTINEL_ID) return parts.join("");
        // A body of exactly MAX_BODY bytes was cut off and continues in this
        // packet; anything shorter ended a message of its own
        if (Buffer.byteLength(parts.at(-1)!) < MAX_BODY) parts.push("\n");
        parts.push(p.body);
      }
    } catch (e) {
      // Reconnect on the next command
      this.close();
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
      socket.once("connect", resolve);
      socket.once("error", reject);
    });
    socket.on("data", (chunk) => this.onData(chunk));
    socket.on("close", () => this.fail(new Error("RCON connection closed")));
    socket.on("error", (e) => this.fail(e));
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
      if (waiter) waiter(packet);
      else this.received.push(packet);
    }
  }

  private failures: ((e: Error) => void)[] = [];

  private fail(e: Error) {
    const rejects = this.failures;
    this.failures = [];
    this.waiting = [];
    this.socket = undefined;
    for (const reject of rejects) reject(e);
  }

  private receive(): Promise<Packet> {
    const ready = this.received.shift();
    if (ready) return Promise.resolve(ready);
    return new Promise((resolve, reject) => {
      const done = (p: Packet) => {
        this.failures = this.failures.filter((f) => f !== reject);
        resolve(p);
      };
      this.waiting.push(done);
      this.failures.push(reject);
    });
  }
}
