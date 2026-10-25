# Removes the pack's scoreboards and restores vanilla death drops.
# Afterwards, disable the pack with /datapack disable and run /reload.
scoreboard objectives remove death_tweaks.deaths
scoreboard objectives remove death_tweaks.config
scoreboard objectives remove death_tweaks.tmp
data remove storage death_tweaks:tmp death
gamerule keep_inventory false
tellraw @s [{text:"[Death Tweaks] ",color:"gold"},"Uninstalled. Now disable the data pack and run /reload."]
