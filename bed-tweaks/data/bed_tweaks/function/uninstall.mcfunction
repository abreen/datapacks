# Removes the pack's scoreboards, storage, bed markers and labels.
# Afterwards, disable the pack with /datapack disable and run /reload.
function bed_tweaks:pick/release_all
kill @e[type=marker,tag=bed_tweaks.bed]
kill @e[type=text_display,tag=bed_tweaks.label]
scoreboard objectives remove bed_tweaks.config
scoreboard objectives remove bed_tweaks.tmp
scoreboard objectives remove bed_tweaks.deaths
scoreboard objectives remove bed_tweaks.alive
scoreboard objectives remove bed_tweaks.pick
scoreboard objectives remove bed_tweaks.window
scoreboard objectives remove bed_tweaks.wait
scoreboard objectives remove bed_tweaks.straw
scoreboard objectives remove bed_tweaks.slept
scoreboard objectives remove bed_tweaks.bed
data remove storage bed_tweaks:beds list
data remove storage bed_tweaks:tmp args
data remove storage bed_tweaks:tmp new
data remove storage bed_tweaks:tmp gone
data remove storage bed_tweaks:tmp mine
data remove storage bed_tweaks:tmp menu
data remove storage bed_tweaks:tmp here
data remove storage bed_tweaks:tmp cmp
data remove storage bed_tweaks:tmp target
data remove storage bed_tweaks:tmp waiting
tellraw @s [{text:"[Bed Tweaks] ",color:"gold"},"Uninstalled. Now disable the data pack and run /reload."]
