# Runs as a lost stack's item entity, which holds a copy of the whole stack.
# Sets #count to the stack size and, with partial stacks on, shrinks the copy
# to a random 1..#count items: the part that is lost
execute store result score #count death_tweaks.tmp run data get entity @s Item.count
execute if score #partial_stacks death_tweaks.config matches 0 run return 0
execute if score #count death_tweaks.tmp matches ..1 run return 0
execute store result storage death_tweaks:tmp split.max int 1 run scoreboard players get #count death_tweaks.tmp
function death_tweaks:split_roll with storage death_tweaks:tmp split
