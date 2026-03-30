dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() + y, x + entity_id )

local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
local shooter

if pcomp ~= nil then
	shooter = ComponentGetValue2( pcomp, "mWhoShot" )
end

local radius = 512
local players = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )

if players[1] ~= nil and shooter ~= nil and shooter ~= NULL_ENTITY then
	local pid = players[Random( 1, #players )]
	local px, py = EntityGetTransform( shooter )
    local cx, cy

    edit_component( pid, "ControlsComponent", function(mcomp,vars)
        cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
    end)

    px = 1.75 * px - 0.75 * cx
    py = py - 240
	local vx = ( cx - px ) * 90
	local vy = ( cy - py ) * 90
	
	shoot_projectile( shooter, "data/entities/projectiles/deck/meteor_rain_newsun.xml", px, py, vx, vy )
	
	GameScreenshake( 666 )
end

local meteors = EntityGetInRadiusWithTag( x, y, radius, "de_meteor_rain_meteor" )

if meteors[1] ~= nil then 
	for i=1,#meteors do
		EntityKill(meteors[i])
	end
end


