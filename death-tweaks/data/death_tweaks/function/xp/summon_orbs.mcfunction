# Arguments: count (of 32767-point orbs), rem (points in the remainder orb)
$execute if score #orb_count death_tweaks.tmp matches 1.. run summon experience_orb ~ ~ ~ {Value:32767s,Count:$(count),Tags:["death_tweaks.new"]}
$execute if score #orb_rem death_tweaks.tmp matches 1.. run summon experience_orb ~ ~ ~ {Value:$(rem)s,Tags:["death_tweaks.new"]}
