dofile_once("data/scripts/lib/utilities.lua")

local entity_id, shooter = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local pcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "ProjectileComponent" )
if pcomp == nil then return end
	
local exp_rad = ComponentObjectGetValue2( pcomp, "config_explosion", "explosion_radius" ) or 10
local proj_dmg = ComponentGetValue2( pcomp, "damage" ) or 0

exp_rad = math.max( exp_rad, 10 )
proj_dmg = math.max( proj_dmg, 0 )

local shooter = ComponentGetValue2( pcomp, "mWhoShot" ) or entity_id
local enemies = EntityGetInRadiusWithTag( x, y, exp_rad + 10, "hittable" )

if enemies ~= nil and proj_dmg > 0 then
	proj_dmg = proj_dmg / ( #enemies * 0.5 + 1 ) -- 2x/(x+2)

	for i,pid in ipairs( enemies ) do if pid ~= shooter and EntityGetFirstComponent( pid, "DamageModelComponent" ) ~= nil then
		EntityInflictDamage( pid, proj_dmg, "DAMAGE_PROJECTILE", "$dSPLASH", "BLOOD_SPRAY", 0, 0, shooter )
	end end

	GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/bullet_rubber_ball/bounce", x + exp_rad, y )
	GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/bullet_rubber_ball/bounce", x - exp_rad, y )
	GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/bullet_rubber_ball/bounce", x, y + exp_rad )
	GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/bullet_rubber_ball/bounce", x, y - exp_rad )
end
