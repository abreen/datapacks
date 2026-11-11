# Run at the origin marker. Three 5x5 pens, a 3x3 one and a 13x13 one, 50 blocks apart so
# they don't share the herd limit (24 blocks). The walls are stone because
# fences placed by /fill don't connect, and animals squeeze between the posts.
fill ~4 ~ ~4 ~10 ~1 ~10 minecraft:stone_bricks
fill ~5 ~ ~5 ~9 ~1 ~9 minecraft:air
fill ~54 ~ ~4 ~60 ~1 ~10 minecraft:stone_bricks
fill ~55 ~ ~5 ~59 ~1 ~9 minecraft:air
fill ~4 ~ ~54 ~10 ~1 ~60 minecraft:stone_bricks
fill ~5 ~ ~55 ~9 ~1 ~59 minecraft:air
# A 3x3 pen, where animals are always pressed together
fill ~54 ~ ~54 ~58 ~1 ~58 minecraft:stone_bricks
fill ~55 ~ ~55 ~57 ~1 ~57 minecraft:air
# A 13x13 pen where animals wander apart, as in a real field
fill ~-60 ~ ~46 ~-46 ~1 ~60 minecraft:stone_bricks
fill ~-59 ~ ~47 ~-47 ~1 ~59 minecraft:air
