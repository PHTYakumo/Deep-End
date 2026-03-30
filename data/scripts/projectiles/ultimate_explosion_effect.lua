dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local ultra = EntityGetInRadiusWithTag( x, y, 24, "ultra_light" )
ultra = math.max( #ultra - 1, 0 )

local amount = 16 - ultra
local length = -9
local speed = 75

if amount > 0 then
	local angle_inc = math.pi * 2 / amount
	local theta = ( entity_id - GameGetFrameNum() ) * 0.1

	for i=1,amount do
		local nx = x + math.cos( theta ) * length
		local ny = y + math.sin( theta ) * length

		shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/ultimate_explosion_effect.xml", nx, ny, math.sin( theta ) * speed, math.cos( theta ) * speed )
		
		theta = theta + angle_inc
		speed = speed + 30 * (-1)^i
	end
end

local enemies = EntityGetInRadiusWithTag( x, y, 18, "mortal" )

if #enemies > 0 then for i=1,#enemies do
	local eid = enemies[i]
	local dmg = 0.4 * ( ultra + 1 )

	if not EntityHasTag( eid, "player_unit" ) then
		EntityInflictDamage( eid, dmg, "NONE", "$ULTIMATE", "NONE", 0, 0, eid )
		EntityInflictDamage( eid, dmg, "DAMAGE_BITE", "$ULTIMATE", "NONE", 0, 0, eid )
		EntityInflictDamage( eid, dmg, "DAMAGE_MATERIAL", "$ULTIMATE", "NONE", 0, 0, eid )
		EntityInflictDamage( eid, dmg, "DAMAGE_FALL", "$ULTIMATE", "NONE", 0, 0, eid )
		EntityInflictDamage( eid, dmg, "DAMAGE_DROWNING", "$ULTIMATE", "NONE", 0, 0, eid )
		EntityInflictDamage( eid, dmg, "DAMAGE_PHYSICS_BODY_DAMAGED", "$ULTIMATE", "NONE", 0, 0, eid )
		EntityInflictDamage( eid, dmg, "DAMAGE_MATERIAL_WITH_FLASH", "$ULTIMATE", "NONE", 0, 0, eid )
		EntityInflictDamage( eid, dmg, "DAMAGE_HEALING", "$ULTIMATE", "NONE", 0, 0, eid )
	end
end end

GamePlaySound( "data/audio/Desktop/misc.bank", "misc/sun/supernova", x, y )
EntityKill( entity_id )