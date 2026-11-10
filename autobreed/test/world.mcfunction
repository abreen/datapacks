# Test server only: runs once after start, at the world spawn. Places a
# marker at the surface and force-loads the test area around it; the pens
# are built by /function test_setup:autobreed/animals, once those chunks
# have loaded (a fill into an unloaded chunk silently does nothing).
execute positioned over world_surface run summon minecraft:marker ~ ~ ~ {Tags:["test_setup.autobreed_origin"]}
forceload add ~-64 ~-64 ~64 ~64
