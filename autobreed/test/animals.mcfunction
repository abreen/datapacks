execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run function test_setup:autobreed/pens
# Two cows in the west pen (should breed up to the limit), a cow and a sheep
# in the east pen (no partner), six cows in the south pen (several pairs at
# once mustn't overshoot the limit), and two free cows west of spawn
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~6.5 ~ ~6.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~8.5 ~ ~8.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~56.5 ~ ~6.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:sheep ~58.5 ~ ~8.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~-50.5 ~ ~-50.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~-51.5 ~ ~-50.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~5.5 ~ ~55.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~7.5 ~ ~55.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~9.5 ~ ~55.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~5.5 ~ ~59.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~7.5 ~ ~59.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~9.5 ~ ~59.5
# Three cows packed into the 3x3 pen: should breed
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~55.5 ~ ~55.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~56.5 ~ ~56.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~57.5 ~ ~55.5
# Three cows spread out in the 13x13 pen: should breed
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~-57.5 ~ ~49.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~-53.5 ~ ~52.5
execute at @e[type=minecraft:marker,tag=test_setup.autobreed_origin] run summon minecraft:cow ~-48.5 ~ ~57.5
