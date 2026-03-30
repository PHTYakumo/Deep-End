dofile_once("data/scripts/lib/utilities.lua")

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local entity_id = GetUpdatedEntityID()
	if damage < 1 then return damage, critical_hit_chance end
	
	local dmgmod = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	if dmgmod == nil then return damage, critical_hit_chance end
	
	local max_hp = ComponentGetValue2( dmgmod, "max_hp" )
	max_hp = math.max( max_hp, 1 )

	local dmgf = ComponentGetValue2( dmgmod, "mLastDamageFrame" )
	dmgf = clamp( GameGetFrameNum() - dmgf - 1, 0.01, 10 )

	local dmg = math.min( damage, max_hp )
	dmg = dmg * dmgf * 0.1
	
	return dmg, math.min( critical_hit_chance, 100 )
end
