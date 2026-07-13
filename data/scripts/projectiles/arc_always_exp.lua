dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

function set_expcfg( pcomp0, pcomp1, cfg )
	local cfg_data = ComponentObjectGetValue2( pcomp0, "config_explosion", cfg )
	if ( type( cfg_data ) == "string" or type( cfg_data ) == "table" ) and #cfg_data == 0 then return end

	if cfg_data ~= nil then
		if cfg ~= "physics_explosion_power" then ComponentObjectSetValue2( pcomp1, "config_explosion", cfg, cfg_data )
		else ComponentObjectSetValue2( pcomp1, "config_explosion", cfg, cfg_data, cfg_data ) end
	end
end

local enemies = EntityGetInRadiusWithTag( x, y, 20, "hittable" )
if enemies[1] == nil then return end

-- local success = RaytracePlatforms( x - 1, y, x + 1, y )
-- if success then return end

local cfg_list = 
{
	"never_cache",
	"camera_shake", 
	"damage",
	"explosion_radius", 
	"explosion_sprite",
	"load_this_entity",
	"explosion_sprite_lifetime", 
	"explosion_sprite_random_rotation",
	"create_cell_probability", 
	"create_cell_material",
	"hole_destroy_liquid",
	"hole_enabled",
	"particle_effect",
	"light_fade_time",
	"light_r",
	"light_g",
    "light_b",
	"sparks_count_min",
	"sparks_count_max",
    "spark_material",
    "sparks_enabled",
    "audio_event_name",
	"audio_enabled",
	"ray_energy",
	"physics_explosion_power", 
	"physics_throw_enabled", 
	"damage_mortals"
	-- "shake_vegetation",
	-- "stains_enabled",
    -- "stains_radius",
}

if entity_id ~= nil and entity_id ~= NULL_ENTITY then
	local pcomp0 = EntityGetFirstComponentIncludingDisabled( entity_id, "LightningComponent" )
	local exp_rad = ComponentObjectGetValue2( pcomp0, "config_explosion", "explosion_radius" )

	if exp_rad ~= nil and exp_rad > 4 then
		local exp_id = EntityLoad( "data/entities/projectiles/blasting_chain_reaction_explosion.xml", x, y )
		local pcomp1 = EntityGetFirstComponentIncludingDisabled( exp_id, "ProjectileComponent" )
		
		if pcomp1 == nil then return end
		for i=1,#cfg_list do set_expcfg( pcomp0, pcomp1, cfg_list[i] ) end
	end
end