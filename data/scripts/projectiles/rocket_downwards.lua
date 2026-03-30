dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local shooter, vel_x, vel_y = entity_id, 0, 0

local comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
if comp ~= nil then vel_x, vel_y = ComponentGetValueVector2( comp, "mVelocity" ) end

local comp2 = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if comp2 ~= nil then shooter = ComponentGetValue2( comp2, "mWhoShot" ) end

if shooter ~= nil and shooter ~= NULL_ENTITY and vel_y > 10 then
	local how_many = 5
	local velocities = {{-100,100},{-50,140},{0,160},{50,140},{100,100}}

	for _,values in ipairs(velocities) do
		local shot_vel_x = values[1]
		local shot_vel_y = values[2]

		shoot_projectile( shooter, "data/entities/projectiles/deck/rocket_downwards.xml", pos_x + shot_vel_x * 0.05, pos_y + shot_vel_y * 0.05, shot_vel_x, shot_vel_y, false )
	end
	
	EntityKill( entity_id )
end