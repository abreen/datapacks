# Usage: function claude_api:api/entities {x:-8,y:60,z:-8,dx:16,dy:10,dz:16}
# Lists non-player entities in the box as {id, pos, uuid}. Only entities in
# loaded chunks are found. Collected in storage because /data get on each
# entity would run together into one line over RCON
data modify storage claude_api:out result set value {ok:1b,entities:[]}
$execute as @e[type=!minecraft:player,x=$(x),y=$(y),z=$(z),dx=$(dx),dy=$(dy),dz=$(dz)] run function claude_api:api/entities_add
