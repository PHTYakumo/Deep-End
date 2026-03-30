dofile_once("data/scripts/lib/utilities.lua")
-- dofile_once("data/scripts/perks/perk.lua")

local function Forever()
	local p = EntityGetWithTag( "player_unit" )

	if #p > 0 then for i=1,#p do
		EntityAddComponent( p[i], "LuaComponent", 
		{
			script_damage_received = "data/scripts/perks/defeat_boss_wizard.lua",
			execute_every_n_frame = "-1",
		} )
	end end
end

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	-- StatsLogPlayerKill( GetUpdatedEntityID() )
	
	local pw = check_parallel_pos( x )
	SetRandomSeed( pw, 30 )
	
	local opts = { "DIVIDE_2", "DIVIDE_3", "DIVIDE_4", "DIVIDE_10", "ADD_TRIGGER", "ADD_TIMER", "ADD_DEATH_TRIGGER", "DUPLICATE" }
	local exopts = { "DE_GFUEL", "DE_CHARGE", "MONEY_MAGIC", "BLOOD_TO_POWER", "DE_MULT_TRIGGER", "DE_MULT_TIMER", "DE_MULT_DEATH", "RESET" }
	
	for i=1,#opts do
		for j=1,4 do
			if j<4 then
				CreateItemActionEntity( opts[i], x+4*(j-2.5)+16*(i-4.5), y+20*(j-5) )
			else
				CreateItemActionEntity( exopts[i], x+4*(j-2.5)+16*(i-4.5), y+20*(j-5) )
			end
		end
	end

	CreateItemActionEntity( "DE_INF_TRAIN", 3805, 12110 )
	if math.abs( x ) > 20000 then Forever() end

	EntityLoad( "data/entities/items/books/book_mestari.xml",  12544, 15222 )
	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml",  x, y - 67 )
	-- EntityLoad( "data/entities/items/pickup/wandstone.xml",  x , y )
	
	local ng_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	if ng_n == 0 then EntityLoad( "data/entities/buildings/teleport_teleroom.xml",  x, y - 67 ) end
	
	AddFlagPersistent( "card_unlocked_mestari" )
	AddFlagPersistent( "miniboss_wizard" )

	ConvertMaterialEverywhere( CellFactory_GetType( "meat_teleport" ), CellFactory_GetType( "fire_blue" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "meat_fast" ), CellFactory_GetType( "fire_blue" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "meat_polymorph" ), CellFactory_GetType( "fire_blue" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "meat_polymorph_protection" ), CellFactory_GetType( "fire_blue" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "meat_confusion" ), CellFactory_GetType( "fire_blue" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "water_swamp" ), CellFactory_GetType( "blood" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "water_salt" ), CellFactory_GetType( "blood" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "water_ice" ), CellFactory_GetType( "blood" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "swamp" ), CellFactory_GetType( "blood" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "radioactive_liquid" ), CellFactory_GetType( "blood" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_mana_regeneration" ), CellFactory_GetType( "blood" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "poison" ), CellFactory_GetType( "blood_fading_slow" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_weakness" ), CellFactory_GetType( "blood_fading_slow" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "material_darkness" ), CellFactory_GetType( "blood_fading" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "creepy_liquid" ), CellFactory_GetType( "blood_fading" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "sand" ), CellFactory_GetType( "diamond" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "sand_blue" ), CellFactory_GetType( "diamond" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "sand_surface" ), CellFactory_GetType( "diamond" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "wizardstone" ), CellFactory_GetType( "templebrick_diamond_static" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_purple" ), CellFactory_GetType( "templebrick_diamond_static" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_cursed" ), CellFactory_GetType( "cheese_static" ) )
	-- ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_hp_regeneration" ), CellFactory_GetType( "mammi" ) )
	-- ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_hp_regeneration_unstable" ), CellFactory_GetType( "mammi" ) )
	-- ConvertMaterialEverywhere( CellFactory_GetType( "magic_gas_hp_regeneration" ), CellFactory_GetType( "mammi" ) )

	GamePrintImportant( "$defeat_boss_wizard_1", "$defeat_boss_wizard_2", "data/ui_gfx/decorations/boss_defeat.png" )

	local world_entity_id = GameGetWorldStateEntity()
	if world_entity_id ~= nil then
		local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
		if comp_worldstate ~= nil then
			local global_genome_relations_modifier = ComponentGetValue2( comp_worldstate, "global_genome_relations_modifier" )
			global_genome_relations_modifier = global_genome_relations_modifier - 10
			ComponentSetValue2( comp_worldstate, "global_genome_relations_modifier", global_genome_relations_modifier )
		end
	end

	local material_str = ""
	local damage_comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	if damage_comp ~= nil  then
		local material = ComponentGetValue2( damage_comp, "mLiquidMaterialWeAreIn" )
		if material ~= -1 then 
			material_str = CellFactory_GetName( material )
		end
	end

	if damage_message == "$damage_drowning" and material_str == "swamp" then
		CreateItemActionEntity( "HOMING_WAND", x, y-50 )
		AddFlagPersistent( "card_unlocked_homing_wand" )
	end

end