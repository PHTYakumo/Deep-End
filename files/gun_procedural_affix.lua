function deep_end_gun_affix_effect( gun, affixrnd, level, always_casts )
	local gun_affix = { }
	gun_affix.deck_capacity = gun["deck_capacity"] or gun.deck_capacity
	gun_affix.actions_per_round = gun["actions_per_round"] or gun.actions_per_round
	gun_affix.reload_time = gun["reload_time"] or gun.reload_time
	gun_affix.fire_rate_wait = gun["fire_rate_wait"] or gun.fire_rate_wait
	gun_affix.spread_degrees = gun["spread_degrees"] or gun.spread_degrees
	gun_affix.speed_multiplier = gun["speed_multiplier"] or gun.speed_multiplier
	gun_affix.mana_charge_speed = gun["mana_charge_speed"] or gun.mana_charge_speed
	gun_affix.mana_max = gun["mana_max"] or gun.mana_max

	-- apply affix effect
	if affixrnd == 1 then gun_affix.deck_capacity = clamp( gun_affix.deck_capacity - level, 1 + always_casts, clamp( level * 2, 1 + always_casts, 31 ) ) 
	elseif affixrnd == 2 then gun_affix.deck_capacity = clamp( gun_affix.deck_capacity + level, math.min( level * 3, 1 ) + always_casts, 31 ) 
	elseif affixrnd == 3 then gun_affix.spread_degrees = math.min( gun_affix.spread_degrees - 30, 0 ) 
	elseif affixrnd == 4 then gun_affix.spread_degrees = math.min( gun_affix.spread_degrees - 15, 0 ) 
	elseif affixrnd == 5 then gun_affix.spread_degrees = clamp( gun_affix.spread_degrees + 15, 0, 180 ) 
	elseif affixrnd == 6 then gun_affix.spread_degrees = clamp( gun_affix.spread_degrees + 30, 0, 180 ) 
	elseif affixrnd == 7 then gun_affix.speed_multiplier = 0.25 
	elseif affixrnd == 8 then gun_affix.speed_multiplier = 0.75 
	elseif affixrnd == 9 then gun_affix.speed_multiplier = 1.25 
	elseif affixrnd == 10 then gun_affix.speed_multiplier = 1.75 
	elseif affixrnd == 11 then gun_affix.mana_max = gun_affix.mana_max + 250 
	elseif affixrnd == 12 then gun_affix.mana_max = gun_affix.mana_max + 125 
	elseif affixrnd == 13 then gun_affix.mana_max = math.max( gun_affix.mana_max - 125, level ) 
	elseif affixrnd == 14 then gun_affix.mana_max = math.max( gun_affix.mana_max - 250, level ) 
	elseif affixrnd == 15 then gun_affix.mana_charge_speed = gun_affix.mana_charge_speed + 80 
	elseif affixrnd == 16 then gun_affix.mana_charge_speed = gun_affix.mana_charge_speed + 40 
	elseif affixrnd == 17 then gun_affix.mana_charge_speed = math.max( gun_affix.mana_charge_speed - 40, level ) 
	elseif affixrnd == 18 then gun_affix.mana_charge_speed = math.max( gun_affix.mana_charge_speed - 80, level ) 
	elseif affixrnd == 19 then
		gun_affix.fire_rate_wait = math.min( gun_affix.reload_time, gun_affix.fire_rate_wait ) - 18
		gun_affix.reload_time = math.max( gun_affix.reload_time, gun_affix.fire_rate_wait ) + 18
	elseif affixrnd == 20 then
		gun_affix.fire_rate_wait = math.max( gun_affix.reload_time, gun_affix.fire_rate_wait ) + 18
		gun_affix.reload_time = math.min( gun_affix.reload_time, gun_affix.fire_rate_wait ) - 18
	elseif affixrnd == 21 then
		local changes = gun_affix.deck_capacity - 1 - always_casts
		gun_affix.mana_max = gun_affix.mana_max + changes * 120 
		gun_affix.mana_charge_speed = gun_affix.mana_charge_speed + changes * 40 
		gun_affix.deck_capacity = 1 + always_casts
	elseif affixrnd == 22 then
		local changes = math.max( gun_affix.deck_capacity * 2, 31 ) - gun_affix.deck_capacity
		gun_affix.mana_max = math.max( gun_affix.mana_max - changes * 75 , level * 45 )
		gun_affix.mana_charge_speed = math.max( gun_affix.mana_charge_speed - changes * 25, level * 15 )
		gun_affix.deck_capacity = changes + gun_affix.deck_capacity
	elseif affixrnd == 23 then
		gun_affix.mana_max = math.min( gun_affix.mana_max * gun_affix.mana_charge_speed, 999999999 )
		gun_affix.mana_charge_speed = 0
	elseif affixrnd == 24 then
		gun_affix.reload_time = math.min( gun_affix.fire_rate_wait, 24 )
		gun_affix.fire_rate_wait = math.min( gun_affix.fire_rate_wait, 12 )
		gun_affix.actions_per_round = 1
	elseif affixrnd == 25 then
		gun_affix.reload_time = math.min( gun_affix.fire_rate_wait, 36 )
		gun_affix.fire_rate_wait = math.min( gun_affix.fire_rate_wait, 6 )
		gun_affix.actions_per_round = 2
	elseif affixrnd == 26 then
		gun_affix.reload_time = gun_affix.reload_time + gun_affix.fire_rate_wait
		gun_affix.fire_rate_wait = math.min( gun_affix.fire_rate_wait, 6 )
		gun_affix.actions_per_round = gun_affix.deck_capacity - always_casts
	elseif affixrnd == 27 then
		gun_affix.reload_time = math.min( gun_affix.reload_time, gun_affix.fire_rate_wait )
		gun_affix.fire_rate_wait = gun_affix.reload_time
	end

	local wandtype = 0

	if affixrnd == 23 then wandtype = 0
	elseif gun_affix.mana_charge_speed >= gun_affix.mana_max then wandtype = 1
	elseif gun_affix.mana_charge_speed * 20 <= gun_affix.mana_max then wandtype = 2 end

	gun_affix.deck_capacity = clamp( gun_affix.deck_capacity, always_casts + 1, 31 )
	gun_affix.name = GameTextGetTranslatedOrNot( "$deep_end_wand_affix_" .. tostring(affixrnd) ) .." " .. GameTextGetTranslatedOrNot( "$deep_end_wand_name_" .. tostring(wandtype) )

	return gun_affix
