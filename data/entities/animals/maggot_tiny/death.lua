dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	-- kill self
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	-- do some kind of an effect? throw some particles into the air?
	EntityLoad( "data/entities/items/pickup/heart_evil.xml", pos_x - 24, pos_y )
	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml", pos_x + 24, pos_y )

	local ability_comp = EntityGetFirstComponentIncludingDisabled( EntityLoad( "data/entities/items/wand_level_100.xml", pos_x, pos_y ), "AbilityComponent" )
	if ability_comp ~= nil then ComponentObjectSetValue2( ability_comp, "gun_config", "shuffle_deck_when_empty", false ) end
	
	GameAddFlagRun( "miniboss_maggot" )
	AddFlagPersistent( "miniboss_maggot" )
	AddFlagPersistent( "card_unlocked_maggot" )
	
	--StatsLogPlayerKill( entity_id )
	--EntityKill( entity_id )
end