# Arguments: slot, count (negative: how many to remove)
$item modify entity @s $(slot) {type:"set_count",count:$(count),add:true}
