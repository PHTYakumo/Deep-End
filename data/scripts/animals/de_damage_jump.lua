dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id = GetUpdatedEntityID()
	local x, y, r, sx, sy = EntityGetTransform( entity_id )

	SetRandomSeed( GameGetFrameNum(), entity_id - entity_who_caused )
	
	local comp = EntityGetFirstComponent( entity_id, "ControlsComponent" )
    if sx == nil or comp == nil then return end

	if EntityHasTag( entity_id, "player_unit" ) then r = clamp( damage * 5, 1, 5 )
	else r = 2.5 end

	if Random( 1, 100 ) >= 75 then r = -r end
	if entity_who_caused == entity_id then r = -r end

	x, y = sign( sx ) * r * Random( 1, 100 ), -sign( sy ) * r * Random( 1, 100 )
	ComponentSetValueVector2( comp, "mJumpVelocity", x, y )
end
