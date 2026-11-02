# Blocks every api/ function that changes the world, and the bridge's
# run_commands tool; api/ queries still work
scoreboard players set #enabled agent_api.config 0
function agent_api:config/show
