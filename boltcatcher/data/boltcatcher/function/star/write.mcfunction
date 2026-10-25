execute store result storage boltcatcher:tmp args.damage int 1 run scoreboard players get #damage boltcatcher.tmp
execute store result storage boltcatcher:tmp args.expires int 1 run scoreboard players get #expires boltcatcher.tmp
function boltcatcher:star/modify with storage boltcatcher:tmp args
