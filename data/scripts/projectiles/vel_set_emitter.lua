dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local frame_count = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )

local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
local pcomps = EntityGetComponent( entity_id, "ParticleEmitterComponent" )

if vcomp == nil or pcomps == nil then return end
local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity" )

local offset = get_magnitude( vx, vy ) * 0.02 - frame_count * 2

for i=1,#pcomps do
    ComponentSetValue2( pcomps[i], "x_pos_offset_max", offset )
    ComponentSetValue2( pcomps[i], "x_pos_offset_min", offset * 0.02 )
end