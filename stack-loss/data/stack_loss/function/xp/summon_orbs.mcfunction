# Arguments: count (of 32767-point orbs), rem (points in the remainder orb)
$execute if score #orb_count stack_loss.tmp matches 1.. run summon experience_orb ~ ~ ~ {Value:32767s,Count:$(count),Tags:["stack_loss.new"]}
$execute if score #orb_rem stack_loss.tmp matches 1.. run summon experience_orb ~ ~ ~ {Value:$(rem)s,Tags:["stack_loss.new"]}
