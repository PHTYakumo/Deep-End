dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local parent_id = EntityGetParent(entity_id)
local root_id = EntityGetRootEntity(entity_id)

local x, y = EntityGetTransform(entity_id)
local px, py = EntityGetTransform(root_id)
py = py - 4

local ncomp = EntityGetFirstComponent( entity_id, "VariableStorageComponent" )
if ncomp == nil then return end

local scomp = EntityGetFirstComponent( entity_id, "SpriteComponent" )
if scomp == nil then return end

-- GamePrint( tostring(root_id) .. ", " .. tostring(parent_id) .. ", " .. tostring(entity_id) )
EntitySetTransform( parent_id, px, py - 4 )
EntityApplyTransform( parent_id, px, py - 4 )

if EntityHasTag( root_id, "player_unit" ) and GameGetFrameNum() > 60 then
    local dist = ( (x-px)^2 + (y-py)^2 )^0.5
    local do_shot = false
    
    if dist > 600 then
        EntitySetTransform( entity_id, px, py + 128 * sign(py-y) )
        EntityApplyTransform( entity_id, px, py + 128 * sign(py-y) )
        
        ComponentSetValue2( scomp, "alpha", 0.2 )
        return
    else
        local wand_id = EntityGetParent(parent_id)
        local acomp = EntityGetFirstComponentIncludingDisabled( wand_id, "AbilityComponent" )

        if EntityHasTag( wand_id, "wand" ) and acomp ~= nil then
            local shot_times = ComponentGetValue2( acomp, "stat_times_player_has_shot" )

            if shot_times > ComponentGetValue2( ncomp, "value_int" )
            and wand_id == tonumber( ComponentGetValue2( ncomp, "value_string" ) ) then
                do_shot = true
            else
                ComponentSetValue2( ncomp, "value_string", tostring(wand_id) )
            end

            -- GamePrint( tostring(shot_times) .. ", " .. tostring(ComponentGetValue2( ncomp, "value_int" )) )
            ComponentSetValue2( ncomp, "value_int", shot_times )
        else
            ComponentSetValue2( ncomp, "value_string", "NULL_ENTITY" )
            ComponentSetValue2( ncomp, "value_int", 0 )
            ComponentSetValue2( ncomp, "value_bool", false )
        end
    end

    if dist < 8 then do_shot = false end

    local mcomp = EntityGetFirstComponent( root_id, "ControlsComponent" )
    if mcomp ~= nil then px,py = ComponentGetValueVector2( mcomp, "mMousePosition") end

    dist = ( (x-px)^2 + (y-py)^2 )^0.5
    if dist > 24 then do_shot = false end

    EntitySetTransform( entity_id, px * 0.125 + x * 0.875, py * 0.12 + y * 0.88 )
    EntityApplyTransform( entity_id, px * 0.125 + x * 0.875, py * 0.12 + y * 0.88 )

    ComponentSetValue2( scomp, "alpha", clamp( 1.2 - dist * 0.03, 0.25, 1 ) )
    if do_shot then ComponentSetValue2( ncomp, "value_bool", true ) end
else
    ComponentSetValue2( ncomp, "value_bool", false )
    ComponentSetValue2( ncomp, "value_string", "NULL_ENTITY" )
    ComponentSetValue2( ncomp, "value_int", 0 )
    ComponentSetValue2( scomp, "alpha", 0 )

    EntitySetTransform( entity_id, px, py + 32 * sign(y-py) )
    EntityApplyTransform( entity_id, px, py + 32 * sign(y-py) )
end