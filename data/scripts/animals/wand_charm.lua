dofile_once("data/scripts/lib/utilities.lua")

function wand_has_any_cards_in_it( wand_entity )
	local always_casts = 0
	local card = 0

	local c = EntityGetAllChildren( wand_entity )
	local comp = EntityGetFirstComponentIncludingDisabled( wand_entity, "AbilityComponent" )

	if c ~= nil then for a,b in ipairs( c ) do
		if EntityGetFirstComponentIncludingDisabled( b, "ItemActionComponent" ) ~= nil then card = card + 1 end
	end end
				
	if comp ~= nil then always_casts = ComponentObjectGetValue( comp, "gun_config", "deck_capacity" ) - EntityGetWandCapacity( wand_entity ) end
	if card > always_casts then return true end

	return false
end

----

function material_area_checker_success( x, y )
	local entity_id = GetUpdatedEntityID()
	-- always_casts can be removed!
	-- shop wands can be charmed!

	if EntityHasTag( entity_id, "wand" ) then
		local x, y, r = EntityGetTransform( entity_id )
		local level, card_id = 1, 0

		local ability_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "AbilityComponent" )
		local cards = EntityGetAllChildren( entity_id )

		if ability_comp ~= nil then
			level = ComponentGetValue2( ability_comp, "gun_level" )
			level = tonumber( clamp( level, 1, 100 ) )
		end

		if cards ~= nil and #cards > 0 then for i=1,#cards do
			if EntityGetFirstComponentIncludingDisabled( cards[i], "ItemActionComponent" ) ~= nil then
				EntityRemoveFromParent( cards[i] )
				EntitySetTransform( cards[i], x, y, 0, 1, 1 )

				EntitySetComponentsWithTagEnabled( cards[i], "enabled_in_hand", false )
				EntitySetComponentsWithTagEnabled( cards[i], "enabled_in_inventory", false )
				EntitySetComponentsWithTagEnabled( cards[i], "enabled_in_world", true )
				EntitySetComponentsWithTagEnabled( cards[i], "item_unidentified", false )

				local vel_comp = EntityGetFirstComponentIncludingDisabled( cards[i], "VelocityComponent" )
				card_id = card_id + 1

				if vel_comp ~= nil then
					local angle = card_id * (-1)^card_id
					if angle > 0 then angle = angle - 1 end

					ComponentSetValue2( vel_comp, "mVelocity", angle * 5, -25 )
				end
			end
		end end

		if card_id == 0 then
			local dollar_comps = EntityGetComponent( d_dollar, "VariableStorageComponent" )
			local money, d_dollar = clamp( 10^level, 1, 10^16 ), nil

			if level < 6 then d_dollar = EntityLoad( "data/entities/items/pickup/gold_dollar.xml", x, y )
			else d_dollar = EntityLoad( "data/entities/items/pickup/gold_giant_dollar.xml", x, y ) end
		
			if dollar_comps ~= nil then for i,comp in ipairs( dollar_comps ) do
				local n = ComponentGetValue2( comp, "name" )

				if n == "gold_value" then ComponentSetValue2( comp, "value_int", money )
				elseif n == "hp_value" then ComponentSetValue2( comp, "value_float", money * 0.016 ) end
			end end

			dollar_comps = EntityGetFirstComponent( d_dollar, "ItemComponent" )
			level = level * r * 100

			if dollar_comps ~= nil then if ComponentGetValue2( dollar_comps, "auto_pickup" ) then
				ComponentSetValue2( dollar_comps, "next_frame_pickable", GameGetFrameNum() + 45 )
				PhysicsApplyTorque( d_dollar, level )
			end end

			EntityLoad( "data/entities/particles/image_emitters/heart_fullhp_effect.xml", x, y )
		else
			EntityLoad( "data/entities/particles/image_emitters/spell_refresh_effect.xml", x, y )
		end

		EntityKill( entity_id )
		return
	end

	if EntityHasTag( entity_id, "this_is_sampo" ) then
		-- remove CameraBoundComponent
		local entity_ghost = EntityLoad( "data/entities/animals/wand_ghost_with_sampo.xml", x, y )
		EntityAddTag( entity_ghost, "this_is_sampo" )

		-- make pick up only this item - via ItemPickUpperComponent::only_pick_this_entity
		local itempickup = EntityGetFirstComponent( entity_ghost, "ItemPickUpperComponent" )

		if itempickup then
			ComponentSetValue2( itempickup, "only_pick_this_entity", entity_id )
			GamePickUpInventoryItem( entity_ghost, entity_id, false )
			-- print( "called item pick up ")
		end

		-- check that we hold the item
		local items = GameGetAllInventoryItems( entity_ghost )
		local has_item = false

		-- if we don't have the item kill us for we are too dangerous to be left alive
		if items ~= nil then for i,v in ipairs(items) do if v == entity_id then has_item = true end end end
		if has_item == false then EntityKill( entity_ghost ) end
	end
end

