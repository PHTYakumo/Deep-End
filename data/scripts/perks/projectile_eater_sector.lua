dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( entity_id )

local x, y = EntityGetTransform( entity_id )
local ax, ay, a = 0, 0

local deg_full, distance_full = 24, 24
local pcomp = EntityGetFirstComponent( entity_id, "ParticleEmitterComponent" )

if pcomp ~= nil then
	deg_full, distance_full = ComponentGetValue2( pcomp, "area_circle_radius" )
	deg_full = ComponentGetValue2( pcomp, "area_circle_sector_degrees" ) - 6
end

local projectiles = EntityGetInRadiusWithTag( x, y, distance_full, "projectile" )
edit_component( player_id, "ControlsComponent", function(comp,vars) ax,ay = ComponentGetValue2( comp, "mAimingVector" ) end)

a, y = math.pi - math.atan2( ay, ax ), y - 4
EntitySetTransform( entity_id, x, y, -a )

if #projectiles > 0 then for i,projectile_id in ipairs( projectiles ) do	
	local px, py = EntityGetTransform( projectile_id )
	local distance, direction = get_distance( px, py, x, y ), get_direction( px, py, x, y )
	
	local dirdelta = get_direction_difference( direction, a )
	local dirdelta_deg = math.abs( math.deg( dirdelta ) )
	
	if distance <= distance_full and dirdelta_deg < deg_full then
		local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
			
		if projectilecomponents ~= nil then for j,comp_id in ipairs( projectilecomponents ) do
			ComponentSetValue2( comp_id, "on_death_explode", false )
			ComponentSetValue2( comp_id, "on_lifetime_out_explode", false )
			ComponentSetValue2( comp_id, "collide_with_entities", false )
			ComponentSetValue2( comp_id, "collide_with_world", false )
		end end
		
		EntityKill( projectile_id )
	end
end end