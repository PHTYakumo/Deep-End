dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	-- kill self
	local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	ConvertMaterialEverywhere( CellFactory_GetType( "water" ), CellFactory_GetType( "smoke" ) )

	-- do some kind of an effect? throw some particles into the air?
	EntityLoad( "data/entities/items/pickup/heart_evil.xml", pos_x - 20, pos_y - 10 )
	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml", pos_x + 20, pos_y - 10 )

	local ability_comp = EntityGetFirstComponentIncludingDisabled( EntityLoad( "data/entities/items/wand_level_100.xml", pos_x, pos_y ), "AbilityComponent" )
	if ability_comp ~= nil then ComponentObjectSetValue2( ability_comp, "gun_config", "shuffle_deck_when_empty", false ) end

	if not EntityHasTag( entity_id, "holy_mountain_creature" ) then
		CreateItemActionEntity( "TENTACLE_PORTAL", pos_x, pos_y - 44 )
		CreateItemActionEntity( "TENTACLE", pos_x - 18, pos_y - 40 )
		CreateItemActionEntity( "TENTACLE_TIMER", pos_x + 18, pos_y - 40 )
		CreateItemActionEntity( "DE_TENTACLE_VINE", pos_x - 36, pos_y - 25 )
		CreateItemActionEntity( "DE_TENTACLE_HAND", pos_x + 36, pos_y - 25 )
	end
	
	GameAddFlagRun( "miniboss_fish" )
	AddFlagPersistent( "miniboss_fish" )
	AddFlagPersistent( "card_unlocked_maggot" )
	
	--StatsLogPlayerKill( entity_id )
	--EntityKill( entity_id )
end