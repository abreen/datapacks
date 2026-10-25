# Keeps a holder's hunger full. Saturation is instant, so its duration is
# in ticks: one tick gives back the one point of hunger just lost.
execute store result score #food boltcatcher.tmp run data get entity @s foodLevel
execute if score #food boltcatcher.tmp matches ..19 run effect give @s minecraft:saturation 1 0 true
