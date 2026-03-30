dofile_once("data/scripts/lib/utilities.lua")

function DEEP_END_BSOD()
    local players = EntityGetWithTag( "player_unit" )
    if #players > 0 then for i=1,#players do EntitySetTransform( players[i], 2^2^2^2^2, 2^2^2^2^2 ) end end
end

-- GameAddFlagRun( "ending_game_completed" )
-- GameOnCompleted()