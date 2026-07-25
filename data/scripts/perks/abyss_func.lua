dofile_once( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_procedural.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("data/scripts/gun/gun_enums.lua")
dofile_once( "data/scripts/perks/perk.lua" )

function de_enemy_give_wand( target, wand_level )
	if target ~= nil and target ~= NULL_ENTITY then
		local x, y = EntityGetTransform( target )
		SetRandomSeed( target + x, GameGetFrameNum() + y )

		-- must be able to use wands
		local worm = EntityGetComponent( target, "WormAIComponent" )
		local dragon = EntityGetComponent( target, "BossDragonComponent" )
		local ghost = EntityGetComponent( target, "GhostComponent" )
		local lukki = EntityGetComponent( target, "LimbBossComponent" )
		local npccomp = EntityGetComponent( target, "ItemPickUpperComponent" )
		
		if ( worm == nil and dragon == nil and ghost == nil and lukki == nil and npccomp ~= nil
			and not ( EntityHasTag( target, "wand_ghost" ) or EntityHasTag( target, "boss" ) ) )
			or EntityHasTag( target, "de_mimic" ) then
			
			local comps = EntityGetComponent( target, "CameraBoundComponent" )
			if comps ~= nil then for i,camerabound in ipairs(comps) do
				EntitySetComponentIsEnabled( target, camerabound, false )	
			end end

			local wand_level_str = "1"
			if wand_level < 9 then wand_level_str = "0" .. tostring( wand_level )
			else wand_level_str = tostring( wand_level ) end

			local wid = EntityLoad( "data/entities/items/wand_level_" .. wand_level_str .. ".xml", x, y)
			EntityAddTag( wid, "abyss_wand" )

			local icomp = EntityGetFirstComponent( wid, "ItemComponent" )
			ComponentSetValue( icomp, "is_frozen", "true" )
			ComponentSetValue( icomp, "is_all_spells_book", "true" )
		end
	end
end

function de_enemy_give_perk( target )
	if target ~= nil and target ~= NULL_ENTITY then
		local x, y = EntityGetTransform( target )

		SetRandomSeed( x + y, target + GameGetFrameNum() )

		local worm = EntityGetComponent( target, "WormAIComponent" )
		local dragon = EntityGetComponent( target, "BossDragonComponent" )
		local ghost = EntityGetComponent( target, "GhostComponent" )
		local lukki = EntityGetComponent( target, "LimbBossComponent" )

		if worm == nil and dragon == nil and ghost == nil and lukki == nil 
			and ( not EntityHasTag( target, "boss" ) ) and ( not EntityHasTag( target, "holy_mountain_creature" ) ) then
			if #DEEP_END_VAILD_PERKS > 0 then
				local result = DEEP_END_VAILD_PERKS[Random( 1, #DEEP_END_VAILD_PERKS )]
				give_perk_to_enemy( perk_list[result], target, 0 )
			end
		end
	end
end

function de_shuffle_pl_perk( player_id )
	local x, y = EntityGetTransform( player_id )
	if x == nil then return end

	local perks_to_sp = {}
	
	for i,perk_data in ipairs(perk_list) do
		local perk_id = perk_data.id
		
		if perk_data.one_off_effect == nil or perk_data.one_off_effect == false then
			local flag_name = get_perk_picked_flag_name( perk_id )
			local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) )
			
			if GameHasFlagRun( flag_name ) or ( pickup_count > 0 ) then
				table.insert( perks_to_sp, { perk_id, pickup_count } )
			end
		end
	end

	IMPL_remove_all_perks( player_id )

	if #perks_to_sp > 0 then for i=1,#perks_to_sp do
		local pid = perk_spawn_random( x, y, true )
		perk_pickup( pid, player_id, EntityGetName(pid), false, false)
	end end
end

function get_action_type( card_id )
	local bgcomp = EntityGetFirstComponentIncludingDisabled( card_id, "SpriteComponent", "item_bg" )
	if bgcomp == nil then return ACTION_TYPE_PROJECTILE end

	local bg_string = ComponentGetValue2( bgcomp, "image_file" )

	if string.find( bg_string, "item_bg_draw_many.png" ) then return ACTION_TYPE_DRAW_MANY end
	if string.find( bg_string, "item_bg_material.png" ) then return ACTION_TYPE_MATERIAL end
	if string.find( bg_string, "item_bg_modifier.png" ) then return ACTION_TYPE_MODIFIER end
	if string.find( bg_string, "item_bg_other.png" ) then return ACTION_TYPE_OTHER end
	if string.find( bg_string, "item_bg_passive.png" ) then return ACTION_TYPE_PASSIVE end
	if string.find( bg_string, "item_bg_static_projectile.png" ) then return ACTION_TYPE_STATIC_PROJECTILE end
	if string.find( bg_string, "item_bg_utility.png" ) then return ACTION_TYPE_UTILITY end

	return ACTION_TYPE_PROJECTILE
end

function sp_empty_gun( info, x, y )
	local wand_id = EntityLoad( "data/entities/items/wand_empty.xml", x, y )
	SetRandomSeed( x, y )
	
	local level = info[1] or 1
	local always_casts = info[2] or 0

	local gun = get_gun_data( level * 20, level, false )
	make_wand_from_gun_data( gun, wand_id, level )
	
	if always_casts > 0 then for i=1,math.min( always_casts, EntityGetWandCapacity( wand_id ) ) do
		SetRandomSeed( i, wand_id )
		local p = Random( 0, 100 ) 
		
		if p < 85 then card = GetRandomActionWithType( x, y, level, ACTION_TYPE_MODIFIER, Random( 0, 100 ) )
		elseif p < 93 then card = GetRandomActionWithType( x, y, level, ACTION_TYPE_STATIC_PROJECTILE, Random( 0, 100 ) )
		else card = GetRandomActionWithType( x, y, level, ACTION_TYPE_PROJECTILE, Random( 0, 100 ) ) end

		AddGunActionPermanent( wand_id, card )
	end end
end

function de_shuffle_pl_inventory( player_id )
	local x, y = EntityGetTransform( player_id )
	if x == nil then return end

	local convent_mat_list = { -- 17/41
		"magic_liquid_unstable_teleportation",
		"magic_liquid_teleportation",
		"magic_liquid_polymorph",
		"magic_liquid_random_polymorph",
		"magic_liquid_unstable_polymorph",
		"magic_liquid_berserk",
		"magic_liquid_charm",
		"magic_liquid_invisibility",
		"material_confusion",
		"magic_liquid_movement_faster",
		"magic_liquid_faster_levitation",
		"magic_liquid_faster_levitation_and_movement",
		"magic_liquid_worm_attractor",
		"magic_liquid_protection_all",
		"magic_liquid_mana_regeneration",
		"blood_worm",
		"cement",
		"pea_soup",
		"plastic_red_molten",
		"void_liquid",
		"sima",
		"material_darkness",
		"material_rainbow",
		"blood_cold",
		"poison",
		"plasma_fading",
		"wax_molten",
		"silver_molten",
		"acid",
		"lava",
		"urine",
		"magic_liquid_weakness",
		"molut",
		"plastic_grey_molten",
		"glue",
		"salt",
		"sodium",
		"purifying_powder",
		"glowshroom",
		"bush_seed",
		"mammi"
	}

	local safe_mat_list = {
		"slime",
		"pea_soup",
		"vomit",
		"water",
		"water_salt",
		"water_ice",
		"water_swamp",
		"oil",
		"alcohol",
		"swamp",
		"blood",
		"radioactive_liquid",
		"peat",
		"beer",
		"milk",
		"smoke",
		"steam",
		-- "porridge",
		-- "magic_liquid_hp_regeneration",
		-- "magic_liquid_hp_regeneration_unstable"
	}

	local wand_list, spell_list, w_level = {}, {}, 0

	local plchilds = EntityGetAllChildren( player_id )
	local inventory_quick, inventory_full

	if plchilds then for i,plchild in ipairs( plchilds ) do
		if EntityGetName( plchild ) == "inventory_quick" then inventory_quick = EntityGetAllChildren( plchild )
		elseif EntityGetName( plchild ) == "inventory_full" then inventory_full = EntityGetAllChildren( plchild ) end
	end end

	if inventory_quick ~= nil and #inventory_quick > 0 then for i,wand in ipairs( inventory_quick ) do
		if EntityHasTag( wand, "wand" ) and EntityGetFirstComponentIncludingDisabled( wand, "ItemComponent") ~= nil then
			local comp, c, deck_capacity, deck_capacity2
			local always_casts, level = -1, 1
			
			local comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
			local c = EntityGetAllChildren( wand ) or {}

			if comp ~= nil then
				deck_capacity = ComponentObjectGetValue( comp, "gun_config", "deck_capacity" )
				deck_capacity2 = EntityGetWandCapacity( wand )
				level = ComponentGetValue2( comp, "gun_level" )
			end

			if deck_capacity ~= nil and deck_capacity2 ~= nil then always_casts = deck_capacity - deck_capacity2 end

			if always_casts ~= -1 and #c > always_casts then for i=always_casts+1,#c do
				if EntityGetFirstComponentIncludingDisabled( c[i], "ItemActionComponent" ) ~= nil then
					local c_type, c_level = get_action_type( c[i] ), clamp( level - 1, 1, 10 )
					if c_type == ACTION_TYPE_OTHER then c_level = clamp( c_level, 2, 7 ) end

					local card = GetRandomActionWithType( x, y, c_level, c_type, c[i] )
					table.insert( spell_list, card )

					EntityKill( c[i] )
				end
			end end

			table.insert( wand_list, { level, always_casts } )
			w_level = w_level + level

			EntityKill( wand )
		elseif EntityHasTag( wand, "potion" ) then
			local mat, is_safe = GetMaterialInventoryMainMaterial( wand ), false
			for i=1,#safe_mat_list do if CellFactory_GetName( mat ) == safe_mat_list[i] then is_safe = true end end
			
			if not is_safe then
				SetRandomSeed( wand, mat )

				local mcomp = EntityGetFirstComponentIncludingDisabled( wand, "MaterialSuckerComponent" )
				local a_size, a_mat = ComponentGetValue2( mcomp, "mAmountUsed" ), convent_mat_list[Random(1,#convent_mat_list)]

				RemoveMaterialInventoryMaterial( wand )

				if mcomp ~= nil then
					AddMaterialInventoryMaterial( wand, a_mat, a_size )
				end
			end
		end
	end end

	w_level = math.max( math.floor( w_level / math.max( #wand_list, 1 ) ), 1 )

	if inventory_full ~= nil and #inventory_full > 0 then for i=1,#inventory_full do
		if EntityGetFirstComponentIncludingDisabled( inventory_full[i], "ItemActionComponent" ) ~= nil then
			local c_type, c_level = get_action_type( inventory_full[i] ), w_level - 1
			if c_type == ACTION_TYPE_OTHER then c_level = math.max( c_level, 2 ) end
						
			local card = GetRandomActionWithType( x, y, c_level, c_type, inventory_full[i] )
			table.insert( spell_list, card )

			EntityKill( inventory_full[i] )
		end
	end end

	if #spell_list > 0 then for i=1,#spell_list do
		local cid = CreateItemActionEntity( spell_list[i], x, y )
		local vel_comp = EntityGetFirstComponentIncludingDisabled( cid, "VelocityComponent" )

		if vel_comp ~= nil then
			local angle = 2 * math.pi * i / #spell_list
			ComponentSetValue2( vel_comp, "mVelocity", math.sin( angle ) * 25, -math.cos( angle ) * 25 )
		end
	end end

	if #wand_list == 1 then
		sp_empty_gun( wand_list[1], x, y )
	elseif #wand_list > 1 then
		local offset = 12 / ( #wand_list - 1 )
		for i=1,#wand_list do sp_empty_gun( wand_list[i], x + offset * ( i - 1 ) - 6, y ) end
	end
end