dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	ConvertMaterialEverywhere( CellFactory_GetType( "water" ), CellFactory_GetType( "smoke" ) )

	CreateItemActionEntity( "DE_DARKBEAM", x, y - 41 )
	
	EntityLoad( "data/entities/items/pickup/heart_evil.xml", x + 24, y )
	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml", x - 24, y )
	
	-- EntityLoad( "data/entities/items/pickup/chest_random_super.xml",  x - 32, y )
	-- EntityLoad( "data/entities/buildings/teleport_teleroom.xml",  x, y )

	GameAddFlagRun( "miniboss_maggot" )
	AddFlagPersistent( "miniboss_maggot" )
end