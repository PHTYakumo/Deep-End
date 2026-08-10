dofile_once("data/scripts/lib/utilities.lua")

if GameHasFlagRun( "exploding_gold" ) then
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local player = EntityGetClosestWithTag( x, y, "player_unit" )
	local herd_id = 0

	if player ~= nil then
		edit_component( player, "GenomeDataComponent", function(comp,vars)
			herd_id = ComponentGetValue2( comp, "herd_id" )
		end )

		edit_component( entity_id, "ProjectileComponent", function(comp,vars)
			ComponentSetValue2( comp, "mWhoShot", entity_id )
			ComponentSetValue2( comp, "mShooterHerdId", herd_id )
			ComponentObjectSetValue2( comp, "config_explosion", "dont_damage_this", player )
		end )
	end
end