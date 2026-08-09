dofile_once("data/scripts/lib/utilities.lua")

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local new_damage = clamp( critical_hit_chance * 0.01 * 0.25, 0, 9 )
	-- GamePrint( tostring( new_damage ) )

	new_damage = damage * ( new_damage + 1 )
	return new_damage, critical_hit_chance
end
