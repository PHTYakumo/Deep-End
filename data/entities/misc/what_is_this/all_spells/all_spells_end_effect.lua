dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local player = EntityGetClosestWithTag( x, y, "player_unit")
if player ~= nil then x, y = EntityGetTransform( player ) end

SetRandomSeed( GameGetFrameNum(), entity_id )
local fl = Random(6,12)

local fx = x + ( Random(6,12) - 9 ) * 15
local fy = y - Random(6,12) * 3

for i=1,fl do
    local rad = math.pi *2 * i / fl
    shoot_projectile( entity_id, "data/entities/projectiles/ultimate_ultra_killer_megabomb.xml", fx, fy, math.cos(rad), math.sin(rad) )
end

-- GameCreateParticle()
