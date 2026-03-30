dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local players = EntityGetInRadiusWithTag( x, y, 35900 * 3, "player_unit" )
if #players == 0 then return end
	
for i=1,#players do if not IsInvisible( players[i] ) then
	local px, py = EntityGetTransform( players[i] )
	local dis = math.abs( px-x ) + math.abs( py-y )

	if EntityHasTag( players[i], "speed_runner_in_deep_end" ) and not EntityHasTag( players[i], "speed_run_complete_in_deep_end" ) then
		EntitySetTransform( players[i], 780, -1200 )
		EntityApplyTransform( players[i], 780, -1200 )

		EntityAddTag( players[i], "speed_run_complete_in_deep_end" )

		GamePrintImportant( "$flee_boss_centipede_3", "$flee_boss_centipede_4" )
	elseif dis > 2000 and not EntityHasTag( players[i], "speed_runner_in_deep_end" ) then
		EntitySetTransform( players[i], 3400, 40150 )
		EntityApplyTransform( players[i], 3400, 40150 )
		
		EntitySetTransform( entity_id, 3546, 40150 )
		EntityApplyTransform( entity_id, 3546, 40150 )

		GamePrintImportant( "$flee_boss_centipede_1", "$flee_boss_centipede_2" )
	end
end end