dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local player = EntityGetWithTag( "player_unit" )
SetRandomSeed( GameGetFrameNum(), entity_id )

local set_cd_1, set_cd_2 = Random( 39, 52 ), 39
local cd_1, cdcomp_1 = set_cd_1, nil

if entity_id ~= nil and #player > 0 then
    local click = false
    local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

    if comps ~= nil then
        for i,comp in ipairs( comps ) do
            local n = ComponentGetValue2( comp, "name" )

            if n == "cd_timer_1" then
                cd_1 = ComponentGetValue2( comp, "value_int" )
                cdcomp_1 = comp
                break
            end
        end

        for i=1,#player do -- set input to avoid it?
            component_read( EntityGetFirstComponent(player[i], "ControlsComponent"), { mButtonDownFire = false },
                function(controls_comp)
                    click = controls_comp.mButtonDownFire or false
                end
            )

            if cdcomp_1 ~= nil and click then
                if cd_1 == 0 then
                    shoot_projectile( entity_id, "data/entities/projectiles/deck/all_peace.xml", x, y, 0, 0 )
                    cd_1 = set_cd_1

                    if EntityHasTag( player[i], "chaos_frankenstein" ) then
                        GamePrint( "$shoot_boss_spirit_3" )
                        cd = set_cd_2
                    elseif Random(1,10) > 5 then
                        GamePrint( "$shoot_boss_spirit_2" )
                    else
                        GamePrint( "$shoot_boss_spirit_1" )
                    end
                end
            end
        end

        cd_1 = math.max( cd_1 - 1, 0 )
        ComponentSetValue2( cdcomp_1, "value_int", cd_1 )
    end
end

