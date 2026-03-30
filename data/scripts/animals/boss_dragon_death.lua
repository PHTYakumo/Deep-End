dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	-- kill self
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	-- do some kind of an effect? throw some particles into the air?
	EntityLoad( "data/entities/items/pickup/heart_evil.xml", pos_x - 16, pos_y )
	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml", pos_x + 16, pos_y )

	local ability_comp = EntityGetFirstComponentIncludingDisabled( EntityLoad( "data/entities/items/wand_level_10.xml", pos_x, pos_y ), "AbilityComponent" )
	if ability_comp ~= nil then ComponentObjectSetValue2( ability_comp, "gun_config", "shuffle_deck_when_empty", false ) end
	
	AddFlagPersistent( "miniboss_dragon" )
	AddFlagPersistent( "card_unlocked_dragon" )
	
	SetRandomSeed( check_parallel_pos( pos_x ), 540 )
	local flag_status = HasFlagPersistent( "card_unlocked_dragon" )
	
	local opts = { "SPELLS_TO_POWER", "DAMAGE_FOREVER", "HEAVY_SHOT", "LIGHT_SHOT", "ZERO_DAMAGE", "EXPLOSIVE_PROJECTILE" }
	local count = 6
	
	for i=1,count do
		local rnd = Random( 1, #opts )
		CreateItemActionEntity( opts[rnd], pos_x - 8 * count + (i-0.5) * 16, pos_y )
		table.remove( opts, rnd )
	end
	
	--StatsLogPlayerKill( entity_id )
	--EntityKill( entity_id )
end