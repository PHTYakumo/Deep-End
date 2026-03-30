dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local varcomp, eatercomp
local circle, eater_switch, state = math.pi * 2, 0, 0

if GameHasFlagRun( "DEEP_END_OPEN_CHEST_STEEL" ) then eater_switch = 1 end -- never close shield

local varcomps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local pshields = EntityGetInRadiusWithTag( x, y, 8, "shieldshot" )

local cplayers = EntityGetInRadiusWithTag( x, y, 400, "player_unit" )
local you = EntityGetClosestWithTag( x, y, "player_unit" )

if varcomps ~= nil then
	for i,v in ipairs( varcomps ) do
		local n = ComponentGetValue2( v, "name" )
		if n == "state" then
			state = ComponentGetValue2( v, "value_int" )
			varcomp = v
		elseif n == "spell_eater" then
			eatercomp = v
		end
	end
end

if pshields[1] ~= nil then for i=1,#pshields do
	EntityKill(pshields[i])
end end

SetRandomSeed( x + GameGetFrameNum(), y + entity_id )

if varcomp ~= nil and eatercomp ~= nil then
	PhysicsApplyTorque( entity_id, Random( -5000, 5000 ) )

	--[[
	
	-1	clustered lasers
	0	clustered rockets
	1	mini rockets
	2	continuous rockets
	3	orbital discs
	4	circular lances a
	5	circular lances b
	6	dissociated discs
	7	aligned lances a
	8	aligned lances b
	9	raiding lances
	10	raiding lances
	11	ace sniper
	12	ace sniper
	13	diffused discs
	
	]]--

	if state < 0 then
		if cplayers[1] ~= nil then
			for i=1,#cplayers do
				local nx,ny = EntityGetTransform( cplayers[i] )

				EntityAddChild( entity_id, EntityLoad( "data/entities/misc/effect_regeneration_boss_shorter.xml", nx, ny ) )

				local a = math.pi * Random( -100, 100 ) * 0.01

				for i=1,28 do
					local offset = 245 + 0.5 * i
					local vel = 105 + 5 * i

					local vx = math.cos( a )
					local vy = math.sin( a )
					
					shoot_projectile( entity_id, "data/entities/animals/boss_robot/other/laser_elect.xml", nx - vy * offset, ny + vx * offset, vx * vel, vy * vel )
					a = a + 0.2244
				end
			end

			EntityLoad( "data/entities/animals/boss_centipede/clear_materials.xml", x, y )
		end
	elseif state == 0 then
		ComponentSetValue2( eatercomp, "value_int", 1 )

		if cplayers[1] ~= nil then
			for i=1,#cplayers do EntityAddChild( cplayers[i], EntityLoad( "data/entities/misc/sentry_target_long.xml" ) ) end

			for i=1,6 do
				local a = math.pi * ( Random( 0, 100 ) * 0.01 )
				local length = Random( 150, 270 )
				local vx = math.cos( a ) * length
				local vy = -math.sin( a ) * length
				
				shoot_projectile( entity_id, "data/entities/animals/boss_robot/rocket/rocket_roll.xml", x, y, vx, vy )
			end
		end

		local eid = EntityLoad( "data/entities/animals/robobase/drone_shield.xml", x, y + 16 )
		EntityAddTag( eid, "boss_centipede_minion" )

		local aicomp = EntityGetFirstComponent( eid, "AnimalAIComponent" )
		if aicomp ~= nil then ComponentSetValue2( aicomp, "attack_ranged_enabled", false ) end

		local eshields = EntityGetAllChildren( eid, "energy_shield" )
		if #eshields >= 2 then for i=2,#eshields do EntityKill( eshields[i] ) end end

		EntityAddComponent( eid, "LifetimeComponent",
		{
			lifetime=1681,
		})

		EntityAddComponent( eid, "VariableStorageComponent", 
		{ 
			_tags="no_gold_drop",
		} )
	elseif state == 1 then
		ComponentSetValue2( eatercomp, "value_int", eater_switch )

		if cplayers[1] ~= nil then
			for i=1,13 do
				local a = math.pi * Random( -100, 100 ) * 0.01
				local length = Random( 70, 130 )
				local vx = math.cos( a ) * length
				local vy = -math.sin( a ) * length
				
				shoot_projectile( entity_id, "data/entities/animals/boss_robot/rocket/rocket_bouncy.xml", x + Random( -13, 13 ), y + Random( -13, 13 ), vx, vy )
			end

			EntityLoad( "data/entities/animals/boss_robot/rocket/summon_rocket.xml", x, y )
		end
	elseif state == 2 then
	elseif state == 3 then
		ComponentSetValue2( eatercomp, "value_int", 1 )

		for i=1,4 do
			local dir = circle * i / 4
			
			local nx = x + math.cos( dir ) * 35
			local ny = y - math.sin( dir ) * 35
		
			local eid = EntityLoad( "data/entities/animals/boss_robot/disc/disc_orbit.xml", nx, ny )
		
			if eid ~= nil then
				EntityAddChild( entity_id, eid )
				
				local dcomp = EntityGetFirstComponent( eid, "VariableStorageComponent", "disc_id" )
				if dcomp ~= nil then
					ComponentSetValue2( dcomp, "value_int", i-1 )
				end
			end

			local vx = math.cos( dir )
			local vy = math.sin( dir )

			shoot_projectile( entity_id, "data/entities/animals/boss_robot/other/laser_elect.xml", x, y, vx * 1.43 - vy * 0.59, vy * 1.43 + vx * 0.59 )
			shoot_projectile( entity_id, "data/entities/animals/boss_robot/other/laser_elect.xml", x, y, vx * 1.43 + vy * 0.59, vy * 1.43 - vx * 0.59 )
		end
	elseif state == 4 then
		local count = 24
		local range = 500

		local rotation_rad = -circle / 45

		for i=1,count do
			local dir = circle * i * 2 / count

			local vx = math.cos( dir )
			local vy = math.sin( dir )
			
			local nx = x - vx * range
			local ny = y - vy * range

			local rx = math.cos( rotation_rad ) * vx - math.sin( rotation_rad ) * vy -- let the dirction rotates 
			local ry = math.sin( rotation_rad ) * vx + math.cos( rotation_rad ) * vy

			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, rx, ry )
			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, rx*20, ry*20 )
			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, -rx, -ry )
			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, -rx*20, -ry*20 )
		end

		ComponentSetValue2( EntityGetFirstComponent( EntityLoad( "data/entities/animals/boss_robot/trail/lance_formation.xml", x, y ), "VariableStorageComponent" ), "value_int", 1 )
	elseif state == 5 then
		local count = 25
		local range = 500

		local rotation_rad = circle / 30

		for i=1,count do
			local dir = circle * i * 2 / count

			local vx = math.cos( dir )
			local vy = math.sin( dir )
			
			local nx = x - vx * range
			local ny = y - vy * range

			local rx = math.cos( rotation_rad ) * vx - math.sin( rotation_rad ) * vy -- let the dirction rotates 
			local ry = math.sin( rotation_rad ) * vx + math.cos( rotation_rad ) * vy

			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, rx, ry )
			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, rx*20, ry*20 )
			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, -rx, -ry )
			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, -rx*20, -ry*20 )
		end

		ComponentSetValue2( EntityGetFirstComponent( EntityLoad( "data/entities/animals/boss_robot/trail/lance_formation.xml", x, y ), "VariableStorageComponent" ), "value_int", 2 )
	elseif state == 6 then
		ComponentSetValue2( eatercomp, "value_int", eater_switch )

		for i=1,4 do
			local dir = circle * i / 6
			
			local vx = math.cos( dir )
			local vy = math.sin( dir )
			
			local nx = x + vx * 40
			local ny = y - vy * 40

			shoot_projectile( entity_id, "data/entities/animals/boss_robot/disc/disc_shoot.xml", nx, ny, vx, vy )
		
			local eid = EntityLoad( "data/entities/animals/boss_robot/disc/disc_decelerate.xml", nx, ny )
			EntityAddChild( entity_id, eid )
			
			local dcomp = EntityGetFirstComponent( eid, "VariableStorageComponent", "disc_id" )
			if dcomp ~= nil then
				ComponentSetValue2( dcomp, "value_int", i-1 )
			end

			--[[
			local ocomp = EntityGetFirstComponent( eid, "VariableStorageComponent", "orbit_id" )
			if ocomp ~= nil then
				ComponentSetValue2( dcomp, "value_int", 48 )
			end
			]]--
		end
	elseif state == 7 then
		ComponentSetValue2( eatercomp, "value_int", 1 )

		local mx, my = x, y

		if you ~= nil then
			local px, py = EntityGetTransform( you )

			mx = ( x + px ) * 0.5
			my = ( y + py ) * 0.5
		end

		local count = 46
		local range = 1100

		for i=1,count do 
			local interval = range / ( count-1 )

			local nx = mx + range/2
			local ny = my + range/2 - ( i-1 ) * interval

			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, -2000, 0 )
			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, -20, 0 )

			nx = mx - range/2

			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, 2000, 0 )
			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, 20, 0 )
		end

		ComponentSetValue2( EntityGetFirstComponent( EntityLoad( "data/entities/animals/boss_robot/trail/lance_formation.xml", x, y ), "VariableStorageComponent" ), "value_int", 3 )
	elseif state == 8 then
		local mx, my = x, y
		
		if you ~= nil then
			local px, py = EntityGetTransform( you )

			mx = ( x + px ) * 0.5
			my = ( y + py ) * 0.5
		end

		local count = 40
		local range = 778

		for i=1,count do
			local interval = range / ( count-1 )

			local sx = ( i-1 ) * interval
			local sy = range - sx

			local nx = mx - sx
			local ny = my + sy

			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, 1414.2, -1414.2 )
			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, 14.142, -14.142 )

			nx = mx + sx
			ny = my - sy

			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, -1414.2, 1414.2 )
			shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, -14.142, 14.142 )
		end

		ComponentSetValue2( EntityGetFirstComponent( EntityLoad( "data/entities/animals/boss_robot/trail/lance_formation.xml", x, y ), "VariableStorageComponent" ), "value_int", 4 )
	elseif state == 9 then
		ComponentSetValue2( eatercomp, "value_int", eater_switch )

		EntityLoad( "data/entities/animals/boss_robot/trail/summon_lance.xml", x, y )

		if cplayers[1] ~= nil then
			for i=1,#cplayers do
				local flcomp = EntityGetFirstComponent( cplayers[i], "CharacterDataComponent" )
				
				if flcomp ~= nil then
					local flight = ComponentGetValue2( flcomp, "mFlyingTimeLeft" )
					flight = math.max( flight, 2.5 )

					ComponentSetValue2( flcomp, "mFlyingTimeLeft", flight )
				end
			end
		end
	elseif state == 10 then
	elseif state == 11 then
		ComponentSetValue2( eatercomp, "value_int", 1 )

		EntityLoad( "data/entities/animals/boss_robot/other/aiming_load.xml", x, y )

		if cplayers[1] ~= nil then
			for i=1,#cplayers do
				local nx,ny = EntityGetTransform( cplayers[i] )

				EntityLoad( "data/entities/animals/boss_robot/other/aiming_shot.xml", nx, ny )
			end
		end
	elseif state == 12 then
	elseif state == 13 then
		ComponentSetValue2( eatercomp, "value_int", eater_switch )
		
		local rotation_rad = -circle / 4

		for i=1,8 do
			local dir = circle * i / 8

			local vx = math.cos( dir )
			local vy = math.sin( dir )
			
			local nx = x - vx * 48
			local ny = y - vy * 48

			local rx = math.cos( rotation_rad ) * vx - math.sin( rotation_rad ) * vy -- let the dirction rotates 
			local ry = math.sin( rotation_rad ) * vx + math.cos( rotation_rad ) * vy

			EntityAddComponent( shoot_projectile( entity_id, "data/entities/animals/boss_robot/disc/disc_shoot.xml", nx, ny, rx, ry ),
				"LuaComponent",
			{	script_source_file="data/entities/animals/boss_centipede/orb_boss_limbs.lua",
				execute_every_n_frame=tostring( i % 2 + 2 ),
			} )
		end

		EntityAddChild( entity_id, EntityLoad( "data/entities/misc/effect_regeneration_boss_shorter.xml", x, y ) )

		state = -1
	end
	
	ComponentSetValue2( varcomp, "value_int", state + 1 )

	if eater_switch == 1 then
		EntityLoad( "data/entities/animals/boss_robot/disc/discs_pour_out.xml", x, y )
	end
end
