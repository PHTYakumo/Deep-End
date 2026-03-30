dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

if math.abs(x) < 2560 then
	EntitySetTransform( entity_id, -12030, 13040 )
	EntityApplyTransform( entity_id, -12030, 13040 )
	return
end

local players = EntityGetInRadiusWithTag( x, y, 35900, "player_unit" )
local angle = math.pi

if ( #players > 0 ) then
	SetRandomSeed( x, y )
	local pid = players[Random(1,#players)]
	local px,py = EntityGetTransform( pid )
	
	angle = get_direction( x, y, px, py ) + angle
	pid = NULL_ENTITY

	for i=1,#players do
		pid = players[i]
		px, py = EntityGetTransform( pid )

		local dis = math.abs( px-x ) + math.abs( py-y )

		if ( pid ~= nil ) and ( pid ~= NULL_ENTITY ) then
			EntityAddRandomStains( pid, CellFactory_GetType("blood_fading"), 49 )

			local comp = EntityGetFirstComponent( pid, "DamageModelComponent" )
			
			if ( comp ~= nil ) then
				local air = ComponentGetValue2( comp, "air_in_lungs" )
				air = math.floor( math.max( air * 97.5, 0 ) ) * 0.01

				ComponentSetValue2( comp, "air_in_lungs", air )
			end

			if ( dis > 1200 ) then
				if not EntityHasTag( pid, "flee_boss_ghost_" ) then 
					EntityAddTag( pid, "flee_boss_ghost_")
		
					GamePrintImportant( "$flee_boss_ghost_1", "$flee_boss_ghost_2" )
		
					EntityInflictDamage( pid, 4, "DAMAGE_HEALING", "$flee_boss_ghost_3", "NONE", 0, 0, entity_id )
					EntityInflictDamage( pid, 0.002, "DAMAGE_CURSE", "$flee_boss_ghost_3", "DISINTEGRATED", 0, 0, entity_id )
		
					local damagemodels = EntityGetComponent( pid, "DamageModelComponent" )
		
					if( damagemodels ~= nil ) then
						for i,damagemodel in ipairs(damagemodels) do
							local max_hp = ComponentGetValue2( damagemodel, "max_hp" )
		
							ComponentSetValue2( damagemodel, "max_hp_old", max_hp )
							ComponentSetValue2( damagemodel, "max_hp", math.ceil( max_hp * 25 ) / 50 )
							ComponentSetValue2( damagemodel, "mLastMaxHpChangeFrame", GameGetFrameNum() )
						end
					end
				end
				-- EntityKill( pid )
			elseif ( dis > 600 ) then
				local curse_list = { "effect_movement_slower", "effect_blindness", "neutralized" }
				local curse_rnd = Random( 1, #curse_list )
				
				EntityAddChild( pid, EntityLoad( "data/entities/misc/" .. curse_list[curse_rnd] .. "_once.xml" ) )
				GamePrint( "$flee_boss_ghost_3" )
			end
		end
	end
end

GameCreateSpriteForXFrames( "data/entities/animals/boss_ghost/pupil.png", x + math.cos( angle ) * 3, y - math.sin( angle ) * 3, true, 0, 0, 1, true )