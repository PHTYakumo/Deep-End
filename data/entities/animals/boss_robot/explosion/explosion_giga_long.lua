dofile_once("data/scripts/lib/utilities.lua")

local x, y = EntityGetTransform( GetUpdatedEntityID() )
SetRandomSeed( GameGetFrameNum() - y, GameGetFrameNum() - x )

local rx, ry = Random( -100, 100 ) * 0.67, Random( -100, 100 ) * 0.67
local px, py = x + rx, y + ry

EntityLoad( "data/entities/animals/boss_robot/explosion/explosion_giga_a.xml", px, py )
GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/critical_hit/create", px, py )

rx, ry = ( Random( -100, 100 ) * 0.67 ) * sign( rx ), ( Random( -100, 100 ) * 0.67 ) * sign( ry )
px, py = x - rx, y - ry

EntityLoad( "data/entities/animals/boss_robot/explosion/explosion_giga_b.xml", px, py )
GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/critical_hit/create", px, py )