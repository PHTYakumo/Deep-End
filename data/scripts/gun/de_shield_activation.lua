dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local shields = EntityGetAllChildren( entity_id )

if shields ~= nil then
    for a,shield in ipairs( shields ) do
        local comps = EntityGetAllComponents( shield )
        
        if comps ~= nil then for b,comp in ipairs( comps ) do EntitySetComponentIsEnabled( shield, comp, true ) end end
    end
end