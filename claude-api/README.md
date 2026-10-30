# Claude API

A small command API for Claude (through [claude-bridge](../claude-bridge))
to query and build in the world over RCON. Each function under `api/`
writes its answer to `storage claude_api:out result`, which the bridge
reads back with `/data get`.

## Functions

| Function | Arguments | Result |
| --- | --- | --- |
| `api/ping` | none | `{ok, version, enabled, game_time}` |
| `api/test_block` | `x`, `y`, `z`, `block` (an id with states, or a tag) | `{ok, loaded, match}` |
| `api/setblock` | `x`, `y`, `z`, `block` | `{ok}` |
| `api/fill` | `x1`, `y1`, `z1`, `x2`, `y2`, `z2`, `block` | `{ok, count}` |

The bridge puts the arguments in `storage claude_api:in args` and runs
`function claude_api:api/<name> with storage claude_api:in args`.

## Configuration

| Function | Effect |
| --- | --- |
| `config/disable` | Blocks `setblock` and `fill` (they answer `error:"disabled"`) and the bridge's `run_commands`; queries still work |
| `config/enable` | Allows them again (the default) |
| `config/show` | Shows whether Claude can change the world |

## Uninstalling

Run `/function claude_api:uninstall`, then `/datapack disable` the pack and
`/reload`.

## Compatibility

Uses the `claude_api` namespace only and changes no game rules.
