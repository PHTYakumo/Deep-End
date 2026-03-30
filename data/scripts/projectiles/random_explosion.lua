dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()

local projectilecomponents = EntityGetComponent( entity_id, "ProjectileComponent" )

local opts = 
	{
		"acidshot","acidburst","black_hole_big","white_hole_big",
		"cloud_thunder","cloud_acid","cloud_blood","cloud_water","cloud_oil",
		"death_cross","death_cross_big","death_cross_big_explosion","glitter_bomb_explosion","thunder_blast",
		"disc_bullet","disc_bullet_big","disc_bullet_bigger","nuke","nuke_giga",
		"duck","ball_lightning","fireball_ray_small","grenade_small","rocket_downwards",
		"worm_shot","orb_laseremitter_weak","orb_laseremitter_weak_opposite","regeneration_field","xray"
	}

SetRandomSeed( entity_id + 2533, entity_id - 36 )
local rnd = Random( 1, #opts )

local result = "data/entities/projectiles/deck/" .. opts[rnd] .. ".xml"

if ( projectilecomponents ~= nil ) then
	for i,comp_id in ipairs( projectilecomponents ) do	
		ComponentSetValue2( comp_id, "on_collision_spawn_entity", true )
		ComponentSetValue2( comp_id, "spawn_entity_is_projectile", true )
		
		ComponentSetValue2( comp_id, "spawn_entity", result )
	end
end