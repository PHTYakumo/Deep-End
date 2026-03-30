dofile_once("data/scripts/lib/utilities.lua")

local comp = EntityGetFirstComponent( GetUpdatedEntityID(), "LightningComponent" )
if comp ~= nil then return end

ComponentObjectSetValue2( comp, "config_explosion", "explosion_sprite", "data/particles/geomagnetic_storm_2.xml" )
ComponentSetValue2( comp, "sprite_lightning_file", "data/particles/lightning_dark_2.png" )