// MCP server that gives Claude Code a Minecraft server's console over RCON.
// Settings: RCON_HOST (default 127.0.0.1), RCON_PORT (25575), RCON_PASSWORD.
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { Rcon } from "./rcon";
import { callApi, players, runCommands, say } from "./minecraft";

const password = process.env.RCON_PASSWORD;
if (!password) {
  console.error("claude-bridge: set RCON_PASSWORD");
  process.exit(1);
}
const rcon = new Rcon(
  process.env.RCON_HOST ?? "127.0.0.1",
  Number(process.env.RCON_PORT ?? 25575),
  password,
);

const server = new McpServer({ name: "minecraft", version: "0.1.0" });

const text = (value: unknown) => ({
  content: [{ type: "text" as const, text: typeof value === "string" ? value : JSON.stringify(value, null, 2) }],
});

server.registerTool(
  "run_commands",
  {
    description:
      "Run Minecraft commands on the server console (no leading slash), in order, and return each response. Stops at the first command that fails to send. Commands run at the world spawn as the server. Refused while claude_api:config/disable is on.",
    inputSchema: { commands: z.array(z.string()).min(1) },
  },
  async ({ commands }) => text(await runCommands(rcon, commands)),
);

server.registerTool(
  "call_api",
  {
    description:
      "Call a claude_api data pack function, e.g. name \"fill\" with args {x1,y1,z1,x2,y2,z2,block}. Returns its result from storage claude_api:out (null if the call failed). Arguments are whole numbers or strings without spaces. Functions: ping, test_block {x,y,z,block}, setblock {x,y,z,block}, fill {x1,y1,z1,x2,y2,z2,block}.",
    inputSchema: {
      name: z.string(),
      args: z.record(z.string(), z.unknown()).optional(),
    },
  },
  async ({ name, args }) => text(await callApi(rcon, name, args)),
);

server.registerTool(
  "players",
  { description: "List online players with their position and dimension." },
  async () => text(await players(rcon)),
);

server.registerTool(
  "say",
  {
    description: "Send a chat message to every player, shown as <Claude>.",
    inputSchema: { text: z.string() },
  },
  async ({ text: message }) => text(await say(rcon, message)),
);

await server.connect(new StdioServerTransport());
