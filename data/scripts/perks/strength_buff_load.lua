dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local p = EntityGetWithTag( "player_unit" )
if #p == 0 then return end

for i=1,#p do if EntityHasTag( p[i], "de_strength" ) then -- GameHasFlagRun()
		EntityAddChild( p[i], EntityLoad( "data/entities/misc/effect_damage_plus_small_longer.xml", x, y ) )
end end