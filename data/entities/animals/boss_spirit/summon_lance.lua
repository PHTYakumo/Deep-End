dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local tm = 0
local tmcomp
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

if ( comps ~= nil ) then
    for i,comp in ipairs( comps ) do
        local n = ComponentGetValue2( comp, "name" )
        if ( n == "branche_timer" ) then
            tm = ComponentGetValue2( comp, "value_int" )
            tmcomp = comp
            break
        end
    end
end

local angle = GameGetFrameNum() * 1.67
local branches = math.floor( tm / 27 ) + 2
local range = 360
local speed = 1600
local space = 360 / branches

for i=1,branches do

    local vx = math.cos( math.rad(angle)+math.rad(1.44) ) * speed
    local vy = math.sin( math.rad(angle)+math.rad(1.44) ) * speed
    local dx = math.cos( math.rad(angle) ) * range
    local dy = math.sin( math.rad(angle) ) * range

    -- shoot_projectile( entity_id, "data/entities/animals/boss_spirit/lance.xml", x - dx, y - dy, vx, vy )
    shoot_projectile( entity_id, "data/entities/projectiles/jimi_bullet.xml", x - dx, y - dy, vx, vy )

    angle = angle + space
end

tm = tm + 3
ComponentSetValue2( tmcomp, "value_int", tm )