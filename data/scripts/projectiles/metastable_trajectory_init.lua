dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y, angle = EntityGetTransform( entity_id )

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local comp1 = EntityGetFirstComponent( entity_id, "VelocityComponent" )
local comp2 = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

if comp1 ~= nil and comp2 ~= nil then
	if ComponentGetValue2( comp1, "terminal_velocity" ) < 1250 then ComponentSetValue2( comp1, "terminal_velocity", 1250 ) end
	local shooter = ComponentGetValue2( comp2, "mWhoShot" )

	if shooter ~= nil and shooter ~= NULL_ENTITY then
		local wand_id = find_the_wand_held( shooter )
		if wand_id ~= nil and wand_id ~= NULL_ENTITY then x, y, angle = EntityGetTransform( wand_id ) end
	end
end

angle = -math.atan2( math.cos(angle), math.sin(angle) )
-- GamePrint(tostring(angle))

if comps ~= nil then
	for i,comp in ipairs( comps ) do
		local n = ComponentGetValue2( comp, "name" )

		if n == "sx" then
			ComponentSetValue2( comp, "value_float", x )
		elseif n == "sy" then
			ComponentSetValue2( comp, "value_float", y )
		elseif n == "angle" then
			ComponentSetValue2( comp, "value_float", angle )
		end
	end
end