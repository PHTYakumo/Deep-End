dofile_once("data/scripts/lib/utilities.lua")

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance ) -- except holy_dmg
	local entity_id = GetUpdatedEntityID()
	if damage < 0.2 then return damage, critical_hit_chance end
	
	local dmgmod = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	if dmgmod == nil then return damage, critical_hit_chance end
	
	local hp = math.max( ComponentGetValue2( dmgmod, "hp" ), 0.2 )
	if hp < 1 then return damage * 0.4, critical_hit_chance end

	local max_hp = math.max( ComponentGetValue2( dmgmod, "max_hp" ), 0.8 )
	if damage > max_hp * 10 + 0.25 then return damage * 0.5, critical_hit_chance end

	if hp < max_hp * 0.8 then
		-- GamePrint( "$dAbyss_0" )
		local extra_resistance = 0.4 + math.max( hp / max_hp * 0.75, 0 )
		
		return damage * extra_resistance, critical_hit_chance
	end
	
	return damage, critical_hit_chance
end
