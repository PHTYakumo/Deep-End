dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, r, sx, sy = EntityGetTransform( entity_id )

local comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )

if comp == nil then
    comp = EntityGetFirstComponent( entity_id, "SpriteComponent" )

    if comp ~= nil then
        ComponentSetValue2( comp, "alpha", ComponentGetValue2( comp, "alpha" ) - 0.0344 )
        ComponentSetValue2( comp, "special_scale_x", ComponentGetValue2( comp, "special_scale_x" ) + 0.0345 )
        ComponentSetValue2( comp, "special_scale_y", ComponentGetValue2( comp, "special_scale_y" ) + 0.0345 )
    end
else
    local vx, vy = ComponentGetValueVector2( comp, "mVelocity" )
    r = math.pi * 1.5 - math.atan2( vx, vy )

    local eid = EntityLoad( "data/entities/misc/order_fade.xml", x, y )
    local pl = EntityGetClosestWithTag( x, y, "player_unit" )

    if pl ~= nil then
        comp = EntityGetFirstComponent( pl, "ControlsComponent" )
        if comp ~= nil then x, y = ComponentGetValueVector2( comp, "mMousePosition") end
    end

    EntitySetTransform( eid, x, y, r )
    EntityApplyTransform( eid, x, y, r )
end


