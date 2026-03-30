dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")

local entity_id    = GetUpdatedEntityID()
local px,py,pr,psx,psy = EntityGetTransform( entity_id )

local radius = 600
local suns = EntityGetInRadiusWithTag( px, py, radius, "seed_e" )
local dark_suns = EntityGetInRadiusWithTag( px, py, radius, "seed_f" )

if ( #suns == 0 ) or ( #dark_suns == 0 ) then
    if ( not EntityHasTag( entity_id, "deep_end_ending_triggered" ) ) then 
        EntityAddTag( entity_id, "deep_end_ending_triggered" )

        if ( ModSettingGet( "DEEP_END.NIGHTMARE_END" ) ) then DEEP_END_do_newgame_any_dimension(-10000)  end
    end

    local sun = EntityLoad( "data/entities/items/pickup/sun/newsun.xml", px-500, py )
	local dark_sun = EntityLoad( "data/entities/items/pickup/sun/newsun_dark_smaller.xml", px+500, py )
    
    EntityAddComponent( sun, "LuaComponent", 
    {
        script_source_file="data/entities/animals/boss_centipede/ending/deep_end_ending_suns.lua",
        execute_every_n_frame="1",
    } )
    EntityAddComponent( dark_sun, "LuaComponent", 
    {
        script_source_file="data/entities/animals/boss_centipede/ending/deep_end_ending_suns.lua",
        execute_every_n_frame="1",
    } )
else
    local path = "data/entities/projectiles/remove_ground_bigger.xml"
	shoot_projectile( entity_id, path, px, py, 0, 0 )
end