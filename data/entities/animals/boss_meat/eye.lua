dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local sprite = EntityGetFirstComponent( entity_id, "SpriteComponent" )

if ( sprite ~= nil ) then
	local statuscomp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "status" )
	local status = ComponentGetValue2( statuscomp, "value_int" )
	
	if ( status == 1 ) then
		GamePlayAnimation( entity_id, "open", 0, "opened", 0 )
		
		local hitcomp = EntityGetFirstComponent( entity_id, "HitboxComponent" )

		if ModSettingGet( "DEEP_END.MEAT_HEAL" ) then
			ComponentSetValue2( hitcomp, "damage_multiplier", 0.1 )
		else
			ComponentSetValue2( hitcomp, "damage_multiplier", 1.0 )

			EntitySetComponentsWithTagEnabled( entity_id, "vacuum", true )
			EntitySetComponentsWithTagEnabled( entity_id, "vacuum_NOT", false )
		end

		shoot_projectile( entity_id, "data/entities/projectiles/deck/de_circle_water.xml", x, y, 0, 0 )
	elseif ( status == 3 ) then
		GamePlayAnimation( entity_id, "close", 0, "stand", 0 )

		local hitcomp = EntityGetFirstComponent( entity_id, "HitboxComponent" )
		ComponentSetValue2( hitcomp, "damage_multiplier", 0 )

		if not ModSettingGet( "DEEP_END.MEAT_HEAL" ) then
			EntitySetComponentsWithTagEnabled( entity_id, "vacuum", false )
			EntitySetComponentsWithTagEnabled( entity_id, "vacuum_NOT", true )

			shoot_projectile( entity_id, "data/entities/animals/boss_meat/orb_big.xml", x, y-17, 0, 0 )
			shoot_projectile( entity_id, "data/entities/animals/boss_meat/orb_big.xml", x+15, y+9, 0, 0 )
			shoot_projectile( entity_id, "data/entities/animals/boss_meat/orb_big.xml", x-15, y+9, 0, 0 )
		end
	else
		local damagemodels = EntityGetComponent( entity_id, "DamageModelComponent" )

		if damagemodels ~= nil then for i,damagemodel in ipairs(damagemodels) do
			local max_hp = ComponentGetValue2( damagemodel, "max_hp" )
			local hp = ComponentGetValue2( damagemodel, "hp" )

			if ModSettingGet( "DEEP_END.MEAT_HEAL" ) then
				ComponentSetValue2( damagemodel, "max_hp", math.min( ( max_hp + 1.01 )^2, 24424424424424.4 ) )
				ComponentSetValue2( damagemodel, "hp", math.min( ( max_hp + 1.01 )^2, 24424424424424.4 ) )
			else
				local max_hp = ComponentGetValue2( damagemodel, "max_hp" )
				local hp = ComponentGetValue2( damagemodel, "hp" )

				ComponentSetValue2( damagemodel, "max_hp", math.min( max_hp * 2, 32768000 ) )
				ComponentSetValue2( damagemodel, "hp", math.min( max_hp + hp, max_hp * 2, 32768000 ) )
			end
		end end

		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/heart_fullhp", x, y )
		EntityAddChild( entity_id, EntityLoad( "data/entities/misc/effect_regeneration_boss_shorter.xml", x, y) )
	end

	if ModSettingGet( "DEEP_END.MEAT_HEAL" ) then
		EntitySetComponentsWithTagEnabled( entity_id, "vacuum", true )
		EntitySetComponentsWithTagEnabled( entity_id, "vacuum_NOT", false )

		if status > 0 then shoot_projectile( entity_id, "data/entities/animals/boss_meat/orb_big_homing.xml", x, y, 0, 0 ) end
	end
	
	status = ( status + 1 ) % 4
	ComponentSetValue2( statuscomp, "value_int", status )

	--[[
	local enemies = EntityGetInRadiusWithTag( x, y, 256, "enemy" )

	for i,enemy in ipairs( enemies ) do
		if not EntityHasTag( wid, "touchmagic_immunity" ) then EntityAddTag( wid, "touchmagic_immunity" ) end
		if not EntityHasTag( wid, "polymorphable_NOT" ) then EntityAddTag( wid, "polymorphable_NOT" ) end

		if not EntityHasTag( enemy, "no_swap" ) then
			EntityAddTag( enemy, "no_swap")

			if not EntityHasTag( enemy, "boss" ) then
				EntityAddComponent( enemy, "LuaComponent", {
					script_damage_about_to_be_received = "data/entities/animals/boss_wizard/orbit/dmg_cap.lua",
					execute_every_n_frame = "-1",
				} )
			end
		end
	end
	]]--
end