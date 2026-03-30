dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")

	vel_x = vel_x * 0.25
	vel_y = vel_y * 0.25

	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)
