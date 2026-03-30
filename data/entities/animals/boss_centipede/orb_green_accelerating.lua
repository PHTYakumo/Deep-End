dofile( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity" )

	ComponentSetValueVector2( comp, "mVelocity", -vel_x, -vel_y)

	pos_x = pos_x + math.floor ( vel_y * 0.1 )
	pos_y = pos_y - math.floor ( vel_x * 0.1 )

	EntitySetTransform( entity_id, pos_x, pos_y )
	EntityApplyTransform( entity_id, pos_x, pos_y )
end)