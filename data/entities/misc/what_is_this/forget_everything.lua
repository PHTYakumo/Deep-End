dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

if not GameHasFlagRun( "ending_game_completed" ) then 
    ConvertEverythingToGold( "deep_end_hush", "deep_end_hush" ) -- deep_end_hush_static: too much charge will cause the game to crash
    GameAddFlagRun( "ending_game_completed" )
    -- GameOnCompleted()

    local players = EntityGetWithTag( "player_unit" )
    EntityLoad( "data/entities/misc/what_is_this/lightning_mouse.xml", x, y )

    if #players > 0 then for i=1,#players do
        local pl = players[i]

        EntityAddComponent( pl, "ElectricitySourceComponent", 
        { 
            radius="128",
            emission_interval_frames="13",
        } )
    end end
end

GamePrintImportant( "$deep_end_forget_everything_1", "$deep_end_forget_everything_2", "data/ui_gfx/decorations/boss_defeat.png" )
EntityKill( entity_id )

--[[

https://www.youtube.com/watch?v=xYyMIafWQXg
If you've seen this video you'll know what I'm trying to create

]]--