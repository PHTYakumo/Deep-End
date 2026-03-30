local w = 70
local h = 100

BiomeMapSetSize( w, h )

if ( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then
    BiomeMapLoadImage( 0, 0, "mods/deep_end/files/map/biome_map_mania.png" )
else
    local chosen = tonumber(ModSettingGet( "DEEP_END.MAP_TYPE" ))

    if chosen == 0 then
        BiomeMapLoadImage( 0, 0, "mods/deep_end/files/map/biome_map.png" )
    elseif chosen == 1 then
        BiomeMapLoadImage( 0, 0, "mods/deep_end/files/map/biome_map_wasteland.png" )
    elseif chosen == 2 then
        BiomeMapLoadImage( 0, 0, "mods/deep_end/files/map/biome_map_thorny.png" )
    elseif chosen == 3 then
        BiomeMapLoadImage( 0, 0, "mods/deep_end/files/map/biome_map_neddle.png" )
    elseif chosen == 4 then
        BiomeMapLoadImage( 0, 0, "mods/deep_end/files/map/biome_map_doom.png" )
    end
end