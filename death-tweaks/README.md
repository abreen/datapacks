# Death Tweaks

A middle ground between `keep_inventory` and losing everything: when you die,
each stack in your inventory has a random chance of being hit (by default
10% on Peaceful, 20% on Easy, 30% on Normal and 50% on Hard), and a hit stack
loses a random number of its items (anywhere from one to all of them). You
also lose a share of your experience. Everything else stays with you.

## How it works

On load, the pack turns on the `keep_inventory` game rule so vanilla never
drops anything. A `deathCount` scoreboard detects deaths, and for each of the
41 player slots (hotbar, inventory, armor, offhand) the pack rolls
`random value 1..100` against the chance configured for the world's current
difficulty. For a hit stack of N items, a second roll of `random value 1..N`
decides how many are lost; the rest stay in the slot. Any other single item
(anything unstackable) is lost whole. Lost items are dropped at the
player's death location (from `LastDeathLocation`, so it works even with
`immediate_respawn`), or destroyed if configured.

A hit item with durability (tools, weapons, armor, elytra, shields, …) isn't
lost: it loses a random amount of durability instead, from one point up to a
configured share of its maximum (by default 10% on Peaceful, 20% on Easy, 30%
on Normal and 50% on Hard). If that uses up all its remaining durability, it
breaks and is lost whole like any other stack. Unbreakable items are kept as
they are.

The player also loses a configurable percentage (30% by default) of their
experience. It's taken from their total experience *points*, not levels, so
the loss scales with level the way vanilla XP does: each level above 16 costs
more points, so 30% of a level 30 player's XP is about 5 levels, not 9. Lost
experience is dropped as orbs at the death location, or destroyed, following
the same setting as lost stacks.

After dying, the player gets a private message (only they can see it)
listing what they dropped, e.g. `7× Gold Ingot` (the number lost, not the
stack size), under "You dropped these items:". Items that lost durability are listed
under "These items were damaged:". Items that were deleted instead
are listed in red under "These items were destroyed:", with `(vanished)`
after Curse of Vanishing items. Then comes how much experience they dropped
("You dropped 5 levels of experience.") or, in red, how much was destroyed
("5 levels of experience were destroyed.").

Also:

- Items with **Curse of Vanishing** are destroyed on death, as they would be
  without `keep_inventory`. This can be turned off.
- Items in the `#death_tweaks:protected` item tag are never lost. It's empty by
  default; add items to it with another data pack (or by editing
  `data/death_tweaks/tags/item/protected.json`).
- When lost stacks are destroyed, a lost **shulker box** is still destroyed,
  but its contents are dropped at the death location (and listed under "You
  dropped these items:") instead of being deleted with it.
- If the death location is in an unloaded chunk, lost stacks and experience
  are kept instead of being deleted.

## Configuration

Run these as an operator:

| Command | Effect |
| --- | --- |
| `/function death_tweaks:config/show` | Show current settings |
| `/function death_tweaks:config/set_chance {difficulty:"normal",percent:30}` | Chance (0–100) that each stack is hit on that difficulty (`peaceful`, `easy`, `normal` or `hard`) |
| `/function death_tweaks:config/set_durability_loss {difficulty:"normal",percent:30}` | Most durability (1–100% of the maximum) a hit damageable item can lose on that difficulty |
| `/function death_tweaks:config/set_xp_loss {percent:30}` | Percentage (0–100) of total experience points lost |
| `/function death_tweaks:config/drop_lost_items` | Drop lost stacks and experience at the death location (default) |
| `/function death_tweaks:config/destroy_lost_items` | Delete lost stacks and experience instead (shulker boxes still drop their contents) |
| `/function death_tweaks:config/vanishing_curse_on` | Destroy Curse of Vanishing items on death (default) |
| `/function death_tweaks:config/vanishing_curse_off` | Keep Curse of Vanishing items |

Settings are stored on the `death_tweaks.config` scoreboard and survive reloads.

## Uninstalling

Run `/function death_tweaks:uninstall`. This removes the pack's scoreboards and
storage and turns `keep_inventory` back off. Then disable the pack with
`/datapack disable` and run `/reload`.

## Compatibility

Built for Minecraft 26.3 (data pack format 121). It uses the `keep_inventory`
game rule name, macros, and `execute if items`, so it won't load on older
versions.
