dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")

ConvertEverythingToGold()

local world_entity_id = GameGetWorldStateEntity()
if( world_entity_id ~= nil ) then
    local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
    
    if( comp_worldstate ~= nil ) then ComponentSetValue2( comp_worldstate, "time_dt", 0 ) end
end

-- do_newgame_plus()