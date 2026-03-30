dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	-- kill self
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	
	if EntityHasTag( entity_id, "holy_mountain_creature" ) then
		CreateItemActionEntity( "EXPLODING_DEER", pos_x, pos_y - 2 )
	elseif EntityHasTag( entity_id, "robot" ) then
		EntityLoad( "data/entities/items/pickup/summon_portal_broken.xml", pos_x, pos_y - 3 )
	else
		SetRandomSeed( GameGetFrameNum() + entity_id, pos_x + pos_y )

		local my_tombstone = Random( 1, 7 )

		EntityLoad( "data/entities/props/my_tombstone_0" .. tostring(my_tombstone) .. ".xml", pos_x, pos_y - 4 )
	end

	GameCreateSpriteForXFrames( "data/ui_gfx/game_over_menu/Pow.png", pos_x, pos_y, true, 0, 0, 12, true )
end