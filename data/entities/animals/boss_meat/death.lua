dofile( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/perks/perk.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	-- kill self
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	GlobalsSetValue( "BOSS_MEAT_DEAD", "1" )
	AddFlagPersistent( "miniboss_meat" )

	if EntityHasTag( entity_id, "holy_mountain_creature" ) then return end

	-- If you exit the game without loading the corresponding chunks, these entities will not be saved!
	EntityLoad( "data/entities/items/pickup/evil_eye.xml", 3835, 12075 )
	EntityLoad( "data/entities/items/pickup/evil_eye.xml", 3838, 12080 )
	EntityLoad( "data/entities/items/pickup/evil_eye.xml", 3832, 12080 )
	-- EntityLoad( "data/entities/items/wands/experimental/experimental_wand_4.xml", x, y-12 )

	CreateItemActionEntity( "BLOOD_MAGIC", x-27, y-27 )
	CreateItemActionEntity( "BLOODLUST", x+27, y-27 )
	CreateItemActionEntity( "HEAL_BULLET", x, y-15 )
	CreateItemActionEntity( "DE_SAKUYA", 3853, 12110 )

	perk_spawn_with_name( x, y+6, "SAVING_GRACE", true )

	local ng_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	if ng_n == 0 then EntityLoad( "data/entities/buildings/teleport_teleroom.xml",  x, y-67 ) end

	ConvertMaterialEverywhere( CellFactory_GetType( "meat_cursed" ), CellFactory_GetType( "spark_white" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "meat_cursed_dry" ), CellFactory_GetType( "spark_white" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "meat_slime_cursed" ), CellFactory_GetType( "spark_white" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "meat_static" ), CellFactory_GetType( "nest_static" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "pus" ), CellFactory_GetType( "vomit" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "just_death" ), CellFactory_GetType( "porridge" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "Eucharist_Deep_End" ), CellFactory_GetType( "mud" ) )
	-- ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_hp_regeneration_unstable" ), CellFactory_GetType( "mud" ) )
	-- ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_hp_regeneration" ), CellFactory_GetType( "mud" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "sand_static_rainforest" ), CellFactory_GetType( "root_growth" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "sand_static_rainforest_dark" ), CellFactory_GetType( "root_growth" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "soil_dead" ), CellFactory_GetType( "honey" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "soil_dark" ), CellFactory_GetType( "honey" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "soil_lush" ), CellFactory_GetType( "sand_herb" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "soil_lush_dark" ), CellFactory_GetType( "sand_herb" ) )

	GamePrintImportant( "$defeat_boss_meat_1", "$defeat_boss_meat_2", "data/ui_gfx/decorations/boss_defeat.png" )
	
	local e = EntityGetWithTag( "no_heal_in_meat_biome" )
	if ( #e > 0 ) then
		for i,v in ipairs( e ) do
			EntitySetComponentsWithTagEnabled( v, "effect_no_heal_in_meat_biome", false )
		end

		local world_entity_id = GameGetWorldStateEntity()
		if( world_entity_id ~= nil ) then
			local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
			if( comp_worldstate ~= nil ) then
				local global_genome_relations_modifier = ComponentGetValue2( comp_worldstate, "global_genome_relations_modifier" )
				global_genome_relations_modifier = global_genome_relations_modifier - 10
				ComponentSetValue2( comp_worldstate, "global_genome_relations_modifier", global_genome_relations_modifier )
			end
		end
	end

	local p = EntityGetWithTag( "player_unit" )
	if ( #p > 0 ) then
		for i=1,#p do
			local pl = p[i]

			EntityAddChild( pl, EntityLoad( "data/entities/misc/effect_regeneration_once.xml" ) )
			EntityAddChild( pl, EntityLoad( "data/entities/misc/effect_protection_all_once_no_ui.xml" ) )

			if not EntityHasTag( pl, "deep_end_meat_boss_gore" ) then
				EntityAddChild( pl, EntityLoad( "data/entities/misc/effect_hoh_global_gore.xml", x, y ) )
				EntityAddTag( pl, "deep_end_meat_boss_gore" )
			end
		end
	end
end