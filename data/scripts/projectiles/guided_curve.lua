dofile_once( "data/scripts/lib/utilities.lua" )

local executed_times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
if executed_times <= 1 then return end

local entity_id = GetUpdatedEntityID()
local x, y, mx, my, nx, my, cx, cy = EntityGetTransform( entity_id )

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )

if comps ~= nil then for i,comp in ipairs( comps ) do
	local n = ComponentGetValue2( comp, "name" )

	if n == "start" then
		x = ComponentGetValue2( comp, "value_float" )
		y = tonumber(ComponentGetValue2( comp, "value_string" ))
	elseif n == "node_1" then
		mx = ComponentGetValue2( comp, "value_float" )
		my = tonumber(ComponentGetValue2( comp, "value_string" ))
	elseif n == "node_2" then
		nx = ComponentGetValue2( comp, "value_float" )
		ny = tonumber(ComponentGetValue2( comp, "value_string" ))
	elseif n == "end" then
		cx = ComponentGetValue2( comp, "value_float" )
		cy = tonumber(ComponentGetValue2( comp, "value_string" ))

		if executed_times % 12 == 3 then
			local enemies = EntityGetInRadiusWithTag( cx, cy, 45, "enemy" )
			if #enemies > 0 then cx, cy = EntityGetTransform( enemies[#enemies] ) end

			ComponentSetValue2( comp, "value_float", cx )
			ComponentSetValue2( comp, "value_string", tostring(cy) )
		end
	end
end end

--[[

start:		-1t3 +3t2 -3t +1	-3t2 +6t -3
node_1:		+3t3 -6t2 +3t		+9t2 -12t +3
node_2:		-3t3 +3t2			-9t2 +6t
end:		+1t3				+3t2

]]--

if cy ~= nil and vcomp ~= nil then
	local t = ( executed_times - 1 ) * 0.016

	local t1 = -3*t^2 + 6*t - 3
	local t2 = 9*t^2 - 12*t + 3
	local t3 = -9*t^2 + 6*t
	local t4 = 3*t^2

	local vx, px = t1*x + t2*mx + t3*nx + t4*cx, x
	local vy, py = t1*y + t2*my + t3*ny + t4*cy, y

	t1 = -t^3 + 3*t^2 - 3*t + 1
	t2 = 3*t^3 - 6*t^2 + 3*t
	t3 = -3*t^3 + 3*t^2
	t4 = t^3

	px = t1*x + t2*mx + t3*nx + t4*cx
	py = t1*y + t2*my + t3*ny + t4*cy

	if executed_times == 2 then
		EntitySetComponentsWithTagEnabled( entity_id, "enabled_in_world", true )
	elseif executed_times >= 66 and executed_times <= 67 then
		t = math.max( ( vx^2 + vy^2 )^0.5, 1 )
		vx, xy = vx * 120 / t, vy * 120 / t
	end

	if executed_times <= 67 then 
		ComponentSetValueVector2( vcomp, "mVelocity", vx, vy )

		EntitySetTransform( entity_id, px, py )
		EntityApplyTransform( entity_id, px, py )
	elseif executed_times >= 99 then
		EntityKill( entity_id )
	end
end