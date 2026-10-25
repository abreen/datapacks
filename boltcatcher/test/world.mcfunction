# Test server only: runs once after start, at the world spawn. Builds a
# catcher 3 blocks east of spawn, with a marker where a bolt drawn to its
# rod would land; /function test_setup:boltcatcher/strike strikes it.
execute positioned over world_surface run setblock ~3 ~ ~ minecraft:hopper
execute positioned over world_surface run setblock ~3 ~1 ~ minecraft:redstone_block
execute positioned over world_surface run setblock ~3 ~2 ~ minecraft:lightning_rod
execute positioned over world_surface run summon minecraft:marker ~3.5 ~3 ~0.5 {Tags:["test_setup.boltcatcher_rod"]}
