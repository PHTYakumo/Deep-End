dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")

function collision_trigger()
	local entity_id = EntityGetClosestWithTag( 275, -120, "controls_mouse" )
	
	local components = EntityGetAllComponents( entity_id )
	if components == nil then
		return
	end

	for i,comp in ipairs( components ) do 
		EntitySetTransform( entity_id, -160, 400 )
		EntityApplyTransform( entity_id, -160, 400 )

		EntitySetComponentIsEnabled( entity_id, comp, true )
	end

	local new_entity_id = EntityLoad( "data/entities/particles/image_emitters/controls_aadd.xml", 278, -116 )
	local new_components = EntityGetAllComponents( new_entity_id )

	for i,comp in ipairs( new_components ) do 
		EntitySetComponentIsEnabled( new_entity_id, comp, true )
	end
end