dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
entity_id = EntityGetRootEntity( entity_id )

if entity_id ~= NULL_ENTITY then
	local exp_radius = 5

	edit_component( entity_id, "ProjectileComponent", function(comp,vars)
		exp_radius = clamp( ComponentObjectGetValue2( comp, "config_explosion", "explosion_radius" ) * 0.25, 5, 25 )
		ComponentObjectSetValue2( comp, "config_explosion", "explosion_radius", math.floor(exp_radius) )
	end )
	
	local comps = EntityGetComponent( entity_id, "ExplosionComponent" )

	if comps ~= nil then for i,v in ipairs( comps ) do
			exp_radius = clamp( ComponentObjectGetValue2( v, "config_explosion", "explosion_radius" ) * 0.25, 5, 25 )
			ComponentObjectSetValue2( v, "config_explosion", "explosion_radius", math.floor(exp_radius) )
	end end
	
	comps = EntityGetComponent( entity_id, "ExplodeOnDamageComponent" )

	if comps ~= nil then for i,v in ipairs( comps ) do
			exp_radius = clamp( ComponentObjectGetValue2( v, "config_explosion", "explosion_radius" ) * 0.25, 5, 25 )
			ComponentObjectSetValue2( v, "config_explosion", "explosion_radius", math.floor(exp_radius) )
	end end
end
