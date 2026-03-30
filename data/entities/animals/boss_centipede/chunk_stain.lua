dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

EntityLoad( "data/entities/misc/bloody_stain.xml", x, y+64 )
GamePrint( "( " .. tostring(x) .. ", " .. tostring(y) .. " )" )