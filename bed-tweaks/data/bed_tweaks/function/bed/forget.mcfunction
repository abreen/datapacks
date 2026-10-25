# Removes a bed from storage and tells its owner, if online. Argument: bed
data remove storage bed_tweaks:tmp gone
$data modify storage bed_tweaks:tmp gone set from storage bed_tweaks:beds list[{bed:$(bed)}]
$data remove storage bed_tweaks:beds list[{bed:$(bed)}]
execute if data storage bed_tweaks:tmp gone run function bed_tweaks:bed/notify_gone with storage bed_tweaks:tmp gone
