dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/gun/gun_actions.lua" )
dofile_once( "data/scripts/game_helpers.lua" )

-------------------------------------------------------------------------------

function make_random_card( x, y )
	-- this does NOT call SetRandomSeed() on purpouse. 
	-- SetRandomSeed( x, y )

	local item = ""
	local valid = false

	while ( valid == false ) do
		local itemno = Random( 1, #actions )
		local thisitem = actions[itemno]
		item = string.lower(thisitem.id)
		
		if ( thisitem.spawn_requires_flag ~= nil ) then
			local flag_name = thisitem.spawn_requires_flag
			local flag_status = HasFlagPersistent( flag_name )
			
			if flag_status then
				valid = true
			end

			-- 
			if( thisitem.spawn_probability == "0" ) then 
				valid = false
			end
			
		else
			valid = true
		end

		if thisitem.id == "DE_RESET_ALL" or thisitem.id == "DE_ULTIMATE" then valid = false end
	end


	if ( string.len(item) > 0 ) then
		local card_entity = CreateItemActionEntity( item, x, y )
		return card_entity
	else
		print( "No valid action entity found!" )
	end
end

function chest_load_gold_entity( entity_filename, x, y, remove_timer )
	local eid = load_gold_entity( entity_filename, x, y, remove_timer )
	local item_comp = EntityGetFirstComponent( eid, "ItemComponent" )

	-- auto_pickup e.g. gold should have a delay in the next_frame_pickable, since they get gobbled up too fast by the player to see
	if item_comp ~= nil then
		if( ComponentGetValue2( item_comp, "auto_pickup") ) then
			ComponentSetValue2( item_comp, "next_frame_pickable", GameGetFrameNum() + 15 )	
		end
	end
end

-------------------------------------------------------------------------------

function drop_random_reward( x, y, entity_id, rand_x, rand_y, set_rnd_  )
	local set_rnd = false 
	if( set_rnd_ ~= nil ) then set_rnd = set_rnd_ end
	
	local good_item_dropped = true
	
	-- using deferred loading of entities, since loading some of them (e.g. potion.xml) will call SetRandomSeed(...)
	-- if position is not given (in entities table), will load the entity to rand_x, rand_y and then move it to chest position
	-- reason for this is that then the SetRandomSeed() of those entities will be deterministic 
	-- but for some reason it cannot be done to random_card.xml, since I'm guessing

	local entities = {}
	local count = 1
	local plus = 0
	local chest_type = 0

	while ( count > 0 ) do
		local year, month, day = GameGetDateAndTimeLocal()
		SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
		
		local rnd = Random(1,100)
		count = count - 1

		local chosen = tonumber(ModSettingGet( "DEEP_END.MAP_TYPE" ))
		local unlimited = 123

		if ( not ModSettingGet( "DEEP_END.ORIGINAL_SPELLS" ) ) and ( y > 512 ) then
			local rrnd = Random(1,777)
			if ComponentGetValue2( EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" ), "perk_infinite_spells" ) then unlimited = 456 end
			
			if ( rrnd > 765 ) then
				table.insert( entities, { "data/entities/items/pickup/ammo_box.xml" } )
			elseif ( rrnd > 750 ) then
				table.insert( entities, { "data/entities/items/pickup/utility_box.xml" } )
			elseif ( rrnd > unlimited ) then
				table.insert( entities, { "data/entities/items/pickup/spell_refresh.xml" } )
				unlimited = 0
			elseif ( rrnd < 66 ) then
				table.insert( entities, { "data/entities/animals/illusions/shaman_wind.xml" } )
			end
		end

		if GlobalsGetValue( "DEEP_END_REMOVE_FOG_OF_WAR" ) == "t" and unlimited ~= 0 then
			table.insert( entities, { "data/entities/items/pickup/spell_refresh.xml" } )
		end

		local typecomps = EntityGetComponent( entity_id, "VariableStorageComponent" )

		if ( typecomps ~= nil ) then
			for key,comp_id in pairs(typecomps) do 
				local var_name = ComponentGetValue2( comp_id, "name" )

				if ( var_name == "type" ) then
					chest_type = ComponentGetValue2( comp_id, "value_int" )
					-- GamePrint(tostring(chest_type))
					break
				end
			end
		end

		if ( chest_type == 1 ) and ( rnd <= 8 ) then
			rnd = Random(11,100)
		elseif ( chest_type == 2 ) and ( rnd > 8 ) and ( rnd <= 35 ) then
			rnd = Random(6,100)
		elseif ( chest_type == 3 ) and ( rnd > 35 ) and ( rnd <= 65 ) then
			rnd = Random(71,100)
		elseif ( chest_type == 4 ) and ( rnd > 70 ) then
			rnd = Random(36,65)
		elseif ( chest_type == 5 ) and ( ( rnd > 45 and rnd <= 65 ) or ( rnd > 90 ) ) then
			rnd = Random(36,65)
			if rnd > 45 then rnd = rnd + 25 end
		elseif ( chest_type == 6 ) and ( ( rnd > 35 and rnd <= 45 ) or ( rnd > 70 and rnd <= 90 ) ) then
			rnd = Random(46,75)
			if rnd > 65 then rnd = rnd + 25 end
		elseif ( chest_type == 7 ) then
			rnd = Random(21,100)
		elseif ( chest_type == 0 ) and ( y <= 0 ) then
			rnd = Random(11,100)
		end

		if GlobalsGetValue( "DEEP_END_REMOVE_FOG_OF_WAR" ) == "t" then rnd = Random(16,100) end
		if ( chosen >= 3 ) then rnd = Random(11,100) end
		if ( y <= 0 ) and ( rnd <= 8 ) then rnd = Random(16,90) end

		if ( rnd <= 10 ) then -- 10%
			-------------------------------------------------------------------
			-- Bomb
			-------------------------------------------------------------------
			local temple_area = EntityGetInRadiusWithTag( x, y, 128, "perk_reroll_machine" )

			if ( #temple_area > 0 ) then
				table.insert( entities, { "data/entities/projectiles/bomb_holy_lmao.xml" } )
			else
				table.insert( entities, { "data/entities/projectiles/bomb_holy.xml" } )

				local player = EntityGetInRadiusWithTag( x, y, 128, "player_unit" )

				if ( #player > 0 ) then
					GameCreateSpriteForXFrames( "data/entities/animals/boss_robot/trail/warning.png", x, y-24, true, 0, 0, 18, true )
					GamePrint("$chest_bad_msg_1")
				end
			end

			-- EntityLoad( "data/entities/projectiles/bomb_small.xml", x + Random(-10,10), y - 4 + Random(-10,10) )
			good_item_dropped = false
			
		elseif ( rnd <= 35 ) then -- 25%
			-------------------------------------------------------------------
			-- Gold (I think the reason there's empty is chests is goldnuggets)
			-------------------------------------------------------------------
			local remove_gold_timer = false
	
			if ComponentGetValue2( EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" ), "perk_gold_is_forever" ) then
				remove_gold_timer = true
			end

			rnd = Random(1,100)
			if (rnd <= 80) then
				for i=1,Random(2,4) do
					chest_load_gold_entity( "data/entities/items/pickup/goldnugget_1000.xml", x + Random(-10,10), y - 4 + Random(-10,5), false )
				end
			else
				chest_load_gold_entity( "data/entities/items/pickup/goldnugget_10000.xml", x + Random(-10,10), y - 4 + Random(-10,5), false )
			end

			rnd = Random(1,100)
			if ( rnd <= 75 ) then
				for i=1,Random(1,4) do
					chest_load_gold_entity( "data/entities/items/pickup/bloodmoney_200.xml", x + Random(-10,10), y - 4 + Random(-10,5), false )
				end
			else
				chest_load_gold_entity( "data/entities/items/pickup/bloodmoney_1000.xml", x + Random(-10,10), y - 4 + Random(-10,5), false )
			end

			rnd = Random(1,100) 
			if ( rnd <= 33 ) and ( y <= 0 ) then table.insert( entities, { "data/entities/items/pickup/speed_run_package.xml" } ) end
		elseif( rnd <= 45 ) then -- 20%
			-------------------------------------------------------------------
			-- Potion
			-------------------------------------------------------------------
			rnd = Random(1,100)
			local potion_type_list = { "_secret", "_random_material", "" }

			if (y > 0) then
				for i=1,5 do table.insert( entities, { "data/entities/items/pickup/potion" .. potion_type_list[Random(1,3)] .. ".xml" } ) end
			elseif (rnd > 66) then
				for i=1,3 do table.insert( entities, { "data/entities/items/pickup/potion" .. potion_type_list[Random(1,3)] .. ".xml" } ) end
				table.insert( entities, { "data/entities/items/pickup/potion.xml" } )
				table.insert( entities, { "data/entities/items/pickup/potion.xml" } )
			else
				for i=1,5 do table.insert( entities, { "data/entities/items/pickup/potion.xml" } ) end
			end
		elseif( rnd <= 65 ) then -- 20%W
			-------------------------------------------------------------------
			-- Random card
			-------------------------------------------------------------------
			-- NOTE( Petri ): random_card.xml is bad, it leaves an empty entity hanging around
			-- table.insert( entities, { "data/entities/items/pickup/random_card.xml",  x + Random(-10,10), y - 4 + Random(-5,5) } )
			-- this does NOT call SetRandomSeed() on purpouse
			local amount = 3
			rnd = Random(1,100)
			if (rnd <= 25) then -- 25
				amount = 3
			elseif (rnd <= 45) then -- 20
				amount = 4
			elseif (rnd <= 65) then -- 20
				amount = 5
			elseif (rnd <= 80) then -- 15
				amount = 6
			elseif (rnd <= 90) then -- 10
				amount = 7
			else -- 10
				amount = 8
			end

			for i=1,amount do
				make_random_card( x + (i - (amount / 2)) * 8, y - 4 + Random(-5,5) )
			end
		elseif( rnd <= 90 ) then -- 35%
			-------------------------------------------------------------------
			-- Wand
			-------------------------------------------------------------------

			rnd = Random(1,100)
			
			if( rnd <= 4 ) then --4
				table.insert( entities, { "data/entities/items/wand_unshuffle_02.xml" } )
			elseif( rnd <= 20 ) then --16
				table.insert( entities, { "data/entities/items/wand_unshuffle_03.xml" } )
			elseif( rnd <= 54 ) then --34
				table.insert( entities, { "data/entities/items/wand_unshuffle_04.xml" } )
			elseif( rnd <= 87 ) then --33
				table.insert( entities, { "data/entities/items/wand_unshuffle_05.xml" } )
			elseif( rnd <= 99 ) then --12
				table.insert( entities, { "data/entities/items/wand_unshuffle_06.xml" } )
			elseif( rnd <= 100 ) then --1
				table.insert( entities, { "data/entities/items/wand_unshuffle_10.xml" } )
			end
		elseif( rnd <= 100 ) then -- 10%
			-------------------------------------------------------------------
			-- Heart(s)
			-------------------------------------------------------------------
			rnd = Random(1,100)
			
			if (rnd <= 10) and (y > 0)then -- 10
				table.insert( entities, { "data/entities/animals/illusions/dark_alchemist.xml" } )
			elseif (rnd <= 70) then -- 60
				table.insert( entities, { "data/entities/items/pickup/heart.xml" } )
			elseif (rnd <= 95) then -- 25
				table.insert( entities, { "data/entities/items/pickup/heart_better.xml" } )
			else -- 5
				table.insert( entities, { "data/entities/items/pickup/heart_fullhp.xml" } )
			end
		end

		SetRandomSeed( rnd, plus + day * month )

		rnd = Random(1,199)

		if (rnd == 199) and (plus < 7) and (y > 0) then 
			count = count + 1 
			plus = plus + 1
		end
	end

	for i,entity in ipairs(entities) do
		local eid = 0 
		if( entity[2] ~= nil and entity[3] ~= nil ) then 
			eid = EntityLoad( entity[1], entity[2], entity[3] ) 
		else
			eid = EntityLoad( entity[1], rand_x, rand_y )
			EntityApplyTransform( eid, x + Random(-10,10), y - 4 + Random(-5,5)  )
		end

		local item_comp = EntityGetFirstComponent( eid, "ItemComponent" )

		-- auto_pickup e.g. gold should have a delay in the next_frame_pickable, since they get gobbled up too fast by the player to see
		if item_comp ~= nil then
			if( ComponentGetValue2( item_comp, "auto_pickup") ) then
				ComponentSetValue2( item_comp, "next_frame_pickable", GameGetFrameNum() + 30 )	
			end
		end
	end


	return good_item_dropped
end

function drop_money( entity_item )
	
	-- 
end

function on_open( entity_item )
	local x, y = EntityGetTransform( entity_item )
	local rand_x = x
	local rand_y = y

	-- PositionSeedComponent
	local position_comp = EntityGetFirstComponent( entity_item, "PositionSeedComponent" )
	if( position_comp ) then
		rand_x = ComponentGetValue2( position_comp, "pos_x")
		rand_y = ComponentGetValue2( position_comp, "pos_y")
	end

	-- NOTE( Petri ): x and y are also used in spawn_heart function, which then limits this
	-- to 0.3 - 0.7 range... thus we'll mix the rand_x, rand_y
	rand_x = rand_x + 509.7
	rand_y = rand_y + 683.1

	SetRandomSeed( rand_x, rand_y )

	-- money
	-- card
	-- potion
	-- wand
	-- bunch of spiders
	-- bomb
	local good_item_dropped = drop_random_reward( x, y, entity_item, rand_x, rand_y, false )
	
	if good_item_dropped then
		EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y)
	else
		EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y)
	end
end

function item_pickup( entity_item, entity_who_picked, name )
	if EntityHasTag( entity_who_picked, "player_unit" ) then
		GamePrintImportant( "$log_chest", "", "data/ui_gfx/decorations/peace_temple_break.png" )
	else
		GamePrintImportant( "$log_chest_hamis_haha", "", "data/ui_gfx/decorations/peace_temple_break.png" )
	end
	-- GameTriggerMusicCue( "item" )

	--if (remove_entity == false) then
	--	EntityLoad( "data/entities/misc/chest_random_dummy.xml", x, y )
	--end

	on_open( entity_item )
	
	EntityKill( entity_item )
end

function physics_body_modified( is_destroyed )
	-- GamePrint( "A chest was broken open" )
	-- GameTriggerMusicCue( "item" )
	local entity_item = GetUpdatedEntityID()
	
	on_open( entity_item )

	edit_component( entity_item, "ItemComponent", function(comp,vars)
		EntitySetComponentIsEnabled( entity_item, comp, false )
	end)
	
	EntityKill( entity_item )
end