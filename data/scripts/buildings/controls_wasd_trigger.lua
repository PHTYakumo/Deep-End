dofile_once("data/scripts/lib/utilities.lua")

function collision_trigger()
	local entity_id = EntityGetClosestWithTag( 275, -120, "controls_wasd" )
	
	local components = EntityGetAllComponents( entity_id )
	if components == nil then
		return
	end

	for i,comp in ipairs( components ) do 
		EntitySetTransform( entity_id, -160, 400 )
		EntityApplyTransform( entity_id, -160, 400 )

		EntitySetComponentIsEnabled( entity_id, comp, true )
	end

	local new_entity_id = EntityLoad( "data/entities/particles/image_emitters/controls_right_mouse.xml", 177, -170 )
	local new_components = EntityGetAllComponents( new_entity_id )

	for i,comp in ipairs( new_components ) do 
		EntitySetComponentIsEnabled( new_entity_id, comp, true )
	end
end