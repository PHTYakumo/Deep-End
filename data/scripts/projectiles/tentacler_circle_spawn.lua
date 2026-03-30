dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local px, py = EntityGetTransform( entity_id )

local radius = 66
local players = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )

if #players > 0 then
	for i=1,#players do
		px, py = EntityGetTransform( players[i] )

		edit_component( players[i], "VelocityComponent", function(vcomp,vars)
			ComponentSetValueVector2( vcomp, "mVelocity", 0, 0 )
		end)
		
		edit_component( players[i], "CharacterDataComponent", function(ccomp,vars)
			ComponentSetValueVector2( ccomp, "mVelocity", 0, 0 )
		end)

		EntityInflictDamage( players[i], 0.4, "DAMAGE_MELEE", "$dSword", "BLOOD_EXPLOSION", 0, 0, shooter )
	end
end

EntityLoad( "data/entities/projectiles/tentacler_melee_portal.xml", px, py-4 )
EntityKill( entity_id )