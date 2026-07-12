dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local pl = EntityGetClosestWithTag( x, y, "player_unit" )

if pl ~= nil then
    local cx, cy = x, y

    local comp = EntityGetFirstComponent( pl, "ControlsComponent" )
    if comp ~= nil then cx, cy = ComponentGetValueVector2( comp, "mMousePosition") end

    EntitySetTransform( entity_id, cx, cy )
	EntityApplyTransform( entity_id, cx, cy )
end

