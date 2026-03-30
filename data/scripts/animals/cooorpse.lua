dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, msg, source )
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform( entity_id )

    if script_wait_frames( entity_id, 5 ) then return end
    SetRandomSeed( entity_id - x, GameGetFrameNum() - y )
    if script_wait_frames( entity_id, 120 ) and Random(1,100) > 50 then return end

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

    local proj = shoot_projectile( entity_id, bullet, x, y, Random(-666,666) * 0.5, Random(-666,666) * 0.5 )
    local pcomp = EntityGetFirstComponent( proj, "ProjectileComponent" )

    if pcomp ~= nil then
        ComponentSetValue2( pcomp, "collide_with_tag", "player_unit" )
        ComponentSetValue2( pcomp, "explosion_dont_damage_shooter", true )
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

        if pcomp ~= nil then
            ComponentSetValue2( pcomp, "collide_with_tag", "player_unit" )
            ComponentSetValue2( pcomp, "go_through_this_material", "gold_box2d" ) -- bloodgold_box2d
        end

        angle = angle + math.pi * 2 / amount
    end
end