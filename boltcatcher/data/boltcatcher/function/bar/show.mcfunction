# Fails harmlessly if the bar already exists
$bossbar add boltcatcher:$(id) ""
$execute unless data storage boltcatcher:bars list[{id:$(id)}] run data modify storage boltcatcher:bars list append value {id:$(id)}
$bossbar set boltcatcher:$(id) players @a
$bossbar set boltcatcher:$(id) max $(max)
$bossbar set boltcatcher:$(id) value $(value)
$bossbar set boltcatcher:$(id) color $(color)
$execute if score #sec boltcatcher.tmp matches 10.. run bossbar set boltcatcher:$(id) name [{text:"⚡ ",color:"yellow"},{selector:"@s"},"  ",{score:{name:"#mins",objective:"boltcatcher.tmp"}},":",{score:{name:"#sec",objective:"boltcatcher.tmp"}}]
$execute if score #sec boltcatcher.tmp matches ..9 run bossbar set boltcatcher:$(id) name [{text:"⚡ ",color:"yellow"},{selector:"@s"},"  ",{score:{name:"#mins",objective:"boltcatcher.tmp"}},":0",{score:{name:"#sec",objective:"boltcatcher.tmp"}}]
