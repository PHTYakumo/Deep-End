dofile_once("data/scripts/lib/utilities.lua")

local entity_id, sprite_a = GetUpdatedEntityID(), 1
local comp = EntityGetFirstComponent( entity_id, "SpriteComponent" )

if comp == nil then return end
sprite_a = math.ceil( ComponentGetValue2( comp, "alpha" ) * 100 - 0.5 )

if sprite_a > 30 then sprite_a = 30
elseif sprite_a < 3 then sprite_a = 3
elseif sprite_a % 2 == 1 then sprite_a = sprite_a + 2
else sprite_a = sprite_a - 2 end

ComponentSetValue2( comp, "alpha", sprite_a * 0.01 )
-- GamePrint( tostring(sprite_a) )