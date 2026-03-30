dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/gun/gun_actions.lua" )
dofile_once("data/scripts/biomes/summon_portal_util.lua")
dofile( "data/scripts/perks/perk.lua" )
dofile( "data/scripts/items/chest_random.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- convert items
local converted = false


for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 128, "leukaluu")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then

		-- look for kantele...
		local e_kanteles = EntityGetInRadiusWithTag( pos_x, pos_y, 128, "kantele" )
		if ( #e_kanteles > 0 ) then 
			local kantele = e_kanteles[1] 

			local x,y = EntityGetTransform(id)
			EntityLoad("data/entities/projectiles/explosion.xml", x, y - 10)
			EntityLoad("data/entities/items/leukaluu_kantele.xml", x, y - 5)
			EntityLoad("data/entities/particles/image_emitters/magical_symbol.xml", x, y - 5)

			EntityKill(id)
			EntityKill( kantele )
			converted = true
		else
			local x,y = EntityGetTransform(id)
			EntityLoad("data/entities/projectiles/explosion.xml", x, y - 10)
			CreateItemActionEntity( "FISH", x, y)
			AddFlagPersistent( "card_unlocked_fish" )
			EntityKill(id)
			converted = true
		end
	end
end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 216, "card_summon_portal_broken")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then
		local x, y = EntityGetTransform(id)
		-- EntityLoad("data/entities/projectiles/explosion.xml", x, y - 10)

		local card_converted = EntityGetInRadiusWithTag(pos_x, pos_y, 256, "summon_portal_card")
		SetRandomSeed( x, y )

		for i=1,7 do
			local eid, ex, ey = -1, x, y

			if ( i == 4 ) and ( #card_converted == 0 ) then
				ey = y - 6.4
				eid = CreateItemActionEntity( "SUMMON_PORTAL", ex, ey )
				
				if not EntityHasTag( entity_id, "summon_portal_card" ) then EntityAddTag( entity_id, "summon_portal_card" ) end
			else
				ex = x + ( i - 4 ) * 9.6
				ey = y - 6.4 + 12.8 * math.sin( math.pi * 0.5 * ( i - 4 ) )

				eid = make_random_card( ex, ey )
			end

			if eid > 0 then
				EntityAddComponent( eid, "ItemCostComponent", { 
					_tags="shop_cost,enabled_in_world", 
					cost="0",
					stealable="0",
				} )
					
				EntityAddComponent( eid, "LuaComponent", { 
					script_item_picked_up="data/scripts/items/shop_effect.lua",
				} )

				EntityAddComponent( eid, "LuaComponent", { 
					_tags="enabled_in_world",
					script_source_file="data/scripts/items/shop_item_breath.lua",
					execute_every_n_frame="2",
				} )

				EntitySetTransform( eid, ex, ey, Random(-100,100) * 0.00061, 0.83, 0.83 )
				EntityApplyTransform( eid, ex, ey, Random(-100,100) * 0.00061, 0.83, 0.83 )
			end
		end

		EntityKill(id)
		converted = true
	end
end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 216, "broken_wand")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then
		local x,y = EntityGetTransform(id)
		EntityLoad("data/entities/items/wand_level_05_better.xml", x, y - 5)
		-- EntityLoad("data/entities/projectiles/explosion.xml", x, y - 10)
		EntityKill(id)
		converted = true
	end
end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 216, "deep_end_bin")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then
		local portal_x, portal_y = get_portal_position()
		GamePrintImportant( tostring(portal_x) .. "  " .. tostring(portal_y), " ", "data/ui_gfx/decorations/next_ng.png" )
		EntityKill(id)
		converted = true
	end
end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 128, "de_my_soul")) do
	local x,y = EntityGetTransform(id)
	EntityLoad( "data/entities/projectiles/deck/circle_end.xml", x, y )
	EntityLoad( "data/entities/projectiles/deck/circle_end.xml", x+300, y+300 )
	EntityLoad( "data/entities/projectiles/deck/circle_end.xml", x+300, y-300 )
	EntityLoad( "data/entities/projectiles/deck/circle_end.xml", x-300, y+300 )
	EntityLoad( "data/entities/projectiles/deck/circle_end.xml", x-300, y-300 )
	EntityKill(id)
	converted = true
end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 216, "broken_wand_big")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then
		local x,y = EntityGetTransform(id)

		SetRandomSeed( x+GameGetFrameNum(), y+id )
		local wand_rnd = Random(1,100)

		if wand_rnd > 6 then
			local wand = EntityLoad( "data/entities/items/wand_unshuffle_10.xml", x, y - 5 )
			local ability_comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )

			if ability_comp ~= nil then ComponentObjectSetValue2( ability_comp, "gun_config", "shuffle_deck_when_empty", false ) end
		else
			wand_rnd = math.ceil( wand_rnd * 0.49 )
			EntityLoad( "data/entities/items/wands/wand_good/wand_good_" .. tostring(wand_rnd) .. ".xml", x, y - 5 )
		end

		-- EntityLoad("data/entities/projectiles/explosion.xml", x, y - 10)
		EntityKill(id)
		converted = true
	end
