dofile_once("data/scripts/lib/utilities.lua")

local comps = EntityGetComponentIncludingDisabled( GetUpdatedEntityID(), "LaserEmitterComponent" )
	
if comps ~= nil then for i=1,#comps do
	local r = ComponentGetValue2( comps[i], "laser_angle_add_rad" )
	r = r + 0.0606 * (-1)^i

	if r > 0.91 then r = - 0.9
	elseif r < -0.91 then r = 0.9 end

	ComponentSetValue2( comps[i], "laser_angle_add_rad", r )
	ComponentObjectSetValue2( comps[i], "laser", "max_length", 45 - math.abs(r) * 20 )
end end