dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local comps = EntityGetComponent( entity_id, "SpriteComponent" )
if comps ~= nil then for i=1,#comps do EntitySetComponentIsEnabled( entity_id, comps[i], false ) end end

EntitySetComponentsWithTagEnabled( entity_id, "projectile_file_sprite", true )
EntityConvertToMaterial( entity_id, "ice_static" )

-- GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/frozen/damage", x, y )
-- GamePlaySound( "data/audio/Desktop/materials.bank", "materials/ice_cracked", x, y )
GamePlaySound( "data/audio/Desktop/materials.bank", "collision/ice", x, y )