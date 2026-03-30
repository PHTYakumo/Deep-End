dofile_once("data/scripts/lib/utilities.lua")

local range = 200
local projectile_velocity_min = 600
local projectile_velocity_max = 750
local scatter = 0.05

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)
local px, py = EntityGetTransform( entity_id )

SetRandomSeed(px + GameGetFrameNum(), py + entity_id)

-- locate nearest enemy
local enemy, ex, ey
local min_dist = 9999
for _,id in pairs( EntityGetInRadiusWithTag(px, py, range, "mortal") ) do
	-- is target a valid enemy
	if EntityGetComponent( id, "GenomeDataComponent" ) ~= nil
	and EntityGetHerdRelation( root_id, id ) < 40
	and IsPlayer( root_id ) ~= IsPlayer( id )
	and not EntityHasTag( id, "holy_mountain_creature" ) 
	and not EntityHasTag( id, "do_not_homing_this" ) then
		local x, y = EntityGetFirstHitboxCenter( id )
		local dist = get_distance( px, py, x, y )

		if dist < min_dist then
			min_dist = dist
			enemy = id
			ex = x
			ey = y
		end
	end
end

if not enemy then return end

-- check los
if RaytraceSurfacesAndLiquiform( px, py, ex, ey ) then return end

-- direction
local vx, vy = vec_sub( ex, ey, px, py )
vx,vy = vec_normalize( vx, vy )

-- change projectile based on lost hp
local projectile = "light_bullet"
local count = 1

if IsPlayer(root_id) then
	local projectiles_list = { "deck/light_bullet", "deck/light_bullet_blue", "deck/bullet", "deck/spitter", "orb_green", 'orb' }

	projectile = projectiles_list[Random( 1, #projectiles_list )]
end

for i=1,count do
	-- scatter
	local vx,vy = vec_rotate( vx,vy, rand( -scatter, scatter ) )
	scatter = scatter + 0.05 -- subsequent shots more inaccurate

	-- apply velocity & shoot
	vx,vy = vec_mult( vx,vy, rand( projectile_velocity_min, projectile_velocity_max ) )
	local eid = shoot_projectile( root_id, "data/entities/projectiles/".. projectile .. ".xml", px, py, vx, vy )
	
	--[[
	-- scale damage by visited biome count
	if ( eid ~= nil ) then
		local c = EntityGetFirstComponent( eid, "ProjectileComponent" )
		local vbc = tonumber( GlobalsGetValue( "visited_biomes_count" ) ) or 0
		
		if ( c ~= nil ) and ( vbc > 0 ) then
			local extra_damage = vbc
			local damage = ComponentGetValue2( c, "damage" ) + extra_damage * 0.1
			ComponentSetValue2( c, "damage", damage )
		end
	end
	--]]
end

-- delay randomly so that multiple ghosts shoot at different times
local comp_id = GetUpdatedComponentID()
if comp_id ~= 0 then
	ComponentSetValue( comp_id, "execute_every_n_frame", 24 + Random(2) )
end

