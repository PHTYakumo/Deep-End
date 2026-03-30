dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/game_helpers.lua" )


function do_money_drop( amount_multiplier, trick_kill )
	if GameGetIsTrailerModeEnabled() then return end

	local newgame_n = math.abs(tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") ))
	if newgame_n >= 100 then return end

	local entity = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity )

	local no_gold_drop = false
	edit_component_with_tag( entity, "VariableStorageComponent", "no_gold_drop", function(comp,vars) no_gold_drop = true end )
	if no_gold_drop then return end

	SetRandomSeed( GameGetFrameNum(), entity )

	local amount = 0.6667
	local hpcomp = EntityGetFirstComponent( entity, "DamageModelComponent" )

	if hpcomp ~= nil then amount = ComponentGetValue2( hpcomp, "max_hp") end
	if amount > 0.6667 then amount = math.floor( amount * ( Random( 25, 50 ) * 0.02 + Random( 1, 100 ) * 0.01 ) ) end

	local hah_amount_multiplier = math.max( math.floor( ModSettingGet( "DEEP_END.HELL_AND_HELL_HP" ) + 0.5 ), 1 )
	amount = amount * amount_multiplier * math.ceil( hah_amount_multiplier^0.8 )

	local money = math.max( math.floor( Random( 9 + hah_amount_multiplier, 12 + 3 * hah_amount_multiplier ) * amount ), Random( 9 + hah_amount_multiplier, 12 + 3 * hah_amount_multiplier ) - 5 )
	local gold_entity = "data/entities/items/pickup/goldnugget_"
	
	local remove_timer = false
	local is_blood_money = false

	local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )

	if comp_worldstate ~= nil then
		local hp_drop_chance = ComponentGetValue2( comp_worldstate, "perk_hp_drop_chance" ) * amount_multiplier

		if hp_drop_chance > 0 and Random( 1, 100 ) <= hp_drop_chance and ( not is_blood_money ) then
			gold_entity = "data/entities/items/pickup/bloodmoney_"
			is_blood_money = true
			money = math.max( money, 25 )
		end

		if EntityHasTag( entity, "de_mimic" ) then
			gold_entity = "data/entities/items/pickup/bloodmoney_"
			is_blood_money = true
			money = math.max( money, 50 )
		end

		if ComponentGetValue2( comp_worldstate, "perk_trick_kills_blood_money" ) and trick_kill then
			gold_entity = "data/entities/items/pickup/bloodmoney_"
			is_blood_money = true
		end

		if ComponentGetValue2( comp_worldstate, "perk_gold_is_forever" ) and ( money > 10 or is_blood_money ) then remove_timer = true end
	end

	local d_dollar = entity
	
	if money >= 1000*1000 then
		d_dollar = load_gold_entity( "data/entities/items/pickup/gold_giant_dollar.xml", x, y-8, remove_timer )
	elseif money >= 100*1000 then
		d_dollar = load_gold_entity( "data/entities/items/pickup/gold_dollar.xml", x, y-8, remove_timer )
	elseif money >= 10*1000 then
		d_dollar = load_gold_entity( gold_entity .. "10000.xml", x, y-8, remove_timer )
	elseif money >= 1000 then
		d_dollar = load_gold_entity( gold_entity .. "1000.xml", x, y-8, remove_timer )
	elseif money >= 200 then
		d_dollar = load_gold_entity( gold_entity .. "200.xml", x, y-8, remove_timer )
	elseif money >= 50 then
		d_dollar = load_gold_entity( gold_entity .. "50.xml", x, y-8, remove_timer )
	else
		d_dollar = load_gold_entity( gold_entity .. "10.xml", x, y-8, remove_timer )
	end

	local dollar_comps = EntityGetComponent( d_dollar, "VariableStorageComponent" )
	
	if dollar_comps ~= nil then for i,comp in ipairs( dollar_comps ) do
		local n = ComponentGetValue2( comp, "name" )

		if n == "gold_value" then
			ComponentSetValue2( comp, "value_int", math.ceil(money) )
		elseif n == "hp_value" then
			if is_blood_money then
				money = math.max( money, 4 )

				if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then ComponentSetValue2( comp, "value_float", money * 0.002 )
				else ComponentSetValue2( comp, "value_float", money * 0.00032 * ( 100 - Random( 25, 50 ) ) ) end
			end
		end
	end end
end