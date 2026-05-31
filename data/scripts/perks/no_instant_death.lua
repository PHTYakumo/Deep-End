dofile_once("data/scripts/lib/utilities.lua")

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local entity_id = GetUpdatedEntityID()
	local dmgmod = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	if damage < 0.2 or dmgmod == nil then return damage, critical_hit_chance end
	
	local hp = ComponentGetValue2( dmgmod, "hp" ) 
	if hp < 0 then ComponentSetValue2( dmgmod, "hp", 0.2 ) end
	if hp < 1 then return damage * 0.4, critical_hit_chance end

	local max_hp = math.max( ComponentGetValue2( dmgmod, "max_hp" ), 0.8 )
	if damage > max_hp * 5 + 10 then return damage * 0.1, critical_hit_chance end
	if hp < max_hp * 0.8 then return damage * ( 0.4 + math.max( hp / max_hp * 0.75, 0 ) ), critical_hit_chance end
	
	return damage, critical_hit_chance
end
