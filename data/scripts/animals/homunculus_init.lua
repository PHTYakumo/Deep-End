dofile_once("data/scripts/lib/utilities.lua")


local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local types =
{
	{
		name="laser",
		AnimalAIComponent =
		{
			attack_ranged_entity_file="data/entities/projectiles/deck/laser.xml",
			attack_ranged_frames_between=65,
			attack_ranged_max_distance=160,
		},
		SpriteComponent =
		{
			image_file="data/enemies_gfx/homunculus_laser.xml",
		},
	},
	{
		name="slow",
		AnimalAIComponent =
		{
			attack_ranged_entity_file="data/entities/projectiles/deck/bullet_heavy.xml",
			attack_ranged_frames_between=60,
			attack_ranged_max_distance=180,
		},
		SpriteComponent =
		{
			image_file="data/enemies_gfx/homunculus_dark.xml",
		},
	},
	{
		name="spitter",
		AnimalAIComponent =
		{
			attack_ranged_entity_file="data/entities/projectiles/deck/spitter_tier_2.xml",
			attack_ranged_frames_between=55,
			attack_ranged_max_distance=150,
		},
		SpriteComponent =
		{
			image_file="data/enemies_gfx/homunculus_heal.xml",
		},
	},
	{
		name="arrow",
		AnimalAIComponent =
		{
			attack_ranged_entity_file="data/entities/projectiles/deck/bullet.xml",
			attack_ranged_frames_between=50,
			attack_ranged_max_distance=200,
		},
		SpriteComponent =
		{
			image_file="data/enemies_gfx/homunculus.xml",
		},
	},
	{
		name="fireball",
		AnimalAIComponent =
		{
			attack_ranged_entity_file="data/entities/projectiles/deck/slime.xml",
			attack_ranged_frames_between=45,
			attack_ranged_max_distance=200,
		},
		SpriteComponent =
		{
			image_file="data/enemies_gfx/homunculus_fire.xml",
		},
	},
}

SetRandomSeed( x + entity_id, y - entity_id )

local data = types[Random(1,#types)]
local max_hp = clamp( math.abs(y) * 0.001, 1, 1000 )

edit_component( entity_id, "DamageModelComponent", function(comp,vars)
	ComponentSetValue2( comp, "max_hp", max_hp )
	ComponentSetValue2( comp, "hp", max_hp )
end ) 

for i,v in pairs(data) do if type( v ) == "table" then
	edit_component( entity_id, i, function(comp,vars)
		for a,b in pairs( v ) do ComponentSetValue2( comp, a, b ) end
	end )
end end

if not EntityHasTag( entity_id, "forgeable" ) then EntityAddTag( entity_id, "forgeable" ) end
if EntityHasTag( entity_id, "homing_target" ) then EntityRemoveTag( entity_id, "homing_target" ) end
if EntityHasTag( entity_id, "enemy" ) then EntityRemoveTag( entity_id, "enemy" ) end