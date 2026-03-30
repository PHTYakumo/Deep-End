dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local p = EntityGetWithTag( "player_unit" )

if ( #p > 0 ) then
	for i=1,#p do
		local x,y = EntityGetTransform( p[i] )

		EntityAddChild( p[i], EntityLoad( "data/entities/animals/boss_wizard/debuff.xml", x, y ) )
		EntityAddChild( p[i], EntityLoad( "data/entities/misc/effect_blindness_immediate.xml", x, y ) )

		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/fungal_effect/create", x, y-72 )
	end
end

EntityKill( entity_id )