dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	if damage <= 0 or entity_who_caused == entity_id or script_wait_frames( entity_id, 2 ) then return end
	SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	
	local angle, angle_inc, angle_inc_set = 0, 0, false
	local length = 333
	
	if entity_who_caused ~= nil and entity_who_caused ~= NULL_ENTITY then
		local ex, ey = EntityGetTransform( entity_who_caused )
		
		if ex ~= nil and ey ~= nil then
			angle_inc = -math.atan2( ey - y, ex - x )
			angle_inc_set = true
		end
	end

	if angle_inc_set then angle = angle_inc + Random( -6, 6 ) * 0.01
	else angle = math.rad( Random( 1, 360 ) ) end
	
	local vel_x = math.cos( angle ) * length
	local vel_y = -math.sin( angle ) * length

	shoot_projectile( entity_id, "data/entities/projectiles/wraith_glowing_laser.xml", x, y, vel_x, vel_y )
	GameEntityPlaySound( entity_id, "shoot" )
end
