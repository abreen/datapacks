import { afterAll, expect, test } from "bun:test";
import { Rcon } from "../src/rcon";
import { callApi, players, runCommands } from "../src/minecraft";
import { fakeServer } from "./fake";

let enabled = 1;
let stored = false;
const { server, port, log } = await fakeServer((command) => {
  if (command.startsWith("scoreboard players get")) return `#enabled has ${enabled} [claude_api.config]`;
  if (command === "data remove storage claude_api:out result") {
    stored = false;
    return "Modified storage claude_api:out";
  }
  if (command === "function claude_api:api/ping with storage claude_api:in args") {
    stored = true;
    return "Running function claude_api:api/ping";
  }
  if (command === "data get storage claude_api:out result") {
    return stored ? "Storage claude_api:out has the following contents: {ok: 1b}" : "Found no elements matching result";
  }
  if (command === "list uuids") {
    return "There are 2 of a max of 20 players online: Alex (069a79f4-44e9-4726-a5be-fca90e38aaf5), Sam_2 (11111111-2222-3333-4444-555555555555)";
  }
  if (command.startsWith("data get entity 069a")) return command.endsWith("Pos") ? "Alex has the following entity data: [1.0d, 64.0d, 2.0d]" : 'Alex has the following entity data: "minecraft:overworld"';
  if (command.startsWith("data get entity 1111")) return command.endsWith("Pos") ? "Sam_2 has the following entity data: [0.0d, 70.0d, 0.0d]" : 'Sam_2 has the following entity data: "minecraft:the_nether"';
  return `ran ${command}`;
});
const rcon = new Rcon("127.0.0.1", port, "secret");
afterAll(() => (rcon.close(), server.close()));

test("callApi clears the last result first", async () => {
  expect((await callApi(rcon, "ping")).result).toBe("{ok: 1b}");
  // A function that doesn't exist writes nothing, so its result is null
  expect((await callApi(rcon, "missing")).result).toBeNull();
});

test("callApi refuses arguments that could add words to a macro", async () => {
  expect(() => callApi(rcon, "test_block", { x: 0, y: 0, z: 0, block: "stone run say hi" })).toThrow("without spaces");
  expect(() => callApi(rcon, "setblock", { x: 0.5, y: 0, z: 0, block: "stone" })).toThrow("whole number");
  expect(() => callApi(rcon, "../x")).toThrow("bad API name");
});

test("players reads names without team prefixes", async () => {
  expect(await players(rcon)).toEqual([
    { name: "Alex", pos: "[1.0d, 64.0d, 2.0d]", dimension: '"minecraft:overworld"' },
    { name: "Sam_2", pos: "[0.0d, 70.0d, 0.0d]", dimension: '"minecraft:the_nether"' },
  ]);
});

test("runCommands keeps earlier responses when one fails", async () => {
  const out = await runCommands(rcon, ["a", "say " + "x".repeat(2000), "c"]);
  expect(out[0]).toEqual({ command: "a", response: "ran a" });
  expect(out[1].error).toContain("RCON allows");
  expect(out).toHaveLength(2);
});

test("runCommands is refused while the pack is disabled", async () => {
  enabled = 0;
  const before = log.length;
  await expect(runCommands(rcon, ["a"])).rejects.toThrow("turned off");
  expect(log.slice(before)).not.toContain("a");
  enabled = 1;
});
