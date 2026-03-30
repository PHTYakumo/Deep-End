dofile_once("data/scripts/lib/utilities.lua")

if GameHasFlagRun( "exploding_gold" ) then
	local entity_id = GetUpdatedEntityID()
	
	local eid = EntityLoad( "data/entities/misc/perks/gold_explosion.xml" )
	EntityAddChild( entity_id, eid )
	
	local value = 10
	
	local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
	
	if ( comps ~= nil ) then
		for j,comp in ipairs( comps ) do
			local name = ComponentGetValue2( comp, "name" )
			
			if ( name == "gold_value" ) then
				value = ComponentGetValue2( comp, "value_int" )
				break
			end
		end
	end
	
	local players = EntityGetWithTag( "player_unit" )
	local herd_id = -1
	local player
	if ( #players > 0 ) then
		player = players[1]
		
		edit_component( player, "GenomeDataComponent", function(comp,vars)
			herd_id = ComponentGetValue2( comp, "herd_id" )
		end)
	end
	
	local flag_name = "PERK_PICKED_EXPLODING_GOLD"
	local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) )
	
	local exp_radius = ( 4 * value / ( 16 + value * 0.01 ) ) + math.min( 64, 16 + 8 * pickup_count ) - 2
	local exp_damage = ( value^0.64 - 3.2 ) * math.min( 3.2, ( 0.4 + 0.8 * pickup_count ) ) - 0.2
	-- local exp_shake = 0.2 * ( ( value / ( 10 + value * 0.01 ) ) + 10 )
	
	local exp_sparks_min = clamp( math.floor( exp_radius * 0.2 ), 4, 40 )
	local exp_sparks_max = clamp( math.floor( exp_radius * 0.8 ), 20, 80 )
	
	edit_component( eid, "ProjectileComponent", function(comp,vars)
		ComponentObjectSetValue2( comp, "config_explosion", "explosion_radius", clamp( math.ceil( exp_radius ), 25, 125 ) )
		ComponentObjectSetValue2( comp, "config_explosion", "damage", exp_damage )
		--ComponentObjectSetValue2( comp, "config_explosion", "camera_shake", exp_shake )
		
		ComponentObjectSetValue2( comp, "config_explosion", "sparks_count_min", exp_sparks_min )
		ComponentObjectSetValue2( comp, "config_explosion", "sparks_count_max", exp_sparks_max )
		ComponentObjectSetValue2( comp, "config_explosion", "physics_explosion_power", exp_sparks_min * 0.1, exp_sparks_max * 0.1 )
		
		if ( player ~= nil ) then
			ComponentSetValue2( comp, "mWhoShot", player )
			ComponentSetValue2( comp, "mShooterHerdId", herd_id )
			ComponentObjectSetValue2( comp, "config_explosion", "dont_damage_this", player )
		end
	end)
end