scoreboard objectives add bed_tweaks.config dummy
scoreboard objectives add bed_tweaks.tmp dummy
scoreboard objectives add bed_tweaks.deaths deathCount
# Reset on death and counts up only while alive, so it shows when a player has respawned
scoreboard objectives add bed_tweaks.alive minecraft.custom:minecraft.time_since_death
scoreboard objectives add bed_tweaks.pick trigger
# Ticks left to pick a bed from the menu
scoreboard objectives add bed_tweaks.window dummy
# Ticks spent waiting for a picked bed's chunk to load
scoreboard objectives add bed_tweaks.wait dummy
# Counts up when a player lies down in a straw bed (the slept_in_bed
# advancement only fires for beds that can set a spawn point)
scoreboard objectives add bed_tweaks.straw minecraft.custom:minecraft.sleep_in_straw_bed
# The clock time when a player was last seen asleep in a straw bed
scoreboard objectives add bed_tweaks.slept dummy
# On each bed's marker: the bed's id in storage bed_tweaks:beds
scoreboard objectives add bed_tweaks.bed dummy

# Defaults, only applied if not already configured
execute unless score #choose_seconds bed_tweaks.config matches 0.. run scoreboard players set #choose_seconds bed_tweaks.config 60
execute unless score #straw_beds bed_tweaks.config matches 0.. run scoreboard players set #straw_beds bed_tweaks.config 0
execute unless score #labels bed_tweaks.config matches 0.. run scoreboard players set #labels bed_tweaks.config 1

# Constants for scoreboard math
scoreboard players set #-1 bed_tweaks.tmp -1
scoreboard players set #2 bed_tweaks.tmp 2
scoreboard players set #20 bed_tweaks.tmp 20
