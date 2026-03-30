dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local enemies = EntityGetInRadiusWithTag( x, y, 512, "destruction_target" )
local players = EntityGetInRadiusWithTag( x, y, 256, "player_unit" ) -- release at a distance?

if #enemies > 0 then
	local kills = 0

	for _,enemy_id in ipairs(enemies) do
		local ex, ey = EntityGetTransform( enemy_id )
		
		if EntityHasTag( enemy_id, "robot_egg_boosted" ) == false
		and EntityHasTag( enemy_id, "boss" ) == false
		and EntityHasTag( enemy_id, "this_is_sampo" ) == false
		then
			kills = kills + 1

			EntityLoad( "data/entities/particles/destruction.xml", ex, ey )
			EntityKill( enemy_id )
		end
	end

	if #players > 0 then
		for _,player_id in ipairs(players) do
			local px, py = EntityGetTransform( player_id )		
			local damagemodels = EntityGetComponent( player_id, "DamageModelComponent" )
			
			if damagemodels ~= nil then
				EntityLoad( "data/entities/particles/destruction_player.xml", px, py-4 )

				for _,damagemodel in ipairs(damagemodels) do
					local hp = ComponentGetValue2( damagemodel, "hp" )
					local health = hp * ( 1 - kills * 0.002 / #players )
					health = math.min( health, hp * 0.999, hp - 0.08 )
					health = math.max( health, hp * 0.5, hp - 4, 0.96 )

					ComponentSetValue2( damagemodel, "hp", math.ceil( health * 25 ) * 0.04 )
				end
			end
		end
	end

	GameScreenshake( clamp( kills * 10, 20, 400 ) )
end

EntityKill( entity_id )