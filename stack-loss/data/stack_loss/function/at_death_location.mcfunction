# Integer x/z are already block-centered by `positioned`; lift y off the floor
$execute in $(dimension) positioned $(x) $(y) $(z) positioned ~ ~0.5 ~ run function stack_loss:roll_all
$execute in $(dimension) positioned $(x) $(y) $(z) positioned ~ ~0.5 ~ run function stack_loss:xp/lose
