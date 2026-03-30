dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local cx, cy = DEBUG_GetMouseWorld()
local follow_percentage = 1

if EntityHasTag( entity_id, "de_my_soul" ) then follow_percentage = 0.02 end

x = (1-follow_percentage)*x + follow_percentage*cx
y = (1-follow_percentage)*y + follow_percentage*cy

EntitySetTransform( entity_id, x, y )
EntityApplyTransform( entity_id, x, y )

if not EntityHasTag( entity_id, "de_my_soul" ) then return end

local executed_times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
local beep_frame = 0

if executed_times <= 666 then
    for i=1,36 do
        beep_frame = beep_frame + 37 - i

        if executed_times == beep_frame then
            GamePlaySound( "data/audio/Desktop/animals.bank", "animals/mine/beep", x, y )
            break
        end
    end
elseif executed_times <= 777 then
    beep_frame = math.ceil( ( executed_times - 666 ) / 37 )

    for i=1,beep_frame do GamePlaySound( "data/audio/Desktop/animals.bank", "animals/mine/beep", x, y ) end
else
    for i=1,38 do GamePlaySound( "data/audio/Desktop/animals.bank", "animals/mine/beep", x, y ) end

    EntityKill(entity_id)
end