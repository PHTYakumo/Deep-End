dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
SetRandomSeed( entity_id, 142857 )

local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
if vcomp == nil then return end

local rnd = Random( 0, 100 ) -- n/101
local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity" )

if ComponentGetValue2( vcomp, "terminal_velocity" ) < 999 then
    ComponentSetValue2( vcomp, "terminal_velocity", 999 + rnd * 0.25 )
    ComponentSetValueVector2( vcomp, "mVelocity", vx * 3.6 - vy * ( 25 + rnd * 0.049 ), vy * 3.6 + vx * ( 25 + rnd * 0.049 ) )
else
    ComponentSetValue2( vcomp, "terminal_velocity", 6666 )
    ComponentSetValueVector2( vcomp, "mVelocity", -vy, vx )
end