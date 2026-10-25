# Boltcatcher

Catch lightning during a thunderstorm, then take it into the dark and fight
to keep it charged. While you carry it, you hit three times as hard, run
twice as fast, never get hungry, glow, float on 40% of normal gravity,
take no fall damage and sprint up one-block ledges.

## Building a catcher

Stack three blocks, top to bottom:

1. A lightning rod (any copper age, waxed or not), pointing up
2. A block of redstone
3. A hopper

In a thunderstorm, vanilla draws lightning to any rod within 128 blocks that
has open sky above it. When a bolt hits the rod of a catcher, a **Caught
Lightning** appears in the hopper. It looks like a shimmering Nether Star
with a durability bar. The redstone block locks the hopper, so the star stays
put until someone takes it. If the hopper is full, the lightning grounds out
in a puff of smoke. A Channeling trident thrown at the rod works too, and so
does `/summon minecraft:lightning_bolt` on the block above the rod.

## Charge

The durability bar is the charge, counted in seconds. A new catch starts
with 2 minutes, out of a maximum of 5. It drains one point a second,
wherever the star is: in a chest, an ender chest or an unloaded chunk it is
caught up the next time the pack sees it. When it reaches zero, the star
fizzles out with a spark.

While you carry a star, each heart of damage you deal adds 2 seconds and
each kill adds 5. That counts the extra damage the lightning gives you, so
a charged hit recharges three times as much as a normal one. A kill plays
the dragon's-breath bottle sound so you know it worked. Every star you
carry gets the bonus, up to its maximum.

## Powers

Anyone carrying a star anywhere in their inventory or offhand gets:

- Three times the melee damage, weapon included
- Glowing (others see you through walls), with sparks around you
- Twice the speed (sprinting adds its usual 30% on top)
- A hunger bar that stays full, however much you sprint
- 40% of normal gravity, for high, floaty jumps
- No fall damage
- A step height of 1.1, so you walk up one-block ledges without jumping

Everyone online sees a boss bar for each holder, with their name and the
time left on their fullest star. It turns red in the last quarter. The
powers end as soon as you no longer carry a star (it fizzled, you dropped
it or put it away).

## Configuration

Run these as an operator:

| Command | Effect |
| --- | --- |
| `/function boltcatcher:config/show` | Show current settings |
| `/function boltcatcher:config/set_start_charge {seconds:120}` | Charge a new catch starts with (1–3600, never above the maximum) |
| `/function boltcatcher:config/set_max_charge {seconds:300}` | Maximum charge (10–3600) for lightning caught from now on |
| `/function boltcatcher:config/set_damage_bonus {seconds:2}` | Seconds added per heart of damage dealt (0–60) |
| `/function boltcatcher:config/set_kill_bonus {seconds:5}` | Seconds added per kill (0–600) |
| `/function boltcatcher:config/set_speed {percent:200}` | Speed while charged, as a percentage of normal (100–500) |
| `/function boltcatcher:config/set_damage {percent:300}` | Melee damage while charged, as a percentage of normal (100–1000) |
| `/function boltcatcher:config/set_gravity {percent:40}` | Gravity while charged, as a percentage of normal (5–100) |

Settings are stored on the `boltcatcher.config` scoreboard and survive
reloads. The speed, damage and gravity settings reach current holders
right away.

## Uninstalling

Run `/function boltcatcher:uninstall`. This takes the powers away from online
holders and removes the pack's scoreboards, storage, boss bars and markers.
Then disable the pack with `/datapack disable` and run `/reload`. Caught
Lightning left in the world stays a Nether Star. A holder who is offline
during the uninstall keeps the speed, damage and gravity changes, so
uninstall while everyone is online.

## Compatibility

Built for Minecraft 26.3 (data pack format 121). It uses the `gravity`,
`attack_damage`, `fall_damage_multiplier` and `step_height` attributes,
item components and macros, so it won't load on older versions.

The star is a real Nether Star, so it can be crafted into a beacon or used
to power one, which uses it up. Two stars put together in a crafting grid
merge like damaged tools into one plain Nether Star with no charge.

Damage dealt counts the `damage_dealt` statistic, which may not include
damage from arrows and tridents; kills by any means count.
