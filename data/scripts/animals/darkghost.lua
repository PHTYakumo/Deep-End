dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
SetRandomSeed( entity_id, GameGetFrameNum() )

if Random(1,10) % 3 == 1 then
	edit_all_components( entity_id, "SpriteComponent", function(comp,vars)
		ComponentSetValue( comp, "rect_animation",      "blink" )
		ComponentSetValue( comp, "next_rect_animation", "stand" )
	end )

	local pos_x, pos_y = EntityGetTransform( entity_id )
	local how_many, speed = 13, 100

	local angle = math.pi * 0.2 * Random(1,10)
	local angle_inc = math.pi * 2 / how_many

	for i=1,how_many do
		local vel_x = math.cos(angle) * ( speed + Random(1,10) * 10 )
		local vel_y = -math.sin(angle) * ( speed + Random(1,10) * 10 )

		local pid = shoot_projectile( entity_id, "data/entities/projectiles/darkflame_stationary.xml", pos_x, pos_y, vel_x, vel_y )
		local comps = EntityGetComponent( pid, "ProjectileComponent" )

		if comps ~= nil then for i,v in ipairs( comps ) do
			ComponentSetValue2( v, "dont_collide_with_tag", "enemy" )
			ComponentSetValue2( v, "penetrate_world", true )
		end end

		angle = angle + angle_inc
	end
end