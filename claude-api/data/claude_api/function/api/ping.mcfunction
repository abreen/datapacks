# Usage: function claude_api:api/ping
# Every api/ function writes its answer to storage claude_api:out result,
# which the bridge reads back with /data get
data modify storage claude_api:out result set value {ok:1b,version:1}
execute store result storage claude_api:out result.enabled byte 1 if score #enabled claude_api.config matches 1
execute store result storage claude_api:out result.game_time long 1 run time query gametime
