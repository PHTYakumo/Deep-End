dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/de_input.lua")

local entity_id = GetUpdatedEntityID()
local px,py,pr,psx,psy = EntityGetTransform( entity_id )

local tap_detecting_frame = math.max( ModSettingGet( "DEEP_END.DOUBLE_TAPPING" ), 0 )
local cd_frame = 18

function do_hook( where )
    if ( entity_id ~= NULL_ENTITY ) then
        local x, y = EntityGetTransform( entity_id )
        local ox,oy

        edit_component( entity_id, "ControlsComponent", function(comp,vars)
            ox,oy = ComponentGetValueVector2( comp, "mAimingVector")
        end)

        if ( where == 1 )then x = x - 8 end
        if ( where == 2 )then x = x + 8 end
        y = y - 4
        
        shoot_projectile( entity_id, "data/entities/projectiles/deck/special_hook.xml", x, y, 5*ox, 5*oy )
    end
end


function do_dash( where, flight, fcomp )
    -- maxflight?
    if ( flight > 0.25 ) then
        local pos_x, pos_y = EntityGetTransform( entity_id ) --GamePrint( "Dash!" )
        local buff

        if ( flight > 2.75 ) then 
            buff = EntityLoad( "data/entities/misc/effect_protection_all_shorter_full.xml", pos_x, pos_y ) 
        else
            buff = EntityLoad( "data/entities/misc/effect_protection_all_shorter.xml", pos_x, pos_y )
        end 
        
        EntityAddChild( entity_id, buff )
        EntityAddChild( entity_id, EntityLoad( "data/entities/misc/effect_melee_counter.xml", pos_x, pos_y ) )

        shoot_projectile( entity_id, "data/entities/projectiles/deck/dash_hook.xml", pos_x + 9*where, pos_y, 20*where, 0 )

        flight = math.max( 0, flight - 0.5 )
        ComponentSetValue2( fcomp, "mFlyingTimeLeft", flight )

        EntityRemoveStainStatusEffect( entity_id, "RADIOACTIVE", 5 )
        EntityRemoveStainStatusEffect( entity_id, "POISONED", 5 )
        EntityRemoveStainStatusEffect( entity_id, "FOOD_POISONING", 5 )
        EntityRemoveStainStatusEffect( entity_id, "OILED", 5 )
        EntityRemoveStainStatusEffect( entity_id, "TRIP", 5 )
        EntityRemoveStainStatusEffect( entity_id, "ALCOHOLIC", 5 )
        EntityRemoveStainStatusEffect( entity_id, "WEAKNESS", 5 )
    else
        GamePrint( "$tDASH" )
    end
    -- GlobalsSetValue( "fungal_shift_last_frame", "-30000" )
end

