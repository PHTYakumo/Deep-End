dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local t = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
local scomp = EntityGetFirstComponent( entity_id, "SpriteComponent" )

if scomp ~= nil then
    if t <= 13 then
        ComponentSetValue2( scomp, "alpha", clamp( ComponentGetValue2( scomp, "alpha" ) + 0.08, 0.08, 1 ) )
        ComponentSetValue2( scomp, "special_scale_x", clamp( ComponentGetValue2( scomp, "special_scale_x" ) + 0.08, 0.08, 1 ) )
        ComponentSetValue2( scomp, "special_scale_y", clamp( ComponentGetValue2( scomp, "special_scale_y" ) + 0.08, 0.08, 1 ) )
    elseif t >= 56 then
        ComponentSetValue2( scomp, "alpha", clamp( ComponentGetValue2( scomp, "alpha" ) - 0.12, 0.04, 1 ) )
    end
end
