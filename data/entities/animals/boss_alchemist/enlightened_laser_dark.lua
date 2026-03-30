dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/gun.lua")
local speed = 20

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y, rot = EntityGetTransform( entity_id )

-- velocity
local vel_x,vel_y = GameGetVelocityCompVelocity(entity_id)
vel_x, vel_y = vec_normalize(vel_x, vel_y)
if vel_x == nil then return end
vel_x = vel_x * speed
vel_y = vel_y * speed

local count = 3
local angle = math.pi * 0.1

for i=1,count do
	local px = pos_x + vel_x * 2
	local py = pos_y + vel_y * 2
    local vx = math.cos( angle*(i-2) ) * vel_x - math.sin( angle*(i-2) ) * vel_y 
    local vy = math.sin( angle*(i-2) ) * vel_x + math.cos( angle*(i-2) ) * vel_y
	shoot_projectile_from_projectile( entity_id, "data/entities/animals/boss_alchemist/meteor.xml", px, py, vx, vy )
end

-- sound is played here instead of the projectiles to avoid duplicates
GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/enlightened_laser/launch_dark", pos_x, pos_y )

