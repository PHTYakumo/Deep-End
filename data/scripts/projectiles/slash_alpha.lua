dofile_once( "data/scripts/lib/utilities.lua" )

local t = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
if t > 6 then return end

local entity_id = GetUpdatedEntityID()
local malpha = 0.88

local scomp = EntityGetFirstComponent( entity_id, "SpriteComponent" )
if scomp == nil then return end

if EntityHasTag( entity_id, "de_projectile_spawner" ) then malpha = 1
elseif EntityHasTag( entity_id, "projectile_cloned" ) then malpha = 0.75 end

ComponentSetValue2( scomp, "alpha", math.min( ComponentGetValue2( scomp, "alpha" ) + malpha * 0.2, malpha ) )
