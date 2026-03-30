dofile_once("data/scripts/lib/utilities.lua")

local frame_count = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" ) - 2
if frame_count < 0 then return end

local entity_id = GetUpdatedEntityID()
local rrad, rrate = 0.3, 0.6

local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

if vcomp == nil or pcomp == nil then return end
local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity" )

local r = ComponentGetValue2( pcomp, "angular_velocity" )
local vel = ComponentGetValue2( pcomp, "speed_min" )

vx = math.cos( frame_count * rrad - r ) * rrate - math.sin( r ) * ( 1 - rrate )
vy = math.sin( frame_count * rrad - r ) * rrate + math.cos( r ) * ( 1 - rrate )

ComponentSetValueVector2( vcomp, "mVelocity", vx * vel, vy * vel )
