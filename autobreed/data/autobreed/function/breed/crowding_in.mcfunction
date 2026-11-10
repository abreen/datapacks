# Returns the number of adult farm animals (any species) within 3 blocks of
# here, other than the pair. Babies don't count, since they follow their
# parents while they grow up.
execute store result score #others autobreed.tmp if entity @e[type=#autobreed:livestock,distance=..3,tag=!autobreed.first,tag=!autobreed.mate,predicate=!autobreed:baby]
return run scoreboard players get #others autobreed.tmp
