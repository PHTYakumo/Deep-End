dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")

local entity_id = GetUpdatedEntityID()
local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent" )

if ( comp ~= nil ) then
    local killwho = ComponentGetValue2( comp, "value_int" )

    if ( killwho ~= nil ) and ( killwho ~= 0 ) then
        local dcomp = EntityGetFirstComponent( killwho, "DamageModelComponent" )
                    
        if ( dcomp ~= nil ) then
            ComponentSetValue2( dcomp, "hp", 0.02 )
            EntityInflictDamage( killwho, ComponentGetValue2( dcomp, "max_hp" ) * 100, "DAMAGE_HEALING", "$SUICIDE_KING", "DISINTEGRATED", 0, 0, entity_id )
        else
            EntityKill( killwho )
        end
    end
end

EntityKill( entity_id )