dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
local shooter = entity_id

if ( comp ~= nil ) then
	shooter = ComponentGetValue2( comp, "mWhoShot" )
end

if ( shooter ~= nil ) and ( shooter ~= NULL_ENTITY ) and ( not EntityHasTag( shooter, "wand_ghost" ) ) then
    local px, py, pr, psx, psy = EntityGetTransform( shooter )
    local gcomp = EntityGetFirstComponent( shooter, "CharacterPlatformingComponent" )

    if ( gcomp ~= nil ) then EntitySetTransform( shooter, px, py, pr, 1, sign( ComponentGetValue2( gcomp, "pixel_gravity" ) ) ) end

    EntityAddChild( shooter, EntityLoad( "data/entities/misc/effect_movement_faster_long.xml", px, py ) )
    EntityAddChild( shooter, EntityLoad( "data/entities/misc/effect_faster_levitation_long.xml", px, py ) )
end