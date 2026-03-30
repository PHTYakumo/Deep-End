dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local opts = { "orb_dark_tiny", "orb_poly", "orb_tele", "orb_twitchy" }
SetRandomSeed( GameGetFrameNum() - y, x )

for i=1,4 do
	local rnd = Random( 1, #opts )
	local arc = Random( 0, 100 ) * 0.01 * math.pi * 2

	local vx = math.cos( arc ) * 250
	local vy = -math.sin( arc ) * 250
	
	shoot_projectile_from_projectile( entity_id, "data/entities/animals/boss_wizard/lance.xml", x, y, vy, -vx )
	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/" .. opts[rnd] .. ".xml", x, y, vx, vy )
end