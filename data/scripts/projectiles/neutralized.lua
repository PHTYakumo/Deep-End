dofile_once("data/scripts/lib/utilities.lua")

function shot( projectile_id )
	if EntityHasTag( EntityGetRootEntity( GetUpdatedEntityID() ), "boss" ) or projectile_id == NULL_ENTITY then return end
	local px, py = EntityGetTransform( projectile_id )
	
	EntityLoad("data/entities/particles/neutralized.xml", px, py)
	EntityKill( projectile_id )

	local comps = EntityGetComponent( projectile_id, "ProjectileComponent" )

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
	
	comps = EntityGetComponent( projectile_id, "ExplosionComponent" )

	if comps ~= nil then for i,v in ipairs( comps ) do
		ComponentObjectSetValue2( v, "config_explosion", "audio_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "stains_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "sparks_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "hole_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "explosion_radius", 2 )
		ComponentObjectSetValue2( v, "config_explosion", "damage", 0 )
		EntitySetComponentIsEnabled( projectile_id, v, false )
	end end
	
	comps = EntityGetComponent( projectile_id, "ExplodeOnDamageComponent" )

	if comps ~= nil then for i,v in ipairs( comps ) do
		ComponentObjectSetValue2( v, "config_explosion", "audio_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "stains_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "sparks_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "hole_enabled", false )
		ComponentObjectSetValue2( v, "config_explosion", "explosion_radius", 2 )
		ComponentObjectSetValue2( v, "config_explosion", "damage", 0 )
		EntitySetComponentIsEnabled( projectile_id, v, false )
	end end
end