dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local enemies = EntityGetInRadiusWithTag( x, y, 48, "human" )
if #enemies < 1 then return end

local executed_times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
local vel = 72

if ( executed_times + 1 ) % 8 == 0 then vel = -1000 end
-- GamePrint( tostring(vel) )

for i=1,#enemies do
    local eid = enemies[i]

    if eid ~= nil and eid ~= NULL_ENTITY and ( EntityHasTag( eid, "homing_target" ) or EntityHasTag( eid, "player_unit" ) )
    and not EntityHasTag( eid, "wand_ghost" ) and not EntityHasTag( eid, "live_fungus" )
    then
        local px, py = EntityGetTransform( eid )
        px, py = x - px, y - py

        vel = vel / math.max( ( px^2 + py^2 )^0.5, 1 )
        px, py = px * vel, py * vel

        local vcomp = EntityGetFirstComponent( eid, "VelocityComponent" )
        local ccomp = EntityGetFirstComponent( eid, "CharacterDataComponent" )

        if vcomp ~= nil then
            local vx, vy = ComponentGetValueVector2( vcomp, "mVelocity" )
            vx, vy = vx + px, vy + py

            ComponentSetValueVector2( vcomp, "mVelocity", vx, vy )
        end

        if ccomp ~= nil then
            local vx, vy = ComponentGetValueVector2( ccomp, "mVelocity" )
            vx, vy = vx + px, vy + py

            ComponentSetValueVector2( ccomp, "mVelocity", vx, vy )
        end
    end
end
