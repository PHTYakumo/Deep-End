dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	local flag_name = "PERK_PICKED_DEATH_GHOST"
	local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) ) 
	
	local c = EntityGetAllChildren( EntityLoad( "data/entities/misc/perks/death_ghost.xml", pos_x, pos_y ) )
	pos_y = clamp( 0.4 + math.abs( pos_y ) * 0.0008 * pickup_count, 0.8, 40 )

	if c ~= nil then for a,b in ipairs( c ) do
		local comp = EntityGetFirstComponent( b, "AreaDamageComponent" )
		if comp ~= nil then ComponentSetValue2( comp, "damage_per_frame", pos_y ) end
	end end
end