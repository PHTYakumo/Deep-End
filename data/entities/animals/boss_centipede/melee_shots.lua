dofile( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local boss_id = EntityGetClosestWithTag( x, y, "boss")
if boss_id == nil then return end

local opts = { "orb_dark_tiny", "orb_homing", "orb_neutral", "orb_tele", "orb_twitchy", "orb_wither" }
SetRandomSeed( GameGetFrameNum(), entity_id )

for i=1,#opts do
	local arc = math.pi * 2 * i / #opts + Random( 0, 100 ) * 0.01
	local vrnd = Random( 0, 100 ) * 0.5 + 10

	local vx = math.cos( arc ) * vrnd
	local vy = math.sin( arc ) * vrnd
	
	local pid = shoot_projectile( boss_id, "data/entities/projectiles/" .. opts[i] .. ".xml", x, y, vx, vy )
	if not EntityHasTag( pid, "projectile_centipede" ) then EntityAddTag( pid, "projectile_centipede" ) end

	local comp = EntityGetFirstComponent( pid, "ProjectileComponent" )
	if comp ~= nil then ComponentSetValue2( comp, "dont_collide_with_tag", "boss_centipede_minion" ) end
end

