# Run as each entity found by api/entities
data modify storage claude_api:tmp entity set value {}
data modify storage claude_api:tmp entity.id set from entity @s id
data modify storage claude_api:tmp entity.pos set from entity @s Pos
data modify storage claude_api:tmp entity.uuid set from entity @s UUID
data modify storage claude_api:out result.entities append from storage claude_api:tmp entity
