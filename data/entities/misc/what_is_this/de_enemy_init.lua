dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
if not EntityHasTag( entity_id, "enemy" ) then return end

if GlobalsGetValue( "DEEP_END_GLOBAL_GORE" ) == "t" then
    local comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
    if comp ~= nil then ComponentSetValue2( comp, "ragdoll_fx_forced", "CONVERT_TO_MATERIAL" ) end
    -- in fact, death will disappear directly without leaving any ragdolls or materials
end

if GlobalsGetValue( "PERK_NO_MORE_SHUFFLE_WANDS" ) == "1" then
    if EntityHasTag( entity_id, "wand_ghost" ) and not ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then
        EntityAddComponent( entity_id, "LuaComponent", 
        {
            script_shot="data/scripts/projectiles/neutralized.lua",
            execute_every_n_frame = "-1",
        } )
    else
        local comp = EntityGetFirstComponent( entity_id, "ItemPickUpperComponent" )
        if comp ~= nil then EntitySetComponentIsEnabled( entity_id, comp, false ) end
    end
end

if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) and not EntityHasTag( entity_id, "boss" ) then
    local mania_level = math.floor( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL_FACTOR" ) + 0.5 )
    SetRandomSeed( entity_id - mania_level, GameGetFrameNum() - mania_level )

    if mania_level == 41 then
        EntityAddComponent( entity_id, "LuaComponent", {
            script_damage_received = "data/scripts/animals/cooorpse.lua" ,
            script_death = "data/scripts/animals/cooorpse.lua" ,
            execute_every_n_frame = "-1",
        } )
    else
        EntityAddComponent( entity_id, "LuaComponent", {
            script_death = "data/scripts/animals/cooorpse.lua" ,
            execute_every_n_frame = "-1",
        } )
    end

    local comps = EntityGetComponentIncludingDisabled( entity_id, "HitboxComponent" )
    local comp = EntityGetFirstComponent( entity_id, "AnimalAIComponent" )

    local x, y, r, sx, sy = EntityGetTransform( entity_id )
    local scale = Random( 1, 100 )
    
    scale = scale^0.5 * 0.2
    sx, sy = sx * scale, sy * scale
    -- 0.2 ~ 2.0, average scale = 1.343
    -- GamePrint( scale )

    if comps ~= nil then for i,v in ipairs( comps ) do
        ComponentSetValue2( v, "aabb_min_x", ComponentGetValue2( v, "aabb_min_x" ) * scale )
        ComponentSetValue2( v, "aabb_max_x", ComponentGetValue2( v, "aabb_max_x" ) * scale )
        ComponentSetValue2( v, "aabb_min_y", ComponentGetValue2( v, "aabb_min_y" ) * scale )
        ComponentSetValue2( v, "aabb_max_y", ComponentGetValue2( v, "aabb_max_y" ) * scale )
    end end

    if comp ~= nil then
        if Random( 1, 100 ) <= 25 then ComponentSetValue2( comp, "attack_ranged_predict", true ) end
        ComponentSetValue2( comp, "sense_creatures_through_walls", true )
        ComponentSetValue2( comp, "dont_counter_attack_own_herd", true )
        
        if scale < 1 then scale = scale^0.6 end

        ComponentSetValue2( comp, "attack_melee_max_distance", ComponentGetValue2( comp, "attack_melee_max_distance" ) * scale )
        ComponentSetValue2( comp, "attack_dash_distance", ComponentGetValue2( comp, "attack_dash_distance" ) * scale )
    end
                    
    if EntityGetFirstComponent( entity_id, "CrawlerAnimalComponent" ) == nil then
        EntitySetTransform( entity_id, x, y, r, sx, sy )
        EntityApplyTransform( entity_id, x, y, r, sx, sy ) -- not so good for enemies with child entities
    end
end

if EntityHasTag( entity_id, "robot" )
and ( not EntityHasTag( entity_id, "boss" ) )
and ( not EntityHasTag( entity_id, "robot_egg_boosted" ) )
then
    if GameHasFlagRun( "DEEP_END_OPEN_CHEST_STEEL" ) then
        if not EntityHasTag( entity_id, "teleportable_NOT" ) then EntityAddTag( entity_id, "teleportable_NOT" ) end
        if not EntityHasTag( entity_id, "touchmagic_immunity" ) then EntityAddTag( entity_id, "touchmagic_immunity" ) end
        if not EntityHasTag( entity_id, "polymorphable_NOT" ) then EntityAddTag( entity_id, "polymorphable_NOT" ) end

        local acomp = EntityGetFirstComponent( entity_id, "AnimalAIComponent" )
        if acomp ~= nil then ComponentSetValue2( acomp, "dont_counter_attack_own_herd", true ) end

        local dcomp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
        if dcomp ~= nil then ComponentSetValue2( dcomp, "blood_multiplier", 0.0001 ) end

        -- EntityAddTag( entity_id, "robot_egg_boosted" )
        
        EntityAddComponent( entity_id, "LuaComponent", {
            script_shot = "data/scripts/projectiles/smart_shot.lua" ,
            execute_every_n_frame = "-1",
        } )

        EntityAddComponent( entity_id, "LuaComponent", {
            script_damage_about_to_be_received = "data/entities/animals/boss_wizard/orbit/dmg_cap.lua",
            execute_every_n_frame = "-1",
        } )
    else
        EntityAddComponent( entity_id, "LuaComponent", 
        {
            script_damage_received="data/scripts/animals/de_bot_malfunction.lua",
            execute_every_n_frame = "-1",
        } )
    end
end

-- GamePrint(tostring(entity_id))