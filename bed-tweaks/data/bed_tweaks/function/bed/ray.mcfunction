# One 0.05-block step. Argument: check, the function that looks for the new
# bed here. Succeeds if it registered one
$execute if function bed_tweaks:bed/$(check) run return 1
scoreboard players remove #steps bed_tweaks.tmp 1
$execute if score #steps bed_tweaks.tmp matches 1.. positioned ^ ^ ^0.05 run return run function bed_tweaks:bed/ray {check:"$(check)"}
return fail
