dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), entity_id )

local length = Random( 0, 10 ) * 50 + 250
local angle = GameGetFrameNum() * 0.5

vx = math.cos( angle ) * length
vy = -math.sin( angle ) * length

shoot_projectile( entity_id, "data/entities/projectiles/deck/tentacle.xml", x, y, vx, vy )
