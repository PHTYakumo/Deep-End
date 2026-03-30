dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/items/chest_random.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	local name = EntityGetName(entity_id)
	local seed_offset = 0
	local pw = check_parallel_pos( pos_x )
	
	if ( name == "$animal_gate_monster_b" ) then
		seed_offset = 1
	elseif ( name == "$animal_gate_monster_c" ) then
		seed_offset = 2
	elseif ( name == "$animal_gate_monster_d" ) then
		seed_offset = 3
	end
	
	for i=1,6 do
		SetRandomSeed( GameGetFrameNum() + seed_offset, ( entity_id + pw ) * i )
	
		make_random_card( pos_x + Random(-16,16), pos_y + Random(-16,16) )
	end

	GamePrint( "$defeat_gate_monster" )

	-- set flag with name of monster. 
	GameAddFlagRun(EntityGetName(entity_id) .. "_killed")

	-- if all 4 monsters killed, add persistent flag for treetop pillar
	if GameHasFlagRun("$animal_gate_monster_a_killed")
	and GameHasFlagRun("$animal_gate_monster_b_killed")
	and GameHasFlagRun("$animal_gate_monster_c_killed")
	and GameHasFlagRun("$animal_gate_monster_d_killed") then
		AddFlagPersistent( "miniboss_gate_monsters" )
	end
end