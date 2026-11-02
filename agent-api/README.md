# Agent API

A small command API for any MCP-compatible AI agent (through [agent-bridge](../agent-bridge))
to query and build in the world over RCON. Each function under `api/`
writes its answer to `storage agent_api:out result`, which the bridge
reads back with `/data get`.

## Functions

| Function | Arguments | Result |
| --- | --- | --- |
| `api/ping` | none | `{ok, version, enabled, game_time}` |
| `api/test_block` | `x`, `y`, `z`, `block` (an id with states, or a tag) | `{ok, loaded, match}` |
| `api/setblock` | `x`, `y`, `z`, `block` | `{ok}` |
| `api/fill` | `x1`, `y1`, `z1`, `x2`, `y2`, `z2`, `block` | `{ok, count}` |

The bridge puts the arguments in `storage agent_api:in args` and runs
`function agent_api:api/<name> with storage agent_api:in args`.

## Configuration

| Function | Effect |
| --- | --- |
| `config/disable` | Blocks `setblock` and `fill` (they answer `error:"disabled"`) and the bridge's `run_commands`; queries still work |
| `config/enable` | Allows them again (the default) |
| `config/show` | Shows whether the agent can change the world; from the console or RCON, it returns 1 if so and 0 if not |

## Uninstalling

Run `/function agent_api:uninstall`, then `/datapack disable` the pack and
`/reload`.

## Compatibility

Uses the `agent_api` namespace only and changes no game rules.
