dofile_once("data/scripts/lib/utilities.lua")

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local entity_id = GetUpdatedEntityID()
	-- GamePrint(tostring(entity_thats_responsible))

	local dmgmod = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	if damage < 0.2 or dmgmod == nil then return damage, critical_hit_chance end
	 
	local max_hp = math.max( ComponentGetValue2( dmgmod, "max_hp" ), 0.08 )
	local hp = ComponentGetValue2( dmgmod, "hp" ) 

	GlobalsSetValue( "DEEP_END_PLAYER_LAST_DAMAGED_FRAME", tostring(GameGetFrameNum()) )
	if hp < 0 then ComponentSetValue2( dmgmod, "hp", 0.1 ) end

	if damage > 4 then return math.min( damage, max_hp * 0.75 ), critical_hit_chance end
	if hp < max_hp * 0.8 then return damage * ( 0.4 + math.max( hp / max_hp * 0.75, 0 ) ), critical_hit_chance end
	
	return damage, critical_hit_chance
end
