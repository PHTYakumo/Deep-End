dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
local ed2_happened = ComponentGetValue2( comp_worldstate, "ENDING_HAPPINESS" )

if not ed2_happened then
    local me = EntityLoad( "data/entities/animals/boss_pit/boss_pit.xml", x, y )
    local hcomp = EntityGetFirstComponent( me, "BossHealthBarComponent" )

    EntityAddTag( me, "holy_mountain_creature" )

    if hcomp ~= nil then EntityRemoveComponent( me, hcomp ) end
else
    local me = EntityLoad( "data/entities/player_base.xml", x, y )

    EntityAddComponent( me, "LuaComponent", 
    {
        script_death="data/scripts/animals/mr_fox_death.lua",
        execute_every_n_frame="-1",
        remove_after_executed="0",
    } )
end

EntityKill( entity_id )