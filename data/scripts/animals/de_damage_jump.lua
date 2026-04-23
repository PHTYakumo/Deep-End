dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id = GetUpdatedEntityID()
	local x, y, r, sx, sy = EntityGetTransform( entity_id )
	SetRandomSeed( GameGetFrameNum(), entity_id - entity_who_caused )
	
	local comp = EntityGetFirstComponent( entity_id, "ControlsComponent" )
    if sx == nil or comp == nil then return end

	x, y = sign( sx ) * 5 * Random( 1, 100 ), -5 * Random( 1, 100 )
	ComponentSetValueVector2( comp, "mJumpVelocity", x, y )
end
