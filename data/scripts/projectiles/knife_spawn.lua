dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity = GetUpdatedEntityID()
local ix, iy = EntityGetTransform( entity )

---------------------------------[[ function part ]]---------------------------------

function g_atan2( pid )
	local ax = 0
	local ay = 1

	edit_component( pid, "ControlsComponent", function(comp,vars)
		ax,ay = ComponentGetValueVector2( comp, "mAimingVector")
	end)

	local angle = math.atan2( -ay, ax )

	return angle
end

function straight_shoot( amount, perfect )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local pid = EntityGetClosestWithTag( x, y, "player_unit")
	local px, py = EntityGetTransform( pid )

	local angle = g_atan2( pid )
	local speed = 240
	local many = math.floor( (amount-1) / 12 ) + 1

	local sx = math.cos( angle ) * speed
	local sy = math.sin( angle ) * speed

	for i=1,many do
		local fx = ( 1+ (-1)^i ) * 2
		local fy = 4 * ( (many-i) - (many-1)/2 )

		fx,fy = vec_rotate( fx, fy, angle )

		fx = px + fx
		fy = (py-4) - fy

		shoot_projectile( pid, "data/entities/projectiles/deck/summon_knife.xml", fx, fy, sx, -sy )
	end
end

function v_shoot( amount )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local pid = EntityGetClosestWithTag( x, y, "player_unit")
	local px, py = EntityGetTransform( pid )

	local angle = g_atan2( pid )
	local speed = 240
	local many = math.floor( (amount-1) / 24 ) * 2 + 1

	local sx = math.cos( angle ) * speed
	local sy = math.sin( angle ) * speed

	for i=1,many do
		local fx = 8 * ( math.floor( many/2 ) - math.abs( (many+1)/2 - i ) )  -- * sign(x)
		local fy = 6 * ( (many-i) -(many-1)/2 )

		fx,fy = vec_rotate( fx, fy, angle )

		fx = px + fx
		fy = (py-4) - fy

		shoot_projectile( pid, "data/entities/projectiles/deck/summon_knife.xml", fx, fy, sx, -sy )
	end
end

function spread_shoot( amount )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local pid = EntityGetClosestWithTag( x, y, "player_unit")
	local px, py = EntityGetTransform( pid )

	local angle = g_atan2( pid )
	local speed = 240
	local many = math.floor( (amount-1) / 24 ) * 2 + 3
	local spread = math.rad( 18 / (many-1) )

	for i=1,many do
		local offset = ( (many-i) - (many-1)/2 )

		local fx = 0
		local fy = offset * (-2)

		fx,fy = vec_rotate( fx, fy, angle )

		fx = px + fx
		fy = (py-4) - fy

		local sx = math.cos( angle ) * speed
		local sy = math.sin( angle ) * speed
		
		sx,sy = vec_rotate( sx, sy, offset * spread )

		shoot_projectile( pid, "data/entities/projectiles/deck/summon_knife.xml", fx, fy, sx, -sy )
	end
end

function focuse_shoot( amount )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local pid = EntityGetClosestWithTag( x, y, "player_unit")
	local px, py = EntityGetTransform( pid )

	local angle = g_atan2( pid )
	local speed = 240
	local many = math.floor( (amount-1) / 24 ) * 2 + 2

	local cx = px
	local cy = py

	edit_component( pid, "ControlsComponent", function(mcomp,vars)
		cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
	end)

	local dist = math.sqrt( ( cx - px )^2 + ( cy - py )^2 )

	for i=1,many do
		local offset = ( (many-i) - (many-1)/2 )
		local offset_y = offset * math.floor( -48 / (many-1) )

		local fx = 0
		local fy = offset_y

		fx,fy = vec_rotate( fx, fy, angle )

		fx = px + fx
		fy = (py-4) - fy
		
		local sx = math.cos( angle ) * speed
		local sy = math.sin( angle ) * speed

		offset = math.atan2( offset_y , dist )
		
		sx,sy = vec_rotate( sx, sy, -offset )

		shoot_projectile( pid, "data/entities/projectiles/deck/summon_knife.xml", fx, fy, sx, -sy )
	end
end

function ft_shoot( formation )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local pid = EntityGetClosestWithTag( x, y, "player_unit")
	local px, py = EntityGetTransform( pid )

	local angle = g_atan2( pid )
	local speed = 64

	local sx = math.cos( angle ) * speed
	local sy = math.sin( angle ) * speed

	local kid = shoot_projectile( pid, "data/entities/projectiles/deck/summon_knife.xml", px, py-4, sx, -sy )

	if ( kid ~= nil ) then
		local fcomp = EntityGetFirstComponent( kid, "VariableStorageComponent", "formation" )
		if ( fcomp ~= nil ) then
			local form = math.floor( (formation-1) / 8 ) + 1

			ComponentSetValue2( fcomp, "value_int", form )
		end
	end
end

function circle_shoot()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local pid = EntityGetClosestWithTag( x, y, "player_unit")
	local px, py = EntityGetTransform( pid )

	local angle = g_atan2( pid )
	local speed = 16

	local sx = math.cos( angle ) * speed
	local sy = math.sin( angle ) * speed

	local kid = shoot_projectile( pid, "data/entities/projectiles/deck/knife_summon_circle.xml", px, py-4, sx, -sy )

	if ( kid ~= nil ) then
		local acomp = EntityGetFirstComponent( kid, "VariableStorageComponent", "angle" )
		if ( acomp ~= nil ) then
			angle = math.floor( math.deg( angle - math.rad( 12 ) ) ) + 360

			ComponentSetValue2( acomp, "value_int", angle )
		end
	end
end

---------------------------------[[ shoot part ]]---------------------------------

local player_unit = EntityGetClosestWithTag( x, y, "player_unit")
if ( player_unit ~= nil ) then
	local plx, ply = EntityGetTransform( player_unit )

	SetRandomSeed( GameGetFrameNum() + ix, entity + ply )

	local formation_rnd = Random( 1, 365 )

	--local counts = EntityGetWithTag( "perfect_maid" )
	if (formation_rnd <= 72) then
		straight_shoot( formation_rnd )
	elseif (formation_rnd <= 144) then
		v_shoot( formation_rnd - 72 )
		ft_shoot( Random( 1, 24 ) )
	elseif (formation_rnd <= 216) then
		spread_shoot( formation_rnd - 144 )
		ft_shoot( Random( 1, 24 ) )
	elseif (formation_rnd <= 288) then
		focuse_shoot( formation_rnd - 216 )
		ft_shoot( Random( 1, 24 ) )
	elseif (formation_rnd <= 360) then
		ft_shoot( formation_rnd - 288 )
	else
		circle_shoot()
		straight_shoot( formation_rnd - 345 )
	end

	EntityKill( entity )
end

