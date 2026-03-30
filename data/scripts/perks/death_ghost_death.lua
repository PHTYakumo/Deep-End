dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )
	local flag_name = "PERK_PICKED_DEATH_GHOST" -- what r u doing
	local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) ) -- what r u doing
	local rat_count = math.max( 1, math.min( 1 + ( pickup_count - 1 ), 10 ) ) -- what r u doing
	local rats = EntityGetWithTag( "death_ghost" )
	
	for i=1,rat_count do
		local doit = true
		
		if ( i > 1 ) then
			if ( Random( 1, pickup_count + 3 ) < 3 ) then
				doit = false
			end
		end
		
		if doit and ( #rats < 30 ) then
			local eid = EntityLoad( "data/entities/misc/perks/death_ghost.xml", pos_x, pos_y )
			
			if ( i > 1 ) then
				local lifetime = 1200 - Random( 0, 600 + #rats * 10 )
				local comp = EntityGetFirstComponent( eid, "LifetimeComponent" )
				if ( comp ~= nil ) then
					ComponentSetValue2( comp, "lifetime", lifetime )
					ComponentSetValue2( comp, "kill_frame", GameGetFrameNum() + lifetime )
				end
			end
			
			local c = EntityGetAllChildren( eid )
			if ( c ~= nil ) then
				for a,b in ipairs( c ) do
					local comp = EntityGetFirstComponent( b, "AreaDamageComponent" )
					if ( comp ~= nil ) then
						local damage = clamp( pickup_count * ( 0.09 + math.abs( pos_y ) * 0.01 * 0.04 ), 0.13, 80 )
						ComponentSetValue2( comp, "damage_per_frame", damage )
					end
				end
			end
		end
	end
end