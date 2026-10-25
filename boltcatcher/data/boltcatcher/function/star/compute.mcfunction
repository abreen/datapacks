# In: #expires, #max (seconds), #bonus (ticks), #now. Out: #expires with
# the bonus (capped at a full charge), #rem ticks left, #secs left and the
# #damage that shows it.
scoreboard players operation #expires boltcatcher.tmp += #bonus boltcatcher.tmp
scoreboard players operation #cap boltcatcher.tmp = #max boltcatcher.tmp
scoreboard players operation #cap boltcatcher.tmp *= #20 boltcatcher.tmp
scoreboard players operation #cap boltcatcher.tmp += #now boltcatcher.tmp
scoreboard players operation #expires boltcatcher.tmp < #cap boltcatcher.tmp
scoreboard players operation #rem boltcatcher.tmp = #expires boltcatcher.tmp
scoreboard players operation #rem boltcatcher.tmp -= #now boltcatcher.tmp
# Rounded up, so the bar only empties when the charge does
scoreboard players operation #secs boltcatcher.tmp = #rem boltcatcher.tmp
scoreboard players add #secs boltcatcher.tmp 19
scoreboard players operation #secs boltcatcher.tmp /= #20 boltcatcher.tmp
scoreboard players operation #damage boltcatcher.tmp = #max boltcatcher.tmp
scoreboard players operation #damage boltcatcher.tmp -= #secs boltcatcher.tmp
