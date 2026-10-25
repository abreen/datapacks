# Any item with the data counts, so stars caught as goat horns by an
# earlier version still work
execute if items entity @s container.* *[minecraft:custom_data~{boltcatcher:{}}] run return 1
execute if items entity @s weapon.* *[minecraft:custom_data~{boltcatcher:{}}] run return 1
return 0
