execute store result score @s autobreed.wait run random value 0..3600
scoreboard players operation @s autobreed.wait %= #interval autobreed.config
