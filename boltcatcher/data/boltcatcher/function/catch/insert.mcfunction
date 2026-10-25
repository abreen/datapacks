# A goat horn drawn as a Nether Star: a real Nether Star could be crafted
# into a beacon, or two merged into a plain one by the repair recipe.
# Without an instrument the horn does nothing when used.
$item replace block ~ ~ ~ container.$(slot) with minecraft:goat_horn[!minecraft:instrument,minecraft:item_model="minecraft:nether_star",minecraft:item_name={text:"Caught Lightning",color:"yellow"},minecraft:rarity="epic",minecraft:enchantment_glint_override=true,minecraft:max_damage=$(max),minecraft:damage=$(damage),minecraft:lore=[{text:"Fight to keep it charged",color:"gray",italic:true}],minecraft:custom_data={boltcatcher:{expires:$(expires)}}]
