dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local executed_times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )

if executed_times == 2 and not EntityHasTag( entity_id, "mortal" ) then EntityAddTag( entity_id, "mortal" )
elseif executed_times == 175 then EntitySetComponentsWithTagEnabled( entity_id, "enabled_in_world", false ) end

local vcomp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "enable_when_player_seen" )
if vcomp == nil then return end

local bind_id = ComponentGetValue2( vcomp, "value_int" )
if bind_id < 0 or bind_id == NULL_ENTITY or not EntityGetIsAlive(bind_id) then return end

local x, y = EntityGetTransform( bind_id )
if x == nil or y == nil then return end

local fx = ComponentGetValue2( vcomp, "value_float" )
local fy = ComponentGetValue2( vcomp, "value_string" )
fy = tonumber(fy)

EntitySetTransform( entity_id, x + fx, y + fy, math.atan2( fx, -fy ) )
EntityApplyTransform( entity_id, x + fx, y + fy, math.atan2( fx, -fy ) )