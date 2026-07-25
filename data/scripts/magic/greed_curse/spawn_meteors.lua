dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), x + y )
local count = Random(1,3)

for i=1,count do
	local px, py = x + Random( -100, 100 ) * 2, y - 325
	local vx, vy = Random( -100, 100 ) * 2.5, Random( -100, 100 ) * 5 + 1250

	shoot_projectile( entity_id, "data/entities/misc/greed_curse/greed_meteor.xml", px, py, vx, vy )
end

GameScreenshake( 8 * count )
