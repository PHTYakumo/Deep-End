dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)

if ( root_id == nil ) or ( root_id == NULL_ENTITY ) or EntityHasTag( root_id, "polymorphable_NOT" ) then
	EntityKill(entity_id)
	return
end

local childs = EntityGetAllChildren( root_id )

if ( childs ~= nil ) and ( not EntityHasTag( root_id, "player_unit" ) ) and ( not EntityHasTag( root_id, "boss" ) ) then
	for i=1,#childs do
		local childcomps = EntityGetComponent( childs[i], "GameEffectComponent" )

		if ( childcomps ~= nil ) then
			for j=1,#childcomps do
				local effect_str = ComponentGetValue2( childcomps[j], "effect" )

				if ( effect_str == "PROTECTION_ALL" ) or ( effect_str == "SAVING_GRACE" ) then
					EntityRemoveComponent( childs[i], childcomps[j] )
				end
			end
		end
	end
end

component_readwrite( EntityGetFirstComponent(root_id, "DamageModelComponent" ), { hp = 0, max_hp = 0, ragdoll_material = "meat" }, function(comp)
	local health_ratio = 0.1
	local convert_radius = 12

	local x, y = EntityGetFirstHitboxCenter(root_id)

	if ( ( comp.hp / comp.max_hp <= health_ratio ) or ( comp.hp <= 1.0 ) ) and ( comp.hp >= 0 ) and ( comp.max_hp > 0 ) then
		EntityRemoveFromParent(entity_id) -- detach to avoid being killed along with the enemy

		-- mWhoShot
		local who_shot = 0

		component_read(get_variable_storage_component(entity_id, "projectile_who_shot"), { value_int = 0 }, function(varstor_comp)
			who_shot = varstor_comp.value_int
		end)

		local no_gold_drop = false
		local pm_money_amount = 25
		local pm_hp_amount = 0

		edit_component_with_tag( root_id, "VariableStorageComponent", "no_gold_drop", function(comp,vars) no_gold_drop = true end )

		local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
		
		if ( comp_worldstate == nil ) then return end
		
		if not no_gold_drop then
			local trick_multiplier = ComponentGetValue2( comp_worldstate, "trick_kill_gold_multiplier" )
			local hah_amount_multiplier = math.max( math.floor( ModSettingGet( "DEEP_END.HELL_AND_HELL_HP" ) + 0.5 ), 1 )

			pm_money_amount = math.max( math.ceil( comp.max_hp * 2.5 * trick_multiplier * hah_amount_multiplier ), pm_money_amount )

			if EntityHasTag( root_id, "touchmagic_immunity" ) or EntityHasTag( root_id, "curse_NOT" ) or EntityHasTag( root_id, "necrobot_NOT" ) then
				EntityAddComponent( root_id, "VariableStorageComponent", 
				{ 
					_tags="no_gold_drop",
				} )
			end
		end

		if ComponentGetValue2( comp_worldstate, "perk_trick_kills_blood_money" ) then
			pm_hp_amount = math.max( math.floor( pm_money_amount / 495 * 50 ) * 0.02, pm_hp_amount )
			-- GamePrint(tostring(pm_hp_amount))
		end

		local money_prj = EntityLoad( "data/entities/projectiles/deck/petrify_midas_gold_drop.xml", x, y )

		EntityAddComponent( money_prj, "VariableStorageComponent", 
		{ 
			name="pm_money_amount",
			value_float=tostring( pm_money_amount ),
		} )

		EntityAddComponent( money_prj, "VariableStorageComponent", 
		{ 
			name="pm_hp_amount",
			value_float=tostring( pm_hp_amount ),
		} )
		
		if pm_hp_amount > 0.02 then
			local bloody_particle = EntityGetComponentIncludingDisabled( money_prj, "ParticleEmitterComponent" )

			if bloody_particle[1] ~= nil then
				for i=1,#bloody_particle do
					EntitySetComponentIsEnabled( money_prj, bloody_particle[i], true )
				end
			end
		end

		EntityInflictDamage(root_id, comp.max_hp * 10, "DAMAGE_CURSE", "$damage_curse", "NONE", 0, 0, who_shot)
		
		-- convert ragdoll material
		EntityAddComponent( entity_id, "MagicConvertMaterialComponent", 
		{ 
			from_material = CellFactory_GetType(comp.ragdoll_material),
			to_material = CellFactory_GetType("gold"),
			radius = 45,
			steps_per_frame = 12,
			kill_when_finished = "1",
		} )
	else
		EntityKill(entity_id)
	end
end)

