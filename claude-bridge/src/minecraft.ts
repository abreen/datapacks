import type { Rcon } from "./rcon";
import { toSnbt } from "./snbt";

const NAME = /^[A-Za-z0-9_]{1,16}$/;
const API_NAME = /^[a-z0-9_/]+$/;

/**
 * Calls a claude_api data pack function. The arguments go through storage
 * so the bridge does the SNBT escaping, not the macro substitution.
 */
export async function callApi(rcon: Rcon, name: string, args: Record<string, unknown> = {}) {
  if (!API_NAME.test(name)) throw new Error(`bad API name ${name}`);
  await rcon.run(`data modify storage claude_api:in args set value ${toSnbt(args)}`);
  const ran = await rcon.run(`function claude_api:api/${name} with storage claude_api:in args`);
  const result = await rcon.run("data get storage claude_api:out result");
  return { ran, result: afterColon(result) };
}

/** Online players with their position and dimension. */
export async function players(rcon: Rcon) {
  // "There are 1 of a max of 20 players online: Alex"
  const list = afterColon(await rcon.run("list"));
  const names = list.split(",").map((n) => n.trim()).filter((n) => NAME.test(n));
  const out = [];
  for (const name of names) {
    out.push({
      name,
      pos: afterColon(await rcon.run(`data get entity ${name} Pos`)),
      dimension: afterColon(await rcon.run(`data get entity ${name} Dimension`)),
    });
  }
  return out;
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
