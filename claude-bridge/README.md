# claude-bridge

An MCP server that gives Claude Code a Minecraft server's console over RCON,
plus the [claude-api](../claude-api) data pack's functions. Needs
[Bun](https://bun.sh).

## Tools

| Tool | What it does |
| --- | --- |
| `run_commands` | Runs console commands in order and returns each response; refused while `claude_api:config/disable` is on |
| `call_api` | Calls a `claude_api:api/` function and returns its result |
| `players` | Lists online players with position and dimension |
| `say` | Sends a chat message as `<Claude>` |

## Setup

1. In the server's `server.properties`:

   ```properties
   enable-rcon=true
   rcon.port=25575
   rcon.password=<a long random password>
   ```

   RCON is unencrypted. Never forward the RCON port on your router.
2. Copy `claude-api` into the world's `datapacks` folder and `/reload`.
3. `bun install` in this folder, then add it to Claude Code:

   ```sh
   claude mcp add minecraft -e RCON_PASSWORD=<password> -- bun run <path to>/claude-bridge/src/index.ts
   ```

   `RCON_HOST` (default `127.0.0.1`) and `RCON_PORT` (default `25575`) can be
   set the same way.

## Testing

`bun test` runs the RCON client against a fake server.
