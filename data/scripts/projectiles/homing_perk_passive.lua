dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	if not EntityHasTag( GetUpdatedEntityID(), "card_action_lua_enabled" )
	or EntityHasTag( entity_id, "do_not_homing_this" ) then return end
	
	local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
	if pcomp == nil then return end

	EntityAddTag( entity_id, "do_not_homing_this" )

	EntityAddComponent( entity_id, "HomingComponent", 
	{ 
		homing_targeting_coeff = "66.7",
		homing_velocity_multiplier = "0.9",
	} )
end