dofile_once("data/scripts/gun/procedural/gun_procedural.lua")


function do_level1( level )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	SetRandomSeed( x, y + entity_id )

	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )

	if ( ability_comp == nil ) then
		print_error( "Couldn't find AbilityComponent for entity, it is probably not enabled" )
	end

	local reload_time = tonumber( ComponentObjectGetValue( ability_comp, "gun_config", "reload_time"  ) )
	local fire_rate_wait = tonumber( ComponentObjectGetValue( ability_comp, "gunaction_config", "fire_rate_wait" ) )
	local spread_degrees = tonumber( ComponentObjectGetValue( ability_comp, "gunaction_config", "spread_degrees" ) )
	local deck_capacity = tonumber( ComponentObjectGetValue( ability_comp, "gun_config", "deck_capacity" ) )
	local mana_max = ComponentGetValue2( ability_comp, "mana_max" )

	local total = reload_time + fire_rate_wait + spread_degrees

	-- print(total)
	-- print( reload_time + fire_rate_wait + spread_degrees )
	--[[
	ComponentObjectSetValue( ability_comp, "gun_config", "actions_per_round", gun["actions_per_round"] )
	ComponentObjectSetValue( ability_comp, "gun_config", "deck_capacity", gun["deck_capacity"] )
	ComponentObjectSetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", gun["shuffle_deck_when_empty"] )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "spread_degrees", gun["spread_degrees"] )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "speed_multiplier", gun["speed_multiplier"] )
	]]--

	total = total + Random( -10, 20 )

	local level_1_cards =
	{
		"LIGHT_BULLET",
		"RUBBER_BALL",
		"SPITTER",
		"BUBBLESHOT",
		"BOUNCY_ORB",
		"BULLET",
		"AIR_BULLET",
		"SLIMEBALL"
	}	

	local card_count = Random( 1, 7 ) 

	if ( Random( 1, 100 ) <= 80 ) then table.insert(level_1_cards, "POLLEN") end
	
	if ( Random( 1, 100 ) <= 80 ) then table.insert(level_1_cards, "DISC_BULLET") end

	if ( Random( 1, 100 ) <= 60 ) then
		table.insert(level_1_cards, "ARROW")
		card_count = Random( 2, 6 )
	end

	if ( Random( 1, 100 ) <= 60 ) then
		table.insert(level_1_cards, "HEAVY_BULLET")
		card_count = Random( 2, 6 )
	end

	if ( Random( 1, 100 ) <= 40 ) then
		table.insert(level_1_cards, "SLOW_BULLET")
		card_count = Random( 2, 6 )
	end

	if ( Random( 1, 100 ) <= 40 ) then
		table.insert(level_1_cards, "HOOK")
		card_count = Random( 2, 6 )
	end

	if ( Random( 1, 100 ) <= 20 ) then
		mana_max = math.max( 170, mana_max + 70 )
	end

	if ( total > 50 ) then

		level_1_cards = 
		{
			"GRENADE",
			"BOMB",
			"ROCKET",
			"DYNAMITE",
			"FIREBALL",
			"ACIDSHOT",
			"GLITTER_BOMB",
			"MINE"
		}
		
		card_count = 1
	end

	local do_util = Random( 0, 100 ) -- 49 / 101

	if ( do_util < 36 ) then

		level_1_cards = 
		{
			"HEAVY_SPREAD",
			"LUMINOUS_DRILL",
			"CHAINSAW"
		}

		if ( Random( 1, 100 ) <= 80 ) then table.insert(level_1_cards, "MATERIAL_CEMENT") end

		if ( Random( 1, 100 ) <= 80 ) then table.insert(level_1_cards, "DIGGER") end

		if ( Random( 1, 100 ) <= 80 ) then table.insert(level_1_cards, "POWERDIGGER") end

		if ( Random( 1, 100 ) <= 60 ) then table.insert(level_1_cards, "SEA_OIL") end

		if ( Random( 1, 100 ) <= 60 ) then table.insert(level_1_cards, "SEA_ACID_GAS") end

		if ( Random( 1, 100 ) <= 60 ) then table.insert(level_1_cards, "SEA_ALCOHOL") end

		if ( Random( 1, 100 ) <= 40 ) then table.insert(level_1_cards, "DE_GFUEL") end 
		
		if ( Random( 1, 100 ) <= 40 ) then table.insert(level_1_cards, "DE_CHARGE") end

		if ( Random( 1, 50 ) <= 40 ) then table.insert(level_1_cards, "DE_CAPE_PURIFY") end

		if ( Random( 1, 50 ) <= 40 ) then table.insert(level_1_cards, "DE_HAEMOSPASIA") end

		card_count = 1
	end

	if ( card_count > deck_capacity ) then card_count = deck_capacity end

	for i=1,card_count do
		local card = RandomFromArray( level_1_cards )
		
		AddGunAction( entity_id, card )
	end
end

do_level1( 1 )