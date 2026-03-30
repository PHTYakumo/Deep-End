dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

if vcomp == nil or pcomp == nil then return end
local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity" )
	
ComponentSetValue2( pcomp, "speed_min", get_magnitude( vx, vy ) )
ComponentSetValue2( pcomp, "angular_velocity", -math.atan2( vx, vy ) )
ComponentSetValue2( pcomp, "velocity_sets_rotation", true )