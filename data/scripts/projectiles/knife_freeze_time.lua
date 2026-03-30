dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local pid = EntityGetClosestWithTag( x, y, "player_unit")
if ( pid ~= nil ) then
	local px, py = EntityGetTransform( pid )

	local cx = px
	local cy = py

	edit_component( pid, "ControlsComponent", function(mcomp,vars)
		cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
	end)

	SetRandomSeed( GameGetFrameNum() + cx + px, entity_id + y + cy )

	local range = 96
	local rrad = Random( 1, 360 )

	local sx = math.cos( rrad ) * range
	local sy = math.sin( rrad ) * range

	local fx = cx - sx
	local fy = cy - sy

	local formation = 0
	local fcomp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "formation" )
	if ( fcomp ~= nil ) then
		formation = ComponentGetValue2( fcomp, "value_int" )
	end

	local many = math.fmod( formation, 3 ) + 1
	if formation > 0 then formation = math.floor( (formation-1) / 3 ) + 1 end

	if ( formation == 1 ) then
		for i=1,many do
			shoot_projectile( pid, "data/entities/projectiles/deck/summon_knife_freeze_time.xml", fx, fy, sx, sy )
		end

		EntityKill( entity_id )
	elseif ( formation == 2 ) then
		for i=1,many do
			local offset = ( (many-i) - (many-1)/2 )

			sx = math.cos( rrad ) * range
			sy = math.sin( rrad ) * range
			
			sx,sy = vec_rotate( sx, sy, offset * math.rad(7) )
	
			shoot_projectile( pid, "data/entities/projectiles/deck/summon_knife_freeze_time.xml", fx, fy, sx, sy )
		end

		EntityKill( entity_id )
	elseif ( formation == 3 ) then
		for i=1,many do
			local mx = 8 * ( math.floor( many/2 ) - math.abs( (many+1)/2 - i ) )  -- * sign(x)
			local my = 6 * ( (many-i) -(many-1)/2 )
	
			local angle = math.atan2( -sy, sx )
			mx,my = vec_rotate( mx, my, angle )
	
			ix = fx + mx
			iy = fy - my
	
			shoot_projectile( pid, "data/entities/projectiles/deck/summon_knife_freeze_time.xml", ix, iy, sx, sy )
		end

		EntityKill( entity_id )
	else
		local rclick = false
	
		component_read(EntityGetFirstComponent(pid, "ControlsComponent"), { mButtonDownRightClick = false }, function(controls_comp)
			rclick = controls_comp.mButtonDownRightClick or false
		end)
		
		if ( rclick ) then
			local enemys = EntityGetInRadiusWithTag( cx, cy, 32, "enemy" )
			if ( #enemys > 0 ) then cx, cy = EntityGetTransform( enemys[#enemys] ) end

			local angle = math.atan2( -(cy-y), (cx-x) )
			local speed = 560

			sx = math.cos( angle ) * speed
			sy = math.sin( angle ) * speed

			comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
			ComponentSetValueVector2( comp, "mVelocity", sx, -sy)
		end
	end
end