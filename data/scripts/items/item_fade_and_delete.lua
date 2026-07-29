dofile_once("data/scripts/lib/utilities.lua")

local entity_id, do_kill = GetUpdatedEntityID(), false
local scomps = EntityGetComponent( entity_id, "SpriteComponent" )

if scomps ~= nil then for i=1,#scomps do
    local fade = ComponentGetValue2( scomps[i], "alpha" )

    if fade > 0.03 then ComponentSetValue2( scomps[i], "alpha", fade - 0.03 )
    else do_kill = true end
end end

if do_kill then EntityKill( entity_id ) end
