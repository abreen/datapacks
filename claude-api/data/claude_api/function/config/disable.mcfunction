# Blocks every api/ function that changes the world; queries still work
scoreboard players set #enabled claude_api.config 0
function claude_api:config/show
