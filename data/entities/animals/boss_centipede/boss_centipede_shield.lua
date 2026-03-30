dofile_once("data/scripts/lib/utilities.lua")

local entity_id = EntityGetRootEntity(GetUpdatedEntityID())
local x, y = EntityGetTransform(entity_id)
local herd_id = get_herd_id(entity_id)

local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
local conversion_velocity_mult = clamp( 0.24 + newgame_n / 100, 0.01, 0.99 )
local final_velocity_mult = clamp( 1.2 + newgame_n / 25, 0.4, 2.0 )
local distance_full = 60

-- projectile attractor
local projectiles = EntityGetInRadiusWithTag( x, y, distance_full, "projectile" )

if #projectiles == 0 then return end
for _,id in ipairs(projectiles) do	

	local projectilecomp = EntityGetFirstComponent( id, "ProjectileComponent" )
	local is_converted = EntityHasTag( id, "projectile_converted" ) and not EntityHasTag( id, "projectile_centipede" )

	if ( ComponentGetValue2( projectilecomp, "mWhoShot" ) ~= entity_id or is_converted ) and not EntityHasTag( id, "ultra" ) then
		-- gravity
		local px, py = EntityGetTransform( ComponentGetValue2(projectilecomp, "mWhoShot") )
		local player_entity = EntityGetClosestWithTag( x, y, "player_unit")

		if player_entity ~= nil then px, py = EntityGetTransform( player_entity ) end
		
		local offset_x = px - x
		local offset_y = py - y

		offset_x = offset_x * conversion_velocity_mult
		offset_y = offset_y * conversion_velocity_mult

		-- apply velocity
		local velocitycomp = EntityGetFirstComponent( id, "VelocityComponent" )

		if velocitycomp ~= nil then
			local vel_x,vel_y = ComponentGetValue2( velocitycomp, "mVelocity" )
			
			vel_x = clamp( vel_x * ( 1 - conversion_velocity_mult ) + offset_x, -3000, 3000 ) * final_velocity_mult
			vel_y = clamp( vel_y * ( 1 - conversion_velocity_mult ) + offset_y, -3000, 3000 ) * final_velocity_mult

			ComponentSetValue2( velocitycomp, "mVelocity", vel_x, vel_y)
		else
			-- add physical force instead
			PhysicsApplyForce( id, offset_x * 0.0003, offset_y * 0.0003 )
		end

		-- extend projectile lifetime
		-- NOTE: may have slightly funky results if projectile has other lifetimes or timers
		local lifetime = ComponentGetValue2( projectilecomp, "lifetime" )

		lifetime = math.max( lifetime + 6, 18 )

		ComponentSetValue2( projectilecomp, "lifetime", lifetime )

		-- init projectile attracted for the first time
		if not is_converted then
			if projectilecomp ~= nil then
				GameEntityPlaySound( entity_id, "suck_projectile" )

				-- prevent projectile from hurting boss
				component_write( projectilecomp,
				{
					mWhoShot = entity_id,
					mShooterHerdId = herd_id,
					friendly_fire = false,
					collide_with_shooter_frames = -1,
				} )
				-- FX
				EntityLoadToEntity("data/entities/animals/boss_centipede/boss_centipede_shield_trail_effect.xml", id)
			end

			for _,comp in ipairs(EntityGetComponent(id, "AreaDamageComponent") or {}) do
				ComponentSetValue2( comp, "entities_with_tag", "player_unit" )
			end

			EntityAddComponent( id, "LifetimeComponent", { lifetime = "90", } )
			EntityAddTag( id, "projectile_converted" )
		end
	end
end


