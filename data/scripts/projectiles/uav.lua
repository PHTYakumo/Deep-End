dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local et = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
local players = EntityGetInRadiusWithTag( x, y, 999, "player_unit" )

if #players > 0 and EntityHasTag( entity_id, "spells_to_power_target" ) == false then
    for i = 1, #players do
        local pid = players[i]
        local px, py, cx, cy = EntityGetTransform( pid )

        edit_component( pid, "ControlsComponent", function(mcomp,vars)
            cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
        end)

        SetRandomSeed( GameGetFrameNum() + y, cx + px )
        py = py - 17

        local dx = Random( -3, 3 )
        local dy = Random( -3, 3 )
        
        shoot_projectile( pid, "data/entities/projectiles/deck/uav_projectile.xml", px+dx, py+dy, cx-px, cy-py )
        shoot_projectile( pid, "data/entities/projectiles/deck/uav_projectile.xml", px-dx, py-dy, cx-px, cy-py )

        if et % 5 == 1 then shoot_projectile( pid, "data/entities/projectiles/deck/uav_projectile_p.xml", px, py, cx-px, cy-py )
        else shoot_projectile( pid, "data/entities/projectiles/deck/uav_projectile.xml", px, py, cx-px, cy-py ) end

        --[[
        local gfx_id = 1
        local gcomp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "gfx_id" )
        if ( gcomp ~= nil ) then
            gfx_id = ComponentGetValue2( gcomp, "value_int" )
            local x_id = math.floor( (gfx_id+3)/4 )

            if ( gfx_id == 12 ) then
                gfx_id = 1 
            else
                gfx_id = gfx_id + 1 
            end

            GameCreateSpriteForXFrames( "data/projectiles_gfx/is_that_a_uav_" .. x_id .. ".png", px, py-4, true, 0, 0, 2, true )
            ComponentSetValue2( gcomp, "value_int", gfx_id )
        end
        ]]--
    end
end

