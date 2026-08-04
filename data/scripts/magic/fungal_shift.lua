dofile_once("data/scripts/lib/utilities.lua")

materials_from = {}

materials_to = {}

log_messages = 
{
	"$log_reality_mutation_00",
	"$log_reality_mutation_01",
	"$log_reality_mutation_02",
	"$log_reality_mutation_03",
	"$log_reality_mutation_04",
	"$log_reality_mutation_05",
}

function matter_random_list_init( iter, frame )
	SetRandomSeed( frame - iter, frame )

	materials_from = {
		{ probability = 0.4, materials = {
			random_from_array( CellFactory_GetAllLiquids( true, true ) ),
			random_from_array( CellFactory_GetAllLiquids( true, true ) ),
			random_from_array( CellFactory_GetAllLiquids( true, true ) )
		} },
		{ probability = 0.35, materials = {
			random_from_array( CellFactory_GetAllSands( true, true ) ),
			random_from_array( CellFactory_GetAllSands( true, true ) ),
			random_from_array( CellFactory_GetAllSands( true, true ) )
		} },
		{ probability = 0.2, materials = {
			random_from_array( CellFactory_GetAllGases( true, true ) ),
			random_from_array( CellFactory_GetAllGases( true, true ) ),
			random_from_array( CellFactory_GetAllGases( true, true ) )
		} },
		{ probability = 0.05, materials = {
			random_from_array( CellFactory_GetAllSolids( true, true ) ),
			random_from_array( CellFactory_GetAllSolids( true, true ) ),
			random_from_array( CellFactory_GetAllSolids( true, true ) )
		} }
	}

	SetRandomSeed( frame, frame - iter )

	materials_to = {
		{ probability = 0.35, materials = random_from_array( CellFactory_GetAllLiquids( true, true ) ) },
		{ probability = 0.35, materials = random_from_array( CellFactory_GetAllSands( true, true ) ) },
		{ probability = 0.2, materials = random_from_array( CellFactory_GetAllGases( true, true ) ) },
		{ probability = 0.1, materials = random_from_array( CellFactory_GetAllSolids( true, true ) ) }
	}
end

function get_held_item_material( entity_id )
	local children = EntityGetAllChildren( entity_id )
	if children == nil then return 0 end

	local inventory2_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "Inventory2Component" )

	if inventory2_comp ~= nil then
		local active_item = ComponentGetValue( inventory2_comp, "mActiveItem" )

		if EntityHasTag( active_item, "potion" ) or EntityHasTag( active_item, "powder_stash" ) then
			return GetMaterialInventoryMainMaterial( active_item )
		end
	end

	return 0
end

-- TODO: pick one of the materials from cape
function fungal_shift( entity, x, y, debug_no_limits )
	local parent = EntityGetParent( entity )
	if parent ~= 0 then entity = parent end

	local frame = GameGetFrameNum()
	local last_frame = tonumber( GlobalsGetValue( "fungal_shift_last_frame", "-1000000" ) )
	if frame < last_frame and not debug_no_limits then return end -- long cooldown

	local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
	if comp_worldstate ~= nil and ComponentGetValue2( comp_worldstate, "EVERYTHING_TO_GOLD" ) then return end -- do nothing in case everything is gold

	local iter = GlobalsGetValue( "fungal_shift_iteration", "0" )
	-- GamePrint( iter )

	iter = tonumber( iter )
	if iter >= 67 and not debug_no_limits then return end

	matter_random_list_init( iter, frame )

	local converted_any = false
	local convert_tries = 0
	local from_material_name = ""

	while converted_any == false and convert_tries < 20 do
		local seed2 = 42345 + iter + 1000 * convert_tries
		SetRandomSeed( 89346, seed2 )

		local rnd = random_create( 9123, seed2 )
		local held_material = get_held_item_material( entity )

		local from = pick_random_from_table_weighted( rnd, materials_from )
		local to = pick_random_from_table_weighted( rnd, materials_to )

		-- if a potion or pouch is equipped, randomly use main material from it as one of the materials
		if held_material > 0 and random_nexti( rnd, 1, 100 ) <= 50 then
			if random_nexti( rnd, 1, 100 ) <= 50 then
				from = {}
				from.materials = { CellFactory_GetName(held_material) }
			else
				to = {}
				to.material = CellFactory_GetName(held_material)
			end
		end

		local to_material = CellFactory_GetType( to.material or random_from_array( CellFactory_GetAllSands() ) )
		if to_material == -1 then to_material = CellFactory_GetType( "deep_end_hush" ) end -- wait for reroll

		if CellFactory_HasTag( to_material, "[NO_FUNGAL_SHIFT]" ) then
			random_next( rnd, -1, 1 )

			to = random_from_array( materials_to )
			to_material = CellFactory_GetType( to.material or random_from_array( CellFactory_GetAllSands() ) )

			if to_material == -1 then to_material = CellFactory_GetType( "physics_throw_material_part2" ) end
		end

		-- apply effects
		for i,it in ipairs(from.materials) do
			local from_material = CellFactory_GetType( it )
			from_material_name = string.upper( GameTextGetTranslatedOrNot( CellFactory_GetUIName( from_material ) ) )

			-- convert
			if from_material ~= to_material and from_material ~= -1 then
				print(CellFactory_GetUIName(from_material) .. " -> " .. CellFactory_GetUIName(to_material))
				ConvertMaterialEverywhere( from_material, to_material )
				converted_any = true

				-- shoot particles of new material
				GameCreateParticle( CellFactory_GetName(from_material), x-10, y-10, 1, rand(-100,100), rand(-100,-30), true, true )
				GameCreateParticle( CellFactory_GetName(from_material), x+10, y-10, 1, rand(-100,100), rand(-100,-30), true, true )
			end
		end

		convert_tries = convert_tries + 1
	end

	-- fx
	if converted_any then
		-- increment only here, in case had very bad luck and didn't get a shift
		GlobalsSetValue( "fungal_shift_iteration", tostring( iter + 1 ) )

		-- log
		local log_msg = ""

		if from_material_name ~= "" then
			log_msg = GameTextGet( "$logdesc_reality_mutation", from_material_name )
			GamePrint( log_msg )
		end

		GlobalsSetValue( "fungal_shift_last_frame", tostring(frame) )

		if iter % 9 == 8 and iter >= 19 then
			GamePrintImportant( random_from_array( log_messages ), log_msg, "data/ui_gfx/decorations/3piece_fungal_shift.png" )

			-- remove tripping effect
			EntityRemoveIngestionStatusEffect( entity, "TRIP" )

			-- audio
			GameTriggerMusicFadeOutAndDequeueAll( 5.0 )
			GameTriggerMusicEvent( "music/oneshot/tripping_balls_01", false, x, y )

			-- add ui icon
			local add_icon = true
			local children = EntityGetAllChildren(entity)

			if children ~= nil then for i,it in ipairs(children) do
				if EntityGetName(it) == "fungal_shift_ui_icon" then
					add_icon = false
				elseif EntityHasTag( it, "tripping_extreme" ) then
					EntityKill(it)
				end
			end end

			if add_icon then
				local icon_entity = EntityCreateNew( "fungal_shift_ui_icon" )

				EntityAddComponent( icon_entity, "UIIconComponent", 
				{ 
					name = "$status_reality_mutation",
					description = "$statusdesc_reality_mutation",
					icon_sprite_file = "data/ui_gfx/status_indicators/fungal_shift.png"
				})

				EntityAddChild( entity, icon_entity )
			end
		end
	end
end
