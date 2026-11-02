execute if score #enabled agent_api.config matches 1 run tellraw @s [{text:"[Agent API] ",color:"gold"},"The agent can change the world and run commands. Turn this off with ",{text:"/function agent_api:config/disable",color:"yellow"}]
execute unless score #enabled agent_api.config matches 1 run tellraw @s [{text:"[Agent API] ",color:"gold"},"The agent can't change the world or run commands. Turn this on with ",{text:"/function agent_api:config/enable",color:"yellow"}]
# tellraw @s shows nothing from the console or RCON, so also return the
# state there: "returned 1" means enabled
execute if score #enabled agent_api.config matches 1 run return 1
return 0
