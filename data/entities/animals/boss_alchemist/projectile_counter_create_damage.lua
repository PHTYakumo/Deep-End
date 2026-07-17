dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage )
	local entity_id = GetUpdatedEntityID()
	
	if damage >= 2.0 then
		local x, y = EntityGetTransform( entity_id )
		EntityAddChild( entity_id, EntityLoad( "data/entities/animals/boss_alchemist/projectile_counter.xml", x, y ) )
		edit_component( entity_id, "HitboxComponent", function(comp,vars) ComponentSetValue2( comp, "damage_multiplier", 0.1 ) end )
	end
end