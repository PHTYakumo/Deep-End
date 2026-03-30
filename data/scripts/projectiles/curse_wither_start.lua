dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )

local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "effect_curse_wither_type" )

if ( comp ~= nil ) then
	local name = ComponentGetValue2( comp, "value_string" )
	
	comp = EntityGetFirstComponent( root_id, "DamageModelComponent" )
	
	if ( comp ~= nil ) then
		local mult = ComponentObjectGetValue2( comp, "damage_multipliers", name )
		
		if ( EntityHasTag( root_id, "de_curse_wither_NOT" ) ) then 
			mult = mult
		elseif ( EntityHasTag( root_id, "player_unit" ) ) then 
			mult = mult + 0.05
		else
			mult = mult + 0.25
		end

		ComponentObjectSetValue2( comp, "damage_multipliers", name, mult )
		
		--[[
		if ( mult > 0 ) then
			mult = mult + 0.25
			ComponentObjectSetValue2( comp, "damage_multipliers", name, mult )
		else
			EntityKill( entity_id )
		end
		]]--
	end
end