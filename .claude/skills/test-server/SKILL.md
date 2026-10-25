---
name: test-server
description: Start, reload, drive and stop a local Minecraft test server with this repo's data packs. Use when asked to start or stop a test server, to test or verify a pack change in the game, or to let the user join a server with the packs.
---

# Test server

`tools/test-server.sh` does the setup. Run it from the repo root; it prints
its own usage when run with no arguments.

## Starting

```sh
tools/test-server.sh start            # every pack, fresh flat world
tools/test-server.sh start death-tweaks
```

- If it says `server.jar` isn't cached, ask the user before rerunning with
  `--download`. Say which version and that it comes from Mojang (the script
  prints the size and checks the SHA-1).
- If it asks for `--accept-eula`, ask the user to accept Mojang's EULA
  (https://aka.ms/MinecraftEULA) first. The acceptance is then remembered in
  `.cache/`.
- `start` waits for the server, so a normal foreground command is fine; the
  server keeps running after the command returns.
- Read the errors and warnings it prints. Known harmless lines are already
  filtered out; anything else from a pack is a parse error or a bug.

## Testing a change

1. Edit the pack in the repo, then `tools/test-server.sh sync`. It copies
   the packs again, runs `/reload` and prints any new errors or warnings. A
   parse error discards the whole function file.
2. Drive the server with `tools/test-server.sh rcon 'cmd' ...` (or commands
   on stdin, one per line). Follow the Testing section of `AGENTS.md`:
   `forceload add 0 0`, summon entities in a separate batch from the
   commands that use them, armor stands as player stand-ins, and `set_name`
   to check rendered text.
3. Say what could only be checked with a real player. The user can join at
   `localhost:25599`. If they ask to be opped, run `op <name>` with the name
   they give. The whitelist is off.

## Player setup

When a player first joins, each pack's `test/setup.mcfunction` runs as them
(a generated `test-setup` pack does this), so they arrive with the pack's
test items. `tools/test-server.sh setup <player>` clears their inventory and
runs it again, e.g. to restock after a death test.

When adding or changing a setup file: it's a plain function run as the
player, outside `data/` so it never ships. Each pack fills its own
inventory slots so they don't overlap (bed-tweaks: `hotbar.0`–`3`;
death-tweaks: everything else). Check item counts against the max stack
size (straw beds stack to 16) by running the lines on an armor stand's
`weapon.mainhand`; an oversized count fails the command.

## World setup

Right after `start`, each pack's `test/world.mcfunction` runs once at the
world spawn (its chunk is force-loaded first), for things the world should
already have built, like boltcatcher's catcher 3 blocks east of spawn. It
doesn't run again on `sync`, so restart to rebuild. Any other
`test/<name>.mcfunction` can be run as `test_setup:<namespace>/<name>`,
e.g. `function test_setup:boltcatcher/strike` strikes that catcher with
lightning.

## Stopping

`tools/test-server.sh stop`. Stop the server when the user is done with it,
not before: they may still be connected.
