dofile_once("data/scripts/lib/utilities.lua")

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local entity_id = GetUpdatedEntityID()
	local root_id = EntityGetRootEntity( entity_id )
	if root_id == entity_thats_responsible then return damage, critical_hit_chance end
	
	local dmgmod = EntityGetFirstComponent( root_id, "DamageModelComponent" )
	if dmgmod == nil then return damage, critical_hit_chance end

	local is_aggro = get_variable_storage_component( root_id, "aggro" ) ~= nil
	if damage < 0 and is_aggro then return math.abs( damage ), 0
	elseif damage < 0 then return damage, 0 end

	if damage < 0.0001 then return damage, critical_hit_chance end
	
	local max_hp = ComponentGetValue2( dmgmod, "max_hp" )
	local hp = ComponentGetValue2( dmgmod, "hp" )

	local rdmg = damage * ( 1 + critical_hit_chance * 0.05 )
	max_hp, hp = math.max( max_hp, 1 ), math.max( hp, 0.01 )

	if EntityHasTag( root_id, "sampo_or_boss" ) then
		local vsc, sp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "perk_component" ), 0
		if ComponentGetValue2( vsc, "name" ) == "shield_protection" then sp = ComponentGetValue2( vsc, "value_int" ) end

		if rdmg >= max_hp * 0.01 and sp > 0 then
			max_hp = math.max( max_hp * ( 1 - 0.01 * math.max( rdmg, 1 ) ), hp )
			ComponentSetValue2( dmgmod, "max_hp", max_hp )

			ComponentSetValue2( vsc, "value_int", sp - 1 ) -- GamePrint( "sp: " .. tostring(sp) )
			return damage * 0.1, math.log( math.max( critical_hit_chance, 1 ) )
		end
	else
		if hp - rdmg <= max_hp * 0.75 then
			max_hp = math.max( max_hp - rdmg * 0.25, hp )
			ComponentSetValue2( dmgmod, "max_hp", max_hp ) -- GamePrint( "max_hp: " .. tostring(max_hp) )

			return damage * 0.5, critical_hit_chance
		end
	end

	-- GamePrint( "hp: " .. tostring(hp) )
	return damage, critical_hit_chance
end
