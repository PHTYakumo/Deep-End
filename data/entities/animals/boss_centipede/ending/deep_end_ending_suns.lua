dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local player_entity = EntityGetClosestWithTag( x, y, "player_unit")

if player_entity ~= nil then
    local px, py = EntityGetTransform( player_entity )

    local dx = x - px
    local dy = y - py
    local angle = math.pi/10

    dx,dy = vec_rotate( dx, dy, angle )

    local nx = dx * 0.97 + px
    local ny = dy * 0.97 + py

    EntitySetTransform( entity_id, nx, ny )
	EntityApplyTransform( entity_id, nx, ny )
else
    if ( ModSettingGet( "DEEP_END.NIGHTMARE_END" ) ) then EntityLoad( "data/entities/projectiles/deck/circle_end.xml", x, y ) end
    EntityKill( entity_id )
end