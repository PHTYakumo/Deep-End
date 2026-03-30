dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local ncomp = EntityGetFirstComponent( entity_id, "VariableStorageComponent" )
if ncomp == nil then return end

if ComponentGetValue2( ncomp, "value_bool" ) and GameGetFrameNum() > 60 then
    local root_id = EntityGetRootEntity(entity_id)
    local targets = EntityGetInRadiusWithTag( x, y, 18, "hittable" )

    if EntityHasTag( root_id, "player_unit" ) and targets[1] ~= nil then
        for i=1,#targets do if not EntityHasTag( targets[i], "player_unit" ) then
            EntityInflictDamage( targets[i], 0.8, "DAMAGE_PROJECTILE", "$status_brain_damage", "BLOOD_EXPLOSION", 0, 0, root_id )
        end end

        GameScreenshake( clamp( #targets * 20, 20, 400 ) )
    end

    if GameGetFrameNum() - tonumber( GlobalsGetValue( "DEEP_END_SOUND_SNIPER_FIRE_LAST_PLAY_FRAME" ) ) > 3 then
		GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/bullet_sniper_enemy/create", x, y )

		GlobalsSetValue( "DEEP_END_SOUND_SNIPER_FIRE_LAST_PLAY_FRAME", tostring( GameGetFrameNum() ) )
	end
end

ComponentSetValue2( ncomp, "value_bool", false )