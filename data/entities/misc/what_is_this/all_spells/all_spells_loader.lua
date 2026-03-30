dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")
dofile_once( "data/scripts/gun/gun_enums.lua" )
dofile_once( "data/scripts/gun/gun_actions.lua" )

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local players = EntityGetWithTag( "player_unit" )

if #players > 0 then
    SetRandomSeed( GameGetFrameNum() + x, y - entity_id )

    for i=1,#players do
        local pl = players[i]
        local px, py = EntityGetTransform(pl)

        for i=1,Random( 2, 13 ) do
		    local rnd_spell = actions[Random(1,#actions)] -- ~50% *2~13

            if rnd_spell.related_projectiles ~= nil and rnd_spell.mana >= 0 and rnd_spell.type ~= ACTION_TYPE_MATERIAL then
                x = 10 * Random( 2, 13 ) * (-1)^Random( 2, 13 )
                y = 10 * Random( 2, 13 ) * (-1)^Random( 2, 13 )

                local rx = px - x
                local ry = py - y

                x = x * Random( 2, 13 )
                y = y * Random( 2, 13 )

                local eoe_proj = shoot_projectile( entity_id, rnd_spell.related_projectiles[1], rx, ry, x, y )
                EntityAddTag( eoe_proj, "all_spells_proj" )

                local eoe_proj_name = GameTextGetTranslatedOrNot(rnd_spell.name)

                 for i=1,Random( 2, 13 ) do
                    rnd_spell = actions[Random(1,#actions)] -- ~25% *2~13

                    if rnd_spell.related_extra_entities ~= nil then for i=1,#rnd_spell.related_extra_entities do
                        EntityAddChild( eoe_proj, EntityLoad( rnd_spell.related_extra_entities[i], rx, ry ) )

                        eoe_proj_name = GameTextGetTranslatedOrNot(rnd_spell.name) .. " + " .. eoe_proj_name
                    end end
                end

                EntityAddComponent2( eoe_proj, "SpriteComponent",
                {
                    _tags="enabled_in_world",
                    image_file="data/fonts/font_pixel_white.xml", 
                    is_text_sprite=true, 
                    offset_x=#eoe_proj_name*1.2, 
                    offset_y=-( 4 + Random( 2, 13 ) ), 
                    update_transform=true, 
                    update_transform_rotation=true,
                    text = eoe_proj_name, 
                    has_special_scale=true,
                    special_scale_x=0.3 + 0.05 * Random( 2, 13 ),
                    special_scale_y=0.3 + 0.05 * Random( 2, 13 ),
                    z_index=-1,
                })
            end
        end
    end
end

