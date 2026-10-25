# Test server only: runs as each player on their first join. Fills every
# slot except hotbar.0-3 (bed-tweaks' setup) with a mix of stacks to lose:
# full and partial stacks, unstackables, a renamed item, a Curse of
# Vanishing item, a filled shulker box, worn armor, and enough levels to
# see the XP loss.
item replace entity @s hotbar.4 with minecraft:diamond_sword[enchantments={sharpness:5}]
item replace entity @s hotbar.5 with minecraft:diamond_pickaxe[enchantments={vanishing_curse:1}]
item replace entity @s hotbar.6 with minecraft:cooked_beef 32
item replace entity @s hotbar.7 with minecraft:torch 64
item replace entity @s hotbar.8 with minecraft:ender_pearl 16
item replace entity @s weapon.offhand with minecraft:shield
item replace entity @s armor.head with minecraft:iron_helmet
item replace entity @s armor.chest with minecraft:diamond_chestplate
item replace entity @s armor.legs with minecraft:iron_leggings
item replace entity @s armor.feet with minecraft:golden_boots[enchantments={vanishing_curse:1}]
item replace entity @s inventory.0 with minecraft:gold_ingot 12
item replace entity @s inventory.1 with minecraft:diamond 5
item replace entity @s inventory.2 with minecraft:iron_ingot 64
item replace entity @s inventory.3 with minecraft:emerald 20
item replace entity @s inventory.4 with minecraft:netherite_ingot
item replace entity @s inventory.5 with minecraft:golden_apple 3
item replace entity @s inventory.6 with minecraft:bow[enchantments={power:3}]
item replace entity @s inventory.7 with minecraft:arrow 48
item replace entity @s inventory.8 with minecraft:name_tag[custom_name={text:"Lucky Charm",italic:false}]
item replace entity @s inventory.9 with minecraft:cobblestone 64
item replace entity @s inventory.10 with minecraft:cobblestone 64
item replace entity @s inventory.11 with minecraft:oak_log 64
item replace entity @s inventory.12 with minecraft:oak_planks 37
item replace entity @s inventory.13 with minecraft:glass 64
item replace entity @s inventory.14 with minecraft:dirt 64
item replace entity @s inventory.15 with minecraft:redstone 64
item replace entity @s inventory.16 with minecraft:lapis_lazuli 9
item replace entity @s inventory.17 with minecraft:coal 64
item replace entity @s inventory.18 with minecraft:bread 16
item replace entity @s inventory.19 with minecraft:water_bucket
item replace entity @s inventory.20 with minecraft:shears
item replace entity @s inventory.21 with minecraft:flint_and_steel
item replace entity @s inventory.22 with minecraft:white_wool 64
item replace entity @s inventory.23 with minecraft:string 23
item replace entity @s inventory.24 with minecraft:red_shulker_box[container=[{slot:0,item:{id:"minecraft:diamond",count:7}},{slot:4,item:{id:"minecraft:iron_sword",count:1,components:{"minecraft:custom_name":{text:"Backup Blade",italic:false}}}},{slot:26,item:{id:"minecraft:bone",count:30}}]]
item replace entity @s inventory.25 with minecraft:rotten_flesh 41
item replace entity @s inventory.26 with minecraft:totem_of_undying
xp set @s 30 levels
