dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id = GetUpdatedEntityID()
	local x, y, a = EntityGetTransform( entity_id )
	
	y = y + 4.5
	
	SetRandomSeed( GameGetFrameNum(), entity_id )
	local angle = Random( 1, 100 ) * 0.01 * math.pi * 2
	
	if ( entity_who_caused ~= nil ) and ( entity_who_caused ~= NULL_ENTITY ) then
		local px, py = EntityGetTransform( entity_who_caused )
		angle = get_direction( px, py, x, y )
	end
	
	local vx = math.cos( angle ) * 75
	local vy = 0 - math.sin( angle ) * 75
	
	shoot_projectile( entity_id, "data/entities/animals/boss_fish/mini/orb_big.xml", x, y, vx, vy )
	
	local c = EntityGetComponent( entity_id, "SpriteComponent", "health_bar" )
	if ( c ~= nil ) then
		for i,v in ipairs( c ) do
			ComponentSetValue2( v, "visible", true )
		end
	end
end