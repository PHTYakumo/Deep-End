dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetParent( entity_id )

if ( player_id ~= NULL_ENTITY ) and ( entity_id ~= player_id ) then
    if EntityHasTag( player_id, "chaos_frankenstein" ) then return end
    local px,py,pr,psx,psy = EntityGetTransform( player_id ) -- get player transform

    if ( EntityHasTag( player_id, "player_unit" ) ) then
        local if_tap
        local tapcomp
        local comps = EntityGetComponent( player_id, "VariableStorageComponent" )
        local bcomp = EntityGetFirstComponent( player_id, "HitboxComponent" )
        local fcomp = EntityGetFirstComponent( player_id, "CharacterDataComponent" )
        local gcomp = EntityGetFirstComponent( player_id, "CharacterPlatformingComponent" )

        if ( comps ~= nil ) then
            for i,comp in ipairs( comps ) do
                local n = ComponentGetValue2( comp, "name" )
                if ( n == "gravity_if_tap" ) then
                    if_tap = ComponentGetValue2( comp, "value_bool" )
                    tapcomp = comp
                    break
                end
            end
        end
            
        if ( fcomp ~= nil ) then
            local flight = ComponentGetValue2( fcomp, "mFlyingTimeLeft" )

            if flight > 4096 then return end

            ComponentSetValue2( fcomp, "mFlyingTimeLeft", -1 )
        end
        
        if ( fcomp ~= nil ) and ( gcomp ~= nil ) and ( tapcomp ~= nil ) then
            local is_jumping = false
            
            component_read(EntityGetFirstComponent(player_id, "ControlsComponent"), { mButtonDownUp = false }, function(controls_comp)
                is_jumping = controls_comp.mButtonDownUp or false
            end)

            if ( is_jumping ) and ( if_tap ) then
                local pixel_gravity = -ComponentGetValue2( gcomp, "pixel_gravity" )

                ComponentSetValue2( gcomp, "pixel_gravity", pixel_gravity )

                if ( GameHasFlagRun( "ATTACK_FOOT_CLIMBER" ) ) then
                    pixel_gravity = pixel_gravity * 3.0
                else
                    pixel_gravity = pixel_gravity * 0.3
                end

                edit_component( player_id, "VelocityComponent", function(vcomp,vars)
                    local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity")
                    ComponentSetValueVector2( vcomp, "mVelocity", vx, pixel_gravity )
                end)
        
                edit_component( player_id, "CharacterDataComponent", function(ccomp,vars)
                    local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity")
                    ComponentSetValueVector2( ccomp, "mVelocity", vx, pixel_gravity )
                end)

                local arm_r = EntityGetAllChildren( player_id, "player_arm_r" )

                if ( arm_r ~= nil ) then
                    local tscomps = EntityGetComponent( arm_r[1], "InheritTransformComponent" )

                    if ( tscomps ~= nil ) then for i,comp in ipairs( tscomps ) do
                        if ( ComponentGetValue2( comp, "parent_hotspot_tag" ) == "right_arm_root" ) then
                            ComponentSetValue2( comp, "only_position", false )
                            break
                        end
                    end end -- the stain icons may show abnormal when flipping with opposite scale_x, so always false
                end

                -- If you flip over on the ceiling you'll get stuck

                if ( bcomp ~= nil ) then
                    
                    local hitboxmax = -ComponentGetValue2( bcomp, "aabb_min_y" )
                    local hitboxmin = -ComponentGetValue2( bcomp, "aabb_max_y" )

                    ComponentSetValue2( bcomp, "aabb_max_y", hitboxmax )
                    ComponentSetValue2( bcomp, "aabb_min_y", hitboxmin )
                end

                EntitySetTransform( player_id, px, py, pr, psx, -psy ) -- flip player entity
                GamePlaySound( "data/audio/Desktop/animals.bank", "animals/ultimate_killer/damage/projectile", px, py )
            end
            
            if ( is_jumping ) then
                ComponentSetValue2( tapcomp, "value_bool", false )
            else
                ComponentSetValue2( tapcomp, "value_bool", true )
            end
        end
    elseif ( not EntityHasTag( player_id, "boss" ) ) and ( not EntityHasTag( player_id, "wand_ghost" ) ) then
        if script_wait_frames( entity_id, 40 ) then  return end
            
        local hitboxmax = 0
        local hitboxmin = 0

        local fcomp = EntityGetFirstComponent( player_id, "CharacterDataComponent" )
        local bcomp = EntityGetFirstComponent( player_id, "HitboxComponent" )
        local gcomp = EntityGetFirstComponent( player_id, "CharacterPlatformingComponent" )

        if ( fcomp ~= nil ) then
            hitboxmax = -ComponentGetValue2( fcomp, "collision_aabb_min_y" )
            hitboxmin = -ComponentGetValue2( fcomp, "collision_aabb_max_y" )

            ComponentSetValue2( fcomp, "collision_aabb_max_y", hitboxmax )
            ComponentSetValue2( fcomp, "collision_aabb_min_y", hitboxmin )
        end

        if ( bcomp ~= nil ) then
            hitboxmax = -ComponentGetValue2( bcomp, "aabb_min_y" )
            hitboxmin = -ComponentGetValue2( bcomp, "aabb_max_y" )

            ComponentSetValue2( bcomp, "aabb_max_y", hitboxmax )
            ComponentSetValue2( bcomp, "aabb_min_y", hitboxmin )
        end

        if ( gcomp ~= nil ) then
            local pixel_gravity = -ComponentGetValue2( gcomp, "pixel_gravity" )

            ComponentSetValue2( gcomp, "pixel_gravity", pixel_gravity )

            EntitySetTransform( player_id, px, py - hitboxmax - hitboxmin + sign( pixel_gravity ) * 2, pr, psx, -psy )
            GamePlaySound( "data/audio/Desktop/animals.bank", "animals/ultimate_killer/damage/projectile", px, py )
        end
    end
end

