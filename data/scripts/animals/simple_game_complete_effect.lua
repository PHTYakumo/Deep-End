dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()

if ( entity_id ~= nil ) and ( entity_id ~= NULL_ENTITY ) then
    local px, py, pr, psx, psy = EntityGetTransform( entity_id )
    local G_FUELLLLLLLLLLLLLL = math.rad( GameGetFrameNum() * 6 )

    EntitySetTransform( entity_id, px, py, pr + 0.04, psx + 0.2 * math.cos( G_FUELLLLLLLLLLLLLL ), psy +  0.2 * math.sin( G_FUELLLLLLLLLLLLLL ) ) 
end