dofile_once( "data/scripts/lib/utilities.lua" )

local distance = 28

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
if vcomp == nil then return end

local vx, vy = ComponentGetValueVector2( vcomp, "mVelocity" )
local dir = -math.atan2( vy, vx )

x = x + math.cos( dir ) * distance
y = y - math.sin( dir ) * distance

EntitySetTransform( entity_id, x, y )