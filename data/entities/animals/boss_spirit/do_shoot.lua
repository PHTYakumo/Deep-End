dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local player = EntityGetWithTag( "player_unit" )

for i=1,#player do -- set input to avoid it?
    local px,py = EntityGetTransform( player[i] )
    py = py - 4
    
    local angle = math.atan2( y-py, px-x )
    local speed = 111

    px = math.cos( angle ) * speed
    py = -math.sin( angle ) * speed

    shoot_projectile( entity_id, "data/entities/animals/boss_spirit/orb.xml", x, y-17, px, py )
    -- EntityLoad( "data/entities/animals/boss_spirit/summon_lance.xml", px, py )
end

