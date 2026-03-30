dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local shooter,vx,vy,angle,speed
local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

if ( pcomp ~= nil ) then
	shooter = ComponentGetValue2( pcomp, "mWhoShot" )
end

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	vx,vy = ComponentGetValueVector2( comp, "mVelocity" )
	angle = math.atan2( vy, vx )
	speed = ( vy^2 + vx^2 )^0.5

	if speed < 900 then
		vx = vx * 900 / speed
		vy = vy * 900 / speed
	end
end)

local offset = 120

if ( speed > 10 ) and ( shooter ~= nil ) and ( shooter ~= NULL_ENTITY ) then
	local tx,ty = vec_rotate( vx, vy, math.pi * 0.2 )
	local sx = x - math.cos( angle + math.pi * 0.2 ) * offset - math.cos( angle ) * offset * 0.1
	local sy = y - math.sin( angle + math.pi * 0.2 ) * offset - math.sin( angle ) * offset * 0.1

	local prj = shoot_projectile( shooter, "data/entities/projectiles/deck/projectile_meniscus_slash_c.xml", sx, sy, tx, ty, false )

	tx,ty = vec_rotate( vx, vy, -math.pi * 0.2 )
	sx = x - math.cos( angle - math.pi * 0.2 ) * offset - math.cos( angle ) * offset * 0.1
	sy = y - math.sin( angle - math.pi * 0.2 ) * offset - math.sin( angle ) * offset * 0.1

	prj = shoot_projectile( shooter, "data/entities/projectiles/deck/projectile_meniscus_slash_d.xml", sx, sy, tx, ty, false )
end