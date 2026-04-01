dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/perks/deep_end_perk_utilities.lua" )
dofile_once("data/scripts/newgame_plus.lua")

local players = EntityGetWithTag( "player_unit")

if #players > 0 then
    for i=1,#players do
        local player_entity = players[i]
        local px, py = EntityGetTransform( player_entity )

        EntityAddComponent( player_entity, "LuaComponent", 
        {
            script_source_file="data/entities/animals/boss_centipede/ending/deep_end_ending_effect.lua",
            execute_every_n_frame="120",
        } )

        local path = "data/entities/projectiles/remove_ground_bigger.xml"
        shoot_projectile( player_entity, path, px, py, 0, 0 )

        local models = EntityGetComponent( player_entity, "CharacterPlatformingComponent" )
        if models ~= nil then for i,model in ipairs(models) do
            ComponentSetValue2( model, "pixel_gravity", 10 )
        end end

        local wands = EntityGetWithTag( "wand" )
        for i,wand in ipairs( wands ) do EntityKill( wand ) end

        local damagemodels = EntityGetComponent( player_entity, "DamageModelComponent" )
        if damagemodels ~= nil then for i,damagemodel in ipairs(damagemodels) do
            ComponentSetValue2( damagemodel, "max_hp", 0.04)
            ComponentSetValue2( damagemodel, "hp", 0.04)
        end end

        -- EntityRemoveIngestionStatusEffect( player_entity, "HP_REGENERATION" )
        EntityRemoveIngestionStatusEffect( player_entity, "PROTECTION_ALL" )
        EntityRemoveIngestionStatusEffect( player_entity, "DEEP_END_HARDEN_EFFECT" )

        -- EntityRemoveStainStatusEffect( player_entity, "HP_REGENERATION", 15 )
        EntityRemoveStainStatusEffect( player_entity, "PROTECTION_ALL", 15 )
        EntityRemoveStainStatusEffect( player_entity, "DEEP_END_HARDEN_EFFECT", 15 )

        local world_entity_id = GameGetWorldStateEntity()
        if world_entity_id ~= nil  then
            local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
            if comp_worldstate ~= nil then ComponentSetValue2( comp_worldstate, "time_dt", 0 ) end
        end

        if ModSettingGet( "DEEP_END.NIGHTMARE_END" ) then
            EntityAddComponent( player_entity, "LuaComponent", 
            { 
                script_source_file="data/scripts/animals/simple_game_complete_effect.lua",
                execute_every_n_frame="1",
            } )
        end

        edit_component( player_entity, "VelocityComponent", function(vcomp,vars)
            ComponentSetValueVector2( vcomp, "mVelocity", 0, 20 )
        end)
        
        edit_component( player_entity, "CharacterDataComponent", function(ccomp,vars)
            ComponentSetValueVector2( ccomp, "mVelocity", 0, 20 )
        end)

        DEEP_END_remove_all( player_entity )

        EntityAddChild( player_entity, EntityLoad( "data/entities/animals/boss_centipede/ending/effect_protection_all.xml" ) )
        EntityAddChild( player_entity, EntityLoad( "data/entities/misc/effect_levitation.xml" ) )
    end

    GamePrint( "????????????????????????" )
else
    do_newgame_plus()
end