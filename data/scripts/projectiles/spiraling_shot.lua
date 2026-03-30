dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local rrad = 0.4

local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

if vcomp == nil or pcomp == nil then return end
local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity" )
		
local rx = math.cos( rrad ) * vx - math.sin( rrad ) * vy
local ry = math.sin( rrad ) * vx + math.cos( rrad ) * vy

ComponentSetValueVector2( vcomp, "mVelocity", rx, ry )

ComponentSetValue2( vcomp, "gravity_y", 0 )
ComponentSetValue2( vcomp, "gravity_x", 0 )