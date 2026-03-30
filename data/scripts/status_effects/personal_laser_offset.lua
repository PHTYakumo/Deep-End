dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetParent( entity_id )

if entity_id == root_id then return end

local icomp = EntityGetFirstComponent( entity_id, "InheritTransformComponent" )
local hcomp = EntityGetFirstComponent( root_id, "HitboxComponent" )
	
if icomp ~= nil and hcomp ~= nil then
	local hx1 = ComponentGetValue2( hcomp, "aabb_min_x" )
	local hx2 = ComponentGetValue2( hcomp, "aabb_max_x" )
	local hy1 = ComponentGetValue2( hcomp, "aabb_min_y" )
	local hy2 = ComponentGetValue2( hcomp, "aabb_max_y" )

	local x, y, sx, sy, r = ComponentGetValue2( icomp, "Transform" )

	x = hx1 * 1.05 + hx2 + 0.05
	y = hy1 * 1.065 + hy2 - 0.02

	ComponentSetValue2( icomp, "Transform", x, y, sx, sy, r )
end