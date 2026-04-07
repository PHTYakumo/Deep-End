dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local velcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )

if velcomp ~= nil then
	local vel_x, vel_y = ComponentGetValueVector2( velcomp, "mVelocity" )
	local speed = math.max( ( vel_x^2 + vel_y^2 )^0.5, 10 )

	if speed < 100 then 
		vel_x, vel_y = vel_x * 100 / speed, vel_y * 100 / speed
		ComponentSetValueVector2( velcomp, "mVelocity", vel_x, vel_y )
	end
end

local length = 13
local c = EntityGetAllChildren( entity_id )

if c ~= nil then for i,v in ipairs( c ) do if EntityHasTag( v, "spiral_part" ) then
		local comp = EntityGetFirstComponent( v, "VariableStorageComponent", "theta" )

		if comp ~= nil then
			local theta = ComponentGetValue2( comp, "value_float" )
			
			if theta ~= nil then
				local new_x = pos_x + math.cos( theta ) * math.sin( 6 * theta ) * length
				local new_y = pos_y + math.sin( theta ) * math.sin( 6 * theta ) * length

				EntitySetTransform( v, new_x, new_y )
				ComponentSetValue2( comp, "value_float", theta + 0.0175 )
			end
		end
end end end