dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal, projectile_id )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	if damage < 0 or script_wait_frames( entity_id, 4 ) or entity_who_caused == entity_id
	or ( EntityGetParent( entity_id ) ~= NULL_ENTITY and entity_who_caused == EntityGetParent( entity_id ) ) then return end

	if EntityHasTag( entity_id, "enemy" ) and script_wait_frames( entity_id, 10 ) then return end
	SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	
	local angle, angle_random = math.rad( Random( 1, 360 ) ), math.rad( Random( -2, 2 ) )
	local vel_x, vel_y, length = 0, 0, 900
	local projectile = ""
	
	if projectile_id ~= nil and projectile_id ~= NULL_ENTITY then
		local storages = EntityGetComponent( projectile_id, "VariableStorageComponent" )

		if storages ~= nil then for i,comp in ipairs( storages ) do
			name = ComponentGetValue2( comp, "name" )

			if name == "projectile_file" then
				projectile = ComponentGetValue2( comp, "value_string" )
				break
			end
		end end
	end
	
	if entity_who_caused ~= nil and entity_who_caused ~= NULL_ENTITY then
		local ex, ey = EntityGetTransform( entity_who_caused )
		if ex ~= nil and ey ~= nil then angle = -math.atan2( ey - y, ex - x ) end
	end
	
	if #projectile > 0 then
		vel_x = math.cos( angle + angle_random ) * length
		vel_y = -math.sin( angle + angle_random ) * length

		local pid = shoot_projectile( entity_id, projectile, x, y, vel_x, vel_y )
		local pcomp = EntityGetFirstComponent( pid, "ProjectileComponent" )

		if pcomp ~= nil then
			ComponentSetValue2( pcomp, "friendly_fire", false )
			ComponentSetValue2( pcomp, "explosion_dont_damage_shooter", true )

			if EntityHasTag( pid, "de_projectile_spawner" ) then
				local lifetime = ComponentGetValue2( pcomp, "lifetime" )
				ComponentSetValue2( pcomp, "lifetime", math.min( lifetime, 33 ) )
			end
		end
	end
end
