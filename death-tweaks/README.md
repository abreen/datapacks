# Death Tweaks

A middle ground between `keep_inventory` and losing everything: when you die,
each stack in your inventory has a random chance (30% by default) of being
lost, along with a share of your experience. Everything else stays with you.

## How it works

On load, the pack turns on the `keep_inventory` game rule so vanilla never
drops anything. A `deathCount` scoreboard detects deaths, and for each of the
41 player slots (hotbar, inventory, armor, offhand) the pack rolls
`random value 1..100` against the configured chance. Lost stacks are dropped
at the player's death location (from `LastDeathLocation`, so it works even
with `immediate_respawn`), or destroyed if configured.

The player also loses a configurable percentage (30% by default) of their
experience. It's taken from their total experience *points*, not levels, so
the loss scales with level the way vanilla XP does: each level above 16 costs
more points, so 30% of a level 30 player's XP is about 5 levels, not 9. Lost
experience is dropped as orbs at the death location, or destroyed, following
the same setting as lost stacks.

After dying, the player gets a private message (only they can see it)
listing each stack they dropped, e.g. `12× Gold Ingot`, under "You dropped
these items:". Stacks that were deleted instead are listed in red under "These
items were destroyed:", with `(vanished)` after Curse of Vanishing items. Then
comes how much experience they dropped ("You dropped 5 levels of experience.")
or, in red, how much was destroyed ("5 levels of experience were destroyed.").

Also:

- Items with **Curse of Vanishing** are destroyed on death, as they would be
  without `keep_inventory`. This can be turned off.
- Items in the `#death_tweaks:protected` item tag are never lost. It's empty by
  default; add items to it with another data pack (or by editing
  `data/death_tweaks/tags/item/protected.json`).
- If the death location is in an unloaded chunk, lost stacks and experience
  are kept instead of being deleted.

## Configuration

Run these as an operator:

| Command | Effect |
| --- | --- |
| `/function death_tweaks:config/show` | Show current settings |
| `/function death_tweaks:config/set_chance {percent:30}` | Chance (0–100) that each stack is lost |
| `/function death_tweaks:config/set_xp_loss {percent:30}` | Percentage (0–100) of total experience points lost |
| `/function death_tweaks:config/drop_lost_items` | Drop lost stacks and experience at the death location (default) |
| `/function death_tweaks:config/destroy_lost_items` | Delete lost stacks and experience instead |
| `/function death_tweaks:config/vanishing_curse_on` | Destroy Curse of Vanishing items on death (default) |
| `/function death_tweaks:config/vanishing_curse_off` | Keep Curse of Vanishing items |

Settings are stored on the `death_tweaks.config` scoreboard and survive reloads.

## Uninstalling

Run `/function death_tweaks:uninstall`. This removes the pack's scoreboards and
turns `keep_inventory` back off. Then disable the pack with
`/datapack disable` and run `/reload`.

## Compatibility

Built for Minecraft 26.3 (data pack format 121). It uses the `keep_inventory`
game rule name, macros, and `execute if items`, so it won't load on older
versions.
