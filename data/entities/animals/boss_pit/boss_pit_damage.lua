dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage )
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( GetUpdatedEntityID() )

	edit_component( entity_id, "HitboxComponent", function(comp,vars)
		ComponentSetValue2( comp, "damage_multiplier", 0.0 )
	end)
	
	EntitySetComponentsWithTagEnabled( entity_id, "invincible", true )
	SetRandomSeed( x, y + GameGetFrameNum() )

	local projectiles = EntityGetInRadiusWithTag( x, y, 111, "projectile" )
	
	if #projectiles > 0 then for i=1,#projectiles do
		local dmgcomp_1 = EntityGetFirstComponent( projectiles[i], "LaserEmitterComponent" )
		local dmgcomp_2 = EntityGetFirstComponent( projectiles[i], "AreaDamageComponent" )
		local dmgcomp_3 = EntityGetFirstComponent( projectiles[i], "GameAreaEffectComponent" )

		if dmgcomp_1 ~= nil or dmgcomp_2 ~= nil or dmgcomp_3 ~= nil then
			local prjx, prjy = EntityGetTransform( projectiles[i] )

			shoot_projectile( entity_id, "data/entities/projectiles/hamis.xml", prjx, prjy, 0, 0 )
			EntityKill(projectiles[i])
		end
	end end
	
	if Random( 1, 4 ) < 3 and not script_wait_frames( entity_id, 3 ) then
		local p = ""
		local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

		if comps ~= nil then
			for i,v in ipairs( comps ) do
				local n = ComponentGetValue2( v, "name" )

				if n == "state" then
					state = ComponentGetValue2( v, "value_int" )
					state = (state + 1) % 10
					
					ComponentSetValue2( v, "value_int", state )
				elseif n == "memory" then
					p = ComponentGetValue2( v, "value_string" )
					
					if #p == 0 then
						p = "data/entities/projectiles/enlightened_laser_darkbeam.xml"
						ComponentSetValue2( v, "value_string", p )
					end
				end
			end
		end
		
		if #p > 0 then
			local angle = Random( 1, 4 ) * math.pi

			local vel_x = math.cos( angle ) * 100
			local vel_y = 0 - math.cos( angle ) * 100
			
			local wid = shoot_projectile( entity_id, "data/entities/animals/boss_pit/wand.xml", x, y, vel_x, vel_y )

			edit_component( wid, "VariableStorageComponent", function(comp,vars)
				ComponentSetValue2( comp, "value_string", p )
			end)
		end
	end
end