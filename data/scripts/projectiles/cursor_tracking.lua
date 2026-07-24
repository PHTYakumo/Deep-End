dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

function g_velocity( to, from, twist )
	local dis = to - from
	SetRandomSeed( to + entity_id, GameGetFrameNum() )

	if dis == 0 then dis = dis * sign( to ) * twist
	else dis = dis * twist end

	local find = clamp( dis, -1437, 1437 ) + Random( -10, 10 ) * twist
	return find
end

local pid = EntityGetClosestWithTag( x, y, "player_unit" )
local cx, cy, tx, ty = x, y, x, y

if pid == nil or pid == NULL_ENTITY then -- where r u?
	tx = g_velocity( x, x, 80 )
	ty = g_velocity( y, y, 80 )
else
	local px, py = EntityGetTransform( pid )
	local radius = math.abs( x - px ) + math.abs( y - py ) or 0

	if radius < 5120 then
		local projectilecomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
		local lclick, rclick = false, false
		
		if projectilecomp ~= nil then
			component_write( projectilecomp, {
				mWhoShot = pid,
				mShooterHerdId = get_herd_id(pid),
				friendly_fire = false,
				collide_with_shooter_frames = -1,
			} )
		end

		component_read( EntityGetFirstComponent(pid, "ControlsComponent"), { mButtonDownLeftClick = false, mButtonDownRightClick = false },
			function(controls_comp)
				lclick = controls_comp.mButtonDownLeftClick or false
				rclick = controls_comp.mButtonDownRightClick or false
			end
		)

		if lclick == true and rclick == false then -- follow cursor
			edit_component( pid, "ControlsComponent", function(mcomp,vars) cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition" ) end )
			local ex, ey = cx, cy

			radius = math.abs( cx - x ) + math.abs( cy - y )
			if radius > 1024 then EntitySetTransform( entity_id, cx, cy ) end -- tp when too far from the cursor

			local enemy = EntityGetClosestWithTag( cx, cy, "enemy" )
			if EntityGetIsAlive( enemy ) then ex, ey = EntityGetTransform( enemy ) end

			radius = math.abs( cx - ex ) + math.abs( cy - ey )
			if radius <= 60 then cx, cy = ex, ey end -- give up when too far from the cursor

			tx = g_velocity( cx, x, 50 )
			ty = g_velocity( cy, y, 50 )
		elseif lclick == false and rclick == true then -- force to follow u
			tx = g_velocity( px, x, 75 )
			ty = g_velocity( py - 30, y, 75 )
		else
			local enemy = EntityGetClosestWithTag( px, py, "enemy" ) -- up to ur pos
			local homing_r = 225

			if rclick then homing_r = homing_r * 2 end
			radius = homing_r
			
			if enemy ~= nil and EntityGetIsAlive( enemy ) then
				cx, cy = EntityGetTransform( enemy )
				radius = math.abs( cx - px ) + math.abs( cy - py )

				if radius < homing_r then
					tx = g_velocity( cx, x, 125 )
					ty = g_velocity( cy, y, 125 )
				end
			end

			if radius >= homing_r then -- no target, so follow u
				tx = g_velocity( px, x, 32 )
				ty = g_velocity( py - 30, y, 32 )
			end
		end
	else -- too far, kill
		EntityKill( entity_id )
		return
	end
end

edit_component( entity_id, "VelocityComponent", function(comp,vars) ComponentSetValueVector2( comp, "mVelocity", tx, ty ) end )
