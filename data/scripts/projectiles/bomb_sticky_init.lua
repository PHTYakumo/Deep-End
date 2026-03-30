dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local find = true

local vcomp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "enable_when_player_seen" )
if vcomp == nil then find = false end

local bind_id = EntityGetClosestWithTag( x, y, "mortal" ) -- or EntityHasTag( bind_id, "glue_NOT" )
if bind_id == nil or bind_id == NULL_ENTITY
or not EntityHasTag( bind_id, "hittable" ) or not EntityGetIsAlive( bind_id ) then find = false end

local dx, dy = EntityGetTransform( bind_id )
dx = ( x - dx ) * 0.8
dy = ( y - dy ) * 0.8

local hcomp = EntityGetFirstComponent( bind_id, "HitboxComponent" )
if hcomp == nil then
	hcomp = EntityGetFirstComponent( bind_id, "PhysicsImageShapeComponent" )
	if hcomp == nil then find = false end
else
	local dist_max = ComponentGetValue2( hcomp, "aabb_max_x" )
	local dist_min = ComponentGetValue2( hcomp, "aabb_min_x" )
	if dx > dist_max or dx < dist_min then find = false end

	dist_max = ComponentGetValue2( hcomp, "aabb_max_y" )
	dist_min = ComponentGetValue2( hcomp, "aabb_min_y" )
	if dy > dist_max or dy < dist_min then find = false end
end

EntityAddComponent2( entity_id, "PhysicsBody2Component",
{
	angular_damping = 1.2,
	buoyancy = 0.5,
	destroy_body_if_entity_destroyed = true,
} )

EntityAddComponent2( entity_id, "PhysicsImageShapeComponent",
{
	image_file = "data/items_gfx/bomb_sticky.png",
	material = CellFactory_GetType("glue"),
	body_id = 1,
	is_root = true,
	centered = true,
	is_circle = false,
} )

if find then
	ComponentSetValue2( vcomp, "value_int", bind_id )
	ComponentSetValue2( vcomp, "value_float", dx )
	ComponentSetValue2( vcomp, "value_string", tostring(dy) )

	EntitySetComponentsWithTagEnabled( entity_id, "enable_when_player_seen", true )
else
	find, dx, dy = GetSurfaceNormal( x, y, 10, 18 )
	if not find then return end

	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "WELD_JOINT_ATTACH_TO_NEARBY_SURFACE",
		offset_x = 0,
		offset_y = 0,
		body1_id = 1,
		break_force = 10000,
		break_distance = 20,
		ray_x = dx,
		ray_y = dy,
		surface_attachment_offset_x = -sign(dx) * 2.5,
		surface_attachment_offset_y = -sign(dy) * 2.5,
	} )
end



