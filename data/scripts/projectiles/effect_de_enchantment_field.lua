dofile_once("data/scripts/lib/utilities.lua")

local x, y = EntityGetTransform( GetUpdatedEntityID() )
local players = EntityGetInRadiusWithTag( x, y, 27, "player_unit" )
local enemies = EntityGetInRadiusWithTag( x, y, 27, "enemy" )

if #players > 0 then for i=1,#players do
		local id = players[i]
		if id ~= nil and id ~= NULL_ENTITY then EntityAddChild( id, EntityLoad( "data/entities/misc/effect_damage_plus_small.xml", x, y ) ) end
end end

if #enemies > 0 then for i=1,#enemies do
		local id = enemies[i]
		if id ~= nil and id ~= NULL_ENTITY then EntityAddChild( id, EntityLoad( "data/entities/misc/effect_damage_multiplier.xml", x, y ) ) end
end end

-- GameAreaEffectComponent?