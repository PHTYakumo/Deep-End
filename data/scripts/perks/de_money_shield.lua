dofile_once("data/scripts/lib/utilities.lua")

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local entity_id = GetUpdatedEntityID()
	local wcomp = EntityGetFirstComponent( entity_id, "WalletComponent" )

	if damage <= 0 or wcomp == nil then return damage, critical_hit_chance end
	local money = ComponentGetValue2( wcomp, "money" ) 

	local shield_convent = 0.004
	local shield_energy = money * shield_convent

	local audio_path = { "data/audio/Desktop/animals.bank", "animals/spearbot/damage/physics_hit", "animals/robot/damage/projectile" }
	local rmoney, rdamage = money, rdamage
	
	if damage > shield_energy then
		if shield_energy >= 0.01 then for i=1,2 do GamePlaySound( audio_path[1], audio_path[2], x, y ) end end
		rmoney, rdamage = 0, math.max( damage - shield_energy, 0 )
	else
		if shield_energy >= 0.01 then for i=1,2 do GamePlaySound( audio_path[1], audio_path[3], x, y ) end end
		rmoney, rdamage = math.max( money - damage / shield_convent, 0 ), 0
	end
	
	ComponentSetValue2( wcomp, "money", rmoney )
	return rdamage, critical_hit_chance
end
