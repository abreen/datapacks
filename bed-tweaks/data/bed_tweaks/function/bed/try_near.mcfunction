# Like try, but at the corners of a 0.05-block cube around the point. Steps
# are 0.05 apart, so this reaches every block the ray passes through
execute positioned ~-0.025 ~-0.025 ~-0.025 if function bed_tweaks:bed/try run return 1
execute positioned ~-0.025 ~-0.025 ~0.025 if function bed_tweaks:bed/try run return 1
execute positioned ~-0.025 ~0.025 ~-0.025 if function bed_tweaks:bed/try run return 1
execute positioned ~-0.025 ~0.025 ~0.025 if function bed_tweaks:bed/try run return 1
execute positioned ~0.025 ~-0.025 ~-0.025 if function bed_tweaks:bed/try run return 1
execute positioned ~0.025 ~-0.025 ~0.025 if function bed_tweaks:bed/try run return 1
execute positioned ~0.025 ~0.025 ~-0.025 if function bed_tweaks:bed/try run return 1
execute positioned ~0.025 ~0.025 ~0.025 if function bed_tweaks:bed/try run return 1
return fail
