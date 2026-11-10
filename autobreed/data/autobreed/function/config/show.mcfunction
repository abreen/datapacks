tellraw @s [{text:"[Autobreed] ",color:"gold"},"Each adult tries to breed every ",{score:{name:"#interval",objective:"autobreed.config"},color:"yellow"}," seconds, with a ",{score:{name:"#chance",objective:"autobreed.config"},color:"yellow"},"% chance"]
tellraw @s [{text:"[Autobreed] ",color:"gold"},"Breeding stops at ",{score:{name:"#limit",objective:"autobreed.config"},color:"yellow"}," farm animals within 24 blocks"]
execute if score #xp_orbs autobreed.config matches 1 run tellraw @s [{text:"[Autobreed] ",color:"gold"},"Breeding drops experience orbs: ",{text:"on",color:"yellow"}]
execute if score #xp_orbs autobreed.config matches 0 run tellraw @s [{text:"[Autobreed] ",color:"gold"},"Breeding drops experience orbs: ",{text:"off",color:"red"}]
