# Runs as and at each new lightning bolt. A bolt drawn to a rod lands on the
# block above it, and vanilla only draws bolts to a rod with open sky above.
tag @s add boltcatcher.seen
execute if block ~ ~-1 ~ #minecraft:lightning_rods[facing=up] if block ~ ~-2 ~ minecraft:redstone_block if block ~ ~-3 ~ minecraft:hopper positioned ~ ~-3 ~ run function boltcatcher:catch/try
