function boltcatcher:bar/check with storage boltcatcher:tmp bars[0]
data remove storage boltcatcher:tmp bars[0]
execute if data storage boltcatcher:tmp bars[0] run function boltcatcher:bar/sweep_each
