dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local parent_id = EntityGetParent( entity_id )
local target_id, friction, timelimit = entity_id, 0, true

if parent_id ~= NULL_ENTITY then target_id = parent_id end
local x, y, r, sx, sy = EntityGetTransform( target_id )

if target_id ~= NULL_ENTITY  then
	local projectile_components = EntityGetComponent( target_id, "ProjectileComponent" )
	local velocity_comp = EntityGetFirstComponent( target_id, "VelocityComponent" )
		
	if #projectile_components == 0 or velocity_comp == nil then return end
	local vx, vy = ComponentGetValueVector2( velocity_comp, "mVelocity" )
	
	edit_component( target_id, "ProjectileComponent", function(comp,vars) -- interaction with entities and terrain
		vars.on_death_gfx_leave_sprite = false
		vars.die_on_liquid_collision = false
		vars.collide_with_world = false
		vars.on_collision_die = true
		vars.penetrate_entities = true
		vars.velocity_sets_scale = true
	end)

	edit_component( target_id, "VelocityComponent", function(comp,vars) -- velocity
		friction = ComponentGetValue2( comp, "air_friction" )
		vars.terminal_velocity = 16384
		vars.air_friction = -64
		vars.liquid_drag = 0
		vars.gravity_x = 0
		vars.gravity_y = 0
	end)

	if EntityHasTag( target_id, "black_hole" ) then -- bigger black holes
		local ce_comp = EntityGetFirstComponent( target_id, "CellEaterComponent" )

		if ce_comp ~= nil then ComponentSetValue2( ce_comp, "radius", 64 ) end

		edit_component( target_id, "ProjectileComponent", function(comp,vars)
			vars.velocity_sets_scale = false
		end)

		edit_component( target_id, "VelocityComponent", function(comp,vars)
			vars.terminal_velocity = 4096
		end)

		EntitySetTransform( target_id, x, y, r, sx*4, sy*4 )
	end

	local tp_comp = EntityGetFirstComponent( target_id, "TeleportProjectileComponent" ) -- teleportable inside the wall
	if tp_comp ~= nil then ComponentSetValue2( tp_comp, "min_distance_from_wall", 0 ) end

	if EntityGetFirstComponent( target_id, "GameAreaEffectComponent" ) ~= nil then -- bigger field spells
		local particle_components = EntityGetComponent( target_id, "ParticleEmitterComponent" )

		if particle_components ~= nil then
			for i=1,#particle_components do
				ComponentSetValue2( particle_components[i], "area_circle_radius", 63, 65 )
			end
		end

		local shield_components = EntityGetComponent( target_id, "EnergyShieldComponent" )

		if shield_components ~= nil then
			for i=1,#shield_components do
				ComponentSetValue2( shield_components[i], "radius", 64 )
			end
		end

		EntitySetTransform( target_id, x, y, r, sx*2, sy*2 )

		edit_component( target_id, "GameAreaEffectComponent", function(comp,vars)
			vars.radius = 64
		end)
	elseif EntityGetFirstComponent( target_id, "PhysicsBody2Component" ) ~= nil then -- cart
		PhysicsApplyTorque( target_id, 2147483647 )
		-- ComponentSetValue2( velocity_comp, "mVelocity", vx * 32, vy * 32 )
	elseif EntityGetFirstComponent( target_id, "PhysicsBodyComponent" ) ~= nil then -- physics
		local shooter = ComponentGetValue2( projectile_components[1], "mWhoShot" )

		if shooter ~= nil and shooter ~= NULL_ENTITY and ( not EntityHasTag( shooter, "wand_ghost" ) ) then
			vx, vy = EntityGetTransform( shooter )
			timelimit = RaytracePlatforms( vx, vy + 2, vx, vy - 10 ) -- depending on whether the shooter is inside the wall

			if timelimit then
				EntityConvertToMaterial( target_id, "spark_white_bright" ) -- vanish rapidly, able to cast inside the wall to delete the terrain according to the projectile's shape
			else
				PhysicsSetStatic( target_id, true ) -- become part of the terrain
			end
		end

		edit_component( target_id, "PhysicsBodyComponent", function(comp,vars)
			vars.projectiles_rotate_toward_velocity = false
		end)
	else
		local dir = ( vx^2 + vy^2 )^0.5

		if dir < 4 then -- the lower limit of the initial velocity
			local shooter = ComponentGetValue2( projectile_components[1], "mWhoShot" )

			if shooter ~= nil and shooter ~= NULL_ENTITY and ( not EntityHasTag( shooter, "wand_ghost" ) ) then
				vx, vy = EntityGetTransform( shooter )
				dir = -math.atan2( y - vy + 4, x - vx )

				vx = math.cos( dir ) * 256
				vy = -math.sin( dir ) * 256

				ComponentSetValue2( velocity_comp, "mVelocity", vx, vy )
			end
		elseif friction > 0 and dir < 1024 and EntityGetFirstComponent( target_id, "DamageModelComponent" ) == nil then -- sonic boom
			EntityLoad( "data/entities/projectiles/deck/fireblast_f_t_l.xml", x, y )
		end
	end

	local tlimit = 13

	if EntityHasTag( target_id, "death_cross") then tlimit = 69 end -- "ftl + deathcross with trigger + ftl + deathcross with trigger" can go directly to PW
	if timelimit then EntityAddComponent( target_id, "LifetimeComponent",{lifetime = tostring(tlimit),} ) end -- time limitation
end