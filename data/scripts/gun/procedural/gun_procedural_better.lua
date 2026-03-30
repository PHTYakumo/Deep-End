dofile_once("data/scripts/gun/procedural/gun_procedural.lua")

function generate_gun( cost, level, force_unshuffle )
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform( entity_id )
    SetRandomSeed( entity_id - 1437, y - x )

    local gun = get_gun_data( cost + Random( 25, 125 ), level, force_unshuffle )
    make_wand_from_gun_data( gun, entity_id, level )
    
    local dcapacity, apround = deep_end_gun_affix_apply( gun, entity_id, level, true )
    deep_end_wand_add_random_cards( dcapacity, apround, entity_id, level, true )
end