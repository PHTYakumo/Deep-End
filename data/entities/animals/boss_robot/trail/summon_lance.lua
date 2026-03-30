dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local player = EntityGetWithTag( "player_unit" )

if ( entity_id ~= nil ) and ( #player > 0 ) then
    local pid = player[1]
    local px,py = EntityGetTransform( pid )
    local vx,vy = EntityGetTransform( pid )

    edit_component( pid, "CharacterDataComponent", function(vcomp,vars)
		vx,vy = ComponentGetValue2( vcomp, "mVelocity" )
	end)

    py = py - 4
    vy = clamp( vy, -50, 50 )

    local angle = math.atan2( -vy, vx )
    local vpara = 160
    local dpara = 2.25

    vx = math.cos( angle ) * vpara
    vy = -math.sin( angle ) * vpara

    local fx = px - vx * dpara
    local fy = py - vy * dpara

    shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/warning_line.xml", fx, fy, vx*10, vy*10 )
    shoot_projectile( entity_id, "data/entities/animals/boss_robot/trail/lance.xml", fx, fy, vx, vy )

    GameCreateSpriteForXFrames( "data/entities/animals/boss_robot/trail/warning.png", px, py-29, true, 0, 0, 3, true )
end