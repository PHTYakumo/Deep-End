dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	local flag_status = HasFlagPersistent( "card_unlocked_rain" )

	EntityLoad( "data/entities/animals/boss_centipede/clear_materials.xml", x, y )

	if EntityHasTag( entity_id, "holy_mountain_creature" ) then return end
	
	SetRandomSeed( x + GameGetFrameNum(), x + entity_id )
	
	local rnd = Random( -13, 13 )
	rnd = Random( -13, 13 + rnd )

	if ( rnd ~= 13 ) then
		local key = EntityGetInRadiusWithTag( x, y, 256, "alchemist_key" )

		if ( #key == 0 ) then
			rnd = Random( -37, 37 )
			if ( rnd == 0 ) then rnd = Random( 1, 37 ) end

			EntityLoad( "data/entities/items/wand_level_100.xml",  x + rnd, y - rnd )
			EntityLoad( "data/entities/animals/boss_pit/boss_pit.xml", x - rnd, y + rnd )
			-- perk_spawn_random( x, y, true )
			GamePrint( "$defeat_boss_pit_0" ) 

			rnd = 0
		else
			rnd = 13
		end
	end

	if ( rnd == 13 ) then -- 1/60
		CreateItemActionEntity( "DE_UAV", x, y-8 )
		CreateItemActionEntity( "WORM_RAIN", x-16, y )
		CreateItemActionEntity( "DE_TELEPORT_PROJECTILE_V2", x+16, y )
		CreateItemActionEntity( "REGENERATION_FIELD", x, y+8 )
	end
	
	AddFlagPersistent( "card_unlocked_rain" )
	AddFlagPersistent( "miniboss_pit" )
end