dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local phase = 0
local offset = 128

for i=1,4 do
    local px = x - math.cos( phase ) * offset
    local py = y - math.sin( phase ) * offset

    local vx = math.cos( phase ) * offset * 7
    local vy = math.sin( phase ) * offset * 7

    shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/heavenly_wrath_laser.xml", px, py, vx, vy )

    phase = phase + math.pi * 0.5
    vx = math.cos( phase ) * offset * 3
    vy = math.sin( phase ) * offset * 3

    shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/heavenly_wrath_laserbeam.xml", px, py, vx, vy )
    shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/heavenly_wrath_laserbeam.xml", px, py, vy, -vx )
    shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/heavenly_wrath_laserbeam.xml", px, py, -vx, -vy )
    shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/heavenly_wrath_laserbeam.xml", px, py, -vy, vx )
end

GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", x, y )
GameScreenshake( 66 )

local enemies = EntityGetInRadiusWithTag( x, y, offset, "de_ghosty_enemy")
if enemies then for i=1,#enemies do EntityKill(enemies[i]) end end

