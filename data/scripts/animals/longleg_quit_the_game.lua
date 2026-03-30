dofile_once("data/scripts/lib/utilities.lua")

-- function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items ) end
local x, y = EntityGetTransform( GetUpdatedEntityID() )
local items = EntityGetInRadiusWithTag( x, y, 99, "item_pickup" )

if items ~= nil then for i=1,#items do if EntityGetRootEntity( items[i] ) == items[i] then
    local comps = EntityGetAllComponents( items[i] )
    for j=1,#comps do EntitySetComponentIsEnabled( items[i], comps[j], true ) end

    EntitySetComponentsWithTagEnabled( items[i], "enabled_in_hand", false )
    EntitySetComponentsWithTagEnabled( items[i], "enabled_in_inventory", false )
    EntitySetComponentsWithTagEnabled( items[i], "enabled_in_world", true )
end end end
