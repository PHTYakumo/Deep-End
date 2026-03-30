dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")
dofile_once("data/entities/misc/what_is_this/BSOD.lua")

local entity_id = GetUpdatedEntityID()
local de_ng_pre = ComponentGetValue2( EntityGetFirstComponent( entity_id, "VariableStorageComponent", "de_ng_pre" ), "value_int" )
local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )

local just_reset_alls = EntityGetWithTag( "just_reset_all" )
just_reset_alls = #just_reset_alls

if newgame_n == de_ng_pre then
    if de_ng_pre == 0 then
        local ed2_happened = ComponentGetValue2( EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" ), "ENDING_HAPPINESS" )

        if not ed2_happened and just_reset_alls == 1 then
            GameDoEnding2()
            GamePrint( "$deep_end_new_game_tip_1" )
        else
            -- If GameDoEnding2() is executed multiple times, it may be cached for execution in the next round
            GamePrint( "$deep_end_new_game_tip_2" )
        end
    elseif math.abs( de_ng_pre ) > 61440 and just_reset_alls > 1 then
        -- The game will crash...
        DEEP_END_BSOD()
    elseif de_ng_pre ~= 0 then
        if just_reset_alls == 28 then newgame_n = sign( newgame_n ) * 9999 -- D10 + Omega + Regress
        else newgame_n = newgame_n * just_reset_alls * (-1)^just_reset_alls end

        clamp( newgame_n, -9999, 9999 )
        if newgame_n == de_ng_pre then newgame_n = -newgame_n end

        -- Can revese the ng count. Isn't that cool?
        DEEP_END_do_newgame_any_dimension( newgame_n )
    end
end
-- GamePrint( tostring( newgame_n ) .. "/" .. tostring( de_ng_pre ) )
EntityKill( entity_id )