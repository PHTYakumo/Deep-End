dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local players = EntityGetWithTag( "player_unit" )
shoot_projectile( entity_id, "data/entities/projectiles/remove_ground_bigger.xml", x, y, 0, 0 )

if #players > 0 then
    for i=1,#players do
        EntityAddChild( players[i], EntityLoad( "data/entities/misc/what_is_this/all_spells/all_spells_player_effect.xml", x, y ) )

        local damagemodels = EntityGetComponent( players[i], "DamageModelComponent" )
        if damagemodels ~= nil then for i,damagemodel in ipairs(damagemodels) do ComponentSetValue( damagemodel, "blood_multiplier", "0.0" ) end end
    end
end

