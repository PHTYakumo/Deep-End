dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	if EntityHasTag( entity_id, "holy_mountain_creature" ) or EntityHasTag( entity_id, "robot" ) then return end

	local pos_x, pos_y = EntityGetTransform( entity_id )
	SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

	local srnd = Random( 1, 13 )
	local spells = { "FREEZE", "ELECTRIC_CHARGE", "BURN_TRAIL", "DE_PUTREFY", "DE_METALLIZATION", "CRITICAL_HIT" }

	if srnd <= #spells then
		CreateItemActionEntity( spells[srnd], pos_x, pos_y )
	end
	--EntityKill( entity_id )
end