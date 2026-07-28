dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 64

local players = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )

if #players > 0 then for i=1,#players do
	local pid = players[i]
	local px, py = EntityGetTransform( pid )

    EntityAddChild( pid, EntityLoad( "data/entities/misc/mana_from_spell.xml", px, py ) )
end end

