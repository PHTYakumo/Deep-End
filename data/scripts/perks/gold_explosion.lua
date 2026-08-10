dofile_once("data/scripts/lib/utilities.lua")

if GameHasFlagRun( "exploding_gold" ) then
	local entity_id, value = GetUpdatedEntityID(), 10
	local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
	
	if comps ~= nil then for j,comp in ipairs( comps ) do if ComponentGetValue2( comp, "name" ) == "gold_value" then
		value = ComponentGetValue2( comp, "value_int" )
		break
	end end end
	
	local eid = EntityLoad( "data/entities/misc/perks/gold_explosion.xml" )
	EntityAddChild( entity_id, eid )
	
	local flag_name = "PERK_PICKED_EXPLODING_GOLD"
	local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) )
	
	local exp_radius = ( 4 * value / ( 16 + value * 0.01 ) ) + math.min( 64, 16 + 8 * pickup_count ) - 2
	local exp_damage = ( value^0.64 - 3.2 ) * math.min( 3.2, ( 0.4 + 0.8 * pickup_count ) ) - 0.2
	
	local exp_sparks_min = clamp( math.floor( exp_radius * 0.2 ), 4, 40 )
	local exp_sparks_max = clamp( math.floor( exp_radius * 0.8 ), 20, 80 )
	
	edit_component( eid, "ProjectileComponent", function(comp,vars)
		ComponentObjectSetValue2( comp, "config_explosion", "explosion_radius", clamp( math.ceil( exp_radius ), 25, 125 ) )
		ComponentObjectSetValue2( comp, "config_explosion", "damage", exp_damage )
		
		ComponentObjectSetValue2( comp, "config_explosion", "sparks_count_min", exp_sparks_min )
		ComponentObjectSetValue2( comp, "config_explosion", "sparks_count_max", exp_sparks_max )
		ComponentObjectSetValue2( comp, "config_explosion", "physics_explosion_power", exp_sparks_min * 0.1, exp_sparks_max * 0.1 )
	end )
end