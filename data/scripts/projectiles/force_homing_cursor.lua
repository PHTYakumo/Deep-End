dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local pl = get_players()[1]
local x, y = EntityGetTransform( pl )

local cx, cy = ComponentGetValueVector2( EntityGetFirstComponent( pl, "ControlsComponent" ), "mMousePosition" )
cx, cy = cx - x, cy - y

SetRandomSeed( cy, cx )
local vel = Random( 200, 240 ) / math.max( get_magnitude( cx, cy ), 1 )

cx, cy = cx * vel, cy * vel
ComponentSetValueVector2( EntityGetFirstComponent( GetUpdatedEntityID(), "VelocityComponent" ), "mVelocity", cx, cy )

