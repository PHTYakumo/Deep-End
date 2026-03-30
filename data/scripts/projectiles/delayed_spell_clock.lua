dofile_once("data/scripts/lib/utilities.lua")

local comp = EntityGetFirstComponent( GetUpdatedEntityID(), "VelocityComponent" )
if comp == nil then return end

local vx, vy = ComponentGetValueVector2( comp, "mVelocity" )
local vel, angle = math.max( get_magnitude( vx, vy ), 1 ), GameGetFrameNum() * 0.0004

angle = angle * vel
ComponentSetValueVector2( comp, "mVelocity", -math.sin( angle ) * vel, math.cos( angle ) * vel )
