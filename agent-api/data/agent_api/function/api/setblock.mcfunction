# Usage: function agent_api:api/setblock {x:0,y:64,z:0,block:"minecraft:stone"}
# ok is 0b when the block was already there or the chunk isn't loaded
data modify storage agent_api:out result set value {ok:0b}
execute unless score #enabled agent_api.config matches 1 run return run data modify storage agent_api:out result.error set value "disabled"
$execute store success storage agent_api:out result.ok byte 1 run setblock $(x) $(y) $(z) $(block)
