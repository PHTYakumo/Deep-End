dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local cx = x
local cy = y

function g_velocity( to, from, v, twist )
	local dis = to - from
	local rvel = dis^2

	SetRandomSeed( dis + entity_id, GameGetFrameNum() )

	if dis == 0 then
		rvel = rvel * sign( to ) * v
	else
		rvel = rvel / dis * v
	end

	local find = clamp( rvel, -1437, 1437 ) + Random( -twist, twist )

	return find
end

local radius = 35900
local players = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )
if ( #players > 0 ) then
	local pid = players[1]
	local px, py = EntityGetTransform( pid )

	local projectilecomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
	local herd_id = get_herd_id( pid )

	if projectilecomp ~= nil then
		component_write( projectilecomp,
		{
			mWhoShot = pid,
			mShooterHerdId = herd_id,
			friendly_fire = false,
			collide_with_shooter_frames = -1,
		} )
	end

	local lclick = false
	local rclick = false

	component_read(EntityGetFirstComponent(pid, "ControlsComponent"), { mButtonDownLeftClick = false }, function(controls_comp)
		lclick = controls_comp.mButtonDownLeftClick or false
	end)
	component_read(EntityGetFirstComponent(pid, "ControlsComponent"), { mButtonDownRightClick = false }, function(controls_comp)
		rclick = controls_comp.mButtonDownRightClick or false
	end)

	if ( lclick == true ) and ( rclick == false ) then -- if u wanna keep shooting
		local homing = 16
		local enemys = EntityGetInRadiusWithTag( cx, cy, homing, "enemy" )

		edit_component( pid, "ControlsComponent", function(mcomp,vars)
			cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition" )
		end)

		if ( #enemys > 0 ) then
			local ex, ey = EntityGetTransform( enemys[#enemys] ) -- always the enemy with the largest id
			local tardis = math.abs( cx - ex ) + math.abs( cy - ey )

			if ( tardis <= 80 ) then
				cx, cy = EntityGetTransform( enemys[#enemys] ) -- give up when too far from the cursor
			end

			local tx = g_velocity( cx, x, 72, 512 )
			local ty = g_velocity( cy, y, 72, 512 )

			edit_component( entity_id, "VelocityComponent", function(comp,vars)
				ComponentSetValueVector2( comp, "mVelocity", tx, ty)
			end)
		else
			local tardis = math.abs( cx - x ) + math.abs( cy - y )

			if ( tardis > 1024 ) then
				EntityKill( entity_id ) -- just remove itself when too far from the cursor
			end
	
			local tx = g_velocity( cx, x, 16, 384 )
			local ty = g_velocity( cy, y, 16, 384 )
	
			edit_component( entity_id, "VelocityComponent", function(comp,vars)
				ComponentSetValueVector2( comp, "mVelocity", tx, ty )
			end)
		end
	elseif ( lclick == false ) and ( rclick == true ) then -- force to follow u
		local tx = g_velocity( px, x, 24, 432 )
		local ty = g_velocity( py-30, y, 24, 432 )

		edit_component( entity_id, "VelocityComponent", function(comp,vars)
			ComponentSetValueVector2( comp, "mVelocity", tx, ty )
		end)
	else
		local homing = 224
		local enemys = EntityGetInRadiusWithTag( px, py, homing, "enemy" ) -- up to ur pos
		
		if ( #enemys > 0 ) then
			local sufferer = math.floor( #enemys / 2 - 0.34 ) + 1
			local enemy = enemys[sufferer] -- always the enemy with the middle id
			cx, cy = EntityGetTransform( enemy )

			local tx = g_velocity( cx, x, 12, 448 )
			local ty = g_velocity( cy, y, 12, 448 )

			edit_component( entity_id, "VelocityComponent", function(comp,vars)
				ComponentSetValueVector2( comp, "mVelocity", tx, ty )
			end)
		else -- no target, so follow u
			local tx = g_velocity( px, x, 18, 288 )
			local ty = g_velocity( py-30, y, 18, 288 )

			edit_component( entity_id, "VelocityComponent", function(comp,vars)
				ComponentSetValueVector2( comp, "mVelocity", tx, ty )
			end)
		end
	end
else -- where r u?
	edit_component( entity_id, "VelocityComponent", function(comp,vars)
		ComponentSetValueVector2( comp, "mVelocity", g_velocity( x, x, 6, 48 ), g_velocity( x, x, 6, 48 ) )
	end)
end
