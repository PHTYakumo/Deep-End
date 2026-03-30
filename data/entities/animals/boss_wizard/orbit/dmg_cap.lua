dofile_once("data/scripts/lib/utilities.lua")

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local entity_id = GetUpdatedEntityID()
	if damage < 1 and not EntityHasTag( entity_id, "holy_mountain_creature" ) then return damage, critical_hit_chance end
	
	local dmgmod = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	if dmgmod == nil then return damage, critical_hit_chance end
	
	local max_hp = ComponentGetValue2( dmgmod, "max_hp" )
	max_hp = math.max( max_hp, 4 )

	if EntityHasTag( entity_id, "holy_mountain_creature" ) and not EntityHasTag( entity_id, "do_not_homing_this" ) then return math.max( damage * 0.1 - max_hp, 0.04 ), 0 end
	if EntityHasTag( entity_id, "destruction_target" ) then return math.min( damage * 0.1, max_hp * 0.4 ), 0 end

	if damage > 4000000000 then return damage, 0 end
	if damage > max_hp * 0.01 then return max_hp * 0.01, 0 end

	return damage, 0
end
