import { afterAll, expect, test } from "bun:test";
import { createServer, type Socket } from "node:net";
import { Rcon, encode } from "../src/rcon";

// A fake server that behaves like Minecraft's: one reply per packet, long
// replies split in two, and "Unknown request" for unknown packet types
const fake = createServer((socket: Socket) => {
  let buffer = Buffer.alloc(0);
  socket.on("data", (chunk) => {
    buffer = Buffer.concat([buffer, chunk]);
    while (buffer.length >= 4 && buffer.length >= 4 + buffer.readInt32LE(0)) {
      const length = buffer.readInt32LE(0);
      const id = buffer.readInt32LE(4);
      const type = buffer.readInt32LE(8);
      const body = buffer.subarray(12, 4 + length - 2).toString();
      buffer = buffer.subarray(4 + length);
      if (type === 3) socket.write(encode(body === "secret" ? id : -1, 2, ""));
      else if (type === 2 && body === "long") {
        socket.write(encode(id, 0, "first half, "));
        socket.write(encode(id, 0, "second half"));
      } else if (type === 2) socket.write(encode(id, 0, `ran ${body}`));
      else socket.write(encode(id, 0, "Unknown request"));
    }
  });
});
await new Promise<void>((r) => fake.listen(0, "127.0.0.1", r));
const port = (fake.address() as { port: number }).port;
afterAll(() => fake.close());

test("runs commands in order", async () => {
  const rcon = new Rcon("127.0.0.1", port, "secret");
  const replies = await Promise.all(["a", "b", "c"].map((c) => rcon.run(c)));
  expect(replies).toEqual(["ran a", "ran b", "ran c"]);
  rcon.close();
});

test("joins a reply split over packets", async () => {
  const rcon = new Rcon("127.0.0.1", port, "secret");
  expect(await rcon.run("long")).toBe("first half, second half");
  rcon.close();
});

test("rejects a wrong password", async () => {
  const rcon = new Rcon("127.0.0.1", port, "nope");
  await expect(rcon.run("a")).rejects.toThrow("wrong password");
});
