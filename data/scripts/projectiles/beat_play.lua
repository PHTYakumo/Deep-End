dofile_once("data/scripts/lib/utilities.lua")

-- local times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
-- if times > 1 then return end

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

GamePlaySound( "data/audio/Desktop/player.bank", "game_effect/on_fire/game_effect_end", x, y )
local enemies = EntityGetInRadiusWithTag( x, y, 24, "de_ghosty_enemy")

if not enemies then return end
for i=1,#enemies do EntityKill(enemies[i]) end