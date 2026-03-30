dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/gun/gun_actions.lua" )
dofile_once( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/newgame_plus.lua")
dofile_once("data/scripts/perks/perk.lua")

-------------------------------------------------------------------------------

function make_random_card( x, y )
	--
end

-------------------------------------------------------------------------------

function drop_random_reward( x, y, entity_id, rand_x, rand_y, set_rnd_  )
	local good_item_dropped = true
	--
	return good_item_dropped
end

function drop_money( entity_item )
	-- 
end

function on_open( entity_item )
	local x, y = EntityGetTransform( entity_item )
	local rand_x = x
	local rand_y = y

	local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	local enemies = EntityGetInRadiusWithTag( x, y, 256, "enemy" )

	if #enemies > 0 then for _,enemy_id in ipairs(enemies) do if EntityHasTag( enemy_id, "boss" ) == false and EntityHasTag( enemy_id, "this_is_sampo" ) == false then
		local ex, ey = EntityGetTransform( enemy_id )

		EntityLoad( "data/entities/particles/destruction.xml", ex, ey )
		EntityKill( enemy_id )
	end end end

	GameScreenshake(20)

	-- PositionSeedComponent
	local position_comp = EntityGetFirstComponent( entity_item, "PositionSeedComponent" )
	if ( position_comp ) then
		rand_x = ComponentGetValue2( position_comp, "pos_x")
		rand_y = ComponentGetValue2( position_comp, "pos_y")
	end

	-- NOTE( Petri ): x and y are also used in spawn_heart function, which then limits this
	-- to 0.3 - 0.7 range... thus we'll mix the rand_x, rand_y
	rand_x = rand_x + 509.7
	rand_y = rand_y + 683.1

	SetRandomSeed( rand_x + entity_item, rand_y + GameGetFrameNum() )
	local jackpot = Random( 1, 777 )
	local opens = 10

	-- money
	-- card
	-- potion
	-- wand
	-- bunch of spiders
	-- bomb
	local good_item_dropped = drop_random_reward( x, y, entity_item, rand_x, rand_y, false )
	
	if good_item_dropped then
		if ( newgame_n == 0 ) then
			local components = EntityGetComponent( entity_item, "VariableStorageComponent" )

			if ( components ~= nil ) then
				for key,comp_id in pairs(components) do 
					local var_name = ComponentGetValue2( comp_id, "name" )

					if ( var_name == "open" ) then
						opens = ComponentGetValue2( comp_id, "value_int" )
						jackpot = jackpot - opens^2
						break
					end
				end
			end

			-- GamePrint(jackpot)

			if ( jackpot > 7 ) or ( opens < 13 ) then
				local chest_next = EntityLoad("data/entities/items/pickup/chest_random_super.xml", x, y )
				components = EntityGetComponent( chest_next, "VariableStorageComponent" )

				if ( components ~= nil ) then
					for key,comp_id in pairs(components) do 
						local var_name = ComponentGetValue2( comp_id, "name" )

						if ( var_name == "open" ) then
							ComponentSetValue2( comp_id, "value_int", opens + 1 )
							break
						end
					end
				end

				if ( opens > 13 ) then
					local costs = math.min( 10 * 2 ^ ( opens - 12 ), 66666 )
					costs = tostring(costs)

					EntityAddComponent( chest_next, "SpriteComponent", 
					{ 
						_tags="shop_cost,enabled_in_world",
						image_file="data/fonts/font_pixel_white.xml",
						is_text_sprite="1",
						offset_x=tostring( #costs * 2 + 2 ),
						offset_y="15",
						update_transform="1",
						update_transform_rotation="0",
						text=costs,
						z_index="-1",
					} )
					
					EntityAddComponent( chest_next, "ItemCostComponent", { cost=costs, } )
					-- can still be destroyed by shoting a lot of "disc_bullet_big" ( not "bigger"! ), it seems to be related to the bouncing of the projectile

					EntityAddTag( chest_next, "item_shop" )
					EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y)
				else
					EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y)
				end

				if jackpot > 77 then
					EntityLoad("data/entities/items/pickup/chest_random_harder_" .. Random(1,7) .. ".xml", x, y-17)
				else
					local opts = { "EDIT_WANDS_EVERYWHERE" }
					perk_spawn_many( x-30, y-19, false, opts )
				end

				local item_comp = EntityGetFirstComponent( chest_next, "ItemComponent" )
				if item_comp ~= nil then ComponentSetValue2( item_comp, "next_frame_pickable", GameGetFrameNum() + 12 )	 end
			else-- ~0.1% when ( opens == 13 )
				EntityLoad("data/entities/items/pickup/chest_random_super_bad.xml", x, y)
				GameCreateSpriteForXFrames( "data/entities/animals/boss_robot/trail/warning.png", x, y-24, true, 0, 0, 18, true )

				--[[ -- 0.38%
				do_newgame_plus()
				GamePrint("$chest_bad_msg_2")
				]]--
			end
		else
			EntityLoad("data/entities/items/pickup/goldbin.xml", x, y-17)
			EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y-17)
		end
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

	if not EntityHasTag( entity_who_picked, "player_unit" ) then EntityKill( entity_who_picked ) end
	
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