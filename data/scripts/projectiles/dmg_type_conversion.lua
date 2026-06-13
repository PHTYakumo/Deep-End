dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

local function dmg_type_convent( type_1, type_2, comp )
	local dmg_1 = ComponentObjectGetValue2( comp, "damage_by_type", type_1 )
	local dmg_2 = ComponentObjectGetValue2( comp, "damage_by_type", type_2 )

	if dmg_1 <= dmg_2 then
		ComponentObjectSetValue2( comp, "damage_by_type", type_1, dmg_1 + math.max( dmg_2, 0 ) )
		ComponentObjectSetValue2( comp, "damage_by_type", type_2, 0 )
	else
		ComponentObjectSetValue2( comp, "damage_by_type", type_1, 0 )
		ComponentObjectSetValue2( comp, "damage_by_type", type_2, math.max( dmg_1, 0 ) + dmg_2 )
	end

	-- GamePrint( type_1 .. " = " .. tostring(dmg_1) .. ", " .. type_2 .. " = " .. tostring(dmg_2) )
end

if comp ~= nil then
	local proj = ComponentGetValue2( comp, "damage" )
	local healing = ComponentObjectGetValue2( comp, "damage_by_type", "healing" )

	if proj <= healing then
		ComponentSetValue2( comp, "damage", math.max( proj, 0 ) - healing )
		ComponentObjectSetValue2( comp, "damage_by_type", "healing", 0 )
	else
		ComponentSetValue2( comp, "damage", 0 )
		ComponentObjectSetValue2( comp, "damage_by_type", "healing", - math.max( proj, 0 ) + healing )
	end

	-- GamePrint( "damage = " .. tostring(proj) .. ", healing = " .. tostring(healing) )

	dmg_type_convent( "melee", "electricity", comp )
	dmg_type_convent( "drill", "slice", comp )
	dmg_type_convent( "fire", "ice", comp )
	dmg_type_convent( "radioactive", "poison", comp )
	dmg_type_convent( "curse", "holy", comp )
	dmg_type_convent( "physics_hit", "overeating", comp )

	local exp = ComponentObjectGetValue2( comp, "config_explosion", "damage" ) or 1
	local crit = ComponentObjectGetValue2( comp, "damage_critical", "chance" ) or 0

	ComponentObjectSetValue2( comp, "config_explosion", "damage", exp * math.max( 1 + crit * 0.01, 0 ) )

	-- GamePrint( "explosion = " .. tostring(exp) .. ", critical = " .. tostring(crit) )
end