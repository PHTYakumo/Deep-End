dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	local players = EntityGetInRadiusWithTag( pos_x, pos_y, 200, "player_unit" )
	if ( #players > 0 ) then
		for i=1,#players do
			local id = players[i]
			if ( id ~= nil ) and ( id ~= NULL_ENTITY ) then
				local x, y = EntityGetTransform( id )
				EntityAddChild( id, EntityLoad( "data/entities/misc/effect_movement_faster_once.xml", x, y ) )
			end
		end
	end

	players = EntityGetInRadiusWithTag( pos_x, pos_y, 400, "enemy" )
	if ( #players > 0 ) then
		for i=1,#players do
			local id = players[i]
			if ( id ~= nil ) and ( id ~= NULL_ENTITY ) then
				local x, y = EntityGetTransform( id )
				EntityAddChild( id, EntityLoad( "data/entities/misc/effect_movement_faster_2x_long.xml", x, y ) )
				EntityAddChild( id, EntityLoad( "data/entities/misc/effect_regeneration_once.xml", x, y ) )
			end
		end
	end

	shoot_projectile( entity_id, "data/entities/projectiles/chef_death_explosion.xml", pos_x, pos_y, 0, 0 )
end