end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 128, "chaos_frankenstein")) do
	if EntityGetRootEntity(id) == id then
		-- EntityKill(id)
		EntityRemoveTag( id, "forgeable" ) -- compatible with child-with-tag-de_freeze_field
		EntityRemoveTag( id, "chaos_frankenstein" )

		IMPL_remove_all_perks( id )

        local x, y, plr, plsx, plsy = EntityGetTransform( id )
        EntitySetTransform( id, x, y, 0, 1, 1)
		-- BossHealthBarComponent, full_inventory_slots_x, full_inventory_slots_y, run_velocity, blood_material, etc
		-- enjoy them!
		SetRandomSeed( x+plsy, y+plsx )

		perk_spawn( x, y-36, "EDIT_WANDS_EVERYWHERE", true )
		perk_spawn( x, y+4, "PROTECTION_RADIOACTIVITY", true )

		local rnd = 0
		local opts = { "REMOVE_FOG_OF_WAR", "UNLIMITED_SPELLS", "NO_MORE_SHUFFLE" }
	
		for i=1,3 do
			rnd = Random( 1, #opts )

			local starting_perk = perk_spawn( x + 20 * ( i - 2 ), y - 16, opts[rnd], true )

			EntityAddComponent( starting_perk, "LuaComponent", 
			{ 
				script_item_picked_up="data/scripts/perks/perk_choose_one.lua", -- script_death ?
			} )

			EntityAddTag( starting_perk, "perk_choose_one")
			table.remove( opts, rnd )
		end

		converted = true
	end
end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 128, "de_reward_boss_ghost")) do
	if EntityGetRootEntity(id) == id then
		local fld = EntityGetInRadiusWithTag( pos_x, pos_y, 128, "de_field_boss_ghost" )

		for i=1,#fld do
			perk_spawn( pos_x, pos_y, "PROTECTION_FIRE", true )
			EntityKill(fld[i])
		end

		EntityRemoveTag( id, "de_reward_boss_ghost" )
		EntityRemoveTag( id, "forgeable" )
		
		converted = true
	end
end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 128, "tablet")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then
		local x,y = EntityGetTransform(id)

		local item_comps = EntityGetComponent( id, "ItemComponent" )
		local new_desc = ""
		local item_name

		if ( item_comps ~= nil ) then
			for i,itemc in ipairs(item_comps) do
				item_name = ComponentGetValue2( itemc, "item_name" )

				-- if( item_name == "$booktitle01" ) then new_desc = "$bookdesc01_forged" end
				if( item_name == "$booktitle02" ) then new_desc = "$bookdesc02_forged" end
				-- if( item_name == "$booktitle03" ) then new_desc = "$bookdesc03_forged" end
				if( item_name == "$booktitle04" ) then new_desc = "$bookdesc04_forged" end
				if( item_name == "$booktitle05" ) then new_desc = "$bookdesc05_forged" end
				if( item_name == "$booktitle06" ) then new_desc = "$bookdesc06_forged" end
				if( item_name == "$booktitle07" ) then new_desc = "$bookdesc07_forged" end
				if( item_name == "$booktitle08" ) then new_desc = "$bookdesc08_forged" end
				if( item_name == "$booktitle09" ) then new_desc = "$bookdesc09_forged" end
				if( item_name == "$booktitle10" ) then new_desc = "$bookdesc10_forged" end

			end
		end


		if( new_desc ~= "" ) then
			local forged_book = EntityLoad("data/entities/items/books/base_forged.xml", x, y - 5)
			item_comps = EntityGetComponent( forged_book, "ItemComponent" )
			if ( item_comps ~= nil ) then
				for i,itemc in ipairs(item_comps) do
					ComponentSetValue2( itemc, "item_name", item_name )
					ComponentSetValue2( itemc, "ui_description", new_desc )
				end
			end

			local uiinfo_comp = EntityGetComponent( forged_book, "UIInfoComponent" )
			if( uiinfo_comp ~= nil ) then
				for i,uiinfoc in ipairs(uiinfo_comp) do
					ComponentSetValue2( uiinfoc, "name", item_name )
				end
			end

			local ability_comp = EntityGetComponent( forged_book, "AbilityComponent" )
			if( ability_comp ~= nil ) then
				for i,abic in ipairs(ability_comp) do
					ComponentSetValue2( abic, "ui_name", item_name )
				end
			end

			EntityLoad("data/entities/projectiles/explosion.xml", x, y - 10)
			EntityKill(id)
		end
		converted = true
	end
end

if converted then
	GameTriggerMusicFadeOutAndDequeueAll( 3.0 )
	GameTriggerMusicEvent( "music/oneshot/dark_01", true, pos_x, pos_y )
end