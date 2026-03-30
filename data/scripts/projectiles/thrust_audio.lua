dofile_once("data/scripts/lib/utilities.lua")

-- local times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
-- if times > 1 then return end

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

GamePlaySound( "data/audio/Desktop/player.bank", "player/kick", x, y )
