dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

if math.abs(x) < 2560 then
	EntitySetTransform( entity_id, -12030, 13040 )
	EntityApplyTransform( entity_id, -12030, 13040 )
	return
end

local players = EntityGetInRadiusWithTag( x, y, 262144, "player_unit" )
local angle = math.pi

if #players > 0 then
	SetRandomSeed( x, y )
	local pid = players[Random(1,#players)]
	local px,py = EntityGetTransform( pid )
	
	angle = get_direction( x, y, px, py ) + angle
	pid = NULL_ENTITY

	for i=1,#players do
		pid = players[i]
		px, py = EntityGetTransform( pid )

		local dis = math.abs( px-x ) + math.abs( py-y )

		if pid ~= nil and pid ~= NULL_ENTITY then
			EntityAddRandomStains( pid, CellFactory_GetType("blood_fading"), 49 )

			local comp = EntityGetFirstComponent( pid, "DamageModelComponent" )
			
			if comp ~= nil then
				local air = ComponentGetValue2( comp, "air_in_lungs" )
				air = math.floor( math.max( air * 97.5, 0 ) ) * 0.01

				ComponentSetValue2( comp, "air_in_lungs", air )
			end

			if dis > 1536 and not EntityHasTag( pid, "flee_boss_ghost" ) then 
				EntityAddTag( pid, "flee_boss_ghost")
				GamePrintImportant( "$flee_boss_ghost_1", "$flee_boss_ghost_2" )
				
				EntityAddChild( pid, EntityLoad( "data/entities/misc/effect_de_crippled_permanent.xml" ) )
				EntityInflictDamage( pid, 4, "DAMAGE_CURSE", "$flee_boss_ghost_3", "DISINTEGRATED", 0, 0, entity_id )
			end
		end
	end
end

GameCreateSpriteForXFrames( "data/entities/animals/boss_ghost/pupil.png", x + math.cos( angle ) * 3, y - math.sin( angle ) * 3, true, 0, 0, 1, true )