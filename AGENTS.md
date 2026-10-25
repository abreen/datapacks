# AGENTS.md

Minecraft: Java Edition data packs that tweak vanilla behavior. Each
top-level folder with a `pack.mcmeta` is one pack (currently just
`death-tweaks/`).

## Target version

- **Minecraft 26.3, data pack format 121.** `pack.mcmeta` uses
  `min_format`/`max_format` (no `pack_format`).
- Don't trust memory for version-specific syntax; check the real jar. The
  user's launcher keeps versions in
  `~/Library/Application Support/minecraft/versions/`, and Mojang's manifest
  is at `https://piston-meta.mojang.com/mc/game/version_manifest_v2.json`.
  - `version.json` in the jar has `pack_version.data_major`/`data_minor`.
  - Game rule ids: `strings` on
    `net/minecraft/world/level/gamerules/GameRules.class` (inside
    `META-INF/versions/*/*.jar` for the server jar). In 26.x they are
    snake_case, e.g. `keep_inventory`, `immediate_respawn`.

## Layout and naming

- Folder: kebab-case (`death-tweaks`). Namespace: the same in snake_case
  (`death_tweaks`). Functions live in `data/<ns>/function/` (singular).
- Hook in via `data/minecraft/tags/function/load.json` and `tick.json`.
- Scoreboards are `<ns>.<name>` (`death_tweaks.config`, `.tmp`, `.deaths`).
  Fake players start with `#`. Constants for scoreboard math (`#2`, `#100`,
  …) are set in `load` on every load.
- Entity tags are `<ns>.<name>`; temporary ones (`<ns>.new`) are removed in
  the same function that adds them.
- Storage is `<ns>:tmp` for scratch data such as macro arguments.

## Conventions

- **Settings** live on the `<ns>.config` scoreboard. `load` sets each default
  only if unset (`execute unless score … matches 0.. run …`) so `/reload`
  keeps user changes.
- Each setting has a function under `config/`. Numeric ones are macros
  (`config/set_chance {percent:30}`) that clamp the value and then call
  `config/show`. `config/show` lists every setting with a gold
  `[Pack Name] ` prefix.
- Every pack has an `uninstall` function that removes its scoreboards and
  storage and undoes any game rules it changed.
- Messages to a player are `tellraw` in gray italic (whisper style). Never
  include coordinates.
- Never silently destroy what a player would otherwise keep. If a drop can't
  spawn (e.g. an unloaded chunk), leave the item or XP with the player.
- Comments explain *why* (vanilla quirks, workarounds), briefly. Keep files
  small; split logic into helper functions, not long `execute` chains.
- Each pack has a `README.md` (behavior, configuration table, uninstalling,
  compatibility). Keep it and the root README's pack table in sync.

## 26.x gotchas found the hard way

- A parse error discards the whole function file, and it is only logged at
  load. Referencing an item tag that doesn't exist is a parse error, so ship
  empty tags (`"values": []`).
- Text components in commands are SNBT: `{text:"x",color:"gray"}`.
- Inline item modifiers use `type:`, not `function:`.
- `positioned X Y Z` with integer X/Z already centers on the block; don't add
  `~0.5`.
- An item entity's name (`{selector:"@s"}`) reflects `item_name` but not
  `custom_name`; read `Item.components."minecraft:custom_name"` with
  `interpret:true` for renamed items.
- `{nbt:…}` components render numbers in gold (syntax highlighting). Copy
  the value into a score and use a `score` component for plain text.
- `experience_orb` `Value` is a short (wraps above 32767); `Count` is an int.
- Player NBT is read-only to `data modify`; change players with `/item`,
  `/xp`, etc. `item replace … from entity` and `execute if items` work on any
  entity with that slot.
- With `keep_inventory` on, a dead player still matches `@a`, and their
  `LastDeathLocation` is reliable even after an immediate respawn.

## Testing

Test every change on a real server of the target version before committing:

1. Download that version's `server.jar` from Mojang's manifest (check the
   SHA-1) into a scratch folder, outside the repo. Ask the user first, since
   it means downloading a file and setting `eula=true`.
2. `server.properties`: `level-type=minecraft\:flat`, `server-ip=127.0.0.1`,
   `enable-rcon=true`, an `rcon.port`/`rcon.password`, and non-default
   ports. Copy the pack into `world/datapacks/`; symlinks are rejected.
3. Start it in the background and drive it over RCON with
   [`tools/rcon.py`](tools/rcon.py). It takes commands as arguments or one
   per line on stdin (`#` lines are comments), and reads `RCON_PORT` and
   `RCON_PASSWORD` from the environment:

   ```sh
   RCON_PORT=25598 RCON_PASSWORD=localtest tools/rcon.py 'reload' 'function death_tweaks:config/show'
   ```

   Check `server.log` for `ERROR`/`WARN` after start and after each
   `/reload`. If you write another RCON client, never send a packet before
   the previous one has been answered: the server closes the connection if a
   second packet reaches it before it has handled the first.
4. Run `forceload add 0 0` and summon test entities in a *separate* RCON
   batch from the commands that use them, since they may not be selectable
   the same tick.
5. No player is connected, so use an armor stand as a stand-in for player
   logic (it has `armor.*`/`weapon.*` slots but not `hotbar.*` or `xp`), and
   verify rendered text by writing it into a custom name with an inline
   `set_name` modifier (`entity:"this"`). Say what could only be checked
   with a real player. The user can join the test server for that
   (Direct Connect to `localhost:<port>`; use `online-mode=true` so they can
   be opped by name).

## Building and git

- `./build.sh` zips each pack into `dist/` (git-ignored).
- The default branch is `main`; the remote is
  `git@github.com:abreen/datapacks.git` (SSH). Commit and push only when the
  user asks, and don't create remote branches without permission.
