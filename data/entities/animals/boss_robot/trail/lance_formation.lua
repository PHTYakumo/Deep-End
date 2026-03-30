dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent" )
if comp == nil then return end

local form_type = ComponentGetValue2( comp, "value_int" )
local x, y = EntityGetTransform( entity_id )

local player = EntityGetClosestWithTag( x, y, "player_unit" )
if player == nil then return end

local boss_id = EntityGetClosestWithTag( x, y, "deep_end_boss_robot" )
if boss_id ~= nil then entity_id = boss_id end

local px, py = EntityGetTransform( player )
x, y = EntityGetTransform( entity_id )

local circle = math.pi * 2
local dx, dy = px - x, py - y

if form_type == 1 then
    local count = 30
    local range = 500

    local rotation_rad = -circle / 120
    local dir = math.atan2( py-y, px-x ) - ( count-1 ) * rotation_rad * 0.5
    
    for i=1,count do
        local dist = range + 40 * math.abs( count * 0.5 + 0.5 - i ) -- 1080 ~ 520 ~ 1080

        local vx = math.cos( dir )
        local vy = math.sin( dir )
        
        local nx = px - vx * dist
        local ny = py - vy * dist

        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, vx, vy )
        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, vx*20, vy*20 )
        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, -vx, -vy )
        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, -vx*20, -vy*20 )

        dir = dir + rotation_rad
    end
elseif form_type == 2 then
    local count = 32
    local range = 1120

    local rotation_rad = -circle / 120
    local dir = math.atan2( py-y, px-x ) - ( count-1 ) * rotation_rad * 0.5
    
    for i=1,count do
        local dist = range - 40 * math.abs( count * 0.5 + 0.5 - i ) -- 500 ~ 1100 ~ 500

        local vx = math.cos( dir )
        local vy = math.sin( dir )
        
        local nx = px - vx * dist
        local ny = py - vy * dist

        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, vx, vy )
        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, vx*20, vy*20 )
        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, -vx, -vy )
        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, -vx*20, -vy*20 )

        dir = dir + rotation_rad
    end
elseif form_type == 3 then
    local mx = ( x + px ) * 0.5
    local my = ( y + py ) * 0.5

    local count = 60
    local range = 1100

    for i=1,count do
        local interval = range / ( count-1 )
        local nx = mx + range/2 - ( i-1 ) * interval
        local ny = my + range/2

        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, 0, -2000 )
        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, 0, -20 )

        ny = my - range/2

        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, 0, 2000 )
        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, 0, 20 )
    end
elseif form_type == 4 then
    local mx = ( x + px ) * 0.5
    local my = ( y + py ) * 0.5

    local count = 40
    local range = 778

    for i=1,count do
        local interval = range / ( count-1 )

        local sx = ( i-1 ) * interval
        local sy = range - sx

        local nx = mx - sx
        local ny = my - sy

        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, 1414.2, 1414.2 )
        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, 14.142, 14.142 )

        nx = mx + sx
        ny = my + sy

        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", nx, ny, -1414.2, -1414.2 )
        shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", nx, ny, -14.142, -14.142 )
    end
end
