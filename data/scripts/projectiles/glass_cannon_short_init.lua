dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )

if EntityHasTag( root_id, "de_effect_cannon" ) then
	local c = EntityGetAllChildren( root_id )
	local buff_time, interval = 0, 6

	if c ~= nil then for i,child in ipairs( c ) do if EntityHasTag( child, "de_effect_cannon" ) then
		local comp = EntityGetFirstComponent( child, "GameEffectComponent" )
	
		if comp ~= nil then
			buff_time = ComponentGetValue2( comp, "frames" )
			buff_time = math.min( 600 + buff_time, 10801 )
			ComponentSetValue2( comp, "frames", buff_time )
		end
		
		comp = EntityGetFirstComponent( child, "LifetimeComponent" )
	
		if comp ~= nil then
			ComponentSetValue2( comp, "creation_frame", GameGetFrameNum() )
			ComponentSetValue2( comp, "kill_frame", GameGetFrameNum() + buff_time )
		end

		comp = EntityGetFirstComponent( child, "SpriteParticleEmitterComponent" )

		if comp ~= nil then
			interval = ComponentGetValue2( comp, "emission_interval_max_frames" )
			ComponentSetValue2( comp, "emission_interval_max_frames", math.max( interval - 1, 6 ) )
		end
		
		break
	end end end
end

EntityKill( entity_id )