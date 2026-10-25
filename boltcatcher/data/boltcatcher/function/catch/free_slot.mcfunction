# Returns the first empty hopper slot plus one, or 0 if the hopper is full
execute unless items block ~ ~ ~ container.0 * run return 1
execute unless items block ~ ~ ~ container.1 * run return 2
execute unless items block ~ ~ ~ container.2 * run return 3
execute unless items block ~ ~ ~ container.3 * run return 4
execute unless items block ~ ~ ~ container.4 * run return 5
return 0
