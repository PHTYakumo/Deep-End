dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, a, px, py = EntityGetTransform( entity_id )

local pl = EntityGetClosestWithTag( x, y, "player_unit" )
if pl ~= nil then px, py = EntityGetTransform( pl ) end

EntitySetTransform( entity_id, px, py )
EntityApplyTransform( entity_id, px, py )

EntityLoad( "data/entities/animals/boss_robot/other/aiming_shot.xml", x, y )
SetRandomSeed( x + GameGetFrameNum(), py + entity_id )

local many = Random(1,4)
a = math.pi * Random( -100, 100 ) * 0.01

for i=1,many do
    local vx = math.cos( a ) * 70
    local vy = math.sin( a ) * 70

    shoot_projectile( entity_id, "data/entities/animals/boss_robot/other/laser_beam.xml", px - vx * 4.5, py - vy * 4.5, vx, vy )
    a = a + math.pi * 0.16 / many
end

