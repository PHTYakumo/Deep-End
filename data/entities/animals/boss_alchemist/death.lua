dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	AddFlagPersistent( "card_unlocked_duplicate" )
	AddFlagPersistent( "miniboss_alchemist" )
	
	if EntityHasTag( entity_id, "holy_mountain_creature" ) then return end

	local pw = check_parallel_pos( x )
	
	SetRandomSeed( pw, 60 )
	
	local opts = { "ALPHA", "OMEGA", "GAMMA", "MU", "ZETA", "PHI", "TAU", "SIGMA" }
	local rnd = Random( 1, #opts )
	
	for i=1,#opts do
		rnd = Random( 1, #opts )
		CreateItemActionEntity( opts[rnd], x + ( 2 * i - #opts - 1 ) * 8, y )
		table.remove( opts, rnd )
	end

	CreateItemActionEntity( "METEOR_RAIN", 3841, 12110 )

	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml",  x, y-6 )
	EntityLoad( "data/entities/animals/boss_alchemist/key.xml",  x-16, y-20 )
	
	local wandstone = EntityLoad( "data/entities/items/pickup/wandstone.xml",  x+16, y-20 )
	if not EntityHasTag( wandstone, "de_wand_stone" ) then EntityAddTag( wandstone, "de_wand_stone" ) end

	local ng_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	if ng_n == 0 then EntityLoad( "data/entities/buildings/teleport_teleroom.xml",  x, y-67 ) end

	ConvertMaterialEverywhere( CellFactory_GetType( "meat_slime" ), CellFactory_GetType( "spark_white" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "meat_slime_green" ), CellFactory_GetType( "spark_white" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "meat_slime_orange" ), CellFactory_GetType( "spark_white" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static" ), CellFactory_GetType( "gold_static_dark" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_wet" ), CellFactory_GetType( "gold_static_dark" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_intro" ), CellFactory_GetType( "gold_static_dark" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_trip_secret" ), CellFactory_GetType( "gold_static_dark" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_trip_secret2" ), CellFactory_GetType( "gold_static_dark" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_noedge" ), CellFactory_GetType( "gold_static_dark" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_intro_breakable" ), CellFactory_GetType( "static_magic_material" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "waterrock" ), CellFactory_GetType( "gold_static_dark" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "coal_static" ), CellFactory_GetType( "gold_static_dark" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_grey" ), CellFactory_GetType( "gold_static_dark" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_glow" ), CellFactory_GetType( "gold_static_dark" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "snowrock_static" ), CellFactory_GetType( "gold_static_dark" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_vault" ), CellFactory_GetType( "templebrick_golden_static" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "wood_tree" ), CellFactory_GetType( "templebrick_golden_static" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "wood_static" ), CellFactory_GetType( "templebrick_golden_static" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "wood_static_vertical" ), CellFactory_GetType( "templebrick_golden_static" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "wood_burns_forever" ), CellFactory_GetType( "templebrick_golden_static" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "wood_static_wet" ), CellFactory_GetType( "templebrick_golden_static" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "wood_static_gas" ), CellFactory_GetType( "templebrick_golden_static" ) )

	GamePrintImportant( "$defeat_boss_alchemist_1", "$defeat_boss_alchemist_2", "data/ui_gfx/decorations/boss_defeat.png" )

	local world_entity_id = GameGetWorldStateEntity()
	if( world_entity_id ~= nil ) then
		local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
		if( comp_worldstate ~= nil ) then
			local global_genome_relations_modifier = tonumber( ComponentGetValue2( comp_worldstate, "global_genome_relations_modifier" ) )
			global_genome_relations_modifier = global_genome_relations_modifier - 10
			ComponentSetValue2( comp_worldstate, "global_genome_relations_modifier", global_genome_relations_modifier )
		end
	end

	local p = EntityGetWithTag( "player_unit" )

	if p[1] ~= nil then for i=1,#p do EntityAddTag( p[i], "touchmagic_immunity") end end

	--[[
	local org_list = { "" }
	local trs_list = { "" }
	for i=1,#org_list do
		ConvertMaterialEverywhere( CellFactory_GetType( org_list[i] ), CellFactory_GetType( trs_list[i] ) )
	end
	]]--
end