end

function deep_end_gun_affix_apply( gun, entity_id, level, better )
	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )
	local item_comp = EntityGetFirstComponent( entity_id, "ItemComponent" )
	if ability_comp == nil or item_comp == nil then return end

	local affixrnd = Random(1,100) -- common affix: 60%, rare affix: 10%, no affix: 30%
	local secrnd = Random(1,100) -- add another affix: 20% * 48%
	if affixrnd > 80 then affixrnd = affixrnd - 80 
	elseif affixrnd > 60 then affixrnd = affixrnd - 60 end
	if level > 9 and affixrnd > 27 then affixrnd = 31 end

	local wand_lv_name = tostring(level)
	if level > 9 then wand_lv_name = "10" end
	if better then wand_lv_name = wand_lv_name .. "+" end
	wand_lv_name = " lv." .. wand_lv_name
	if level > 12 then wand_lv_name = "MAX" end

	local light_comp = EntityGetFirstComponent( entity_id, "LightComponent" )

	if light_comp ~= nil then
		if affixrnd > 30 then
			ComponentSetValue2( light_comp, "update_properties", false )
		else
			ComponentSetValue2( light_comp, "update_properties", true )
		end

		if affixrnd > 27 then
			ComponentSetValue2( light_comp, "r", 128 )
			ComponentSetValue2( light_comp, "g", 255 )
			ComponentSetValue2( light_comp, "b", 0 )
		elseif better then
			ComponentSetValue2( light_comp, "r", 127 )
			ComponentSetValue2( light_comp, "g", 0 )
			ComponentSetValue2( light_comp, "b", 255 )
		else
			ComponentSetValue2( light_comp, "r", 0 )
			ComponentSetValue2( light_comp, "g", 255 )
			ComponentSetValue2( light_comp, "b", 255 )
		end
	end
	
	if affixrnd > 30 then
		local wandtype = 0
		if gun["mana_charge_speed"] >= gun["mana_max"] then wandtype = 1 
		elseif gun["mana_charge_speed"] * 30 <= gun["mana_max"] then wandtype = 2 end

		wand_lv_name = GameTextGetTranslatedOrNot( "$deep_end_wand_name_" .. tostring(wandtype) ) .. wand_lv_name
		component_write( item_comp,
			{
				item_name = wand_lv_name,
				always_use_item_name_in_ui = true,
			}
		)

		if level > 99 then ComponentObjectSetValue2( ability_comp, "gun_config", "shuffle_deck_when_empty", true ) end
		return gun["deck_capacity"], gun["actions_per_round"]
	end

	local positive_affix = { 2,3,4,9,10,11,12,15,16,24,25,26,27}
	if gun["is_rare"] == 1 or GlobalsGetValue( "PERK_NO_MORE_SHUFFLE_WANDS", "0" ) == "1" then affixrnd = positive_affix[Random(1,#positive_affix)] end

	local perm = { ACTION_TYPE_MODIFIER, ACTION_TYPE_MODIFIER, ACTION_TYPE_MODIFIER }
	local always_casts = math.max( affixrnd - 27, 0 ) -- gun["deck_capacity"] - EntityGetWandCapacity( entity_id )

	if always_casts > 0 then
		if Random(1,100) > 24 then table.insert( perm, ACTION_TYPE_PASSIVE ) end
		if Random(1,100) < 12 then table.insert( perm, ACTION_TYPE_PROJECTILE ) end
		if Random(1,100) < 6 then table.insert( perm, ACTION_TYPE_STATIC_PROJECTILE ) end
		if Random(1,100) < 3 then table.insert( perm, ACTION_TYPE_UTILITY ) end

		for i=1,always_casts do
			local perm_type = perm[Random(1,#perm)]
			local perm_level = math.max( level + i - 2, always_casts - i )

			AddGunActionPermanent( entity_id, GetRandomActionWithType( affixrnd, always_casts, perm_level, perm_type, 333*i ) )
		end
	end
	
	local gun_affix = deep_end_gun_affix_effect( gun, affixrnd, level, always_casts )
	local affix_group_1 = math.floor( affixrnd * 0.25 + 0.26 )
	local affix_group_2 = math.floor( secrnd * 0.25 + 0.26 )

	if affixrnd >= 2 and affixrnd <= 18 and secrnd <= 20 and affix_group_1 ~= affix_group_2 then -- prevent affixes of the same function
		positive_affix = { 3,4,9,10,11,12,15,16 }
		if gun["is_rare"] == 1 or GlobalsGetValue( "PERK_NO_MORE_SHUFFLE_WANDS", "0" ) == "1" then secrnd = positive_affix[Random(1,#positive_affix)] end -- only the last four affixes are excluded
			
		gun_affix = deep_end_gun_affix_effect( gun_affix, secrnd, level, always_casts )
		gun_affix.name = GameTextGetTranslatedOrNot( "$deep_end_wand_affix_" .. tostring(affixrnd) ) .. " " .. gun_affix.name
	end

	ComponentObjectSetValue2( ability_comp, "gun_config", "deck_capacity", gun_affix.deck_capacity )
	ComponentObjectSetValue2( ability_comp, "gun_config", "actions_per_round", gun_affix.actions_per_round )
	ComponentObjectSetValue2( ability_comp, "gun_config", "reload_time", gun_affix.reload_time )
	ComponentObjectSetValue2( ability_comp, "gunaction_config", "fire_rate_wait", gun_affix.fire_rate_wait )
	ComponentObjectSetValue2( ability_comp, "gunaction_config", "spread_degrees", gun_affix.spread_degrees )
	ComponentObjectSetValue2( ability_comp, "gunaction_config", "speed_multiplier", gun_affix.speed_multiplier )
	ComponentSetValue2( ability_comp, "mana_charge_speed", gun_affix.mana_charge_speed )
	ComponentSetValue2( ability_comp, "mana_max", gun_affix.mana_max )
	ComponentSetValue2( ability_comp, "mana", gun_affix.mana_max )

	-- ComponentSetValue( ability_comp, "ui_name", gun_affix.name .. wand_lv_name )
	component_write( item_comp, {
		item_name = gun_affix.name .. wand_lv_name,
		always_use_item_name_in_ui = true,
	})

	local wand = GetWand( gun )
	SetWandSprite( entity_id, ability_comp, wand.file, wand.grip_x, wand.grip_y, (wand.tip_x - wand.grip_x), (wand.tip_y - wand.grip_y) )

	affix_group_1 = math.max( gun_affix.deck_capacity - always_casts, 0 )
	affix_group_2 = math.min( gun_affix.actions_per_round, affix_group_1 )

	return affix_group_1,affix_group_2
end

function deep_end_wand_add_random_cards( dcapacity, apround, entity_id, level, better )
	if dcapacity == 0 then return end
	local x, y = EntityGetTransform( entity_id )

	if level == nil then level = 1 end
	level = tonumber( level ) - 1

	local random_bullets, card_count = false, 4.4 + Random(1,10) * 0.1
	if better then card_count = card_count + Random(1,10) * 0.1 end

	if Random(1,100) < ( level*9 ) then random_bullets = true end
	if better and Random(1,100) < ( level*9 ) then random_bullets = true end

	card_count = Random( 0.1 * card_count * dcapacity, 0.9 * dcapacity )
	if dcapacity > apround then card_count = math.max( card_count, apround + 1 ) end 

	card_count = clamp( card_count, 1, dcapacity )
	if dcapacity == 1 then card_count = 1 end

	local bullet_card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_PROJECTILE, 0 )
	local card = ""

	if Random( 0, 100 ) > 60 then
		local extra_level = level

		while ( Random(1,10) == 10 and extra_level < 11 ) do
			extra_level = extra_level + 1
			bullet_card = GetRandomActionWithType( entity_id, x+y, extra_level, ACTION_TYPE_PROJECTILE, 0 )
		end

		if card_count < 3 then
			if card_count == 2 and Random( 0, 100 ) < 20 then
				card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_MODIFIER, 2 )
				AddGunAction( entity_id, card )
				AddGunAction( entity_id, bullet_card )
			elseif card_count > 0 then
				for i=1,card_count do
					AddGunAction( entity_id, bullet_card )
				end
			end
		else
			if Random( 0, 100 ) > 60 then
				card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_DRAW_MANY, 1 )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end

			if card_count > 5 and Random( 0, 100 ) > 60 then
				card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_DRAW_MANY, card_count )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end

			if better then level = Random( level, extra_level ) end

			if Random( 0, 100 ) < 60 and card_count > 0 then
				card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_MODIFIER, card_count )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end

			if card_count > 3 and Random( 0, 100 ) < 60 then
				card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_MODIFIER, 2 )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end

			if card_count > ( dcapacity*0.5 ) then
				card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_MODIFIER, 2 )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end

			if Random(1,10) == 10 or card_count > ( dcapacity*0.5 ) then random_bullets = true end
			local ex_add_card_count = math.max(level,apround)

			if random_bullets and card_count > ex_add_card_count and ex_add_card_count > 0 then
				card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_PROJECTILE, card_count )

				for i=1,ex_add_card_count do
					AddGunAction( entity_id, card )
					card_count = card_count - 1
				end
			end

			if card_count > 0 then
				for i=1,card_count do
					AddGunAction( entity_id, bullet_card )
				end

				card_count = 0
			end
		end
	elseif random_bullets then
		if apround == 1 and card_count > 3 then
			card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_DRAW_MANY, 1 )
			AddGunAction( entity_id, card )
			card_count = card_count - 1
		end

		if card_count > 1 then
			AddGunAction( entity_id, bullet_card )
			card_count = card_count - 1

			if card_count > 1 then
				card_count = card_count - 1

				for i=1,card_count do
					if Random(1,100) < 60 then
						card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_PROJECTILE, i )
					elseif Random(1,100) > 60 then
						card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_DRAW_MANY, i )
					else
						card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_MODIFIER, i )
					end
					
					AddGunAction( entity_id, card )
				end

				AddGunAction( entity_id, bullet_card )
			elseif card_count == 1 then
				AddGunAction( entity_id, bullet_card )
			end
		elseif card_count == 1 then
			AddGunAction( entity_id, bullet_card )
		end
	elseif card_count > 0 then
		for i=1,card_count do
			if ( card_count - i ) > ( dcapacity*0.5 ) and ( card_count - i ) > 1 then
				if Random(1,100) < 60 then
					card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_MODIFIER, i )
				else
					card = GetRandomActionWithType( entity_id, x+y, level, ACTION_TYPE_DRAW_MANY, i )
				end
			
				AddGunAction( entity_id, card )
			else
				AddGunAction( entity_id, bullet_card )
			end
		end
	end
end

function generate_gun( cost, level, force_unshuffle )
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform( entity_id )
    SetRandomSeed( entity_id - 1437, y - x )

    local gun = get_gun_data( cost, level, force_unshuffle )
    make_wand_from_gun_data( gun, entity_id, level )

	local dcapacity, apround = deep_end_gun_affix_apply( gun, entity_id, level, false )
    deep_end_wand_add_random_cards( dcapacity, apround, entity_id, level, false )
end


