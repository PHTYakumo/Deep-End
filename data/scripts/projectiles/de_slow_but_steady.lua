dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

if vcomp == nil or pcomp == nil then return end

local vx, vy = ComponentGetValueVector2( vcomp, "mVelocity" )	
local air_friction = ComponentGetValue2( vcomp, "air_friction" )

ComponentSetValue2( vcomp, "gravity_x", 0 )
ComponentSetValue2( vcomp, "gravity_y", 0 )
ComponentSetValue2( vcomp, "liquid_drag", 0 )
ComponentSetValue2( vcomp, "air_friction", 0 )

ComponentSetValue2( pcomp, "friction", 0 )
ComponentSetValue2( pcomp, "die_on_low_velocity", false )

air_friction = 1 / ( 1 + math.max( air_friction * 0.4 , 0 ) )
ComponentGetValueVector2( vcomp, "mVelocity", vx * air_friction, vy * air_friction )