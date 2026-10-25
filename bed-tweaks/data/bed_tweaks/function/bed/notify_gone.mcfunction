# Arguments: owner (a UUID int array), name
$tellraw @a[nbt={UUID:$(owner)}] [{text:"You can no longer respawn at your ",color:"gray",italic:true},{translate:"$(name)"},"; it's gone."]
