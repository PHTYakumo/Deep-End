dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	if script_wait_frames( entity_id, 4 ) or damage < 0 or entity_who_caused == entity_id or ( EntityGetParent( entity_id ) ~= NULL_ENTITY and entity_who_caused == EntityGetParent( entity_id ) ) then return end
	local herd_id, release_exp, bullet = -1, false, ""

	if EntityHasTag( entity_id, "player_unit" ) then
		EntityAddRandomStains( entity_id, CellFactory_GetType("urine"), 16 )
		release_exp = true
	elseif EntityHasTag( entity_id, "enemy" ) and not EntityHasTag( entity_id, "boss" ) then
		SetRandomSeed( entity_id - x, GameGetFrameNum() - y )
		local comps = EntityGetComponent( entity_id, "AIAttackComponent" )

		if comps ~= nil then
			bullet = ComponentGetValue2( comps[Random(1,#comps)], "attack_ranged_entity_file" )
			if #bullet < 4 then release_exp = true end
		else
			local comp = EntityGetFirstComponent( entity_id, "AnimalAIComponent" )

			if comp == nil then
				release_exp = true
			else
				bullet = ComponentGetValue2( comp, "attack_ranged_entity_file" )
				if #bullet < 4 or not ComponentGetValue2( comp, "attack_ranged_enabled" ) then release_exp = true end
			end
		end

		if not release_exp then
			for i=1,Random(2,6) do
				local proj = shoot_projectile( entity_id, bullet, x, y, Random(-666,666), Random(-666,666) )
				local pcomp = EntityGetFirstComponent( proj, "ProjectileComponent" )
        		if pcomp ~= nil then ComponentSetValue2( pcomp, "collide_with_tag", "player_unit" ) end
			end
		end
	end

	if release_exp then
		local eid = shoot_projectile( entity_id, "data/entities/misc/perks/revenge_explosion.xml", x, y, 0, 0 )

		local comp = EntityGetFirstComponent( eid, "GenomeDataComponent" )
		if comp ~= nil then herd_id = ComponentGetValue2( comp, "herd_id" ) end
		
		local pcomp = EntityGetFirstComponent( eid, "ProjectileComponent" )

		if pcomp ~= nil then
			ComponentSetValue2( pcomp, "mWhoShot", entity_id )
			ComponentSetValue2( pcomp, "mShooterHerdId", herd_id )
			ComponentObjectSetValue( pcomp, "config_explosion", "dont_damage_this", entity_id )
		end
	end
end
