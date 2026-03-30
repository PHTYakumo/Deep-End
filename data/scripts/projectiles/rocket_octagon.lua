dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local shooter, vel_x, vel_y = entity_id, 0, 0

local comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
if comp ~= nil then vel_x, vel_y = ComponentGetValueVector2( comp, "mVelocity" ) end

local comp2 = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if comp2 ~= nil then shooter = ComponentGetValue2( comp2, "mWhoShot" ) end

if shooter ~= nil and shooter ~= NULL_ENTITY then
	local speed = math.sqrt( vel_y ^ 2 + vel_x ^ 2 )

	if speed < 50 then
		local how_many = 8
		local angle = 0
		local angle_inc = (math.pi * 2) / how_many

		for i=1,how_many do
			local shot_vel_x = math.cos(angle) * 150
			local shot_vel_y = 0 - math.sin(angle) * 150

			shoot_projectile( shooter, "data/entities/projectiles/deck/rocket_downwards.xml", pos_x + shot_vel_x * 0.05, pos_y + shot_vel_y * 0.05, shot_vel_x, shot_vel_y, false )
			angle = angle + angle_inc
		end
		
		EntityKill( entity_id )
	end
end