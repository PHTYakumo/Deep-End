dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local vel_x, vel_y = 0,0

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)

local types = {"pink","green","blue","orange"}

SetRandomSeed( GameGetFrameNum(), pos_x )
local rnd_1 = Random(1, #types)

SetRandomSeed( pos_y, GameGetFrameNum() )
local rnd_2 = Random(1, #types)

local year, month, day = GameGetDateAndTimeLocal()
local firework_name = "firework_"

if ( month == 1 and day == 1 ) or ( month == 1 and day >= 21 ) or ( month == 2 and day <= 28 ) or ( Random(1, 7) > 5 ) then
	firework_name = "new_year/" .. firework_name
else
	firework_name = "fireworks/" .. firework_name
end

if ( vel_x ~= 0 ) or ( vel_y ~= 0 ) then
	local angle = 0 - math.atan2( vel_y, vel_x )
	local length = 60

	local angle_up = angle + 3.1415 * 0.5
	local angle_down = angle - 3.1415 * 0.5
	
	vel_x = math.cos( angle_up ) * length
	vel_y = 0 - math.sin( angle_up ) * length

	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/" .. firework_name .. tostring(types[rnd_1]) .. ".xml", pos_x, pos_y, vel_x, vel_y )
	
	vel_x = math.cos( angle_down ) * length
	vel_y = 0 - math.sin( angle_down ) * length

	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/" .. firework_name .. tostring(types[rnd_2]) .. ".xml", pos_x, pos_y, vel_x, vel_y )
end