dofile_once("data/scripts/lib/utilities.lua")

if ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" ) < 4 then return end
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local boss_id = EntityGetClosestWithTag( x, y, "deep_end_boss_robot" )
if boss_id == nil then return end

local bx, by = EntityGetTransform( boss_id )
local angle = GameGetFrameNum() / 21
local speed = 210

local vx = math.cos( math.rad(angle) ) * speed
local vy = math.sin( math.rad(angle) ) * speed

shoot_projectile( boss_id, "data/entities/animals/boss_robot/rocket/rocket_roll.xml", bx, by, vx, vy )