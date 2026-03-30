dofile( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity" )

	local angle = -math.atan2(vel_y,vel_x)
	angle = angle - 0.02
	vel_x = vel_x*0.25 + math.cos(angle)*120
	vel_y = vel_y*0.25 - math.sin(angle)*120

	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
end )