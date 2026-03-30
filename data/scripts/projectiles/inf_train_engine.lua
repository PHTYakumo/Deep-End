dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

if ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" ) == 1 then
    local kids = EntityGetAllChildren(entity_id )

    if kids[5] ~= nil then for i =1,#kids do
        local cecomp = EntityGetFirstComponentIncludingDisabled( kids[i], "CellEaterComponent" )
        if cecomp ~= nil then EntitySetComponentIsEnabled( kids[i], cecomp, true ) end
    end end
end

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if comps[7] == nil then return end

local vx, vy, ox, oy, num, tid, tpcomp, radius = 0, 0, 0, 0, 700, 13, comps[6], 72

for i,comp in ipairs( comps ) do
    local n = ComponentGetValue2( comp, "name" )
    
    if n == "x" then ox = ComponentGetValue2( comp, "value_float" )
    elseif n == "y" then oy = ComponentGetValue2( comp, "value_float" )
    elseif n == "vx" then vx = ComponentGetValue2( comp, "value_float" )
    elseif n == "vy" then vy = ComponentGetValue2( comp, "value_float" )
    elseif n == "num" then num = ComponentGetValue2( comp, "value_int" )
    elseif n == "tele" then
        tele = ComponentGetValue2( comp, "value_int" )
        tpcomp = comp
    end
end

local dist = get_magnitude( x - ox, y - oy )
if sign( x - ox ) ~= sign( vx ) and sign( x - oy ) ~= sign( vy ) then dist = 0 end

tid = math.floor( num / 100 )
num = clamp( ( num % 100 ) * 450 - 550, 800, 5300 )

if tele <= 0 and dist >= num + 148 * tid then
    EntityAddComponent( entity_id, "LifetimeComponent", { lifetime = "9", } )
elseif tele > 0 and dist >= num then
    ComponentSetValue2( tpcomp, "value_int", tele - 1 )

    local pr = math.pi * 0.5 - math.atan2( vx, vy )
    radius = 96

    ox = ox + vx * 0.097
    oy = oy + vy * 0.097

    EntitySetTransform( entity_id, ox, oy )
    EntityApplyTransform( entity_id, ox, oy )

    local ptk = EntityLoad( "data/entities/projectiles/deck/fireblast_train.xml", x, y )

    EntitySetTransform( ptk, x, y, pr, 1, 1 )
    EntityApplyTransform( ptk, x, y, pr, 1, 1 )

    ptk = EntityLoad( "data/entities/projectiles/deck/fireblast_train.xml", ox, oy )

    EntitySetTransform( ptk, ox, oy, pr, 1, 1 )
    EntityApplyTransform( ptk, ox, oy, pr, 1, 1 )
    
    -- GamePlaySound( "data/audio/Desktop/projectiles.bank", "	player_projectiles/black_hole_big/destroy", x, y )
    -- GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/black_hole_giga/create", ox, oy )
end

--[[
    150 85  (175)
    200 125 (240)
    260 165 (310)
]]--

edit_component( entity_id, "VelocityComponent", function(vcomp,vars) ComponentSetValueVector2( vcomp, "mVelocity", vx, vy ) end )
-- PhysicsApplyForce( entity_id, 0, 0 )

if ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" ) < 3 then return end

local enemies = EntityGetInRadiusWithTag( x, y, radius, "mortal" )
if enemies[1] == nil then return end

for i=1,#enemies do
    if enemies[i] ~= NULL_ENTITY and ( EntityHasTag( enemies[i], "deep_end_boss_robot" ) or not EntityHasTag( enemies[i], "boss" ) ) then
        local px, py = EntityGetTransform( enemies[i] )

        if tele > 0 and dist >= num then
            px = px - x + ox
            py = py - y + oy

            EntitySetTransform( enemies[i], px, py )
            EntityApplyTransform( enemies[i], px, py )

            x = ox
            y = oy
        end

        if sign( px - x ) ~= sign( vx ) or sign( py - y ) ~= sign( vy ) then
            px = px * 0.12 + ( x + vx * 0.1 ) * 0.88
            py = py * 0.12 + ( y + vy * 0.1 ) * 0.88

            EntitySetTransform( enemies[i], px, py )
            EntityApplyTransform( enemies[i], px, py )
        end

        edit_component( enemies[i], "VelocityComponent", function(vcomp,vars)
            ComponentSetValueVector2( vcomp, "mVelocity", vx, vy )
        end)
        
        edit_component( enemies[i], "CharacterDataComponent", function(ccomp,vars)
            ComponentSetValueVector2( ccomp, "mVelocity", vx, vy )
        end)
    end
end

-- EntityAddRandomStains( entity_id, CellFactory_GetType("blood"), #enemies * 40 + 800 )