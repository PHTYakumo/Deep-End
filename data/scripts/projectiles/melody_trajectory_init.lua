dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local pid = EntityGetClosestWithTag( x, y, "player_unit") -- not shooter

if pid ~= nil then
	local px, py = EntityGetTransform( pid )
	local cx, cy = x, y

	edit_component( pid, "ControlsComponent", function(mcomp,vars)
		cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
	end)

	local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

	if comps ~= nil then
		for i,comp in ipairs( comps ) do
			local n = ComponentGetValue2( comp, "name" )

			if n == "cx" then
				ComponentSetValue2( comp, "value_float", cx )
			elseif n == "cy" then
				ComponentSetValue2( comp, "value_float", cy )
			end
		end
	end
end
