# Bed Tweaks

Every bed you place becomes one of your respawn points. After you die and
respawn (wherever vanilla puts you), a private chat menu lists your other
beds; click one within 60 seconds to be moved there. Optionally, sleeping
through the night in a straw bed opens the same menu, making straw beds
one-use teleporters.

```
Respawn at another bed? You have 60 seconds: [#1 Red Bed, 120 blocks away] [#4 Blue Bed, 4232 blocks away]
```

## How it works

- **Placing a bed** (a `placed_block` advancement) follows your line of sight
  to the new bed, records it in storage `bed_tweaks:beds` with your UUID, and
  puts an invisible marker on it. You get a message: "You can now respawn at
  this bed." Each bed gets a number, which floats over it (this can be
  turned off) and appears in the menu. Only beds you place count; beds placed in dimensions where they
  can't set a spawn point (the Nether, the End) aren't recorded.
- **Breaking a bed**, by anyone, removes it: its marker notices and you're
  told "You can no longer respawn at your Red Bed; it's gone."
- **After respawning**, the menu lists your beds with their color and
  distance (never coordinates). The bed you're standing next to is left out.
  If you have no other beds, there's no menu.
- **Picking a bed** checks it's still there and moves you to a safe spot
  beside it, or onto it if the sides are blocked, like vanilla does. If the
  bed is far away, its chunk is force-loaded for a moment so it can be
  checked. If it's gone or obstructed you're told, and can pick another while
  time remains.

Picking a bed doesn't change your vanilla spawn point; next time you'll
respawn in the same place and get the menu again.

### Straw beds

Straw beds can never be a spawn point in vanilla, and break when you get up.
With the option on (it's off by default), sleeping in one until morning,
when the night is actually skipped, opens the menu with "Travel to one of
your beds?". Getting up early does nothing. The straw bed still breaks as
normal. Since the night must be skipped, this does nothing when the
`advance_time` game rule is off.

## Configuration

Run these as an operator:

| Command | Effect |
| --- | --- |
| `/function bed_tweaks:config/show` | Show current settings |
| `/function bed_tweaks:config/set_choose_time {seconds:60}` | How long (0–3600 seconds) the menu can be used; 0 turns the menu off |
| `/function bed_tweaks:config/straw_beds_on` | Sleeping through the night in a straw bed opens the menu |
| `/function bed_tweaks:config/straw_beds_off` | Straw beds behave as in vanilla (default) |
| `/function bed_tweaks:config/labels_on` | Show each bed's number floating over it (default) |
| `/function bed_tweaks:config/labels_off` | Hide the numbers |

Settings are stored on the `bed_tweaks.config` scoreboard and survive reloads.

## Uninstalling

Run `/function bed_tweaks:uninstall`. This removes the pack's scoreboards,
storage, and the markers and number labels on beds in loaded chunks. Then
disable the pack with `/datapack disable` and run `/reload`.

Markers and labels in unloaded chunks stay behind. The markers are invisible
and do nothing, but the labels can still be seen. To avoid that, turn labels
off with `config/labels_off` and visit your beds before uninstalling, or run
`/kill @e[type=text_display,tag=bed_tweaks.label]` near any that are left. If
the pack is installed again, it removes both as their chunks load.

## Compatibility

Built for Minecraft 26.3 (data pack format 121). It uses the `bed_rule`
environment attribute, straw beds, world clocks and macros, so it won't load
on older versions. Any data pack that changes the bed rule of a dimension
away from the Overworld's stops beds placed there from being recorded.
