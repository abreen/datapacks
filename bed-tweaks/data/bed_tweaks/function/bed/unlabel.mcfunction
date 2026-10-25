# Removes the label of the bed whose foot is here. The bed may be gone, so
# its facing is unknown; try the middle of each side. No other bed's label
# can be there, as that bed would have to share this bed's foot
execute positioned ~ ~1 ~-0.5 run kill @e[type=text_display,tag=bed_tweaks.label,distance=..0.05]
execute positioned ~ ~1 ~0.5 run kill @e[type=text_display,tag=bed_tweaks.label,distance=..0.05]
execute positioned ~-0.5 ~1 ~ run kill @e[type=text_display,tag=bed_tweaks.label,distance=..0.05]
execute positioned ~0.5 ~1 ~ run kill @e[type=text_display,tag=bed_tweaks.label,distance=..0.05]
