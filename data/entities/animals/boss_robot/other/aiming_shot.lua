dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/bullet_sniper_enemy/create", x, y+4 )
GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/bullet_sniper_enemy/create", x, y-4 )
GameScreenshake( 66 )

local pls = EntityGetInRadiusWithTag( x, y, 20, "player_unit" )
if pls[1] == nil then return end

for i=1,#pls do
    local damagemodels = EntityGetComponent( pls[i], "DamageModelComponent" )
    local dmg = 2.64

    if damagemodels ~= nil then
        for i,damagemodel in ipairs(damagemodels) do dmg = math.max( ComponentGetValue2( damagemodel, "max_hp" ) * 0.07, dmg ) end
    end

    EntityInflictDamage( pls[i], dmg, "DAMAGE_HEALING", "$status_brain_damage", "DISINTEGRATED", 0, 0, entity_id )
    GameCreateSpriteForXFrames( "data/entities/animals/boss_robot/other/executed.png", x, y, true, 0, 0, 18, false )

    edit_component( pls[i], "VelocityComponent", function(vcomp,vars)
        local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity")
        ComponentSetValueVector2( vcomp, "mVelocity", 0, 0 )
    end)

    edit_component( pls[i], "CharacterDataComponent", function(ccomp,vars)
        local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity")
        ComponentSetValueVector2( ccomp, "mVelocity", 0, 0 )
    end)
end
