dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
edit_component( entity_id, "HitboxComponent", function(comp,vars) ComponentSetValue2( comp, "damage_multiplier", 0.1 ) end )

local c = EntityGetFirstComponent( entity_id, "LuaComponent", "counter" )
if c ~= nil then ComponentSetValue2( c, "execute_every_n_frame", 480 ) end