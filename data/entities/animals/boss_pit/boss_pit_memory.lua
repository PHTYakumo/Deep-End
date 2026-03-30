dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local pf_comp = EntityGetFirstComponent( entity_id, "PathFindingComponent")

if( pf_comp ) then
	local pf_state = ComponentGetValue2( pf_comp, "read_state" )

	local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			local n = ComponentGetValue2( v, "name" )
			if( n == "pathfinding_frames_stuck" ) then
				local frames_stuck = ComponentGetValue2( v, "value_int" )
				if( pf_state <= 1 ) then 
					frames_stuck = frames_stuck + 1 
				else
					frames_stuck = 0
				end
				ComponentSetValue2( v, "value_int", frames_stuck )
				-- NOTE( Petri ): if frames_stuck is like higher than 160 it means the boss is stuck
				-- print( "frames_stuck: " .. tostring( frames_stuck ) )
			end
		end
	end
end

local projectiles = EntityGetInRadiusWithTag( x, y, 111, "projectile" )

if ( #projectiles > 0 ) then
	local id = math.floor( #projectiles/2 - 0.2 ) + 1
	local p = projectiles[id]
	local p_n = ""

	local comps = EntityGetComponent( p, "VariableStorageComponent" )
	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			local n = ComponentGetValue2( v, "name" )
			if ( n == "projectile_file" ) then
				p_n = ComponentGetValue2( v, "value_string" )
				break
			end
		end
	end
	
	if ( #p_n > 0 ) then
		comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
		if ( comps ~= nil ) then
			for i,v in ipairs( comps ) do
				local n = ComponentGetValue2( v, "name" )
				if ( n == "memory" ) then
					if ( p_n == ComponentGetValue2( v, "value_string" ) ) then
						SetRandomSeed( x, y * GameGetFrameNum() )
						
						local prjs = { "orb_poly", "orb_neutral", "orb_tele", "orb_dark_tiny" }
						local prj_rnd = Random( 1, #prjs )

						ComponentSetValue2( v, "value_string", "data/entities/projectiles/" .. prjs[prj_rnd] .. ".xml" )
					else
						ComponentSetValue2( v, "value_string", p_n )
					end
					break
				end
			end
		end
	end

	for i=1,#projectiles do
		local dmgcomp_1 = EntityGetFirstComponent( projectiles[i], "LaserEmitterComponent" )
		local dmgcomp_2 = EntityGetFirstComponent( projectiles[i], "AreaDamageComponent" )
		local dmgcomp_3 = EntityGetFirstComponent( projectiles[i], "GameAreaEffectComponent" )

		if ( dmgcomp_1 ~= nil ) or ( dmgcomp_2 ~= nil ) or ( dmgcomp_3 ~= nil ) then
			local prjx, prjy = EntityGetTransform( projectiles[i] )

			EntityKill(projectiles[i])

			shoot_projectile( entity_id, "data/entities/projectiles/hamis.xml", prjx, prjy, 0, 0 )
		end
	end
end

local players = EntityGetInRadiusWithTag( x, y, 512, "player_unit" )

if ( #players > 0 ) then
	local pid = players[1]

	if ( pid ~= nil ) and ( pid ~= NULL_ENTITY ) then
		local comp = EntityGetFirstComponent( pid, "CharacterDataComponent" )
		
		if ( comp ~= nil ) then
			local flight = ComponentGetValue2( comp, "mFlyingTimeLeft" )
			flight = math.min( flight*0.99, 1.25 )

			ComponentSetValue2( comp, "mFlyingTimeLeft", flight )
		end
	end
end