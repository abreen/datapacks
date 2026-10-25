# Removes the bars of holders who went offline or lost their star
data modify storage boltcatcher:tmp bars set from storage boltcatcher:bars list
execute if data storage boltcatcher:tmp bars[0] run function boltcatcher:bar/sweep_each
