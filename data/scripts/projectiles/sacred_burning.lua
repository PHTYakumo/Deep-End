dofile_once("data/scripts/lib/utilities.lua")

local entity_id, dmg = EntityGetRootEntity( GetUpdatedEntityID() ), 0.24
local x, y = EntityGetTransform( entity_id )

if EntityHasTag( entity_id, "boss_centipede" ) then
    dmg = ComponentGetValue2( EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" ), "max_hp" ) or 50
    dmg = math.max( dmg * 0.01, 36 )
end

EntityInflictDamage( entity_id, dmg, "DAMAGE_HOLY", "$damage_holy", "NONE", 0, 0, entity_id )
GamePlaySound( "data/audio/Desktop/player.bank", "game_effect/on_fire/game_effect_end", x, y )
