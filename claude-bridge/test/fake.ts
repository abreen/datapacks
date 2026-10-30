// A fake RCON server that behaves like Minecraft's: one reply per packet,
// "Unknown request" for unknown packet types, and replies chosen by respond
import { createServer, type Server, type Socket } from "node:net";
import { encode } from "../src/rcon";

export type Respond = (command: string) => string | string[] | null;

export async function fakeServer(respond: Respond): Promise<{ server: Server; port: number; log: string[] }> {
  const log: string[] = [];
  const server = createServer((socket: Socket) => {
    let buffer = Buffer.alloc(0);
    socket.on("data", (chunk) => {
      buffer = Buffer.concat([buffer, chunk]);
      while (buffer.length >= 4 && buffer.length >= 4 + buffer.readInt32LE(0)) {
        const length = buffer.readInt32LE(0);
        const id = buffer.readInt32LE(4);
        const type = buffer.readInt32LE(8);
        const body = buffer.subarray(12, 4 + length - 2).toString();
        buffer = buffer.subarray(4 + length);
        if (type === 3) {
          socket.write(encode(body === "secret" ? id : -1, 2, ""));
        } else if (type === 2) {
          log.push(body);
          const reply = respond(body);
          // null: never answer
          if (reply === null) continue;
          for (const part of [reply].flat()) socket.write(encode(id, 0, part));
        } else socket.write(encode(id, 0, "Unknown request"));
      }
    });
  });
  await new Promise<void>((r) => server.listen(0, "127.0.0.1", r));
  return { server, port: (server.address() as { port: number }).port, log };
}