if ( entity_id ~= nil ) then
    local statecomp
    local tapcomp
    local cdcomp

    local state = 0
    local tap_time = 0
    local cd_count = 0

    local flight = 3
    local timer = 30

    local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
    if ( comps ~= nil ) then
        for i,comp in ipairs( comps ) do
            local n = ComponentGetValue2( comp, "name" )

            if ( n == "tap_state" ) then
                state = ComponentGetValue2( comp, "value_int" )
                statecomp = comp
            elseif ( n == "tap_timer" ) then
                tap_time = ComponentGetValue2( comp, "value_int" )
                tapcomp = comp
            elseif ( n == "cd_timer" ) then
                cd_count = ComponentGetValue2( comp, "value_int" )
                cdcomp = comp
            elseif ( n == "deep_end_map_timer" ) then
			    timer = ComponentGetValue2( comp, "value_int" )
            end
        end
    end

    local fcomp = EntityGetFirstComponent( entity_id, "CharacterDataComponent" )

    if ( fcomp ~= nil ) then
        flight = ComponentGetValue2( fcomp, "mFlyingTimeLeft" )
    end

    if ( statecomp ~= nil ) and ( tapcomp ~= nil ) and ( cdcomp ~= nil ) then
        local left_key = false
        local right_key = false
        local rclick = false

        local type_what = 0 
        -- nothing = 0, left = 1, right = 2, both = 3
        component_read(EntityGetFirstComponent(entity_id, "ControlsComponent"), { mButtonDownLeft = false }, function(controls_comp)
            left_key = controls_comp.mButtonDownLeft or false
        end)
        component_read(EntityGetFirstComponent(entity_id, "ControlsComponent"), { mButtonDownRight = false }, function(controls_comp)
            right_key = controls_comp.mButtonDownRight or false
        end)
        component_read(EntityGetFirstComponent(entity_id, "ControlsComponent"), { mButtonDownRightClick = false }, function(controls_comp)
            rclick = controls_comp.mButtonDownRightClick or false
        end)

        -- left = 01357, right = 01246
        if ( left_key ) then
            type_what = type_what+1
        end

        if ( right_key ) then
            type_what = type_what+2
        end

        local cx,cy = EntityGetTransform( entity_id )

        edit_component( entity_id, "ControlsComponent", function(mcomp,vars)
            cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
        end)

        local key_1 = ModSettingGet( "DEEP_END.PERK_DASH_HOOK_PRIMARY" )
        local key_2 = ModSettingGet( "DEEP_END.PERK_DASH_HOOK_SECONDARY" )
        local key_3 = ModSettingGet( "DEEP_END.PERK_DASH_HOOK_COMBINED" )
        local key_4 = ModSettingGet( "DEEP_END.PERK_DASH_SKY_GLIDE" )

        if cd_count <= 1 and de_key_judge( key_3, 9999 ) and ( de_key_judge( key_1, 0 ) or de_key_judge( key_2, -9999 ) ) then
            if timer < 30 then
                cd_count = cd_frame * 2
            
                do_hook( type_what )
            elseif EntityHasTag( entity_id, "de_map_tp" ) and timer >= 30 then
                cd_count = cd_frame * 5

                local tpx = math.floor( px * 100 ) * 0.01
                local tpy = math.floor( py * 100 ) * 0.01 - 4.00

                tpx = ( cx - tpx ) * 72 + tpx
                tpy = ( cy - tpy ) * 72 + tpy

                EntitySetTransform( entity_id, tpx, tpy )
                EntityApplyTransform( entity_id, tpx, tpy )

                GamePrint( GameTextGetTranslatedOrNot("$deep_end_map_tele_3") .. tostring(tpx) .. ", " .. tostring(tpy) )
            end
        end 

        if cd_count == 0 then
            if ( state == 7 ) and ( type_what < 3 ) then
                cd_count = cd_frame
                tap_time = 0
                state = 0

                do_dash( -1, flight, fcomp )
            elseif ( state == 6 ) and ( type_what < 3 ) then
                cd_count = cd_frame
                tap_time = 0
                state = 0

                do_dash( 1, flight, fcomp )
            elseif ( state == 5 ) and ( tap_time > 0 ) then
                if ( type_what == 1 ) then
                    state = 7
                elseif ( type_what == 2 ) then
                    tap_time = 0
                    state = 0
                end
            elseif ( state == 4 ) and ( tap_time > 0 ) then
                if ( type_what == 1 ) then
                    tap_time = 0
                    state = 0
                elseif ( type_what == 2 ) then
                    state = 6
                end
            elseif ( state == 3 ) and ( type_what == 0 ) and ( tap_time > 0 ) then
                state = 5
            elseif ( state == 2 ) and ( type_what == 0 ) and ( tap_time > 0 ) then
                state = 4
            elseif ( state == 1 ) then
                tap_time = tap_detecting_frame
                if ( type_what == 1 ) then
                    state = 3
                elseif ( type_what == 2 ) then
                    state = 2
                end
            elseif ( state == 0 ) and ( type_what == 0 ) then
                state = 1
            elseif ( tap_time == 0 ) or ( type_what == 3 ) then
                tap_time = 0
                state = 0
            end
        end
        
        --[[
        if ( cd_count == 1 ) then
            GamePrint( "Dash Skill Is Ready." )
        end
        ]]--
        
        cd_count = math.max( cd_count-1, 0 )
        tap_time = math.max( tap_time-1, 0 )

        ComponentSetValue2( statecomp, "value_int", state )
        ComponentSetValue2( tapcomp, "value_int", tap_time )
        ComponentSetValue2( cdcomp, "value_int", cd_count )

        local down_key, up_key = false, false

        component_read(EntityGetFirstComponent(entity_id, "ControlsComponent"), { mButtonDownDown = false }, function(controls_comp)
            down_key = controls_comp.mButtonDownDown or false
        end)

        component_read(EntityGetFirstComponent(entity_id, "ControlsComponent"), { mButtonDownJump = false, mButtonDownUp = false }, function(controls_comp)
            up_key = controls_comp.mButtonDownUp or controls_comp.mButtonDownJump or false
        end)

        type_what = -1

        if ( down_key ) then type_what = 30/31 end

        if ( down_key ) and ( up_key ) and ( flight < 0.05 ) then type_what = 0 end

        if ( de_key_judge( key_4, -9999 ) ) then
            type_what = 0

            if ( not up_key ) or ( flight > 0.01 ) then
                psy = 0
                ComponentSetValue2( fcomp, "mFlyingTimeLeft", flight - 0.01 )
            end
        end

        if ( type_what > -1 ) then
            edit_component( entity_id, "VelocityComponent", function(vcomp,vars)
                local fx,fy = ComponentGetValue2( vcomp, "mVelocity" )
                ComponentSetValueVector2( vcomp, "mVelocity", fx, fy * type_what + math.max(flight,3) * 4 * sign(psy) )
            end)

            edit_component( entity_id, "CharacterDataComponent", function(ccomp,vars)
                local fx,fy = ComponentGetValue2( ccomp, "mVelocity" )
                ComponentSetValueVector2( ccomp, "mVelocity", fx, fy * type_what + math.max(flight,3) * 4 * sign(psy) ) -- original drop speed: 350
            end)
        end
    end
    -- GamePrint( tostring(cd_count) )
    -- GamePrint( tostring(tap_time) )
    -- GamePrint( tostring(cd_count) )
end

