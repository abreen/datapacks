# Usage: function claude_api:api/fill {x1:0,y1:64,z1:0,x2:4,y2:68,z2:4,block:"minecraft:stone"}
# count is how many blocks changed. Vanilla refuses areas over the
# max_block_modifications game rule, which leaves ok at 0b
data modify storage claude_api:out result set value {ok:0b,count:0}
execute unless score #enabled claude_api.config matches 1 run return run data modify storage claude_api:out result.error set value "disabled"
$execute store success storage claude_api:out result.ok byte 1 store result storage claude_api:out result.count int 1 run fill $(x1) $(y1) $(z1) $(x2) $(y2) $(z2) $(block)
