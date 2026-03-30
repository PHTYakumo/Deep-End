dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x, y )
PhysicsApplyTorque( EntityLoad( "data/entities/buildings/physics_worm_deflector_crystal.xml", 277, -160 ), 999 )

local opts = { "gas", "fart", "fungal", "polar", "sewer", "smuggling" }
local rrnd = Random( 1, #opts ) + Random( 2, 5 )

for i=1,rrnd do
	EntityLoad( "data/entities/buildings/biome_modifiers/" .. opts[Random( 1, #opts )] .. "_pipe_spawner.xml", Random( 200, 500 ), 75 )
end

local opts = {
	"props/pumpkin_01", "props/pumpkin_02", "props/pumpkin_03",
	"props/pumpkin_04", "props/pumpkin_05", "items/easter/beer_bottle"
}

for i=1,#opts do
	local rx = Random( 1, 5 )
	local ry = Random( 1, 5 )

	rrnd = math.min(rx, ry) + 5*math.floor(i/6) - 3

	x = 230 + math.floor( ry^2 ) + 20 * ( rx - 1 ) + 100 * rrnd
	y = -( 108 + rx + ry + rrnd )

	for j=1,rrnd do EntityLoad( "data/entities/" .. opts[i] .. ".xml", x, y ) end
end

 -- from the start of production to the first release
local year, month, day = GameGetDateAndTimeLocal()
if month == 10 and day >= 5 and day <= 29 then EntityLoad( "data/items_gfx/deep_end_map/yakumoran.xml", 415, -385 ) end

EntityKill( entity_id )