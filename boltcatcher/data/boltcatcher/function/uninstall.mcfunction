# Removes the pack's scoreboards, storage, boss bars and markers, and takes
# the powers away from online holders. Caught lightning left behind is an
# inert item. Afterwards, disable the pack with /datapack disable and run
# /reload.
execute as @a[tag=boltcatcher.charged] run function boltcatcher:power/off
# With no holders left, the sweep removes every boss bar
function boltcatcher:bar/sweep
kill @e[type=minecraft:marker,tag=boltcatcher.catcher]
scoreboard objectives remove boltcatcher.config
scoreboard objectives remove boltcatcher.tmp
scoreboard objectives remove boltcatcher.dealt
scoreboard objectives remove boltcatcher.kills
scoreboard objectives remove boltcatcher.kill_sound
scoreboard objectives remove boltcatcher.id
data remove storage boltcatcher:tmp stars
data remove storage boltcatcher:tmp args
data remove storage boltcatcher:tmp catch
data remove storage boltcatcher:tmp bar
data remove storage boltcatcher:tmp bars
data remove storage boltcatcher:tmp power
data remove storage boltcatcher:bars list
tellraw @s [{text:"[Boltcatcher] ",color:"gold"},"Uninstalled. Now disable the data pack and run /reload."]
