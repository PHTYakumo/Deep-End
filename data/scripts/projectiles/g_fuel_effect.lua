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
    local G_FUELLLLLLLLLLLLLL = math.rad( GameGetFrameNum() * 5 )

    EntitySetTransform( shooter, px, py, pr, psx + 0.5 * math.cos( G_FUELLLLLLLLLLLLLL ), psy +  0.5 * math.sin( G_FUELLLLLLLLLLLLLL ) ) 
end