dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

if entity_id ~= nil and entity_id ~= NULL_ENTITY then
	local projcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
	if projcomp == nil then return end

	-- ComponentSetValue2( projcomp, "friction", math.max( 0, ComponentGetValue2( projcomp, "friction" ) ) )
	ComponentSetValue2( projcomp, "penetrate_world", true )
	ComponentSetValue2( projcomp, "penetrate_world_velocity_coeff", ComponentGetValue2( projcomp, "friction" ) + 0.15 )

	local velcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
	if velcomp == nil then return end

	-- ComponentSetValue2( velcomp, "air_friction", math.max( 0, ComponentGetValue2( velcomp, "air_friction" ) ) )
	ComponentSetValue2( velcomp, "gravity_x", 0 )
	ComponentSetValue2( velcomp, "gravity_y", 0 )
end
