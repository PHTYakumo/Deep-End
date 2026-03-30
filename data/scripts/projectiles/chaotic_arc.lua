dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() - x, entity_id - y )

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local vx, vy = ComponentGetValueVector2( comp, "mVelocity")
	local rx, ry = math.abs( vx ) * Random( 1, 4 ), math.abs( vy ) * Random( 1, 4 )

	rx, ry = math.min( rx, ry ) * 0.25, math.max( rx, ry ) * 0.25

	vx = vx + Random( rx, ry ) * ( -1 ) ^ Random( 1, 4 )
	vy = vy + Random( rx, ry ) * ( -1 ) ^ Random( 1, 4 )

	ComponentSetValueVector2( comp, "mVelocity", vx, vy)
end)