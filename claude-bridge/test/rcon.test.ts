import { afterAll, expect, test } from "bun:test";
import { Rcon } from "../src/rcon";
import { fakeServer } from "./fake";

const { server, port } = await fakeServer((command) => {
  if (command === "long") return ["x".repeat(4096), "y"];
  if (command === "two") return ["Running function f", "Function f returned 1"];
  if (command === "hang") return null;
  return `ran ${command}`;
});
afterAll(() => server.close());

test("runs commands in order", async () => {
  const rcon = new Rcon("127.0.0.1", port, "secret");
  const replies = await Promise.all(["a", "b", "c"].map((c) => rcon.run(c)));
  expect(replies).toEqual(["ran a", "ran b", "ran c"]);
  rcon.close();
});

test("joins a reply split over packets", async () => {
  const rcon = new Rcon("127.0.0.1", port, "secret");
  expect(await rcon.run("long")).toBe("x".repeat(4096) + "y");
  rcon.close();
});

test("puts separate messages on their own lines", async () => {
  const rcon = new Rcon("127.0.0.1", port, "secret");
  expect(await rcon.run("two")).toBe("Running function f\nFunction f returned 1");
  rcon.close();
});

test("rejects a wrong password", async () => {
  const rcon = new Rcon("127.0.0.1", port, "nope");
  await expect(rcon.run("a")).rejects.toThrow("wrong password");
});

test("refuses a command too long for the server", async () => {
  const rcon = new Rcon("127.0.0.1", port, "secret");
  await expect(rcon.run("say " + "x".repeat(2000))).rejects.toThrow("RCON allows");
  // The connection is still usable
  expect(await rcon.run("a")).toBe("ran a");
  rcon.close();
});

test("times out when the server doesn't answer, then recovers", async () => {
  const rcon = new Rcon("127.0.0.1", port, "secret", 200);
  await expect(rcon.run("hang")).rejects.toThrow("didn't answer");
  expect(await rcon.run("a")).toBe("ran a");
  rcon.close();
});

test("exclusive keeps other commands out", async () => {
  const rcon = new Rcon("127.0.0.1", port, "secret");
  const order: string[] = [];
  const first = rcon.exclusive(async (run) => {
    order.push(await run("1"));
    await Bun.sleep(20);
    order.push(await run("2"));
  });
  const second = rcon.run("3").then((r) => order.push(r));
  await Promise.all([first, second]);
  expect(order).toEqual(["ran 1", "ran 2", "ran 3"]);
  rcon.close();
});
