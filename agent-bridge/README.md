# agent-bridge

An MCP server that gives any MCP client (pi, Claude Code, Codex, Cursor, …)
a Minecraft server's console over RCON,
plus the [agent-api](../agent-api) data pack's functions. Needs
[Bun](https://bun.sh).

## Tools

| Tool | What it does |
| --- | --- |
| `run_commands` | Runs console commands in order and returns each response; refused while `agent_api:config/disable` is on or the pack isn't loaded |
| `call_api` | Calls a `agent_api:api/` function and returns its result |
| `players` | Lists online players with position and dimension |
| `say` | Sends a chat message as `<AGENT_NAME>` (default `<Agent>`) |
| `scan` | Reads a box of blocks (up to 64×64×64) from the saved chunk files: block counts and a top-down map. Runs `save-all flush` first |
| `entities` | Lists non-player entities in a box by name (custom name if set) and position, loaded chunks only |

## Setup

1. In the server's `server.properties`:

   ```properties
   enable-rcon=true
   rcon.port=25575
   rcon.password=<a long random password>
   ```

   RCON is unencrypted. Never forward the RCON port on your router.
2. Copy `agent-api` into the world's `datapacks` folder and `/reload`.
3. `bun install` in this folder, then add it to your MCP client as a stdio
   server. Most clients (pi's `~/.pi/agent/mcp.json`, Claude Desktop,
   Cursor) take an `mcpServers` entry:

   ```json
   {
     "mcpServers": {
       "minecraft": {
         "command": "bun",
         "args": ["run", "<path to>/agent-bridge/src/index.ts"],
         "env": { "RCON_PASSWORD": "<password>", "MC_WORLD": "<server>/world", "AGENT_NAME": "Pi" }
       }
     }
   }
   ```

   Or from a shell:

   ```sh
   pi mcp add minecraft -e RCON_PASSWORD=<password> -- bun run <path to>/agent-bridge/src/index.ts
   claude mcp add minecraft -e RCON_PASSWORD=<password> -- bun run <path to>/agent-bridge/src/index.ts
   ```

   Codex uses TOML: `[mcp_servers.minecraft]` with the same `command`,
   `args`, and `env`.

   | Variable | Default | Meaning |
   | --- | --- | --- |
   | `RCON_PASSWORD` | (required) | From `server.properties` |
   | `RCON_HOST` | `127.0.0.1` | |
   | `RCON_PORT` | `25575` | |
   | `MC_WORLD` | none | World folder, needed by `scan` (it reads region files directly, so the bridge must run on the server's machine) |
   | `AGENT_NAME` | `Agent` | Name `say` shows in chat |

## Instructions for the agent

Paste this into your client's system prompt or project instructions:

```
You control a Minecraft: Java Edition 26.3 server through the `minecraft`
MCP server. Start with call_api "ping": if enabled is 0, only query, and
tell the user to run /function agent_api:config/enable. Use `players` to
find people before building near them; never post coordinates in chat.
Prefer call_api setblock/fill over run_commands (arguments are integers or
strings without spaces). Check an area with scan or test_block first and
never destroy player builds, chests, or items without asking. run_commands
runs at world spawn as the server, with no leading slash, so use absolute
coordinates or `execute at <player>`. Verify builds afterwards and report
what changed.
```

## Testing

`bun test` runs the RCON client against a fake server and the region reader
against a generated chunk.
