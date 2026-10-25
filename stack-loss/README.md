# Stack Loss

A middle ground between `keep_inventory` and losing everything: when you die,
each stack in your inventory has a random chance (30% by default) of being
lost. Everything else stays with you.

## How it works

On load, the pack turns on the `keep_inventory` game rule so vanilla never
drops anything. A `deathCount` scoreboard detects deaths, and for each of the
41 player slots (hotbar, inventory, armor, offhand) the pack rolls
`random value 1..100` against the configured chance. Lost stacks are dropped
at the player's death location (from `LastDeathLocation`, so it works even
with `immediate_respawn`), or destroyed if configured.

Also:

- Items with **Curse of Vanishing** are destroyed on death, as they would be
  without `keep_inventory`. This can be turned off.
- Items in the `#stack_loss:protected` item tag are never lost. It's empty by
  default; add items to it with another data pack (or by editing
  `data/stack_loss/tags/item/protected.json`).
- If the death location is in an unloaded chunk, a lost stack stays in the
  inventory instead of being deleted.
- XP is kept, since `keep_inventory` keeps it.

## Configuration

Run these as an operator:

| Command | Effect |
| --- | --- |
| `/function stack_loss:config/show` | Show current settings |
| `/function stack_loss:config/set_chance {percent:30}` | Chance (0–100) that each stack is lost |
| `/function stack_loss:config/drop_lost_items` | Drop lost stacks at the death location (default) |
| `/function stack_loss:config/destroy_lost_items` | Delete lost stacks instead |
| `/function stack_loss:config/vanishing_curse_on` | Destroy Curse of Vanishing items on death (default) |
| `/function stack_loss:config/vanishing_curse_off` | Keep Curse of Vanishing items |

Settings are stored on the `stack_loss.config` scoreboard and survive reloads.

## Uninstalling

Run `/function stack_loss:uninstall`. This removes the pack's scoreboards and
turns `keep_inventory` back off. Then disable the pack with
`/datapack disable` and run `/reload`.

## Compatibility

Built for Minecraft 26.3 (data pack format 121). It uses the `keep_inventory`
game rule name, macros, and `execute if items`, so it won't load on older
versions.
