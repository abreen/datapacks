# The damage used up all remaining durability: remove the copy and lose the
# original whole, like any other stack. Argument: slot
kill @e[type=item,tag=death_tweaks.new]
$function death_tweaks:lose {slot:"$(slot)"}
