import type { Rcon, Run } from "./rcon";
import { toSnbt } from "./snbt";

const API_NAME = /^[a-z0-9_]+(\/[a-z0-9_]+)*$/;
// "Alex (069a79f4-44e9-4726-a5be-fca90e38aaf5)"; list without uuids shows
// display names, which carry team prefixes
const NAME_AND_UUID = /([A-Za-z0-9_]{1,16}) \(([0-9a-f-]{36})\)/g;

/**
 * Calls a claude_api data pack function. The arguments go through storage
 * so the bridge does the SNBT escaping, not the macro substitution.
 */
export function callApi(rcon: Rcon, name: string, args: Record<string, unknown> = {}) {
  if (!API_NAME.test(name)) throw new Error(`bad API name ${name}`);
  for (const [key, value] of Object.entries(args)) checkArg(key, value);
  // One exclusive run, so parallel calls can't swap each other's arguments
  // or results
  return rcon.exclusive(async (run) => {
    // Cleared first, so a call that fails can't return the last call's result
    await run("data remove storage claude_api:out result");
    await run(`data modify storage claude_api:in args set value ${toSnbt(args)}`);
    const ran = await run(`function claude_api:api/${name} with storage claude_api:in args`);
    const got = await run("data get storage claude_api:out result");
    const result = got.includes("has the following contents: ") ? afterColon(got) : null;
    return { ran, result };
  });
}

// Macros paste arguments into the command as text, so a space could add
// words such as `run <command>`. Coordinates must be whole numbers.
function checkArg(key: string, value: unknown) {
  if (typeof value === "number" && Number.isInteger(value)) return;
  if (typeof value === "string" && !/\s/.test(value)) return;
  throw new Error(`argument ${key} must be a whole number or a string without spaces`);
}

/** Whether claude_api:config/disable is off. True if the pack isn't loaded. */
export async function writesAllowed(run: Run) {
  const got = await run("scoreboard players get #enabled claude_api.config");
  return got.match(/has (-?\d+)/)?.[1] !== "0";
}

/**
 * Runs console commands in order, stopping at the first that throws. Earlier
 * responses are kept, so it's clear which commands already ran.
 */
export function runCommands(rcon: Rcon, commands: string[]) {
  return rcon.exclusive(async (run) => {
    if (!(await writesAllowed(run))) {
      throw new Error("Claude's commands are turned off in game (claude_api:config/disable)");
    }
    const out: { command: string; response?: string; error?: string }[] = [];
    for (const command of commands) {
      try {
        out.push({ command, response: await run(command) });
      } catch (e) {
        out.push({ command, error: (e as Error).message });
        break;
      }
    }
    return out;
  });
}

/** Online players with their position and dimension. */
export function players(rcon: Rcon) {
  return rcon.exclusive(async (run) => {
    const list = await run("list uuids");
    const out = [];
    for (const [, name, uuid] of list.matchAll(NAME_AND_UUID)) {
      out.push({
        name,
        pos: afterColon(await run(`data get entity ${uuid} Pos`)),
        dimension: afterColon(await run(`data get entity ${uuid} Dimension`)),
      });
    }
    return out;
  });
}

/** Shows a chat message from Claude to everyone. */
export function say(rcon: Rcon, text: string) {
  const message = [{ text: "<Claude> ", color: "aqua" }, { text }];
  return rcon.run(`tellraw @a ${toSnbt(message)}`);
}

// "Storage claude_api:out has the following contents: {ok: 1b}" -> "{ok: 1b}"
function afterColon(s: string) {
  const i = s.indexOf(": ");
  return i === -1 ? s : s.slice(i + 2);
}

/** Non-player entities in a box: their name and position, one line each. */
export function entities(rcon: Rcon, box: { x1: number; y1: number; z1: number; x2: number; y2: number; z2: number }) {
  for (const v of Object.values(box)) {
    if (!Number.isInteger(v)) throw new Error("box corners must be whole numbers");
  }
  const x = Math.min(box.x1, box.x2), y = Math.min(box.y1, box.y2), z = Math.min(box.z1, box.z2);
  const dx = Math.abs(box.x2 - box.x1), dy = Math.abs(box.y2 - box.y1), dz = Math.abs(box.z2 - box.z1);
  // Each entity answers with "<name> has the following entity data: [x, y, z]".
  // Only entities in loaded chunks are found.
  return rcon.run(
    `execute as @e[type=!minecraft:player,x=${x},y=${y},z=${z},dx=${dx},dy=${dy},dz=${dz}] run data get entity @s Pos`,
  );
}
