dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x + GameGetFrameNum(), y )

local secrets = { "RAINBOW_TRAIL", "POISON_TRAIL", "SEA_MIMIC", "ALL_ACID" }
local lists =
	{
		"SEA_LAVA", "SEA_WATER", "SEA_ACID", "SEA_SWAMP",
		"MATERIAL_ACID", "MATERIAL_BLOOD", "MATERIAL_OIL", "MATERIAL_WATER",
		"MIST_BLOOD", "MIST_ALCOHOL", "MIST_SLIME", "MIST_RADIOACTIVE",
		"ACID_TRAIL", "OIL_TRAIL", "GUNPOWDER_TRAIL", "WATER_TRAIL",
		"CIRCLE_FIRE", "CIRCLE_ACID", "CIRCLE_OIL", "CIRCLE_WATER"
	}

local mrnd = Random( 1, 21 )

if ( mrnd == 21  ) then
	local srnd = Random( 1, 4 )
	CreateItemActionEntity( secrets[srnd], x, y )
else
	CreateItemActionEntity( lists[mrnd], x, y )
end

EntityKill( entity_id )