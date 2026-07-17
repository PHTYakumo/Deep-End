dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	if( comps ~= nil ) then
		EntityAddComponent( entity_id, "HomingComponent", 
		{ 
			target_tag="prey",
			detect_distance = "75",
			max_turn_rate = "0.025",
			just_rotate_towards_target = true,
		} )
	end
end