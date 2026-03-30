dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( entity_id )
local attack_cd = 12

function do_flash( mdir1, mdir2 )
    if ( player_id ~= nil ) and ( player_id ~= NULL_ENTITY ) then
        EntityInflictDamage( player_id, 0.12, "DAMAGE_CURSE", "$dSword", "NONE", 0, 0, player_id )
        
        -- local buff = EntityLoad( "data/entities/misc/effect_protection_all_immediate.xml" )
        -- EntityAddChild( player_id, buff )

        local x, y = EntityGetTransform( entity_id )
        local ox,oy
        edit_component( player_id, "ControlsComponent", function(comp,vars)
            ox,oy = ComponentGetValueVector2( comp, "mAimingVector")
        end)

        if ( mdir1 == 1 ) then
            oy = oy / 5 + 120
        elseif ( mdir1 == 2 ) then
            oy = oy / 5 - 120
        end
        if ( mdir2 == 1 ) then
            ox = ox / 5 - 225
        elseif ( mdir2 == 2 ) then
            ox = ox / 5 + 225
        end
        
        shoot_projectile( player_id, "data/entities/projectiles/deck/lightning_teleport.xml", x, y, ox, oy )

        edit_component( player_id, "VelocityComponent", function(vcomp,vars)
            ComponentSetValueVector2( vcomp, "mVelocity", 10*ox, 10*oy )
        end)
        
        edit_component( player_id, "CharacterDataComponent", function(ccomp,vars)
            ComponentSetValueVector2( ccomp, "mVelocity", 10*ox, 10*oy )
        end)
    end
end

function cursor_tele()
    if ( player_id ~= nil ) and ( player_id ~= NULL_ENTITY ) then
        EntityInflictDamage( player_id, 0.24, "DAMAGE_CURSE", "$dSword", "NONE", 0, 0, player_id )
        EntityAddChild( player_id, EntityLoad( "data/entities/misc/effect_protection_all_shorter.xml" ) )

        local cx,cy
        edit_component( player_id, "ControlsComponent", function(mcomp,vars)
            cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
        end)
        
        shoot_projectile( player_id, "data/entities/projectiles/deck/just_teleport.xml", cx, cy, 0, 0 )
    end
end

if ( entity_id ~= nil ) and ( player_id ~= nil ) then
    local state = 0
    local flash_cd_frame = attack_cd
    local statecomp
    local flcdcomp
    local rclick = false
    local move_dir_1 = 0 -- 1 down, 2 up, else do-nothing
    local move_dir_2 = 0 -- 1 left, 2 right, else do-nothing

    component_read(EntityGetFirstComponent(player_id, "ControlsComponent"), { mButtonDownRightClick = false }, function(controls_comp)
        rclick = controls_comp.mButtonDownRightClick or false
    end)
    component_read(EntityGetFirstComponent(player_id, "ControlsComponent"), { mButtonDownDown = false }, function(controls_comp)
        if ( controls_comp.mButtonDownDown ) then 
            move_dir_1 = 1 + move_dir_1 
        end
    end)
    component_read(EntityGetFirstComponent(player_id, "ControlsComponent"), { mButtonDownUp = false }, function(controls_comp)
        if ( controls_comp.mButtonDownUp ) then 
            move_dir_1 = 2 + move_dir_1 
        end
    end)
    component_read(EntityGetFirstComponent(player_id, "ControlsComponent"), { mButtonDownLeft = false }, function(controls_comp)
        if ( controls_comp.mButtonDownLeft ) then 
            move_dir_2 = 1 + move_dir_2 
        end
    end)
    component_read(EntityGetFirstComponent(player_id, "ControlsComponent"), { mButtonDownRight = false }, function(controls_comp)
        if ( controls_comp.mButtonDownRight ) then 
            move_dir_2 = 2 + move_dir_2 
        end
    end)
 
    local comps = EntityGetComponent( player_id, "VariableStorageComponent" )
    if ( comps ~= nil ) then
        for i,comp in ipairs( comps ) do
            local n = ComponentGetValue2( comp, "name" )
            if ( n == "tap_state" ) then
                state = ComponentGetValue2( comp, "value_int" )
                statecomp = comp
            elseif ( n == "flash_timer" ) then
                flash_cd_frame = ComponentGetValue2( comp, "value_int" )
                flcdcomp = comp
                break
            end
        end
    end

    if ( statecomp ~= nil ) and ( flcdcomp ~= nil ) then
        if ( flash_cd_frame == 0 ) and ( rclick ) then
            if ( move_dir_1 == 3 ) or ( move_dir_2 == 3 ) then
                cursor_tele() 
                flash_cd_frame = attack_cd
            else
                do_flash( move_dir_1, move_dir_2 )
                flash_cd_frame = attack_cd
            end
        end

        flash_cd_frame = math.min( math.max( flash_cd_frame-1, 0 ), attack_cd )

        ComponentSetValue2( flcdcomp, "value_int", flash_cd_frame )
    end
end

