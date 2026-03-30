dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/gun.lua")
local speed = 400

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y, rot = EntityGetTransform( entity_id )

-- velocity
local vel_x,vel_y = GameGetVelocityCompVelocity(entity_id)
vel_x, vel_y = vec_normalize(vel_x, vel_y)
if vel_x == nil then return end
vel_x = vel_x * speed
vel_y = vel_y * speed

local count = 3

SetRandomSeed( pos_x * vel_x, pos_y * vel_y )

for i=1,count do
	local px = pos_x + vel_x * 0.1
	local py = pos_y + vel_y * 0.1
	shoot_projectile_from_projectile( entity_id, "data/entities/animals/boss_alchemist/propane_tank.xml", px + Random( -16, 16 ), py + Random( -16, 16 ), vel_x, vel_y )
end

-- sound is played here instead of the projectiles to avoid duplicates
GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/enlightened_laser/launch_fire", pos_x, pos_y )

