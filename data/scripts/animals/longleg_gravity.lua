dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

if ( entity_id ~= NULL_ENTITY ) and ( entity_id ~= nil ) then
    local gcomp = EntityGetFirstComponent( entity_id, "CharacterPlatformingComponent" )

    if ( gcomp ~= nil ) then
        local pixel_gravity = math.abs( ComponentGetValue2( gcomp, "pixel_gravity" ) )

        ComponentSetValue2( gcomp, "pixel_gravity", pixel_gravity )
    end

    EntityRemoveStainStatusEffect( entity_id, "DEEP_END_GRAVITY_EFFECT", 16 )
end

