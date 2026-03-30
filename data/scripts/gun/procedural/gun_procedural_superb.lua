dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/gun/gun_enums.lua")
dofile_once("data/scripts/gun/procedural/wands.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("data/scripts/gun/procedural/gun_procedural.lua")

function wand_add_random_cards_superb( gun, entity_id, level, new_capacity )
	local dcapacity = math.min( gun["deck_capacity"], new_capacity )
	local apround = clamp( gun["actions_per_round"], 1, 27 )
	local x, y = EntityGetTransform( entity_id )

	local card_count = math.min( Random( 0.7 * dcapacity, 0.9 * dcapacity ), 25 )
	card_count = clamp( card_count, 1, dcapacity - 1 )

	if apround < dcapacity then card_count = math.max( card_count, apround + 1 ) end 
	if dcapacity > 8 then card_count = math.min( card_count, dcapacity - 8 ) end
	if dcapacity == 1 then card_count = 1 end

	if level == nil then level = 1 end
	
	if Random( 0, 100 ) <= 3 or Random( 1, 37 ) <= 6 or Random( 1, 37 ) >= 19 then -- 41.3%
		local permanent_cards = { "MANA_REDUCE", "NOLLA", "RECHARGE", "DUPLICATE", "DRAW_RANDOM", "IF_PROJECTILE", "IF_HP", "IF_ENEMY", "IF_HALF", "IF_ELSE", "IF_END" }
		local pc_count = Random( 1, math.ceil( level^0.4 ) )

		for i=1,pc_count do
			local cardrnd = Random( 1, #permanent_cards )
			AddGunActionPermanent( entity_id, permanent_cards[cardrnd] )
			card_count = card_count - 1

			if cardrnd > 5 or card_count < 2 then break end
		end
	end

	local card = ""

	if card_count > 0 then
		local cardtype = { ACTION_TYPE_STATIC_PROJECTILE, ACTION_TYPE_MODIFIER, ACTION_TYPE_MATERIAL, ACTION_TYPE_OTHER, ACTION_TYPE_UTILITY, ACTION_TYPE_PASSIVE }
		local card_add = math.floor( dcapacity * 0.125 )

		if card_add > 0 and card_count > card_add then
			for i=1,card_add do
				card = GetRandomActionWithType( entity_id, x+y, Random(2,7), ACTION_TYPE_DRAW_MANY, i )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end
		end

		for i=1,#cardtype do
			if card_count > 2 and Random(1,100) < 60 then
				card = GetRandomActionWithType( entity_id, x+y, Random(2,7), cardtype[i], card_count )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end
		end

		if card_count > 3 and Random(1,100) > 60 then
			card = GetRandomActionWithType( entity_id, x+y, Random(2,7), ACTION_TYPE_PASSIVE, card_count )
			AddGunAction( entity_id, card )
			card_count = card_count - 1
		end

		cardtype = { ACTION_TYPE_PROJECTILE, ACTION_TYPE_STATIC_PROJECTILE, ACTION_TYPE_MODIFIER, ACTION_TYPE_UTILITY, ACTION_TYPE_MATERIAL }
		card_add = math.floor( card_count * 0.5 )

		if card_add > 0 and card_count > 2 then
			if level > 12 then table.insert( cardtype, ACTION_TYPE_OTHER ) end

			for i=1,card_add do
				local levelrnd = Random(5,10)
				if level < 12 and levelrnd > 7 then levelrnd = 7 end
				if level >= 12 and levelrnd > 7 and levelrnd ~= 10 then levelrnd = levelrnd - 2 end

				card = GetRandomActionWithType( entity_id, x+y, levelrnd, cardtype[Random(1,#cardtype)], i )
				AddGunAction( entity_id, card )
				card_count = card_count - 1
			end
		end

		if card_count > 0 then
			for i=1,card_count do
				local levelrnd = Random(5,10)
				if level < 12 and levelrnd > 7 then levelrnd = 7 end
				if level >= 12 and levelrnd > 7 and levelrnd ~= 10 then levelrnd = levelrnd - 2 end

				card = GetRandomActionWithType( entity_id, x+y, levelrnd, ACTION_TYPE_PROJECTILE, card_count )
				AddGunAction( entity_id, card )
			end
		end
	end

	local light_comp = EntityGetFirstComponent( entity_id, "LightComponent" )

	if light_comp ~= nil then
		ComponentSetValue2( light_comp, "update_properties", true )
		ComponentSetValue2( light_comp, "r", 255 )
		ComponentSetValue2( light_comp, "g", 0 )
		ComponentSetValue2( light_comp, "b", 0 )
	end
end

function generate_gun_superb( cost, level, force_unshuffle )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )

	local gun = get_gun_data( cost, level, force_unshuffle )
	make_wand_from_gun_data( gun, entity_id, level )
	
	local new_capacity = deep_end_gun_affix_apply( gun, entity_id, level, true )
	wand_add_random_cards_superb( gun, entity_id, level, new_capacity )
end


