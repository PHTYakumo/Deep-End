dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local exp_rad, exp_dmg = 20, 0.6

local comps = EntityGetComponent( entity_id, "ProjectileComponent" )

if comps ~= nil then for i,v in ipairs( comps ) do
	ComponentSetValue2( v, "on_death_explode", false )
	ComponentSetValue2( v, "on_lifetime_out_explode", false )

	exp_rad = ComponentObjectGetValue2( v, "config_explosion", "explosion_radius" ) or 20
	exp_dmg = ComponentObjectGetValue2( v, "config_explosion", "damage" ) or 0.6
	
	ComponentObjectSetValue2( v, "config_explosion", "explosion_radius", 2 )
	ComponentObjectSetValue2( v, "config_explosion", "damage", 0 )
end end

comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

if comps ~= nil then for i,comp in ipairs( comps ) do
	if ComponentGetValue2( comp, "name" ) == "exp_data" then
		ComponentSetValue2( comp, "value_int", clamp( exp_rad, 10, 40 ) )
		ComponentSetValue2( comp, "value_float", clamp( exp_dmg, 0, 2500000 ) )
	end
end end