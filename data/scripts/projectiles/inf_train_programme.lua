dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y, num, cx, cy = EntityGetTransform( entity_id )

local pid = EntityGetClosestWithTag( x, y, "player_unit" )
if pid == nil then return end

edit_component( pid, "ControlsComponent", function(mcomp,vars)                  -- get mouse pos
    cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
end)

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if comps[3] == nil then return end

local executed_times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )

if executed_times == 1 then
    local guides = EntityGetInRadiusWithTag( x, y, 512, "de_inf_train" )
    if guides[2] ~= nil then for i=2,#guides do EntityKill(guides[i]) end end   -- kill other spawner

    for i,comp in ipairs( comps ) do
        local n = ComponentGetValue2( comp, "name" )
        
        if n == "x" then ComponentSetValue2( comp, "value_float", cx )           -- save init pos
        elseif n == "y" then ComponentSetValue2( comp, "value_float", cy )
        elseif n == "num" then ComponentSetValue2( comp, "value_int", clamp( #guides + 1, 3, 13 ) ) end
    end

    EntitySetTransform( entity_id, cx, cy, num, 1, 1 )
    EntityApplyTransform( entity_id, cx, cy, num, 1, 1 )

    return
else
    for i,comp in ipairs( comps ) do
        local n = ComponentGetValue2( comp, "name" )
        
        if n == "x" then x = ComponentGetValue2( comp, "value_float" )          -- get init pos
        elseif n == "y" then y = ComponentGetValue2( comp, "value_float" )
        elseif n == "num" then num = clamp( ComponentGetValue2( comp, "value_int" ), 3, 13 ) end
    end
end

local dist = get_magnitude( x - cx, y - cy )

if dist >= 500 then                                                             -- closer if too far
    x = cx + ( x - cx ) * 495 / dist
    y = cy + ( y - cy ) * 495 / dist

    for i,comp in ipairs( comps ) do
        local n = ComponentGetValue2( comp, "name" )
        
        if n == "x" then ComponentSetValue2( comp, "value_float", x )
        elseif n == "y" then ComponentSetValue2( comp, "value_float", y ) end
    end

    dist = 495
end

if executed_times == 175 or num >= 13 then                                      -- spawn trains
    local train_id = EntityLoad( "data/entities/projectiles/deck/inf_train_portal.xml", x, y )
    local spnum = clamp( num, 3, 5 )

    local sx = ( cx - x ) / dist
    local sy = ( cy - y ) / dist

    local tx = x + sx * 75
    local ty = y + sy * 75

    local xml_type = ".xml"
    if sx < 0 then xml_type = "_left" .. xml_type end

    for i=1,spnum do
        if i == spnum then train_id = EntityLoad( "data/entities/projectiles/deck/inf_train_engine" .. xml_type, tx, ty )
        elseif i == 1 then train_id = EntityLoad( "data/entities/projectiles/deck/inf_train_engine_reverse" .. xml_type, tx, ty )
        else train_id = EntityLoad( "data/entities/projectiles/deck/inf_train" .. xml_type, tx, ty ) end

        local tcomps = EntityGetComponent( train_id, "VariableStorageComponent" )

        if tcomps[7] ~= nil then for j,comp in ipairs( tcomps ) do
            local n = ComponentGetValue2( comp, "name" )
            
            if n == "x" then ComponentSetValue2( comp, "value_float", x )
            elseif n == "y" then ComponentSetValue2( comp, "value_float", y )
            elseif n == "vx" then ComponentSetValue2( comp, "value_float", sx * 777 )
            elseif n == "vy" then ComponentSetValue2( comp, "value_float", sy * 777 )
            elseif n == "num" then ComponentSetValue2( comp, "value_int", 100 * ( i - 1 ) + num ) end
        end end

        tx = tx + sx * 148
        ty = ty + sy * 148
    end

    EntityKill(entity_id)
    return
end

local rot = math.pi * 1.5 - math.atan2( x - cx, y - cy )
dist = dist / 81

EntitySetTransform( entity_id, x, y, rot, dist, 1 )                             -- update trans
EntityApplyTransform( entity_id, x, y, rot, dist, 1 )

local do_beep = executed_times % 32

if do_beep == 13 and executed_times < 150 then                                  -- count down
    executed_times = math.floor( ( 175 - executed_times ) * 0.03125 ) * 0.5
    num = clamp( num, 3, 5 )

    local text_1 = GameTextGetTranslatedOrNot("$ddINF_TRAIN_1")
    local text_2 = GameTextGetTranslatedOrNot("$ddINF_TRAIN_2")

    GamePrint( text_1 .. tostring(executed_times) .. text_2 .. tostring(num) )
    for i=1,8 do GamePlaySound( "data/audio/Desktop/animals.bank", "animals/mine/beep", x, y ) end
end