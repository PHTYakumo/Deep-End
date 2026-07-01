dofile_once("data/scripts/lib/utilities.lua")

function shot( proj_id )
	local comp = EntityGetFirstComponent( proj_id, "VariableStorageComponent", "lurkershot_id" )
	if comp == nil then return end

	local entity_id = GetUpdatedEntityID()
	ComponentSetValue2( comp, "value_int", entity_id )

	EntitySetComponentsWithTagEnabled( entity_id, "lurker_data", false )
	if not EntityHasTag( entity_id, "lurkershot_id" ) then EntityAddTag( entity_id, "lurkershot_id" ) end
end