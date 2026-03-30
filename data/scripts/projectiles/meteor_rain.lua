dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local root_id = EntityGetRootEntity(entity_id)
if not EntityHasTag( root_id, "de_meteor_rain_meteor" ) then EntityAddTag( root_id, "de_meteor_rain_meteor" ) end

local radius = 512
local players = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )

if ( #players > 0 ) then
	SetRandomSeed( GameGetFrameNum() + y, x + entity_id )

	local pid = players[Random( 1, #players )]
	local px, py = EntityGetTransform( pid )
    local cx, cy

    edit_component( pid, "ControlsComponent", function(mcomp,vars)
        cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
    end)

	local vx = cx - px
	local vy = cy - py
    px = px - Random( 300, 450 ) * ( vx / math.abs(vx) )
    py = py - Random( 250, 400 )
	vx = ( cx - px ) * Random( 80, 120 ) + Random( -10, 10 )
	vy = ( cy - py ) * Random( 80, 120 ) + Random( -10, 10 )
	
	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/meteor_rain_meteor.xml", px, py, vx, vy )

	vx = ( cx - px ) * Random( 60, 100 ) + Random( -5, 5 )
	vy = ( cy - py ) * Random( 60, 100 ) + Random( -5, 5 )

	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/meteor.xml", px, py, vx, vy )

	if script_wait_frames( entity_id, 15 ) then return end

	px, py = EntityGetTransform( pid )
	vx = cx - px
    px = px - Random( 250, 400 ) * ( vx / math.abs(vx) )
    py = py - Random( 300, 450 )
	vx = ( cx - px ) * Random( 60, 120 )
	vy = ( cy - py ) * Random( 60, 120 )

	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/meteor.xml", px, py, vx, vy )
	
	GameScreenshake( 66 )
end


