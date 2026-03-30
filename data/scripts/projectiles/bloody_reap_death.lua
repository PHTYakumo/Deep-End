dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local money_prj = EntityLoad( "data/entities/projectiles/deck/bloody_reap_blood_drop.xml", x, y )
	local pm_hp_amount = 0.2
	
	component_readwrite( EntityGetFirstComponent(entity_id, "DamageModelComponent" ), { max_hp = 0 }, function(comp)
		if comp.max_hp > 0.2 then pm_hp_amount = clamp( comp.max_hp * 0.06, pm_hp_amount, 8 ) end
	end)
	
	EntityAddComponent( money_prj, "VariableStorageComponent", 
	{ 
		name="pm_money_amount",
		value_float=tostring(0),
	} )

	EntityAddComponent( money_prj, "VariableStorageComponent", 
	{ 
		name="pm_hp_amount",
		value_float=tostring(pm_hp_amount),
	} )

	-- GamePrint(tostring(pm_hp_amount))
end