dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
entity_id = EntityGetRootEntity( entity_id )

if entity_id ~= NULL_ENTITY then
	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )

	if comps ~= nil then for i,v in ipairs( comps ) do
		ComponentSetValue2( v, "on_death_explode", false )
		ComponentSetValue2( v, "on_lifetime_out_explode", false )
		ComponentObjectSetValue2( v, "config_explosion", "audio_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "stains_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "sparks_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "hole_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "explosion_radius", 2 )
		ComponentObjectSetValue2( v, "config_explosion", "damage", 0 )
	end end
	
	comps = EntityGetComponent( entity_id, "ExplosionComponent" )

	if comps ~= nil then for i,v in ipairs( comps ) do
		ComponentObjectSetValue2( v, "config_explosion", "audio_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "stains_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "sparks_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "hole_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "explosion_radius", 2 )
		ComponentObjectSetValue2( v, "config_explosion", "damage", 0 )
		EntitySetComponentIsEnabled( entity_id, v, false )
	end end
	
	comps = EntityGetComponent( entity_id, "ExplodeOnDamageComponent" )

	if comps ~= nil then for i,v in ipairs( comps ) do
		ComponentObjectSetValue2( v, "config_explosion", "audio_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "stains_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "sparks_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "hole_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "explosion_radius", 2 )
		ComponentObjectSetValue2( v, "config_explosion", "damage", 0 )
		EntitySetComponentIsEnabled( entity_id, v, false )
	end end
end
