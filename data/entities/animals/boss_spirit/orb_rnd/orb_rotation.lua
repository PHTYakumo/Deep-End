dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local length = 13

local c = EntityGetAllChildren( entity_id )

if ( c ~= nil ) then
	for i,v in ipairs( c ) do
		if EntityHasTag( v, "spiral_part" ) then
			local comp = EntityGetFirstComponent( v, "VariableStorageComponent", "theta" )
			if ( comp ~= nil ) then
				local theta = ComponentGetValue2( comp, "value_float" )
				
				if ( theta ~= nil ) then
					local new_x = pos_x + math.cos( theta ) * math.sin( 6 * theta ) * length
					local new_y = pos_y + math.sin( theta ) * math.sin( 6 * theta ) * length
					
					EntitySetTransform( v, new_x, new_y )
					
					theta = theta + 0.0175

					ComponentSetValue2( comp, "value_float", theta )
				end
			end
		end
	end
end