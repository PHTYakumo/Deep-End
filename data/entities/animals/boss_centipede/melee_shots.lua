dofile( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local boss_id = EntityGetClosestWithTag( x, y, "boss")
if boss_id == nil then return end

local orbcount = GameGetOrbCountThisRun()
local branches = clamp( 18 + 6 * orbcount, 12, 54 )

local opts = { "orb_dark_tiny", "orb_homing", "orb_neutral", "orb_tele", "orb_twitchy", "orb_wither" }
SetRandomSeed( GameGetFrameNum(), entity_id )

for i=1,branches do
	local rnd = Random( 1, #opts )
	local arc = math.pi * Random( 0, 100 ) * 0.02

	local vx = math.cos( arc ) * 150
	local vy = math.sin( arc ) * 150
	
	local pid = shoot_projectile( boss_id, "data/entities/projectiles/" .. opts[rnd] .. ".xml", x, y, vx, vy )
	if not EntityHasTag( pid, "projectile_centipede" ) then EntityAddTag( pid, "projectile_centipede" ) end

	local comp = EntityGetFirstComponent( pid, "ProjectileComponent" )
	if comp ~= nil then ComponentSetValue2( comp, "collide_with_tag", "player_unit" ) end
end

