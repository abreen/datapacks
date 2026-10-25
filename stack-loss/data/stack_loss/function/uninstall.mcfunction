# Removes the pack's scoreboards and restores vanilla death drops.
# Afterwards, disable the pack with /datapack disable and run /reload.
scoreboard objectives remove stack_loss.deaths
scoreboard objectives remove stack_loss.config
scoreboard objectives remove stack_loss.tmp
data remove storage stack_loss:tmp death
gamerule keep_inventory false
tellraw @s [{text:"[Stack Loss] ",color:"gold"},"Uninstalled. Now disable the data pack and run /reload."]
