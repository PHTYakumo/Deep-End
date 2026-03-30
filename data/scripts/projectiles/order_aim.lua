dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 512*2

local players = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )

if ( #players > 0 ) then
	local pid = players[1]
    
    local cx, cy

    edit_component( pid, "ControlsComponent", function(mcomp,vars)
        cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
    end)

    EntitySetTransform( entity_id, cx, cy )
	EntityApplyTransform( entity_id, cx, cy )
end

