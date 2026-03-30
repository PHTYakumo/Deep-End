dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	SetRandomSeed( GameGetFrameNum(), pos_x, pos_y + entity_id )
	local perk_rnd = Random( 1, 5 )

	if ( perk_rnd < 5 ) then
		perk_spawn( pos_x, pos_y, "LEGGY_FEET", true )	
	else
		perk_spawn_random( pos_x, pos_y, true )
	end
end