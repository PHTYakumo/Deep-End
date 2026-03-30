dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local amount = 18
local length = 11
local speed = 36
local angle_inc = math.pi * 2 / amount
local theta = math.rad(6) - GameGetFrameNum() / 10.0

for i=1,amount do
	local new_x = pos_x + math.cos( theta ) * length
	local new_y = pos_y + math.sin( theta ) * length

	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/new_year/ultimate_explosion_effect_new_year.xml", new_x, new_y, math.sin( theta )*speed, math.cos( theta )*speed )
	
	theta = theta + angle_inc
end

EntityKill( entity_id )