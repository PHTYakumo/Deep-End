dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)

if EntityGetIsAlive( root_id ) and not EntityHasTag( root_id, "player_unit" ) and not EntityHasTag( root_id, "boss" ) and not EntityHasTag( root_id, "robot" ) then
	local damagemodels = EntityGetComponent( root_id, "DamageModelComponent" )

	if damagemodels ~= nil then
		for i,damagemodel in ipairs(damagemodels) do
			-- ComponentSetValue2( damagemodel, "materials_that_damage", "acid,lava,magic_liquid_mana_regeneration" )
			-- ComponentSetValue2( damagemodel, "materials_how_much_damage", "0.004,0.002,0.008" )
			ComponentSetValue2( damagemodel, "blood_material", "metal_sand" )
			ComponentSetValue2( damagemodel, "blood_spray_material", "oil" )
			ComponentSetValue2( damagemodel, "blood_multiplier", 0.3 )
			-- ComponentSetValue2( damagemodel, "fire_probability_of_ignition", 0 )
			-- ComponentSetValue2( damagemodel, "air_needed", false )
		end

		EntityAddTag( root_id, "robot" )
		EntitySetDamageFromMaterial( root_id, "magic_liquid_mana_regeneration", 0.012 )
	end
end

EntityKill(entity_id)

