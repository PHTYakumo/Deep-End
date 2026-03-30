dofile_once("data/scripts/lib/utilities.lua")

local function Frozen()
	local p = EntityGetWithTag( "player_unit" )

	if ( #p > 0 ) then
		for i=1,#p do
			local pl = p[i]
			local px,py = EntityGetTransform( pl )

			local damagemodels = EntityGetComponent( pl, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue2( damagemodel, "blood_material", "alcohol_gas" )
					ComponentSetValue2( damagemodel, "blood_spray_material", "alcohol_gas" )
					ComponentSetValue2( damagemodel, "blood_multiplier", 0.2 )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", "-0.2" )
				end
			end

			local child_id = EntityLoad( "data/entities/misc/perks/freeze_field.xml", px, py )
			EntityAddTag( child_id, "de_field_boss_ghost" )
			EntityAddChild( pl, child_id )

			EntityAddTag( pl, "de_reward_boss_ghost" )
			if not EntityHasTag( pl, "forgeable" ) then EntityAddTag( pl, "forgeable" ) end -- triggering condition
		end
	end
end

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	Frozen()
	
	CreateItemActionEntity( "ALL_SPELLS", x-10, y-9 )
	CreateItemActionEntity( "CESSATION", x+10, y-9 )
	CreateItemActionEntity( "DE_I_NEED_MORE_POWER", 3829, 12110 )

	EntityLoad( "data/entities/items/pickup/sword_wand.xml", x+1, y-17 )
	EntityLoad( "data/entities/items/pickup/heart_evil.xml", x-29 ,y-7 )
	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml", x+29 ,y-7 )
	EntityLoad( "data/entities/items/pickup/beamstone.xml",  x-12, y-67 )
	EntityLoad( "data/entities/items/pickup/sun/sunstone.xml",  x+12, y-67 )

	local ng_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	if ng_n == 0 then EntityLoad( "data/entities/buildings/teleport_teleroom.xml",  x, y-67 ) end
	
	ConvertMaterialEverywhere( CellFactory_GetType( "ice_glass_b2" ), CellFactory_GetType( "fire_blue" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "blood_fungi" ), CellFactory_GetType( "material_confusion" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "blood_worm" ), CellFactory_GetType( "material_confusion" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "blood_cold" ), CellFactory_GetType( "material_confusion" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "plasma_fading" ), CellFactory_GetType( "fire_blue" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "plasma_fading_bright" ), CellFactory_GetType( "fire_blue" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "plasma_fading_green" ), CellFactory_GetType( "fire_blue" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "plasma_fading_pink" ), CellFactory_GetType( "fire_blue" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_movement_faster" ), CellFactory_GetType( "juhannussima" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_faster_levitation" ), CellFactory_GetType( "juhannussima" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_faster_levitation_and_movement" ), CellFactory_GetType( "juhannussima" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_worm_attractor" ), CellFactory_GetType( "juhannussima" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_berserk" ), CellFactory_GetType( "juhannussima" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_charm" ), CellFactory_GetType( "juhannussima" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_invisibility" ), CellFactory_GetType( "juhannussima" ) )

	GamePrintImportant( "$defeat_boss_ghost_1", "$defeat_boss_ghost_2", "data/ui_gfx/decorations/boss_defeat.png" )

	local world_entity_id = GameGetWorldStateEntity()
	if world_entity_id ~= nil then
		local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
		if comp_worldstate ~= nil then
			local global_genome_relations_modifier = ComponentGetValue2( comp_worldstate, "global_genome_relations_modifier" )
			global_genome_relations_modifier = global_genome_relations_modifier - 10
			ComponentSetValue2( comp_worldstate, "global_genome_relations_modifier", global_genome_relations_modifier )
		end
	end
	
	AddFlagPersistent( "miniboss_ghost" )
end