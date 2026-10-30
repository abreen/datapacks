# Usage: function claude_api:api/test_block {x:0,y:64,z:0,block:"minecraft:stone"}
# block can be a tag (#minecraft:logs) or carry states (oak_stairs[facing=north]).
# loaded is 0b when the chunk isn't loaded, since then match is meaningless
data modify storage claude_api:out result set value {ok:1b,loaded:0b,match:0b}
$execute store success storage claude_api:out result.loaded byte 1 if loaded $(x) $(y) $(z)
$execute store success storage claude_api:out result.match byte 1 if block $(x) $(y) $(z) $(block)
