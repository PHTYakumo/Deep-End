dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
local shooter = entity_id

if comp ~= nil then shooter = ComponentGetValue2( comp, "mWhoShot" ) end

if shooter ~= nil and shooter ~= NULL_ENTITY then
    local gcomp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "gfx_id" )
    local gfx_id = 1
    local x_id = 1
    
    if gcomp ~= nil then
        gfx_id = ComponentGetValue2( gcomp, "value_int" )
        x_id = math.floor( (gfx_id+7)*0.125 )

        if gfx_id == 24 then
            gfx_id = 1 
        else
            gfx_id = gfx_id + 1 
        end

        ComponentSetValue2( gcomp, "value_int", gfx_id )
    end

    local players = EntityGetInRadiusWithTag( x, y, 999, "player_unit" )

    if #players > 0 then
        for i=1,#players do
            local pid = players[i]

            if pid ~= nil and pid ~= shooter and pid ~= NULL_ENTITY then
                local px, py = EntityGetTransform( pid )
                py = py - 17

                GameCreateSpriteForXFrames( "data/projectiles_gfx/is_that_a_uav_" .. x_id .. ".png", px, py-4, true, 0, 0, 1, true )
            end
        end
    end
end

