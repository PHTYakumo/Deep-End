dofile( "data/scripts/game_helpers.lua" )

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local players = EntityGetWithTag( "player_unit" )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	if #players > 0 then for i,player_id in ipairs(players) do
		local c = EntityGetAllChildren( player_id )
		
		if c ~= nil then for a,b in ipairs( c ) do
			local valid = EntityHasTag( b, "greed_curse" )
			if valid then EntityKill( b ) end
		end end

		local damagemodels = EntityGetComponent( player_id, "DamageModelComponent" )

		if damagemodels ~= nil  then for i,damagemodel in ipairs(damagemodels) do
			ComponentSetValue2( damagemodel, "blood_multiplier", 1 )
			ComponentSetValue2( damagemodel, "materials_damage_proportional_to_maxhp", false )
		end end
	end end
	
	GameAddFlagRun( "greed_curse_gone" )
	GamePrintImportant( "$log_greed_curse_away", "$logdesc_greed_curse_away" )
end
 