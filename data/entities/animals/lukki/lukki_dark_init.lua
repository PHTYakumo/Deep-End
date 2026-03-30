dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( entity_id - x, GameGetFrameNum() - y )
local mult = Random( 6, 10 ) * 0.2

local aracomps = EntityGetComponent( entity_id, "AreaDamageComponent" )
local sptcomps = EntityGetComponent( entity_id, "SpriteComponent" )
local htbcomp = EntityGetFirstComponent( entity_id, "HitboxComponent" )
local clecomp = EntityGetFirstComponent( entity_id, "CellEaterComponent" )

if aracomps[1] ~= nil then for i,v in ipairs( aracomps ) do
	ComponentSetValue2( v, "circle_radius", math.ceil( ComponentGetValue2( v, "circle_radius" ) * mult - 0.55 ) )
	ComponentSetValue2( v, "damage_per_frame", math.floor( 16 * mult ) * 0.01 )
end end

if sptcomps[1] ~= nil then for i,v in ipairs( sptcomps ) do
	ComponentSetValue2( v, "special_scale_x", mult )
	ComponentSetValue2( v, "special_scale_y", mult )
end end

if htbcomp ~= nil then
	ComponentSetValue2( htbcomp, "aabb_min_x", -math.ceil( 10 * mult - 0.5 ) )
	ComponentSetValue2( htbcomp, "aabb_min_y", -math.ceil( 10 * mult - 0.5 ) )
	ComponentSetValue2( htbcomp, "aabb_max_x", math.ceil( 10 * mult - 0.5 ) )
	ComponentSetValue2( htbcomp, "aabb_max_y", math.ceil( 10 * mult - 0.5 ) )
end

if clecomp == nil then return end
ComponentSetValue2( clecomp, "radius", math.ceil( 18 * mult - 0.45 ) )
