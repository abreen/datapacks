import { afterAll, expect, test } from "bun:test";
import { Rcon } from "../src/rcon";
import { callApi, entities, players, runCommands } from "../src/minecraft";
import { fakeServer } from "./fake";

let enabled: number | null = 1;
let stored = false;
const { server, port, log } = await fakeServer((command) => {
  if (command.startsWith("scoreboard players get")) {
    return enabled === null ? "Can't get value of #enabled for claude_api.config; none is set" : `#enabled has ${enabled} [claude_api.config]`;
  }
  if (command === "data remove storage claude_api:out result") {
    stored = false;
    return "Modified storage claude_api:out";
  }
  if (command === "function claude_api:api/ping with storage claude_api:in args") {
    stored = true;
    return "Running function claude_api:api/pingFunction claude_api:api/ping returned 1";
  }
  if (command.startsWith("function claude_api:api/entities")) return "Running function claude_api:api/entities";
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
  const ping = await callApi(rcon, "ping");
  expect(ping.result).toBe("{ok: 1b}");
  expect(ping.ran).toBe("Running function claude_api:api/ping\nFunction claude_api:api/ping returned 1");
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

test("runCommands is refused while the pack is disabled or missing", async () => {
  for (const state of [0, null]) {
    enabled = state;
    const before = log.length;
    await expect(runCommands(rcon, ["a"])).rejects.toThrow("turned off");
    expect(log.slice(before)).not.toContain("a");
  }
  enabled = 1;
});

test("entities passes the box as a corner and size", async () => {
  await entities(rcon, { x1: 8, y1: 70, z1: 8, x2: -8, y2: 60, z2: -8 });
  expect(log).toContain("data modify storage claude_api:in args set value {x:-8,y:60,z:-8,dx:16,dy:10,dz:16}");
});
