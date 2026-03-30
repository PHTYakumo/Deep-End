dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
if EntityGetRootEntity(entity_id) ~= entity_id then return end

local icomp = EntityGetFirstComponent( entity_id, "ItemComponent" )
if not ComponentGetValue2( icomp, "has_been_picked_by_player" ) then return end

local x, y, r, sx, sy = EntityGetTransform(entity_id)
if x == nil then return end

local vx, vy = ComponentGetValueVector2( EntityGetFirstComponent( entity_id, "VelocityComponent" ), "mVelocity" )
r = r + ( vx^2 + vy^2 )^0.25 * 0.1

EntitySetTransform( entity_id, x, y, r, sx, sy )
EntityApplyTransform( entity_id, x, y, r, sx, sy )

-- GamePrint(tostring(r))