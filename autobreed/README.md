# Autobreed

Farm animals breed on their own, without being fed, until they get crowded.
Keep two cows in a field and in time you have a herd.

## How it works

- **Every 2 minutes**, each adult has a 50% chance to breed with the nearest
  adult of its species within 8 blocks (vanilla's breeding range). Both go
  into love mode, exactly as if fed. Vanilla does the rest, so you see the
  hearts and get the baby, and the parents wait 5 minutes before breeding
  again.
- **No free experience:** vanilla breeding drops a few XP orbs, which would
  make a herd that breeds itself an XP farm. By default the pack removes the
  orbs from the breeding it started, the tick they appear. Older orbs nearby
  are left alone, and animals you breed by hand usually still drop theirs:
  vanilla may pair a hand-fed animal with one the pack put in love, and then
  the orbs may be removed.
- **The limit:** a pair doesn't breed while 32 or more animals of its
  species (babies included) are within 24 blocks of either animal. Other
  species don't count, so a mixed pen fills up with each of them. Pairs
  already in love count as one more each, for the baby on the way. The wide
  radius caps a herd as a whole, even one spread out over a field; it grows
  again only if animals are moved away or culled. Two pens of the same
  species closer than 24 blocks share the limit.
- Babies and animals already in love mode don't try.

There's no pen detection: wild herds grow too, up to the same limit. Fence
animals in, or keep them apart, to control where they multiply. Fences don't
stop pairing, so two animals on either side of one may be paired, fail to
meet, and try again next interval.

Species: cow, mooshroom, sheep, pig, chicken, goat and rabbit, listed in the
entity type tag `#autobreed:livestock`. To add one, add it to that tag and a
matching line to the `autobreed:breed/pair` and `autobreed:breed/herd`
functions. Each pair is always one species.

Each animal's check is a few selectors, and checks are spread across the
interval, so the cost stays small however many animals are loaded. Like all
mob behavior, it only happens in loaded chunks.

## Configuration

Run these as an operator:

| Command | Effect |
| --- | --- |
| `/function autobreed:config/show` | Show current settings |
| `/function autobreed:config/set_interval {seconds:120}` | Seconds between breeding attempts by each adult (1–3600) |
| `/function autobreed:config/set_chance {percent:50}` | Chance (0–100%) that an attempt with room and a partner breeds a pair |
| `/function autobreed:config/set_limit {animals:32}` | Animals of a species within 24 blocks (1–256) at which breeding stops |
| `/function autobreed:config/xp_orbs_off` | Remove the XP orbs from the pack's breeding (default) |
| `/function autobreed:config/xp_orbs_on` | Leave them, as in vanilla |

Settings are stored on the `autobreed.config` scoreboard and survive reloads.

## Uninstalling

Run `/function autobreed:uninstall`. This removes the pack's scoreboards and tags.
Then disable the pack with `/datapack disable` and run `/reload`.

## Compatibility

Built for Minecraft 26.3 (data pack format 121). It uses macros, so it won't
load on older versions. It only changes when animals fall in love, so it
works alongside anything else that breeds or moves them.
