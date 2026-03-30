dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if comps == nil then return end

for i,comp in ipairs( comps ) do
	local name = ComponentGetValue2( comp, "name" )

	if ( name == "x" ) then
		ComponentSetValue2( comp, "value_float", x )
	elseif ( name == "y" ) then
		ComponentSetValue2( comp, "value_float", y )
	elseif ( name == "ng" ) then
		ComponentSetValue2( comp, "value_int", tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") ) )
	end
end

local item_comp = EntityGetFirstComponent( entity_id, "ItemComponent" )
if item_comp == nil then return end

component_write( item_comp, {
	item_name = GameTextGetTranslatedOrNot( "$deep_end_temple_travel_mark" ) .. " ( " .. tostring(x) .. ", " .. tostring(y) .. " )",
	always_use_item_name_in_ui = true,
} )
