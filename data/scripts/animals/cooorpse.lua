dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, msg, source, is_fatal )
    local entity_id = GetUpdatedEntityID()
    local x, y, r, sx, sy = EntityGetTransform( entity_id )

    local scale = ( math.abs(sx) + math.abs(sx) ) * 0.5
    if script_wait_frames( entity_id, 5 ) or damage <= 0 or is_fatal or scale < 0.67 then return end

    scale = scale - 0.08

    if EntityGetFirstComponent( entity_id, "CrawlerAnimalComponent" ) == nil then
        local comps = EntityGetComponentIncludingDisabled( entity_id, "HitboxComponent" )
        local rsclae = scale / ( scale + 0.08 )

        if comps ~= nil then for i,v in ipairs( comps ) do
            ComponentSetValue2( v, "aabb_min_x", ComponentGetValue2( v, "aabb_min_x" ) * rsclae )
            ComponentSetValue2( v, "aabb_max_x", ComponentGetValue2( v, "aabb_max_x" ) * rsclae )
            ComponentSetValue2( v, "aabb_min_y", ComponentGetValue2( v, "aabb_min_y" ) * rsclae )
            ComponentSetValue2( v, "aabb_max_y", ComponentGetValue2( v, "aabb_max_y" ) * rsclae )
        end end

        EntitySetTransform( entity_id, x, y, r, sign(sx) * scale, sign(sy) * scale )
        EntityApplyTransform( entity_id, x, y, r, sign(sx) * scale, sign(sy) * scale )
    end
end


function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform( entity_id )

    SetRandomSeed( entity_id - x, GameGetFrameNum() - y )

    local comps = EntityGetComponent( entity_id, "AIAttackComponent" )
    local bullet = ""

    if comps ~= nil then
        bullet = ComponentGetValue2( comps[Random(1,#comps)], "attack_ranged_entity_file" )
        if #bullet < 4 then return end
    else
        local comp = EntityGetFirstComponent( entity_id, "AnimalAIComponent" )
        if comp == nil then return end

        bullet = ComponentGetValue2( comp, "attack_ranged_entity_file" )
        if #bullet < 4 or not ComponentGetValue2( comp, "attack_ranged_enabled" ) then return end
    end

    local speed = Random(-666,666) * 0.5
    local amount = math.ceil( math.abs( Random(-666,666) )^0.25 ) + 4
    local angle = Random(-666,666) * 0.02

    for i=1,amount do
        local proj = shoot_projectile( entity_id, bullet, x + math.cos(angle) * amount , y + math.sin(angle) * amount, math.cos(angle) * speed, math.sin(angle) * speed )
        
        local pcomp = EntityGetFirstComponent( proj, "ProjectileComponent" )
        local scomp = EntityGetFirstComponent( proj, "PhysicsImageShapeComponent" )

        if pcomp ~= nil then
            ComponentSetValue2( pcomp, "collide_with_tag", "player_unit" )
            ComponentSetValue2( pcomp, "go_through_this_material", "gold_box2d" ) -- bloodgold_box2d

            if EntityHasTag( proj, "de_projectile_spawner" ) then
                local lifetime = ComponentGetValue2( pcomp, "lifetime" )
                ComponentSetValue2( pcomp, "lifetime", math.min( lifetime, 33 ) )
            end
        end

        if scomp ~= nil then
            local comps = EntityGetComponent( proj, "ProjectileComponent" )

            if comps ~= nil then for i,v in ipairs( comps ) do
                ComponentSetValue2( v, "on_death_explode", false )
                ComponentSetValue2( v, "on_lifetime_out_explode", false )
                ComponentObjectSetValue2( v, "config_explosion", "audio_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "stains_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "sparks_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "hole_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "explosion_radius", 2 )
                ComponentObjectSetValue2( v, "config_explosion", "damage", 0 )
            end end

            comps = EntityGetComponent( proj, "ExplosionComponent" )

            if comps ~= nil then for i,v in ipairs( comps ) do
                ComponentObjectSetValue2( v, "config_explosion", "audio_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "stains_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "sparks_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "hole_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "explosion_radius", 2 )
                ComponentObjectSetValue2( v, "config_explosion", "damage", 0 )
                EntitySetComponentIsEnabled( proj, v, false )
            end end

            comps = EntityGetComponent( proj, "ExplodeOnDamageComponent" )

            if comps ~= nil then for i,v in ipairs( comps ) do
                ComponentObjectSetValue2( v, "config_explosion", "audio_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "stains_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "sparks_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "hole_enabled", false )
                ComponentObjectSetValue2( v, "config_explosion", "explosion_radius", 2 )
                ComponentObjectSetValue2( v, "config_explosion", "damage", 0 )
                EntitySetComponentIsEnabled( proj, v, false )
            end end

            EntityKill( proj )
        end

        angle = angle + math.pi * 2 / amount
    end
end