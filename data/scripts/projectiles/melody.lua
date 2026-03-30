dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local cx, cy = EntityGetTransform( entity_id )

if comps ~= nil then
	for i,comp in ipairs( comps ) do
		local n = ComponentGetValue2( comp, "name" )

		if n == "cx" then
			cx = ComponentGetValue2( comp, "value_float" )
		elseif n == "cy" then
			cy = ComponentGetValue2( comp, "value_float" )
		end
	end
end

if get_magnitude( cx, cy ) < 7 then return end
local dis = (cx-x)^2 + (cy-y)^2

if dis < 80 then
	EntitySetTransform( entity_id, cx, cy )
	EntityApplyTransform( entity_id, cx, cy )

	EntityKill( entity_id )
else
	local dir = GameGetFrameNum() - entity_id
	dir = -math.atan2( cy-y, cx-x ) + math.pi * 0.25 * ( math.sin( cx + dir/4 ) + math.sin( cy + dir/6 ) )

	edit_component( entity_id, "VelocityComponent", function(comp,vars)
		cx, cy = ComponentGetValueVector2( comp, "mVelocity")
		
		local dist = math.sqrt( cy^2 + cx^2 ) + 6
		local dir2 = -math.atan2( cy, cx )
		
		local delta = math.atan2( math.sin( dir-dir2 ), math.cos( dir-dir2 ) )
		local newdir = dir2 + delta * 0.34
		
		cx = math.cos( newdir ) * dist
		cy = -math.sin( newdir ) * dist

		ComponentSetValueVector2( comp, "mVelocity", cx, cy)
	end)
end