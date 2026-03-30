dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local comps = EntityGetComponent( entity_id, "VariableStorageComponent", "always_cast_action" )

if ( comps ~= nil ) then
    for i=1,#comps do
        AddGunActionPermanent( entity_id, ComponentGetValue2( comps[i], "value_string" ) )
    end
end

