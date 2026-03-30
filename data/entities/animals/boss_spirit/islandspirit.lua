dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, msg, source )
	local entity_id = GetUpdatedEntityID()
	
	local anger = tonumber( GlobalsGetValue( "HELPLESS_KILLS", "1" ) ) or 1
	local dmg = math.max( damage * anger * 0.1, 1/250 )
	
	local player = EntityGetWithTag( "player_unit" )
	
	for i,v in ipairs( player ) do
		EntityInflictDamage( v, dmg, "DAMAGE_HEALING", "$animal_islandspirit", "NONE", 0, 0, entity_id )
	end
end

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	CreateItemActionEntity( "MASS_POLYMORPH", x-15, y-9 )
	CreateItemActionEntity( "SEA_MIMIC", x, y-21 )
	CreateItemActionEntity( "DESTRUCTION", x+15, y-9 )
	CreateItemActionEntity( "DE_MELODY", 3865, 12110 )

	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml", x-30 ,y-20 )
	EntityLoad( "data/entities/items/pickup/heart_evil.xml", x+30 ,y-20 )
	
	local ng_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	if ng_n == 0 then EntityLoad( "data/entities/buildings/teleport_teleroom.xml",  x, y-67 ) end
	
	AddFlagPersistent( "card_unlocked_polymorph" )
	AddFlagPersistent( "miniboss_islandspirit" )

	ConvertMaterialEverywhere( CellFactory_GetType( "meat_helpless" ), CellFactory_GetType( "spark_white" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_protection_all" ), CellFactory_GetType( "magic_liquid_polymorph" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "steam" ), CellFactory_GetType( "magic_gas_polymorph" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "steam_trailer" ), CellFactory_GetType( "magic_gas_polymorph" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "acid_gas" ), CellFactory_GetType( "magic_gas_polymorph" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "acid_gas_static" ), CellFactory_GetType( "magic_gas_polymorph" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "poison_gas" ), CellFactory_GetType( "magic_gas_polymorph" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "fungal_gas" ), CellFactory_GetType( "magic_gas_polymorph" ) )
	-- ConvertMaterialEverywhere( CellFactory_GetType( "magic_gas_hp_regeneration" ), CellFactory_GetType( "magic_gas_polymorph" ) )
	-- ConvertMaterialEverywhere( CellFactory_GetType( "poo_gas" ), CellFactory_GetType( "magic_gas_polymorph" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "blood_cold_vapour" ), CellFactory_GetType( "magic_gas_polymorph" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_gas_worm_blood" ), CellFactory_GetType( "magic_gas_polymorph" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_gas_teleport" ), CellFactory_GetType( "magic_gas_polymorph" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_gas_fungus" ), CellFactory_GetType( "magic_gas_polymorph" ) )

	GamePrintImportant( "$defeat_boss_spirit_1", "$defeat_boss_spirit_2", "data/ui_gfx/decorations/boss_defeat.png" )

	local world_entity_id = GameGetWorldStateEntity()
	if( world_entity_id ~= nil ) then
		local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
		if( comp_worldstate ~= nil ) then
			local global_genome_relations_modifier = ComponentGetValue2( comp_worldstate, "global_genome_relations_modifier" )
			global_genome_relations_modifier = global_genome_relations_modifier - 10
			ComponentSetValue2( comp_worldstate, "global_genome_relations_modifier", global_genome_relations_modifier )
		end
	end
	
	GlobalsSetValue( "BOSS_SPIRIT_DEAD", "1" )
	
	local anger = tonumber( GlobalsGetValue( "HELPLESS_KILLS", "1" ) ) or 1
	if ( anger >= 300 ) then
		AddFlagPersistent( "miniboss_threelk" )
	end

	local p = EntityGetWithTag( "player_unit" )

	if p[1] ~= nil then for i=1,#p do EntityAddTag( p[i], "polymorphable_NOT") end end
end


-- every update
local anger = tonumber( GlobalsGetValue( "HELPLESS_KILLS", "1" ) ) or 1

if( anger >= 30 ) then
	local players = get_players()
	if players[1] ~= nil then
		local player_id = players[1]
		EntityRemoveStainStatusEffect( player_id, "PROTECTION_ALL", 5 )
		EntityRemoveStainStatusEffect( player_id, "DEEP_END_HARDEN_EFFECT", 5 )
	end
end

VerletApplyCircularForce( x, y, 80, 0.14 )
