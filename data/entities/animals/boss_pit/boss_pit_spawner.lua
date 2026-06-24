dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() + entity_id, x + y )

local sprnd = Random( 1, 666 )
local boss_id

if Random( 0, 66 ) > 13 and ( sprnd == 66 or ( y < -5120 and sprnd > 660 ) ) then
	boss_id = EntityLoad( "data/entities/animals/maggot_tiny/maggot_tiny.xml", x, y )
elseif ( ( sprnd > 13 and sprnd < 17 ) or ( sprnd > 61 and sprnd < 66 ) ) and y >= -5120 then
	boss_id = EntityLoad( "data/entities/animals/parallel/tentacles/parallel_tentacles.xml", x, y )
elseif ( ( sprnd > 8 and sprnd < 13 )  or ( sprnd > 66 and sprnd < 70 ) ) and y >= -5120 then
	boss_id = EntityLoad( "data/entities/animals/parallel/alchemist/parallel_alchemist.xml", x, y )
end

if boss_id ~= nil then
	local hcomp = EntityGetFirstComponent( boss_id, "BossHealthBarComponent" )
	if hcomp ~= nil then EntityRemoveComponent( boss_id, hcomp ) end

	EntityAddTag( boss_id, "holy_mountain_creature" )
end

EntityKill( entity_id )