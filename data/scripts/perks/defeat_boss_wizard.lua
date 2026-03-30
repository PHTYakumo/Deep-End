dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	if ( damage < 0 ) then return end

	if ( entity_who_caused == entity_id ) or ( ( EntityGetParent( entity_id ) ~= NULL_ENTITY ) and ( entity_who_caused == EntityGetParent( entity_id ) ) ) then return end

	if script_wait_frames( entity_id, 16 ) then return end

	EntityAddChild( entity_id, EntityLoad( "data/entities/misc/effect_protection_all_shorter_no_ui.xml", pos_x, pos_y ) )
end
