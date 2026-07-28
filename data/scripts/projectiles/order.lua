dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local radius = 512
local players = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )

if #players > 0 and not EntityHasTag( entity_id, "spells_to_power_target" ) then for i=1,#players do
	local pid = players[i]
    local px, py, cx, cy = EntityGetTransform( pid )
    
    edit_component( pid, "ControlsComponent", function(mcomp,vars)
        cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
    end)

    SetRandomSeed( GameGetFrameNum() + i, cx + y )
    local times = math.ceil( 5 / #players )

    for j=1,times do
        local dx = Random( -12, 12 ) + cx
        local dy = Random( -5, 5 ) - 375 + cy + j
        
        local eid = shoot_projectile( pid, "data/entities/projectiles/deck/order_projectile.xml", dx, dy, 0, 1 )
    end

    GameCreateSpriteForXFrames( "data/projectiles_gfx/order_aim.png", cx, cy-4, true, 0, 0, 36, true )
    GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/bullet_fire_heavy/create", px, py )
end end
