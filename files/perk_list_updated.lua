dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("data/scripts/gun/gun_enums.lua")
dofile_once("data/scripts/perks/perk_utilities.lua")
dofile( "data/scripts/game_helpers.lua" )

--[[

	Damage_multipliers  won't reset after the corresponding perks are removed,
	what can you do with boss_wizard?

]]--

de_perk_list_recompose =
{
	{
		id = "CRITICAL_HIT",
		ui_name = "$perk_critical_hit",
		ui_description = "$dperk_CRITICAL_HIT",
		ui_icon = "data/ui_gfx/perk_icons/critical_hit.png",
		perk_icon = "data/items_gfx/perks/critical_hit.png",
		game_effect = "CRITICAL_HIT_BOOST",
		particle_effect = "critical_hit_boost",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "critical_hit_boost",
			} )
		end,
	},
	{
		id = "BREATH_UNDERWATER",
		ui_name = "$perk_breath_underwater",
		ui_description = "$dbreath_underwater",
		ui_icon = "data/ui_gfx/perk_icons/breath_underwater.png",
		perk_icon = "data/items_gfx/perks/breath_underwater.png",
		game_effect = "BREATH_UNDERWATER",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if ( models ~= nil ) then
				for i,model in ipairs(models) do
					local swim_idle = clamp( ComponentGetValue2( model, "swim_idle_buoyancy_coeff" ) * 0.6, 0.0, 2.0 )
					local swim_up = clamp( ComponentGetValue2( model, "swim_up_buoyancy_coeff" ) * 0.2, 0.0, 2.0 )
					local swim_down = clamp( ComponentGetValue2( model, "swim_down_buoyancy_coeff" ) * 0.2, 0.0, 2.0 )
					
					local swim_drag = clamp( ComponentGetValue2( model, "swim_drag" ) * 1.2, 0.0, 1.01 )
					local swim_drag_extra = clamp( ComponentGetValue2( model, "swim_extra_horizontal_drag" ) * 1.2, 0.0, 1.01 )
					
					ComponentSetValue( model, "swim_idle_buoyancy_coeff", swim_idle )
					ComponentSetValue( model, "swim_up_buoyancy_coeff", swim_up )
					ComponentSetValue( model, "swim_down_buoyancy_coeff", swim_down )
					
					ComponentSetValue( model, "swim_drag", swim_drag )
					ComponentSetValue( model, "swim_extra_horizontal_drag", swim_drag_extra )
				end
			end
			
			-- Thanks to Cr4xy
			local damage_model_ = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if ( damage_model_ ~= nil ) then
				local air_max = ComponentGetValue2( damage_model_, "air_in_lungs_max" )
				ComponentSetValue( damage_model_, "air_in_lungs", air_max )
			end

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local radioactive_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "radioactive" ))
					radioactive_resistance = radioactive_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "radioactive", tostring(radioactive_resistance) )

					local poison_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "poison" ))
					poison_resistance = poison_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "poison", tostring(poison_resistance) )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if ( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue( model, "swim_idle_buoyancy_coeff", 1.2 )
					ComponentSetValue( model, "swim_up_buoyancy_coeff", 0.9 )
					ComponentSetValue( model, "swim_down_buoyancy_coeff", 0.7 )
					
					ComponentSetValue( model, "swim_drag", 0.95 )
					ComponentSetValue( model, "swim_extra_horizontal_drag", 0.9 )
				end
			end
		end,
	},
	-- gold / money related
	{
		id = "EXTRA_MONEY",
		ui_name = "$perk_extra_money",
		ui_description = "$perkdesc_extra_money",
		ui_icon = "data/ui_gfx/perk_icons/extra_money.png",
		perk_icon = "data/items_gfx/perks/extra_money.png",
		game_effect = "EXTRA_MONEY",
		stackable = STACKABLE_YES,
	},
	{
		id = "EXTRA_MONEY_TRICK_KILL",
		ui_name = "$perk_extra_money_trick_kill",
		ui_description = "$perkdesc_extra_money_trick_kill",
		ui_icon = "data/ui_gfx/perk_icons/extra_money_trick_kill.png",
		perk_icon = "data/items_gfx/perks/extra_money_trick_kill.png",
		game_effect = "EXTRA_MONEY_TRICK_KILL",
		stackable = STACKABLE_YES,
	},
	{
		-- Gold nuggets never go away
		id = "GOLD_IS_FOREVER",
		ui_name = "$perk_gold_is_forever",
		ui_description = "$dgold_is_forever",
		ui_icon = "data/ui_gfx/perk_icons/gold_is_forever.png",
		perk_icon = "data/items_gfx/perks/gold_is_forever.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO trick gold, drops blood gold which gives back hp+3
			local world_entity_id = GameGetWorldStateEntity()

			if ( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				
				if ( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "perk_gold_is_forever", "1" )
				end
			end

			local distance_full = tonumber( GlobalsGetValue( "PERK_ATTRACT_ITEMS_RANGE", "0" ) )
			
			if ( distance_full == 0 ) then
				GlobalsSetValue( "PERK_ATTRACT_ITEMS_RANGE", "100" )
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component",
					script_source_file = "data/scripts/perks/attract_items.lua",
					execute_every_n_frame = "30",
				} )
			else
				distance_full = math.max( distance_full + 75, 325 )
				GlobalsSetValue( "PERK_ATTRACT_ITEMS_RANGE", tostring(distance_full) )
			end
		end,
		func_remove = function( entity_who_picked )
			local world_entity_id = GameGetWorldStateEntity()

			if ( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )

				if ( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "perk_gold_is_forever", "0" )
				end
			end

			GlobalsSetValue( "PERK_ATTRACT_ITEMS_RANGE", "0" )
		end,
	},
	{
		id = "TRICK_BLOOD_MONEY",
		ui_name = "$perk_trick_blood_money",
		ui_description = "$perkdesc_trick_blood_money",
		ui_icon = "data/ui_gfx/perk_icons/trick_blood_money.png",
		perk_icon = "data/items_gfx/perks/trick_blood_money.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO trick gold, drops blood gold which gives back hp+3
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if ( comp_worldstate ~= nil ) then
					local perk_trick_blood_money = ComponentGetValue2( comp_worldstate, "perk_trick_kills_blood_money" )
					if ( perk_trick_blood_money ) then
						local perk_hp_drop_chance = tonumber( ComponentGetValue2( comp_worldstate, "perk_hp_drop_chance" ) )
						perk_hp_drop_chance = perk_hp_drop_chance + 20
						ComponentSetValue2( comp_worldstate, "perk_hp_drop_chance", perk_hp_drop_chance )
					else
						ComponentSetValue( comp_worldstate, "perk_trick_kills_blood_money", "1" )
					end
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if ( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "perk_trick_kills_blood_money", "0" )
					ComponentSetValue2( comp_worldstate, "perk_hp_drop_chance", 0 )
				end
			end
		end,
	},
	{
		id = "EXPLODING_GOLD",
		ui_name = "$perk_exploding_gold",
		ui_description = "$perkdesc_exploding_gold",
		ui_icon = "data/ui_gfx/perk_icons/exploding_gold.png",
		perk_icon = "data/items_gfx/perks/exploding_gold.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 6,
		max_in_perk_pool = 1,
		func = function( entity_perk_item, entity_who_picked, item_name )
			GameAddFlagRun( "exploding_gold" )
		end,
		func_remove = function( entity_who_picked )
			GameRemoveFlagRun( "exploding_gold" )
		end,
		
	},
	-- movement related
	{
		id = "HOVER_BOOST",
		ui_name = "$perk_hover_boost",
		ui_description = "$perkdesc_hover_boost",
		ui_icon = "data/ui_gfx/perk_icons/hover_boost.png",
		perk_icon = "data/items_gfx/perks/hover_boost.png",
		game_effect = "HOVER_BOOST",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 1,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local comp = EntityGetFirstComponent( entity_who_picked, "CharacterDataComponent" )
			if comp ~= nil then ComponentSetValue2( comp, "mFlyingTimeLeft", 3*1024 ) end
		end,
	},
	{
		id = "MOVEMENT_FASTER",
		ui_name = "$perk_movement_faster",
		ui_description = "$perkdesc_movement_faster",
		ui_icon = "data/ui_gfx/perk_icons/movement_faster.png",
		perk_icon = "data/items_gfx/perks/movement_faster.png",
		game_effect = "MOVEMENT_FASTER",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 2,
		usable_by_enemies = true,
	},
	{
		id = "STRONG_KICK",
		ui_name = "$perk_strong_kick",
		ui_description = "$dstrong_kick",
		ui_icon = "data/ui_gfx/perk_icons/strong_kick.png",
		perk_icon = "data/items_gfx/perks/strong_kick.png",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 1,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local models = EntityGetComponent( entity_who_picked, "KickComponent" )
			if ( models ~= nil ) then
				for i,model in ipairs(models) do
					local kick_force = tonumber( ComponentGetMetaCustom( model, "max_force" ) ) * 3
					local player_kick_force = tonumber( ComponentGetMetaCustom( model, "player_kickforce" ) ) * 3
					local kick_damage = tonumber( ComponentGetMetaCustom( model, "kick_damage" ) ) * 50 + 0.4
					local kick_knockback = tonumber( ComponentGetMetaCustom( model, "kick_knockback" ) ) * 3 + 81
					local telekinesis_throw_speed = ComponentGetValue2( model, "telekinesis_throw_speed" ) + 80

					ComponentSetMetaCustom( model, "max_force", kick_force )
					ComponentSetMetaCustom( model, "player_kickforce", player_kick_force )
					ComponentSetMetaCustom( model, "kick_damage", kick_damage )
					ComponentSetMetaCustom( model, "kick_knockback", kick_knockback )
					ComponentSetValue2( model, "telekinesis_throw_speed", telekinesis_throw_speed )

					ComponentSetValue2( model, "kick_radius", 5 )
					ComponentSetValue2( model, "kick_entities", ",data/entities/misc/crack_ice.xml,data/entities/misc/perks/thermal_impact.xml" )
				end
			end

			models = EntityGetComponent( entity_who_picked, "TelekinesisComponent" )
			if ( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue2( model, "throw_speed", ComponentGetValue2( model, "throw_speed" ) + 80 )
				end
			end

			local climb = EntityGetFirstComponent( entity_who_picked, "CharacterDataComponent" )
			if ( climb ~= nil ) then
				ComponentSetValue( climb, "climb_over_y", "8" ) -- "4"
			end

			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/de_strong_kick.lua",
				execute_every_n_frame = "1",
			} )
		end,
		func_remove = function( entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "KickComponent" )
			if ( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetMetaCustom( model, "max_force", 12.0 )
					ComponentSetMetaCustom( model, "player_kickforce", 28.0 )
					ComponentSetMetaCustom( model, "kick_damage", 0.04 )
					ComponentSetMetaCustom( model, "kick_knockback", 3.0 )
					ComponentSetValue2( model, "telekinesis_throw_speed", 25.0 )
					ComponentSetValue2( model, "kick_radius", 3 )
					ComponentSetValue2( model, "kick_entities", "" )
				end
			end

			models = EntityGetComponent( entity_who_picked, "TelekinesisComponent" )
			if ( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue2( model, "throw_speed", 25.0 )
				end
			end
		end,
	},
	{
		id = "TELEKINESIS",
		ui_name = "$perk_telekinesis",
		ui_description = "$perkdesc_telekinesis",
		ui_icon = "data/ui_gfx/perk_icons/telekinesis.png",
		perk_icon = "data/items_gfx/perks/telekinesis.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityLoadToEntity( "data/entities/misc/perk_telekinesis.xml", entity_who_picked )
			-- component_write( EntityGetFirstComponent( entity_who_picked, "KickComponent" ), { can_kick = false } )
			
			local throw_speed = 25
			local models = EntityGetComponent( entity_who_picked, "KickComponent" )
			if ( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue2( model, "can_kick", false )
					local ts = tonumber( ComponentGetValue2( model, "telekinesis_throw_speed" ) )
					if ( ts > throw_speed ) then throw_speed = ts end
				end
			end
			-- component_write( EntityGetFirstComponent( entity_who_picked, "TelekinesisComponent" ), { throw_speed = throw_speed } )
			local tks = EntityGetFirstComponent( entity_who_picked, "TelekinesisComponent" )
			if ( tks ~= nil ) then ComponentSetValue2( tks, "throw_speed", throw_speed ) end
		end,
		func_remove = function( entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "KickComponent" )
			if ( models ~= nil ) then
				for i,model in ipairs(models) do
					ComponentSetValue2( model, "can_kick", true )
				end
			end
			-- TODO( Petri ): Remove the perk_telekinesis.xml stuff from the entity
		end,
	},
	{
		id = "REPELLING_CAPE",
		ui_name = "$perk_repelling_cape",
		ui_description = "$perkdesc_repelling_cape",
		ui_icon = "data/ui_gfx/perk_icons/repelling_cape.png",
		perk_icon = "data/items_gfx/perks/repelling_cape.png",
		game_effect = "STAINS_DROP_FASTER",
		game_effect2 = "NO_DAMAGE_FLASH",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 8,
		max_in_perk_pool = 2,
	},
	{
		id = "EXPLODING_CORPSES",
		ui_name = "$perk_exploding_corpses",
		ui_description = "$perkdesc_exploding_corpses",
		ui_icon = "data/ui_gfx/perk_icons/exploding_corpses.png",
		perk_icon = "data/items_gfx/perks/exploding_corpses.png",
		remove_other_perks = {"PROTECTION_EXPLOSION"},
		stackable = STACKABLE_NO,
		game_effect = "EXPLODING_CORPSE_SHOTS",
		game_effect2 = "PROTECTION_EXPLOSION",
		func = function( entity_perk_item, entity_who_picked, item_name )
			add_halo_level(entity_who_picked, -1)
		end,
	},
	{
		id = "SAVING_GRACE",
		ui_name = "$perk_saving_grace",
		ui_description = "$perkdesc_saving_grace",
		ui_icon = "data/ui_gfx/perk_icons/saving_grace.png",
		perk_icon = "data/items_gfx/perks/saving_grace.png",
		game_effect = "SAVING_GRACE",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			add_halo_level(entity_who_picked, 1)
		end,
	},
	{
		id = "REMOVE_FOG_OF_WAR",
		ui_name = "$perk_remove_fog_of_war",
		ui_description = "$dX_RAY",
		ui_icon = "data/ui_gfx/perk_icons/remove_fog_of_war.png",
		perk_icon = "data/items_gfx/perks/remove_fog_of_war.png",
		game_effect = "REMOVE_FOG_OF_WAR",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			GlobalsSetValue( "DEEP_END_REMOVE_FOG_OF_WAR", "t" )

			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/x_ray_light.xml", x, y )
			
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
		func_remove = function( entity_who_picked )
			GlobalsSetValue( "DEEP_END_REMOVE_FOG_OF_WAR", "f" )
		end,
	},
	{
		id = "EXTRA_HP",
		ui_name = "$perk_extra_hp",
		ui_description = "$perkdesc_extra_hp",
		ui_icon = "data/ui_gfx/perk_icons/extra_hp.png",
		perk_icon = "data/items_gfx/perks/extra_hp.png",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 3,
		one_off_effect = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local old_max_hp = ComponentGetValue2( damagemodel, "max_hp" )
					local max_hp = old_max_hp * 1.5
					
					local max_hp_cap = ComponentGetValue2( damagemodel, "max_hp_cap" )
					if max_hp_cap > 0 then
						max_hp = math.min( max_hp, max_hp_cap )
					end
					
					local current_hp = ComponentGetValue2( damagemodel, "hp" )
					current_hp = math.min( current_hp + math.abs(max_hp - old_max_hp), max_hp )
					
					ComponentSetValue( damagemodel, "max_hp", max_hp )
					ComponentSetValue( damagemodel, "hp", current_hp )
				end
			end
		end,
	},
	{
		id = "HEARTS_MORE_EXTRA_HP",
		ui_name = "$perk_hearts_more_extra_hp",
		ui_description = "$perkdesc_hearts_more_extra_hp",
		ui_icon = "data/ui_gfx/perk_icons/hearts_more_extra_hp.png",
		perk_icon = "data/items_gfx/perks/hearts_more_extra_hp.png",
		stackable = STACKABLE_YES,
		stackable_maximum = 9,
		max_in_perk_pool = 2,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO heart containers give 2x more health
			local heart_multiplier = tonumber( GlobalsGetValue( "HEARTS_MORE_EXTRA_HP_MULTIPLIER", "1" ) )
			
			if ( heart_multiplier < 2.0 ) then
				heart_multiplier = heart_multiplier + 1.0
			elseif ( heart_multiplier < 4 ) then
				heart_multiplier = heart_multiplier + 0.5
			end
			
			GlobalsSetValue( "HEARTS_MORE_EXTRA_HP_MULTIPLIER", tostring( heart_multiplier ) )
		end,
		func_remove = function( entity_who_picked )
			GlobalsSetValue( "HEARTS_MORE_EXTRA_HP_MULTIPLIER", "1" )
		end,
	},
	{
		id = "GLASS_CANNON",
		ui_name = "$perk_glass_cannon",
		ui_description = "$dglass_cannon",
		ui_icon = "data/ui_gfx/perk_icons/glass_cannon.png",
		perk_icon = "data/items_gfx/perks/glass_cannon.png",
		game_effect = "DAMAGE_MULTIPLIER",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 2,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local dmg_multiplier = 4.0
					
					local melee = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "melee" ) )
					local projectile = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ) )
					local explosion = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ) )
					local electricity = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "electricity" ) )
					local fire = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "fire" ) )
					local drill = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "drill" ) )
					local slice = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "slice" ) )
					local ice = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "ice" ) )
					local healing = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "healing" ) )
					local physics_hit = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "physics_hit" ) )
					local radioactive = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "radioactive" ) )
					local poison = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "poison" ) )
					local curse = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "curse" ) )
					local holy = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "holy" ) )

					melee = melee * dmg_multiplier
					projectile = projectile * dmg_multiplier
					explosion = explosion * dmg_multiplier
					electricity = electricity * dmg_multiplier
					fire = fire * dmg_multiplier
					drill = drill * dmg_multiplier
					slice = slice * dmg_multiplier
					ice = ice * dmg_multiplier
					healing = healing * dmg_multiplier
					physics_hit = physics_hit * dmg_multiplier
					radioactive = radioactive * dmg_multiplier
					poison = poison * dmg_multiplier
					curse = curse * dmg_multiplier
					holy = holy * dmg_multiplier

					ComponentObjectSetValue( damagemodel, "damage_multipliers", "melee", tostring(melee) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "electricity", tostring(electricity) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(fire) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "drill", tostring(drill) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "slice", tostring(slice) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "ice", tostring(ice) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "healing", tostring(healing) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "physics_hit", tostring(physics_hit) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "radioactive", tostring(radioactive) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "poison", tostring(poison) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "curse", tostring(curse) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "holy", tostring(holy) )
				end
			end
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local max_hp = ComponentGetValue2( damagemodel, "max_hp" )
					max_hp = max_hp / 25 / 5
					
					--ComponentSetValue( damagemodel, "hp", math.min( hp, max_hp ) )
					ComponentSetValue( damagemodel, "max_hp", max_hp )
					ComponentSetValue( damagemodel, "max_hp_cap", max_hp )
					ComponentSetValue( damagemodel, "hp", max_hp )
				end
			end
			
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/glass_cannon_enemy.lua",
				execute_every_n_frame = "-1",
			} )
		end,
		func_remove = function( entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local max_hp = ComponentGetValue2( damagemodel, "max_hp" ) * 25
					ComponentSetValue( damagemodel, "max_hp_cap", 0.0 )
					
					if ( max_hp < 100 ) then
						ComponentSetValue( damagemodel, "max_hp", 4 )
						ComponentSetValue( damagemodel, "hp", 4 )
					end
				end
			end
		end,
	},
	{
		id = "LOW_HP_DAMAGE_BOOST",
		ui_name = "$perk_spell_duplication",
		ui_description = "$dLOW_HP_DAMAGE_BOOST",
		ui_icon = "data/ui_gfx/perk_icons/duplicate_projectile.png",
		perk_icon = "data/items_gfx/perks/duplicate_projectile.png",
		game_effect = "LOW_HP_DAMAGE_BOOST",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 2,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "duplicate_projectile",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 1.1
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				end
			end
		end,
	},
	{
		id = "RESPAWN",
		ui_name = "$perk_respawn",
		ui_description = "$perkdesc_respawn",
		ui_icon = "data/ui_gfx/perk_icons/respawn.png",
		perk_icon = "data/items_gfx/perks/respawn.png",
		game_effect = "RESPAWN",
		one_off_effect = true,
		do_not_remove = true,
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			add_halo_level(entity_who_picked, 1)

			if ( not EntityHasTag( entity_who_picked, "de_respawn" ) ) then EntityAddTag( entity_who_picked, "de_respawn") end
		end,
	},

	{
		id = "WORM_ATTRACTOR",
		ui_name = "$perk_worm_attractor",
		ui_description = "$dworm_attractor",
		ui_icon = "data/ui_gfx/perk_icons/worm_attractor.png",
		perk_icon = "data/items_gfx/perks/worm_attractor.png",
		remove_other_perks = {"PROTECTION_MELEE"},
		game_effect = "WORM_ATTRACTOR",
		game_effect2 = "PROTECTION_MELEE",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
	},
	{
		id = "RADAR_ENEMY",
		ui_name = "$perk_radar_enemy",
		ui_description = "$perkdesc_radar_enemy",
		ui_icon = "data/ui_gfx/perk_icons/radar_enemy.png",
		perk_icon = "data/items_gfx/perks/radar_enemy.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/radar.lua",
				execute_every_n_frame = "1",
			} )
		end,
	},
	{
		id = "IRON_STOMACH",
		ui_name = "$perk_iron_stomach",
		ui_description = "$perkdesc_iron_stomach",
		ui_icon = "data/ui_gfx/perk_icons/iron_stomach.png",
		perk_icon = "data/items_gfx/perks/iron_stomach.png",
		game_effect = "IRON_STOMACH",
		stackable = STACKABLE_NO,
	},
	{
		id = "WAND_RADAR",
		ui_name = "$perk_radar_wand",
		ui_description = "$dradar_wand",
		ui_icon = "data/ui_gfx/perk_icons/radar_wand.png",
		perk_icon = "data/items_gfx/perks/radar_wand.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/radar_wand.lua",
				execute_every_n_frame = "1",
			} )

			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/radar_item.lua",
				execute_every_n_frame = "1",
			} )
		end,
	},
	{
		id = "MOON_RADAR",
		ui_name = "$perk_radar_moon",
		ui_description = "$perkdesc_radar_moon",
		ui_icon = "data/ui_gfx/perk_icons/radar_moon.png",
		perk_icon = "data/items_gfx/perks/radar_moon.png",
		not_in_default_perk_pool = true,
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/radar_moon.lua",
				execute_every_n_frame = "1",
			} )
		end,
	},
	{
		id = "MAP",
		ui_name = "$deep_end_perk_map",
		ui_description = "$deep_end_map_perk",
		ui_icon = "data/ui_gfx/perk_icons/map.png",
		perk_icon = "data/items_gfx/perks/map.png",
		not_in_default_perk_pool = true,
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/map.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
	},
	{
		id = "DASH",
		ui_name = "$DASH",
		ui_description = "$dDASH",
		ui_icon = "data/ui_gfx/perk_icons/dash.png",
		perk_icon = "data/items_gfx/perks/dash.png",
		not_in_default_perk_pool = true,
		one_off_effect = true,
		do_not_remove = true,
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if ( pickup_count == 1 ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{ 
					script_source_file="data/scripts/perks/double_tap_to_dash.lua",
					execute_every_n_frame="1",
				} )

				EntityAddComponent( entity_who_picked, "VariableStorageComponent", 
				{ 
					name="tap_state",
					value_int="0",
				} )

				EntityAddComponent( entity_who_picked, "VariableStorageComponent", 
				{ 
					name="tap_timer",
					value_int="0",
				} )

				EntityAddComponent( entity_who_picked, "VariableStorageComponent", 
				{ 
					name="cd_timer",
					value_int="30",
				} )

				EntityAddComponent( entity_who_picked, "VariableStorageComponent", 
				{ 
					name="slash_timer",
					value_int="10",
				} )

				EntityAddComponent( entity_who_picked, "VariableStorageComponent", 
				{ 
					name="flash_timer",
					value_int="6",
				} )

				local Chara_Data_Comp = EntityGetFirstComponent( entity_who_picked, "CharacterDataComponent" )
				local Chara_Pf_Comp = EntityGetFirstComponent( entity_who_picked, "CharacterPlatformingComponent" )

				if ( Chara_Data_Comp ~= nil ) then
					ComponentSetValue( Chara_Data_Comp, "climb_over_y", "8" ) -- "4"
				end

				if ( Chara_Pf_Comp ~= nil ) then
					ComponentSetValue( Chara_Pf_Comp, "jump_velocity_y", "-152" ) -- "-95"
					ComponentSetValue( Chara_Pf_Comp, "jump_velocity_x", "98" ) -- "56"
					ComponentSetValue( Chara_Pf_Comp, "pixel_gravity", "320" ) -- "350"
				end
			end
		end,
	},
	{
		id = "PROTECTION_EXPLOSION",
		ui_name = "$perk_protection_explosion",
		ui_description = "$perkdesc_protection_explosion",
		ui_icon = "data/ui_gfx/perk_icons/protection_explosion.png",
		perk_icon = "data/items_gfx/perks/protection_explosion.png",
		game_effect = "PROTECTION_EXPLOSION",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
	},
	{
		id = "PROTECTION_MELEE",
		ui_name = "$perk_protection_melee",
		ui_description = "$perkdesc_protection_melee",
		ui_icon = "data/ui_gfx/perk_icons/protection_melee.png",
		perk_icon = "data/items_gfx/perks/protection_melee.png",
		game_effect = "PROTECTION_MELEE",
		stackable = STACKABLE_NO,
	},
	{
		id = "PROTECTION_ELECTRICITY",
		ui_name = "$perk_protection_electricity",
		ui_description = "$perkdesc_protection_electricity",
		ui_icon = "data/ui_gfx/perk_icons/protection_electricity.png",
		perk_icon = "data/items_gfx/perks/protection_electricity.png",
		game_effect = "PROTECTION_ELECTRICITY",
		stackable = STACKABLE_NO,
	},
	{
		id = "PROTECTION_FIRE",
		ui_name = "$perk_protection_fire",
		ui_description = "$dPROTECTION_FIRE",
		ui_icon = "data/ui_gfx/perk_icons/protection_fire.png",
		perk_icon = "data/items_gfx/perks/protection_fire.png",
		game_effect = "PROTECTION_FIRE",
		game_effect2 = "STUN_PROTECTION_FREEZE",
		usable_by_enemies = true,
		not_in_default_perk_pool = true,
		one_off_effect = true,
		do_not_remove = true,
	},
	{
		id = "PROTECTION_RADIOACTIVITY",
		ui_name = "$perk_protection_radioactivity",
		ui_description = "$dPROTECTION_RADIOACTIVITY",
		ui_icon = "data/ui_gfx/perk_icons/protection_radioactivity.png",
		perk_icon = "data/items_gfx/perks/protection_radioactivity.png",
		game_effect = "PROTECTION_RADIOACTIVITY",
		game_effect2 = "PROTECTION_FOOD_POISONING",
		not_in_default_perk_pool = true,
		one_off_effect = true,
		do_not_remove = true,
	},
	{
		id = "TELEPORTITIS_DODGE",
		ui_name = "$perk_teleportitis_dodge",
		ui_description = "$perkdesc_teleportitis_dodge",
		ui_icon = "data/ui_gfx/perk_icons/teleportitis_dodge.png",
		perk_icon = "data/items_gfx/perks/teleportitis_dodge.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/teleportitis_dodge.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
	},
	{
		id = "STAINLESS_ARMOUR",
		ui_name = "$perk_stainless_armour",
		ui_description = "$perkdesc_stainless_armour",
		ui_icon = "data/ui_gfx/perk_icons/stainless_armour.png",
		perk_icon = "data/items_gfx/perks/stainless_armour.png",
		game_effect = "STAINLESS_ARMOUR",
		game_effect2 = "NO_DAMAGE_FLASH",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
	},

	-- WAND & ACTION AFFECTORS
	{
		id = "EDIT_WANDS_EVERYWHERE",
		ui_name = "$perk_edit_wands_everywhere",
		ui_description = "$perkdesc_edit_wands_everywhere",
		ui_icon = "data/ui_gfx/perk_icons/edit_wands_everywhere.png",
		perk_icon = "data/items_gfx/perks/edit_wands_everywhere.png",
		game_effect = "EDIT_WANDS_EVERYWHERE",
		stackable = STACKABLE_NO,
	},
	{
		id = "NO_WAND_EDITING",
		ui_name = "$perk_no_wand_editing",
		ui_description = "$dno_wand_editing",
		ui_icon = "data/ui_gfx/perk_icons/no_wand_editing.png",
		perk_icon = "data/items_gfx/perks/no_wand_editing.png",
		game_effect = "NO_WAND_EDITING",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
			local perk_hp_drop_chance = tonumber( ComponentGetValue2( comp_worldstate, "perk_hp_drop_chance" ) )

			perk_hp_drop_chance = perk_hp_drop_chance + 100
			ComponentSetValue2( comp_worldstate, "perk_hp_drop_chance", perk_hp_drop_chance )
		end,
		func_remove = function( entity_perk_item, entity_who_picked, item_name )
			local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
			ComponentSetValue2( comp_worldstate, "perk_hp_drop_chance", 0 )
		end,
	},
	{
		-- shooting unedited wands gives back HP
		id = "WAND_EXPERIMENTER",
		ui_name = "$perk_wand_experimenter",
		ui_description = "$perkdesc_wand_experimenter",
		ui_icon = "data/ui_gfx/perk_icons/wand_experimenter.png",
		perk_icon = "data/items_gfx/perks/wand_experimenter.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_wand_fired = "data/scripts/perks/wand_experimenter.lua",
				execute_every_n_frame = "-1",
			} )
			
		end,
	},
	{
		-- shooting unedited wands gives back HP
		id = "ADVENTURER",
		ui_name = "$perk_adventurer",
		ui_description = "$perkdesc_adventurer",
		ui_icon = "data/ui_gfx/perk_icons/adventurer.png",
		perk_icon = "data/items_gfx/perks/adventurer.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/adventurer.lua",
				execute_every_n_frame = "60",
			} )
			
		end,
	},
	{
		id = "PROJECTILE_HOMING",
		ui_name = "$perk_projectile_homing",
		ui_description = "$perkdesc_projectile_homing",
		ui_icon = "data/ui_gfx/perk_icons/projectile_homing.png",
		perk_icon = "data/items_gfx/perks/projectile_homing.png",
		game_effect = "PROJECTILE_HOMING",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				script_shot = "data/scripts/perks/projectile_homing_enemy.lua",
				execute_every_n_frame = "-1",
			} )
		end,
	},
	{
		id = "PROJECTILE_HOMING_SHOOTER",
		ui_name = "$perk_projectile_homing_shooter",
		ui_description = "$dprojectile_homing_shooter",
		ui_icon = "data/ui_gfx/perk_icons/projectile_homing_shooter.png",
		perk_icon = "data/items_gfx/perks/projectile_homing_shooter.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )

			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "projectile_homing_shooter",
			} )
			
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "powerful_shot",
			} )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/projectile_homing_shooter_enemy.lua",
				execute_every_n_frame = "-1",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					local explosion_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ))
					
					explosion_resistance = explosion_resistance * 0.8
					projectile_resistance = projectile_resistance * 0.8
					
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion_resistance) )
				end
			end
		end,
	},
	{
		id = "UNLIMITED_SPELLS",
		ui_name = "$perk_unlimited_spells",
		ui_description = "$perkdesc_unlimited_spells",
		ui_icon = "data/ui_gfx/perk_icons/unlimited_spells.png",
		perk_icon = "data/items_gfx/perks/unlimited_spells.png",
		stackable = STACKABLE_NO,
		-- almost all spells of limited use become unlimited
		func = function( entity_perk_item, entity_who_picked, item_name )
			ComponentSetValue( EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" ), "perk_infinite_spells", "1" )

			-- this goes through the items player is holding and sets their uses_remaining to -1
			GameRegenItemActionsInPlayer( entity_who_picked )

			-- UI refreshing, for some reason the uses_remaining remains somewhere
			-- This selects the current wand again, which seems to fix the uses_remaining remaining in various uses
			local inventory2_comp = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" )
			if inventory2_comp ~= nil then ComponentSetValue( inventory2_comp, "mActualActiveItem", "0" ) end
		end,
		func_remove = function( entity_who_picked )
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
				if ( comp_worldstate ~= nil ) then
					ComponentSetValue( comp_worldstate, "perk_infinite_spells", "0" )
				end
			end

			-- this goes through the items player is holding and sets their uses_remaining to -1
			GameRegenItemActionsInPlayer( entity_who_picked )

			-- UI refreshing, for some reason the uses_remaining remains somewhere
			-- This selects the current wand again, which seems to fix the uses_remaining remaining in various uses
			local inventory2_comp = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" )
			if ( inventory2_comp ) then
				ComponentSetValue( inventory2_comp, "mActualActiveItem", "0" )
			end
		end,
	},
	{
		id = "FIRE_GAS",
		ui_name = "$perk_gas_fire",
		ui_description = "$dgas_fire",
		ui_icon = "data/ui_gfx/perk_icons/fire_gas.png",
		perk_icon = "data/items_gfx/perks/fire_gas.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/fire_gas.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
            if ( damagemodels ~= nil ) then
                for i,damagemodel in ipairs(damagemodels) do
                    local fire_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "fire" ))
                    fire_resistance = fire_resistance * 0.75
                    ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(fire_resistance) )

                    local ice_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "ice" ))
                    ice_resistance = ice_resistance * 0.75
                    ComponentObjectSetValue( damagemodel, "damage_multipliers", "ice", tostring(ice_resistance) )
                end
            end
			
		end,
	},
	{
		id = "DISSOLVE_POWDERS",
		ui_name = "$perk_dissolve_powders",
		ui_description = "$ddissolve_powders",
		ui_icon = "data/ui_gfx/perk_icons/dissolve_powders.png",
		perk_icon = "data/items_gfx/perks/dissolve_powders.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/dissolve_powders.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local radioactive_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "radioactive" ))
					radioactive_resistance = radioactive_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "radioactive", tostring(radioactive_resistance) )

					local poison_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "poison" ))
					poison_resistance = poison_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "poison", tostring(poison_resistance) )
				end
			end
		end,
	},
	{
		id = "BLEED_SLIME",
		ui_name = "$perk_bleed_slime",
		ui_description = "$dbleed_slime",
		ui_icon = "data/ui_gfx/perk_icons/slime_blood.png",
		perk_icon = "data/items_gfx/perks/slime_blood.png",
		game_effect = "NO_SLIME_SLOWDOWN",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		usable_by_mult_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "slime" )
					ComponentSetValue( damagemodel, "blood_spray_material", "slime" )
					ComponentSetValue( damagemodel, "blood_multiplier", "0.8" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_purple_$[1-3].xml" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_purple_$[1-3].xml" )
					
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )

					local fire_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "fire" ))
					fire_resistance = fire_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(fire_resistance) )

					local ice_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "ice" ))
					ice_resistance = ice_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "ice", tostring(ice_resistance) )
				end
			end
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "slime" )
					ComponentSetValue( damagemodel, "blood_spray_material", "slime" )
					ComponentSetValue( damagemodel, "blood_multiplier", "4.0" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_purple_$[1-3].xml" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_purple_$[1-3].xml" )
					
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 0.25
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )

					local fire_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "fire" ))
					fire_resistance = fire_resistance * 0.25
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(fire_resistance) )

					local ice_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "ice" ))
					ice_resistance = ice_resistance * 0.25
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "ice", tostring(ice_resistance) )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "blood" )
					ComponentSetValue( damagemodel, "blood_spray_material", "blood" )
					ComponentSetValue( damagemodel, "blood_multiplier", "1.1" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "" )
					-- ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
				end
			end
		end,
	},
	{
		id = "SHIELD",
		ui_name = "$perk_shield",
		ui_description = "$perkdesc_shield",
		ui_icon = "data/ui_gfx/perk_icons/shield.png",
		perk_icon = "data/items_gfx/perks/shield.png",
		stackable = STACKABLE_YES,
		stackable_how_often_reappears = 10,
		stackable_maximum = 5,
		max_in_perk_pool = 2,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/shield.xml", x, y )
			
			local shield_num = tonumber( GlobalsGetValue( "PERK_SHIELD_COUNT", "0" ) )
			local shield_radius = math.min( 12.5 + shield_num * 2.48, 29.86 ) + shield_num * 0.02
			local charge_speed = math.max( 0.20 + shield_num * 0.05, 0.55 )
			shield_num = shield_num + 1
			GlobalsSetValue( "PERK_SHIELD_COUNT", tostring( shield_num ) )
			
			local comps = EntityGetComponent( child_id, "EnergyShieldComponent" )
			if ( comps ~= nil ) then
				for i,comp in ipairs( comps ) do
					ComponentSetValue2( comp, "radius", shield_radius )
					ComponentSetValue2( comp, "recharge_speed", charge_speed )
				end
			end
			
			comps = EntityGetComponent( child_id, "ParticleEmitterComponent" )
			if ( comps ~= nil ) then
				for i,comp in ipairs( comps ) do
					local minradius,maxradius = ComponentGetValue2( comp, "area_circle_radius" )
					
					if ( minradius ~= nil ) and ( maxradius ~= nil ) then
						if ( minradius == 0 ) then
							ComponentSetValue2( comp, "area_circle_radius", 0, shield_radius )
						elseif ( minradius == 10 ) then
							ComponentSetValue2( comp, "area_circle_radius", shield_radius, shield_radius )
							if ( shield_radius > 20 ) then
								local shield_article_multi = math.min( 1.5 + shield_num * 0.1, 7.8 )

								ComponentSetValue2( comp, "count_min", math.floor( ComponentGetValue2( comp, "count_min" ) * shield_article_multi ) )
								ComponentSetValue2( comp, "count_max", math.floor( ComponentGetValue2( comp, "count_max" ) * shield_article_multi ) )
							end
						end
					end
				end
			end
			
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/de_shield_enemy.xml", x, y )
			EntityAddChild( entity_who_picked, child_id )
		end,
		func_remove = function( entity_who_picked )
			local shield_num = 0
			GlobalsSetValue( "PERK_SHIELD_COUNT", tostring( shield_num ) )
		end,
	},
	{
		id = "REVENGE_EXPLOSION",
		ui_name = "$perk_revenge_explosion",
		ui_description = "$drevenge_explosion",
		ui_icon = "data/ui_gfx/perk_icons/revenge_explosion.png",
		perk_icon = "data/items_gfx/perks/revenge_explosion.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		usable_by_mult_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_damage_received = "data/scripts/perks/revenge_explosion.lua",
				execute_every_n_frame = "-1",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local explosion_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ))
					explosion_resistance = explosion_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion_resistance) )

					local fire_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "fire" ))
					fire_resistance = fire_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(fire_resistance) )

					local ice_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "ice" ))
					ice_resistance = ice_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "ice", tostring(ice_resistance) )
				end
			end
		end,
		func_remove = function( entity_who_picked )		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					-- ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", "0.35" )
				end
			end
		end,
	},
	{
		id = "REVENGE_TENTACLE",
		ui_name = "$perk_revenge_tentacle",
		ui_description = "$drevenge_tentacle",
		ui_icon = "data/ui_gfx/perk_icons/revenge_tentacle.png",
		perk_icon = "data/items_gfx/perks/revenge_tentacle.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		usable_by_mult_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_damage_received = "data/scripts/perks/revenge_tentacle.lua",
				execute_every_n_frame = "-1",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )

					local slice_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "slice" ))
					slice_resistance = slice_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "slice", tostring(slice_resistance) )

					local drill_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "drill" ))
					drill_resistance = drill_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "drill", tostring(drill_resistance) )
				end
			end
		end,
		func_remove = function( entity_who_picked )		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					-- ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
				end
			end
		end,
	},
	{
		id = "REVENGE_RATS",
		ui_name = "$perk_revenge_rats",
		ui_description = "$drevenge_rats",
		ui_icon = "data/ui_gfx/perk_icons/revenge_rats.png",
		perk_icon = "data/items_gfx/perks/revenge_rats.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_damage_received = "data/scripts/perks/revenge_rats.lua",
				execute_every_n_frame = "-1",
			} )
			
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = true, } )
			end
			
			perk_pickup_event("RAT")

			local x,y = EntityGetTransform( entity_who_picked )
			CreateItemActionEntity( "DE_RAT_SUMMON", x, y )
			
			add_rattiness_level(entity_who_picked)
			--GenomeSetHerdId( entity_who_picked, "rat" )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local slice_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "slice" ))
					slice_resistance = slice_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "slice", tostring(slice_resistance) )

					local drill_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "drill" ))
					drill_resistance = drill_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "drill", tostring(drill_resistance) )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			-- reset_perk_pickup_event("RAT")
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = false, } )
			end
		end,
	},
	{
		id = "REVENGE_BULLET",
		ui_name = "$perk_revenge_bullet",
		ui_description = "$drevenge_bullet",
		ui_icon = "data/ui_gfx/perk_icons/revenge_bullet.png",
		perk_icon = "data/items_gfx/perks/revenge_bullet.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		usable_by_mult_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_damage_received = "data/scripts/perks/revenge_bullet.lua",
				execute_every_n_frame = "-1",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local explosion_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ))
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					explosion_resistance = explosion_resistance * 0.75
					 projectile_resistance = projectile_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring( explosion_resistance ) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring( projectile_resistance ) )
				end
			end
		end,
		func_remove = function( entity_who_picked )		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					-- ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", "0.35" )
					-- ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
				end
			end
		end,
	},
	-- Pending overhaul.
	{
		id = "ATTACK_FOOT",
		ui_name = "$perk_attack_foot",
		ui_description = "$perkdesc_attack_foot",
		ui_icon = "data/ui_gfx/perk_icons/attack_foot.png",
		perk_icon = "data/items_gfx/perks/attack_foot.png",
		stackable = STACKABLE_YES,
		stackable_maximum = 3,
		max_in_perk_pool = 2,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = 0
			local is_stacking = GameHasFlagRun( "ATTACK_FOOT_CLIMBER" )

			local limb_count = 4
			if is_stacking then limb_count = 2 end
			for i=1,limb_count do
				child_id = EntityLoad( "data/entities/misc/perks/attack_foot/limb_walker.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
			end
			
			for i=1,3 do
				child_id = EntityLoad( "data/entities/misc/perks/attack_foot/limb_attacker_lenth_" ..tostring(i) .. ".xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
			end
			
			if not is_stacking then
				-- enable climbing
				child_id = EntityLoad( "data/entities/misc/perks/attack_foot/limb_climb.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
				GameAddFlagRun( "ATTACK_FOOT_CLIMBER" )
			else
				-- add length to limbs
				for _,v in ipairs(EntityGetAllChildren(entity_who_picked)) do
					if EntityHasTag(v, "attack_foot_walker") then
						component_readwrite(EntityGetFirstComponent(v, "IKLimbComponent"), { length = 50 }, function(comp)
							comp.length = comp.length * 1.5
						end)
					end
				end
			end
			
			local platformingcomponents = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if ( platformingcomponents ~= nil ) then
				for i,component in ipairs(platformingcomponents) do
					local run_speed = tonumber( ComponentGetMetaCustom( component, "run_velocity" ) ) * 1.25
					local vel_x = math.abs( tonumber( ComponentGetMetaCustom( component, "velocity_max_x" ) ) ) * 1.25
					
					local vel_x_min = 0 - vel_x
					local vel_x_max = vel_x
					
					ComponentSetMetaCustom( component, "run_velocity", run_speed )
					ComponentSetMetaCustom( component, "velocity_min_x", vel_x_min )
					ComponentSetMetaCustom( component, "velocity_max_x", vel_x_max )
				end
			end
			
			perk_pickup_event("LUKKI")
			
			if ( pickup_count <= 2 ) then
				add_lukkiness_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("LUKKI")
			GameRemoveFlagRun( "ATTACK_FOOT_CLIMBER" )
			
			local platformingcomponents = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if ( platformingcomponents ~= nil ) then
				for i,component in ipairs(platformingcomponents) do
					ComponentSetMetaCustom( component, "run_velocity", 154 )
					ComponentSetMetaCustom( component, "velocity_min_x", -57 )
					ComponentSetMetaCustom( component, "velocity_max_x", 57 )
					ComponentSetValue2( component, "pixel_gravity", 350 )
				end
			end
		end,
	},
	{
		id = "LEGGY_FEET",
		ui_name = "$perk_leggy_feet",
		ui_description = "$perkdesc_leggy_feet",
		ui_icon = "data/ui_gfx/perk_icons/leggy_feet.png",
		perk_icon = "data/items_gfx/perks/leggy_feet.png",
		stackable = STACKABLE_YES, -- Arvi: these variables don't really make sense for this perk but putting them in anyway
		stackable_is_rare = true,
		not_in_default_perk_pool = true,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = 0
			local is_stacking = GameHasFlagRun( "ATTACK_FOOT_CLIMBER" )
			local limb_count = 2
			if is_stacking then limb_count = 1 end
			
			for i=1,limb_count do
				child_id = EntityLoad( "data/entities/misc/perks/attack_leggy/leggy_limb_left.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
			end
			for i=1,limb_count do
				child_id = EntityLoad( "data/entities/misc/perks/attack_leggy/leggy_limb_right.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
			end
			
			for i=1,3 do
				child_id = EntityLoad( "data/entities/misc/perks/attack_leggy/leggy_limb_attacker_lenth_" ..tostring(i) .. ".xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
			end

			if not is_stacking then
				child_id = EntityLoad( "data/entities/misc/perks/attack_foot/limb_climb.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
				GameAddFlagRun( "ATTACK_FOOT_CLIMBER" )
			else
				-- add length to limbs
				for _,v in ipairs(EntityGetAllChildren(entity_who_picked)) do
					if EntityHasTag(v, "leggy_foot_walker") then
						component_readwrite(EntityGetFirstComponent(v, "IKLimbComponent"), { length = 50 }, function(comp)
							comp.length = comp.length * 1.5
						end)
					end
				end
			end
			
			local platformingcomponents = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if ( platformingcomponents ~= nil ) then
				for i,component in ipairs(platformingcomponents) do
					local run_speed = tonumber( ComponentGetMetaCustom( component, "run_velocity" ) ) * 1.25
					local vel_x = math.abs( tonumber( ComponentGetMetaCustom( component, "velocity_max_x" ) ) ) * 1.25
					
					local vel_x_min = 0 - vel_x
					local vel_x_max = vel_x
					
					ComponentSetMetaCustom( component, "run_velocity", run_speed )
					ComponentSetMetaCustom( component, "velocity_min_x", vel_x_min )
					ComponentSetMetaCustom( component, "velocity_max_x", vel_x_max )
				end
			end
			
			perk_pickup_event("LUKKI")
			
			if ( pickup_count <= 2 ) then
				add_lukkiness_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("LUKKI")
			GameRemoveFlagRun( "ATTACK_FOOT_CLIMBER" )
			local platformingcomponents = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if ( platformingcomponents ~= nil ) then
				for i,component in ipairs(platformingcomponents) do
					ComponentSetMetaCustom( component, "run_velocity", 154 )
					ComponentSetMetaCustom( component, "velocity_min_x", -57 )
					ComponentSetMetaCustom( component, "velocity_max_x", 57 )
					-- NOTE apparently this isn't needed, since the LEGGY works differently from the LUKKI
					-- ComponentSetValue2( component, "pixel_gravity", 350 )
				end
			end
		end,
	},
	{
		id = "PLAGUE_RATS",
		ui_name = "$perk_plague_rats",
		ui_description = "$dplague_rats",
		ui_icon = "data/ui_gfx/perk_icons/plague_rats.png",
		perk_icon = "data/items_gfx/perks/plague_rats.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 5,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if ( pickup_count <= 1 ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component",
					script_source_file = "data/scripts/perks/plague_rats.lua",
					execute_every_n_frame = "20",
				} )
				
				local world_entity_id = GameGetWorldStateEntity()
				if ( world_entity_id ~= nil ) then
					component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = true, } )
				end
				--GenomeSetHerdId( entity_who_picked, "rat" )
			end
			
			perk_pickup_event("RAT")

			local x,y = EntityGetTransform( entity_who_picked )
			CreateItemActionEntity( "DE_RAT_SUMMON", x, y )

			add_rattiness_level(entity_who_picked)

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local fire_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "fire" ))
					fire_resistance = fire_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(fire_resistance) )

					local ice_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "ice" ))
					ice_resistance = ice_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "ice", tostring(ice_resistance) )
				end
			end
		end,
		func_remove = function( entity_perk_item, entity_who_picked, item_name )
			reset_perk_pickup_event("RAT")
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = false, } )
			end
		end,
	},
	{
		id = "VOMIT_RATS",
		ui_name = "$perk_vomit_rats",
		ui_description = "$dvomit_rats",
		ui_icon = "data/ui_gfx/perk_icons/vomit_rats.png",
		perk_icon = "data/items_gfx/perks/vomit_rats.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_perk_item )
			local child_id = EntityLoad( "data/entities/misc/perks/vomit_rats.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			EntityLoad( "data/entities/items/pickup/potion_vomit.xml", x, y )
			EntityLoad( "data/entities/particles/poof_white_appear.xml", x, y )
			
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = true, } )
			end
			
			perk_pickup_event("RAT")

			local x,y = EntityGetTransform( entity_who_picked )
			CreateItemActionEntity( "DE_RAT_SUMMON", x, y )

			add_rattiness_level(entity_who_picked)
			--GenomeSetHerdId( entity_who_picked, "rat" )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local radioactive_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "radioactive" ))
					radioactive_resistance = radioactive_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "radioactive", tostring(radioactive_resistance) )

					local poison_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "poison" ))
					poison_resistance = poison_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "poison", tostring(poison_resistance) )
				end
			end
		end,
		func_remove = function( entity_perk_item, entity_who_picked, item_name )
			reset_perk_pickup_event("RAT")
			local world_entity_id = GameGetWorldStateEntity()
			if ( world_entity_id ~= nil ) then
				component_write( EntityGetFirstComponent( world_entity_id, "WorldStateComponent" ), { perk_rats_player_friendly = false, } )
			end
		end,
	},
	{
		id = "CORDYCEPS",
		ui_name = "$perk_cordyceps",
		ui_description = "$perkdesc_cordyceps",
		ui_icon = "data/ui_gfx/perk_icons/cordyceps.png",
		perk_icon = "data/items_gfx/perks/cordyceps.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if ( pickup_count <= 1 ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component",
					script_source_file = "data/scripts/perks/cordyceps.lua",
					execute_every_n_frame = "20",
				} )
			end
			
			perk_pickup_event("FUNGI")
			
			if ( GameHasFlagRun( "player_status_cordyceps" ) == false ) then
				GameAddFlagRun( "player_status_cordyceps" )
				add_funginess_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("FUNGI")
			GameRemoveFlagRun( "player_status_cordyceps" )
		end,
	},
	{
		id = "MOLD",
		ui_name = "$perk_mold",
		ui_description = "$perkdesc_mold",
		ui_icon = "data/ui_gfx/perk_icons/mold.png",
		perk_icon = "data/items_gfx/perks/mold.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_perk_item )
			local child_id = EntityLoad( "data/entities/misc/perks/slime_fungus.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			EntityLoad( "data/entities/items/pickup/potion_slime.xml", x, y )
			EntityLoad( "data/entities/particles/poof_white_appear.xml", x, y )
			
			perk_pickup_event("FUNGI")
			
			if ( GameHasFlagRun( "player_status_mold" ) == false ) then
				GameAddFlagRun( "player_status_mold" )
				add_funginess_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("FUNGI")
			GameRemoveFlagRun( "player_status_mold" )
		end,
	},
	{
		id = "WORM_SMALLER_HOLES",
		ui_name = "$perk_worm_smaller_holes",
		ui_description = "$dworm_smaller_holes",
		ui_icon = "data/ui_gfx/perk_icons/worm_smaller_holes.png",
		perk_icon = "data/items_gfx/perks/worm_smaller_holes.png",
		stackable = STACKABLE_NO,
		game_effect = "WORM_DETRACTOR",
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_source_file = "data/scripts/perks/worm_smaller_holes.lua",
				execute_every_n_frame = "20",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local melee_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "melee" ))
					melee_resistance = melee_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "melee", tostring(melee_resistance) )

					local radioactive_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "radioactive" ))
					radioactive_resistance = radioactive_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "radioactive", tostring(radioactive_resistance) )

					local fire_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "fire" ))
					fire_resistance = fire_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(fire_resistance) )
				end
			end
		end,
	},
	--[[
	{
		id = "WORM_BIGGER_HOLES",
		ui_name = "$perk_worm_bigger_holes",
		ui_description = "$perkdesc_worm_bigger_holes",
		ui_icon = "data/ui_gfx/perk_icons/worm_bigger_holes.png",
		perk_icon = "data/items_gfx/perks/worm_bigger_holes.png",
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_source_file = "data/scripts/perks/worm_bigger_holes.lua",
				execute_every_n_frame = "20",
			} )
			
		end,
	},
	]]--
	{
		id = "PROJECTILE_REPULSION",
		ui_name = "$perk_projectile_repulsion",
		ui_description = "$dperk_PROJECTILE_REPULSION",
		ui_icon = "data/ui_gfx/perk_icons/projectile_repulsion.png",
		perk_icon = "data/items_gfx/perks/projectile_repulsion.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		usable_by_mult_enemies = false,
		particle_effect = "projectile_repulsion_field",
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			if pickup_count <= 1 then
				-- no existing perk found, spawn perk
				local x,y = EntityGetTransform( entity_who_picked )
				local child_id = EntityLoad( "data/entities/misc/perks/projectile_repulsion_field.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )
			else
				-- skip spawning, store pickup count
				set_perk_entity_pickup_count(entity_who_picked, "projectile_repulsion", pickup_count*2-1)
			end

			-- increase resistance
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 1.1
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				end
			end
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/projectile_repulsion_field.xml", x, y )
			EntityAddChild( entity_who_picked, child_id )

			child_id = EntityLoad( "data/entities/misc/perks/projectile_slow_field.xml", x, y )
			EntityAddChild( entity_who_picked, child_id )
		end,
		func_remove = function( entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					-- ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
				end
			end
		end,
	},
	{
		id = "RISKY_CRITICAL",
		ui_name = "$perk_risky_critical",
		ui_description = "$dperk_RISKY_CRITICAL",
		ui_icon = "data/ui_gfx/perk_icons/risky_critical.png",
		perk_icon = "data/items_gfx/perks/risky_critical.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 3,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/risky_critical.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
	},
	{
		id = "FUNGAL_DISEASE",
		ui_name = "$perk_fungal_disease",
		ui_description = "$perkdesc_fungal_disease",
		ui_icon = "data/ui_gfx/perk_icons/fungal_disease.png",
		perk_icon = "data/items_gfx/perks/fungal_disease.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 3,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/fungal_disease.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			perk_pickup_event("FUNGI")
			
			if ( GameHasFlagRun( "player_status_fungal_disease" ) == false ) then
				GameAddFlagRun( "player_status_fungal_disease" )
				add_funginess_level(entity_who_picked)
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("FUNGI")
			GameRemoveFlagRun( "player_status_fungal_disease" )
		end,
	},
	{
		id = "PROJECTILE_SLOW_FIELD",
		ui_name = "$perk_projectile_slow_field",
		ui_description = "$perkdesc_projectile_slow_field",
		ui_icon = "data/ui_gfx/perk_icons/projectile_slow_field.png",
		perk_icon = "data/items_gfx/perks/projectile_slow_field.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		particle_effect = "projectile_slow_field",
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/projectile_slow_field.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
	},
	{
		id = "PROJECTILE_REPULSION_SECTOR",
		ui_name = "$perk_projectile_repulsion_sector",
		ui_description = "$perkdesc_projectile_repulsion_sector",
		ui_icon = "data/ui_gfx/perk_icons/projectile_repulsion_sector.png",
		perk_icon = "data/items_gfx/perks/projectile_repulsion_sector.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id
			
			if ( pickup_count <= 1 ) then
				child_id = EntityLoad( "data/entities/misc/perks/projectile_repulsion_sector.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
			else
				set_perk_entity_pickup_count(entity_who_picked, "projectile_repulsion_sector", pickup_count*2-1)
				--child_id = EntityLoad( "data/entities/misc/perks/projectile_repulsion_sector_noparticles.xml", x, y )
			end
			
			if ( child_id ~= nil ) then
				EntityAddChild( entity_who_picked, child_id )
			end
		end,
	},
	{
		id = "PROJECTILE_EATER_SECTOR",
		ui_name = "$perk_projectile_eater_sector",
		ui_description = "$perkdesc_projectile_eater_sector",
		ui_icon = "data/ui_gfx/perk_icons/projectile_eater_sector.png",
		perk_icon = "data/items_gfx/perks/projectile_eater_sector.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )

			if pickup_count <= 1 then
				local child_id = EntityLoad( "data/entities/misc/perks/projectile_eater_sector.xml", x, y )

				if child_id ~= nil then
					EntityAddTag( child_id, "perk_entity" )
					EntityAddTag( child_id, "perk_entity_projectile_eater_sector" )
					EntityAddChild( entity_who_picked, child_id )
				end
			elseif pickup_count <= 7 then
				local childs = EntityGetAllChildren( entity_who_picked )

				if childs ~= nil then for i=1,#childs do if EntityHasTag( childs[i], "perk_entity_projectile_eater_sector" ) then
					local comps = EntityGetComponent( childs[i], "ParticleEmitterComponent" )

					if comps ~= nil then for j,comp_id in ipairs( comps ) do
						local radius_min, radius_max = ComponentGetValue2( comp_id, "area_circle_radius" )
						local deg = clamp( ComponentGetValue2( comp_id, "area_circle_sector_degrees" ) + 20, 30, 135 )

						radius_max = clamp( radius_max + 2, 24, 36 )
						if radius_min > 2 then radius_min = radius_max end

						ComponentSetValue2( comp_id, "area_circle_radius", radius_min, radius_max )
						ComponentSetValue2( comp_id, "area_circle_sector_degrees", deg )

						ComponentSetValue2( comp_id, "count_min", ComponentGetValue2( comp_id, "count_min" ) + radius_min )
						ComponentSetValue2( comp_id, "count_max", ComponentGetValue2( comp_id, "count_max" ) + radius_min )
					end end

					break
				end end end
			end
		end,
	},
	{
		id = "ORBIT",
		ui_name = "$perk_orbit",
		ui_description = "$dorbit",
		ui_icon = "data/ui_gfx/perk_icons/orbit.png",
		perk_icon = "data/items_gfx/perks/orbit.png",
		stackable = STACKABLE_YES,
		max_in_perk_pool = 2,
		-- stackable_how_often_reappears = 10,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )

			if ( pickup_count == 1 ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component",
					script_source_file = "data/scripts/perks/orbit.lua",
					execute_every_n_frame = "1",
				} )

				EntityAddComponent( entity_who_picked, "VariableStorageComponent", 
				{ 
					_tags = "perk_orbit_pickup_count",
					name = "perk_orbit_pickup_count",
					value_int = "1",
				} )
			else
				local orbit_comp = EntityGetFirstComponent( entity_who_picked, "VariableStorageComponent", "perk_orbit_pickup_count" )
				
				if ( orbit_comp ~= nil ) then
					ComponentSetValue2( orbit_comp, "value_int", pickup_count )
				end
			end
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 1.1
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				end
			end
		end,
		func_remove = function( entity_perk_item, entity_who_picked, item_name )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					-- ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
					-- ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", "0.35" )
				end
			end
		end,
	},
	{
		id = "ANGRY_GHOST",
		ui_name = "$perk_angry_ghost",
		ui_description = "$dangry_ghost",
		ui_icon = "data/ui_gfx/perk_icons/angry_ghost.png",
		perk_icon = "data/items_gfx/perks/angry_ghost.png",
		stackable = STACKABLE_YES,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/angry_ghost.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				_tags = "perk_component",
				script_wand_fired = "data/scripts/perks/angry_ghost_shoot.lua",
				execute_every_n_frame = "1",
			} )
			
			perk_pickup_event("GHOST")
			
			CreateItemActionEntity( "TINY_GHOST", x, y )
			
			if ( GameHasFlagRun( "player_status_angry_ghost" ) == false ) then
				GameAddFlagRun( "player_status_angry_ghost" )
				add_ghostness_level(entity_who_picked)
			end

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local fire_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "fire" ))
					fire_resistance = fire_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(fire_resistance) )

					local ice_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "ice" ))
					ice_resistance = ice_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "ice", tostring(ice_resistance) )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("GHOST")
			GameRemoveFlagRun( "player_status_angry_ghost" )
		end,
	},
	{
		id = "HUNGRY_GHOST",
		ui_name = "$perk_hungry_ghost",
		ui_description = "$dhungry_ghost",
		ui_icon = "data/ui_gfx/perk_icons/hungry_ghost.png",
		perk_icon = "data/items_gfx/perks/hungry_ghost.png",
		stackable = STACKABLE_YES,
		stackable_maximum = 5,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/hungry_ghost.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			perk_pickup_event("GHOST")

			CreateItemActionEntity( "TINY_GHOST", x, y )
			
			if ( GameHasFlagRun( "player_status_hungry_ghost" ) == false ) then
				GameAddFlagRun( "player_status_hungry_ghost" )
				add_ghostness_level(entity_who_picked)
			end

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local radioactive_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "radioactive" ))
					radioactive_resistance = radioactive_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "radioactive", tostring(radioactive_resistance) )

					local poison_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "poison" ))
					poison_resistance = poison_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "poison", tostring(poison_resistance) )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("GHOST")
			GameRemoveFlagRun( "player_status_hungry_ghost" )
		end,
	},
	{
		id = "DEATH_GHOST",
		ui_name = "$perk_death_ghost",
		ui_description = "$ddeath_ghost",
		ui_icon = "data/ui_gfx/perk_icons/death_ghost.png",
		perk_icon = "data/items_gfx/perks/death_ghost.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )
			if ( pickup_count <= 1 ) then
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{
					_tags = "perk_component",
					script_source_file = "data/scripts/perks/death_ghost.lua",
					execute_every_n_frame = "20",
				} )
			end
			
			perk_pickup_event("GHOST")

			CreateItemActionEntity( "TINY_GHOST", x, y )
			
			if ( GameHasFlagRun( "player_status_death_ghost" ) == false ) then
				GameAddFlagRun( "player_status_death_ghost" )
				add_ghostness_level(entity_who_picked)
			end

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local slice_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "slice" ))
					slice_resistance = slice_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "slice", tostring(slice_resistance) )

					local drill_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "drill" ))
					drill_resistance = drill_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "drill", tostring(drill_resistance) )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			reset_perk_pickup_event("GHOST")
			GameRemoveFlagRun( "player_status_death_ghost" )
		end,
	},
	{
		id = "LUKKI_MINION",
		ui_name = "$STARDUST DRAGON",
		ui_description = "$dSTARDUST DRAGON",
		ui_icon = "data/ui_gfx/perk_icons/lukki_minion.png",
		perk_icon = "data/items_gfx/perks/lukki_minion.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name, pickup_count )
			local x,y = EntityGetTransform( entity_who_picked )
			local stardust_dragon = EntityGetWithTag("de_stardust_dragon")

			CreateItemActionEntity( "DE_TR_PRISMA", x, y )

			if #stardust_dragon == 0 then
				local child_id = EntityLoad( "data/entities/misc/perks/lukki_minion.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddTag( child_id, "de_stardust_dragon" )
				
				EntityAddComponent( child_id, "VariableStorageComponent", 
				{
					name = "owner_id",
					value_int = tostring( entity_who_picked ),
				} )
			else
				local stdcomps = EntityGetComponent( stardust_dragon[1], "AreaDamageComponent" )

				if stdcomps ~= nil then for i,comp in ipairs( stdcomps ) do
					local stdr = math.min( 7 * pickup_count + 9 , 40 )
					ComponentSetValue2( comp, "circle_radius", stdr )

					local stddmg = math.min( 1.8*ComponentGetValue2( comp, "damage_per_frame" ) , 720 )
					ComponentSetValue2( comp, "damage_per_frame", stddmg )
				end end

				if pickup_count < 5 then
					local tailcomp = EntityGetFirstComponent( stardust_dragon[1], "SpriteComponent", "enabled_in_world" )

					if tailcomp ~= nil then
						EntityRemoveComponent( stardust_dragon[1], tailcomp )
						local std_z = 0.5 - 0.02 * pickup_count - 0.01

						EntityAddComponent( stardust_dragon[1], "SpriteComponent", 
						{
							alpha="1",
							image_file="data/entities/animals/lukki/lukki_feet/tail/tail_2.xml",
							rect_animation="stand",
							next_rect_animation="stand",
							offset_x="6",
							offset_y="8",
							update_transform="0",
							z_index=tostring(-std_z),
						} )

						EntityAddComponent( stardust_dragon[1], "SpriteComponent", 
						{
							alpha="1",
							image_file="data/entities/animals/lukki/lukki_feet/tail/tail_1.xml",
							rect_animation="stand",
							next_rect_animation="stand",
							offset_x="6",
							offset_y="8",
							update_transform="0",
							z_index=tostring(0.01-std_z),
						} )

						EntityAddComponent( stardust_dragon[1], "SpriteComponent", 
						{
							_tags="enabled_in_world",
							alpha="1",
							image_file="data/entities/animals/lukki/lukki_feet/tail/tail_0.xml",
							rect_animation="stand",
							next_rect_animation="stand",
							offset_x="6",
							offset_y="8",
							update_transform="0",
							z_index="-0.01",
						} )
					end
				end
			end
			
			-- perk_pickup_event("LUKKI")
			-- add_lukkiness_level(entity_who_picked)

			if not GameHasFlagRun( "player_status_lukki_minion" ) then GameAddFlagRun( "player_status_lukki_minion" ) end
		end,
		func_remove = function( entity_who_picked )
			-- reset_perk_pickup_event("LUKKI")
			GameRemoveFlagRun( "player_status_lukki_minion" )
		end,
	},
	{
		id = "ELECTRICITY",
		ui_name = "$perk_electricity",
		ui_description = "$perkdesc_electricity",
		ui_icon = "data/ui_gfx/perk_icons/electricity.png",
		perk_icon = "data/items_gfx/perks/electricity.png",
		game_effect = "PROTECTION_ELECTRICITY",
		stackable = STACKABLE_NO,
		remove_other_perks = {"PROTECTION_ELECTRICITY"},
		usable_by_enemies = true,
		usable_by_mult_enemies = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/electricity.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
		end,
	},
	{
		id = "EXTRA_KNOCKBACK",
		ui_name = "$perk_extra_knockback",
		ui_description = "$dperk_EXTRA_KNOCKBACK",
		ui_icon = "data/ui_gfx/perk_icons/extra_knockback.png",
		perk_icon = "data/items_gfx/perks/extra_knockback.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "extra_knockback",
			} )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/extra_knockback_enemy.lua",
				execute_every_n_frame = "-1",
			} )	
		end,
	},
	{
		id = "LOWER_SPREAD",
		ui_name = "$perk_lower_spread",
		ui_description = "$dperk_LOWER_SPREAD",
		ui_icon = "data/ui_gfx/perk_icons/lower_spread.png",
		perk_icon = "data/items_gfx/perks/lower_spread.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )

			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "lower_spread",
			} )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/lower_spread_enemy.lua",
				execute_every_n_frame = "-1",
			} )	
		end,
	},
	{
		id = "LOW_RECOIL",
		ui_name = "$perk_low_recoil",
		ui_description = "$dperk_LOW_RECOIL",
		ui_icon = "data/ui_gfx/perk_icons/low_recoil.png",
		perk_icon = "data/items_gfx/perks/low_recoil.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			CreateItemActionEntity( "DE_LASER_AIM", x, y )

			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "low_recoil",
			} )
		end,
	},
	{
		id = "BOUNCE",
		ui_name = "$perk_bounce",
		ui_description = "$dperk_BOUNCE",
		ui_icon = "data/ui_gfx/perk_icons/bounce.png",
		perk_icon = "data/items_gfx/perks/bounce.png",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			CreateItemActionEntity( "DE_LASER_AIM", x, y )

			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "bounce",
			} )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/bounce_enemy.lua",
				execute_every_n_frame = "-1",
			} )	
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/fast_projectiles_enemy.lua",
				execute_every_n_frame = "-1",
			} )	
		end,
	},
	{
		id = "FAST_PROJECTILES",
		ui_name = "$perk_fast_projectiles",
		ui_description = "$dperk_FAST_PROJECTILES",
		ui_icon = "data/ui_gfx/perk_icons/fast_projectiles.png",
		perk_icon = "data/items_gfx/perks/fast_projectiles.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			CreateItemActionEntity( "DE_LASER_AIM", x, y )

			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "fast_projectiles",
			} )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_shot = "data/scripts/perks/fast_projectiles_enemy.lua",
				execute_every_n_frame = "-1",
			} )	
		end,
	},
	{
		id = "ALWAYS_CAST",
		ui_name = "$perk_always_cast",
		ui_description = "$dalways_cast",
		ui_icon = "data/ui_gfx/perk_icons/always_cast.png",
		perk_icon = "data/items_gfx/perks/always_cast.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x, y = EntityGetTransform( entity_perk_item )
			SetRandomSeed( x + GameGetFrameNum(), y + 251 )

			local good_cards = { "FUNKY_SPELL", "DE_FUNKY_SPELL_TRIGGER", "BOMB_DETONATOR", "SLOW_BUT_STEADY", "FIZZLE", "MANA_REDUCE", "NOLLA", "RECHARGE", "SUMMON_WANDGHOST", "CASTER_CAST", "RESET", "DE_LINE_BREAKER", "DRAW_RANDOM", "DRAW_3_RANDOM", "DRAW_RANDOM_X3", "DUPLICATE", "OMEGA", "ZETA", "MU", "PHI", "SIGMA" }
			local r = Random( 1, #good_cards )
			local card = good_cards[r]
			local options = {}
			local id_list = {}

			local children = EntityGetAllChildren( entity_who_picked )
			
			if ( children ~= nil ) then
				for i,child_id in ipairs( children ) do
					if ( EntityGetName( child_id ) == "inventory_full" ) then
						local inventory_cards = EntityGetAllChildren( child_id )
						
						if ( inventory_cards ~= nil ) then
							for k,card_id in ipairs( inventory_cards ) do
								if EntityHasTag( card_id, "card_action" ) then
									local comp = EntityGetFirstComponentIncludingDisabled( card_id, "ItemActionComponent" )
									
									if ( comp ~= nil ) then
										local action_id = ComponentGetValue2( comp, "action_id" )
										
										table.insert( options, action_id )
										table.insert( id_list, card_id )
									end
								end
							end
						end
					end
				end
			end
			
			if ( #options > 0 ) then
				r = Random( 1, #options )
				
				for i=1,#actions do
					if ( actions[i].id == options[r] ) then
						card = options[r]
						break
					end
				end
			else
				r = Random( 1, 100 )
				local level = Random( 4, 7 )

				if ( r <= 34 ) then
					local p = Random( 1, 100 )
					
					if ( p <= 77 ) then
						card = GetRandomActionWithType( x, y, level, ACTION_TYPE_MODIFIER, 666 )
					elseif ( p <= 88 ) then
						card = GetRandomActionWithType( x, y, level, ACTION_TYPE_STATIC_PROJECTILE, 666 )
					elseif ( p <= 99 ) then
						card = GetRandomActionWithType( x, y, level, ACTION_TYPE_PROJECTILE, 666 )
					else
						card = GetRandomActionWithType( x, y, level, ACTION_TYPE_UTILITY, 666 )
					end
				end
			end

			local wand = find_the_wand_held( entity_who_picked )
			
			if ( wand ~= NULL_ENTITY ) then
				local comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
				
				if ( comp ~= nil ) then
					local deck_capacity = ComponentObjectGetValue( comp, "gun_config", "deck_capacity" )
					local deck_capacity2 = EntityGetWandCapacity( wand )
					
					local always_casts = deck_capacity - deck_capacity2
					
					if ( always_casts < 7 ) then
						AddGunActionPermanent( wand, card )
						-- ComponentObjectSetValue( comp, "gun_config", "deck_capacity", tostring(math.max( deck_capacity - 1, always_casts + 1 )) )
						
						if ( #options > 0 ) then EntityKill( id_list[r] ) end
					else
						GamePrintImportant( "$log_always_cast_failed", "$logdesc_always_cast_failed" )
					end
				end
			end
		end,
	},
	{
		id = "EXTRA_MANA",
		ui_name = "$perk_extra_mana",
		ui_description = "$perkdesc_extra_mana",
		ui_icon = "data/ui_gfx/perk_icons/extra_mana.png",
		perk_icon = "data/items_gfx/perks/extra_mana.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local wand = find_the_wand_held( entity_who_picked )
			local x,y = EntityGetTransform( entity_who_picked )
			
			SetRandomSeed( entity_who_picked, wand )
			
			if ( wand ~= NULL_ENTITY ) then
				local comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
				
				if ( comp ~= nil ) then
					local mana_max = ComponentGetValue2( comp, "mana_max" )
					local mana_charge_speed = ComponentGetValue2( comp, "mana_charge_speed" )

					local deck_capacity = ComponentObjectGetValue( comp, "gun_config", "deck_capacity" )
					local deck_capacity2 = EntityGetWandCapacity( wand )
					local always_casts = math.max( 0, deck_capacity - deck_capacity2 )
					
					mana_max = clamp( mana_max * Random( 150, 300 ) * 0.01 + Random( 100, 125 ), 800 + Random( -50, 50 ), 200000 )
					mana_charge_speed = clamp( mana_charge_speed * Random( 200, 400 ) * 0.01, 300 + Random( -25, 25 ), 50000 )
					deck_capacity2 = math.max( 1, math.floor( deck_capacity2 * 0.5 ) )
					
					ComponentSetValue2( comp, "mana_max", math.ceil( mana_max ) )
					ComponentSetValue2( comp, "mana_charge_speed", math.ceil( mana_charge_speed ) )
					ComponentObjectSetValue( comp, "gun_config", "deck_capacity", deck_capacity2 + always_casts )
					
					local c = EntityGetAllChildren( wand )
					
					if ( c ~= nil ) and ( #c > deck_capacity2 + always_casts ) then
						for i=always_casts+1,#c do
							local v = c[i]
							local comp2 = EntityGetFirstComponentIncludingDisabled( v, "ItemActionComponent" )

							if ( comp2 ~= nil ) and ( i > deck_capacity2 + always_casts ) then
								local inventory_full
								local plchilds = EntityGetAllChildren( entity_who_picked )

								if plchilds then
									for i,plchild in ipairs( plchilds ) do
										if EntityGetName( plchild ) == "inventory_full" then
											inventory_full = plchild
											break
										end
									end
								end

								EntityRemoveFromParent( v )

								if inventory_full then
									EntitySetComponentsWithTagEnabled( v, "enabled_in_world", false )
									EntityAddChild( inventory_full, v )
								else
									EntitySetComponentsWithTagEnabled( v, "enabled_in_world", true )
									EntitySetTransform( v, x, y )
								end
							end
						end
					end
				end
			end
		end,
	},
	{
		id = "NO_MORE_SHUFFLE",
		ui_name = "$perk_no_more_shuffle",
		ui_description = "$dNO_MORE_SHUFFLE",
		ui_icon = "data/ui_gfx/perk_icons/no_more_shuffle.png",
		perk_icon = "data/items_gfx/perks/no_more_shuffle.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			GlobalsSetValue( "PERK_NO_MORE_SHUFFLE_WANDS", "1" )
			
			-- local wands = find_all_wands_held( entity_who_picked )
			local wands = EntityGetWithTag("wand")

			for i,wand in ipairs(wands) do
				-- we need to add a slot to the ability_comp
				local ability_comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
				if ability_comp ~= nil then ComponentObjectSetValue2( ability_comp, "gun_config", "shuffle_deck_when_empty", false ) end
			end 
		end,
		func_remove = function( entity_perk_item, entity_who_picked, item_name )
			GlobalsSetValue( "PERK_NO_MORE_SHUFFLE_WANDS", "0" )
		end,
	},
	{
		id = "NO_MORE_KNOCKBACK",
		ui_name = "$perk_no_more_knockback",
		ui_description = "$perkdesc_no_more_knockback",
		ui_icon = "data/ui_gfx/perk_icons/no_player_knockback.png",
		perk_icon = "data/items_gfx/perks/no_player_knockback.png",
		game_effect = "KNOCKBACK_IMMUNITY",
		game_effect2 = "NO_DAMAGE_FLASH",
		usable_by_enemies = true,
		stackable = STACKABLE_NO,
	},
	{
		id = "FASTER_WANDS",
		ui_name = "$perk_faster_wands",
		ui_description = "$perkdesc_faster_wands",
		ui_icon = "data/ui_gfx/perk_icons/faster_wands.png",
		perk_icon = "data/items_gfx/perks/faster_wands.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x, y = EntityGetTransform( entity_who_picked )
			local wands = EntityGetInRadiusWithTag( x, y, 24, "wand" )
			
			for i,entity_id in ipairs( wands ) do
				local root_entity = EntityGetRootEntity( entity_id )
				
				if ( root_entity == entity_who_picked ) then
					local models = EntityGetComponentIncludingDisabled( entity_id, "AbilityComponent" )
					if ( models ~= nil ) then
						for j,model in ipairs(models) do
							local reload_time = tonumber( ComponentObjectGetValue( model, "gun_config", "reload_time" ) )
							local cast_delay = tonumber( ComponentObjectGetValue( model, "gunaction_config", "fire_rate_wait" ) )
							local mana_charge_speed = ComponentGetValue2( model, "mana_charge_speed" )
							
							--print( tostring(reload_time) .. ", " .. tostring(cast_delay) .. ", " .. tostring(mana_charge_speed) )
							
							reload_time = math.floor( math.min( reload_time * 0.75 - 6, reload_time * 0.6, reload_time - 12, 36 ) )
							cast_delay = math.floor( math.min( cast_delay * 0.75 - 6, cast_delay * 0.6, cast_delay - 12, 36 ) )
							mana_charge_speed = mana_charge_speed + 50
							
							ComponentObjectSetValue2( model, "gun_config", "reload_time", reload_time )
							ComponentObjectSetValue2( model, "gunaction_config", "fire_rate_wait", cast_delay )
							ComponentSetValue2( model, "mana_charge_speed", mana_charge_speed )
						end
					end
				end
			end
		end,
	},
	{
		id = "EXTRA_SLOTS",
		ui_name = "$perk_extra_slots",
		ui_description = "$dextra_slots",
		ui_icon = "data/ui_gfx/perk_icons/extra_slots.png",
		perk_icon = "data/items_gfx/perks/extra_slots.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x, y = EntityGetTransform( entity_who_picked )
			local wands = EntityGetInRadiusWithTag( x, y, 256, "wand" )
			
			for i,entity_id in ipairs( wands ) do
				-- local root_entity = EntityGetRootEntity( entity_id )
				-- if ( root_entity == entity_who_picked ) then
				local models = EntityGetComponentIncludingDisabled( entity_id, "AbilityComponent" )
				if ( models ~= nil ) then
					for j,model in ipairs(models) do
						SetRandomSeed( x+entity_who_picked, y+entity_id )

						local deck_capacity = tonumber( ComponentObjectGetValue( model, "gun_config", "deck_capacity" ) )
						local deck_capacity2 = EntityGetWandCapacity( entity_id )
						local always_casts = deck_capacity - deck_capacity2
						
						deck_capacity = clamp( deck_capacity + Random( 3, 8 ), deck_capacity, 30 + always_casts )
						
						ComponentObjectSetValue( model, "gun_config", "deck_capacity", tostring(deck_capacity) )
					end
				end
			end
		end,
	},
	{
		id = "EXTRA_POTION_CAPACITY",
		ui_name = "$perk_extra_potion_capacity",
		ui_description = "$dextra_potion_capacity",
		ui_icon = "data/ui_gfx/perk_icons/extra_potion_capacity.png",
		perk_icon = "data/items_gfx/perks/extra_potion_capacity.png",
		stackable = STACKABLE_YES,
		one_off_effect = true,
		do_not_remove = true,
		stackable_maximum = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_perk_item )
			local flasks = EntityGetInRadiusWithTag( x, y, 200, "potion" )
			local capacity = tonumber( GlobalsGetValue( "EXTRA_POTION_CAPACITY_LEVEL", "1000" ) ) or 1000

			if flasks[1] ~= nil then
				for i=1,#flasks do
					local scomp = EntityGetFirstComponentIncludingDisabled( flasks[i], "MaterialSuckerComponent" )
					local mcomp = EntityGetFirstComponent( flasks[i], "MaterialInventoryComponent" )

					if scomp ~= nil and mcomp ~= nil then
						local mat_id = GetMaterialInventoryMainMaterial( flasks[i] )

						if mat_id ~= nil and mat_id ~= 0 then
							ComponentSetValue( scomp, "barrel_size", math.floor( capacity * 2 ) )
							AddMaterialInventoryMaterial( flasks[i], CellFactory_GetName(mat_id), math.floor( capacity * 2 ) )
						end
					end
				end
			end

			GlobalsSetValue( "EXTRA_POTION_CAPACITY_LEVEL", tostring( math.floor( capacity * 2 ) ) )

			EntityLoad( "data/entities/items/pickup/potion_porridge.xml", x, y )
			EntityLoad( "data/entities/particles/poof_white_appear.xml", x, y )
		end,
	},
	{
		id = "CONTACT_DAMAGE",
		ui_name = "$perk_contact_damage",
		ui_description = "$perkdesc_contact_damage",
		ui_icon = "data/ui_gfx/perk_icons/contact_damage.png",
		perk_icon = "data/items_gfx/perks/contact_damage.png",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/contact_damage.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
		func_enemy = function( entity_perk_item, entity_who_picked )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/contact_damage_enemy.xml", x, y )
			EntityAddChild( entity_who_picked, child_id )
		end,
	},


	-- SECRET
	--[[
	{
		id = "MYSTERY_EGGPLANT",
		ui_name = "$perk_mystery_eggplant",
		ui_description = "$perkdesc_mystery_eggplant", -- does nothing
		ui_icon = "data/ui_gfx/material_indicators/hp_regeneration.png",
		perk_icon = "data/items_gfx/perks/mystery_eggplant.png",
		not_in_default_perk_pool = true, -- if set, this perk only materializes when manually spawned, e.g. when calling spawn_perk("MYSTERY_EGGPLANT") somewhere
	},
	

	-- CRITICALS
	{
		id = "CRITS_2X_DAMAGE",
		ui_name = "$perk_crits_2x_damage",
		ui_description = "$perkdesc_crits_2x_damage",
		ui_icon = "data/ui_gfx/perk_icons/crits_2x_damage.png",
		perk_icon = "data/items_gfx/perks/crits_2x_damage.png",
		game_effect = "CRITS_2X_DAMAGE",
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO crits do 2x more damage, so normally its now 5x and then it would be 10x. Probably should tweak to 4x and 8x
		end,
	},

	-- HP AFFECTORS

	-- WAND & ACTION AFFECTORS
	{
		id = "BERSERK",
		ui_name = "$perk_berserk",
		ui_description = "$perkdesc_berserk",
	},

	-- WAND & ACTION SHUFFLERS and SPAWNERS
	{
		id = "SHUFFLE_WANDS",
		ui_name = "$perk_shuffle_wands",
		ui_description = "$perkdesc_shuffle_wands",
	},
	{
		id = "HEAVY_AMMO",
		ui_name = "$perk_heavy_ammo",
		ui_description = "$perkdesc_heavy_ammo", -- Nuke, Holy_grenade
	},
	-- PERKS
	{
		id = "ROLL_AGAIN",
		ui_name = "$perk_roll_again",
		ui_description = "$perkdesc_roll_again",
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO: code that replaces the perks with a new set 
		end,
	},
	--]]
	{
		id = "GAMBLE",
		ui_name = "$perk_gamble",
		ui_description = "$dgamble",
		ui_icon = "data/ui_gfx/perk_icons/gamble.png", -- TODO
		perk_icon = "data/items_gfx/perks/gamble.png", -- TODO
		stackable = STACKABLE_YES,
		one_off_effect = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local pos_x, pos_y = EntityGetTransform(entity_who_picked)
			EntityLoad("data/entities/misc/perk_gamble_spawner.xml", pos_x, pos_y)
		end,
	},
	{
		id = "PERKS_LOTTERY",
		ui_name = "$perk_perks_lottery",
		ui_description = "$perkdesc_perks_lottery",
		ui_icon = "data/ui_gfx/perk_icons/perks_lottery.png",
		perk_icon = "data/items_gfx/perks/perks_lottery.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		stackable_maximum = 6,
		max_in_perk_pool = 3,
		-- when picking up a perk, there's 50% chance less (instead of 100%) of other perks disappearing
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO - this should work - seems to work
			local perk_destroy_chance = tonumber( GlobalsGetValue( "TEMPLE_PERK_DESTROY_CHANCE", "100" ) )
			perk_destroy_chance = perk_destroy_chance / 2
			GlobalsSetValue( "TEMPLE_PERK_DESTROY_CHANCE", tostring(perk_destroy_chance) )
		end,
		func_remove = function( entity_who_picked )
			GlobalsSetValue( "TEMPLE_PERK_DESTROY_CHANCE", "100" )
		end,
	},
	{
		id = "EXTRA_SHOP_ITEM",
		ui_name = "$perk_extra_shop_item",
		ui_description = "$dextra_shop_item",
		ui_icon = "data/ui_gfx/perk_icons/extra_shop_item.png",
		perk_icon = "data/items_gfx/perks/extra_shop_item.png",
		stackable = STACKABLE_YES,
		stackable_maximum = 5,
		max_in_perk_pool = 2,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local shop_item_count = tonumber( GlobalsGetValue( "TEMPLE_SHOP_ITEM_COUNT", "5" ) )
			shop_item_count = math.min( shop_item_count + 1, 10 )
			GlobalsSetValue( "TEMPLE_SHOP_ITEM_COUNT", tostring(shop_item_count) )

			local x,y = EntityGetTransform( entity_who_picked )
			local level = clamp( math.floor( math.abs(y)^0.25 * 0.5 ), 3, 6 )
			if y >= 40000 then
				level = "unshuffle_10"
			else
				level = "unshuffle_0" .. tostring(level)
			end

			if shop_item_count == 10 then level = "level_100" end

			EntityLoad( "data/entities/items/wand_" .. level .. ".xml", x, y-8 )
		end,
		func_remove = function( entity_who_picked )
			GlobalsSetValue( "TEMPLE_SHOP_ITEM_COUNT", "5" )
		end,
	},
	{
		id = "EXTRA_PERK",
		ui_name = "$perk_extra_perk",
		ui_description = "$dextra_perk",
		ui_icon = "data/ui_gfx/perk_icons/extra_perk.png",
		perk_icon = "data/items_gfx/perks/extra_perk.png",
		stackable = STACKABLE_YES,
		stackable_maximum = 5,
		max_in_perk_pool = 3,
		func = function( entity_perk_item, entity_who_picked, item_name )
			-- TODO - this should work - seems to work
			local perk_count = tonumber( GlobalsGetValue( "TEMPLE_PERK_COUNT", "3" ) )
			perk_count = math.min( perk_count + 1, 6 )
			GlobalsSetValue( "TEMPLE_PERK_COUNT", tostring(perk_count) )

			local perk_reroll_count = tonumber( GlobalsGetValue( "TEMPLE_PERK_REROLL_COUNT", "0" ) )
			perk_reroll_count = math.max( perk_reroll_count - 1, -4 )
			GlobalsSetValue( "TEMPLE_PERK_REROLL_COUNT", tostring( perk_reroll_count ) )
		end,
		func_remove = function( entity_who_picked )
			-- TODO - this should work - seems to work
			GlobalsSetValue( "TEMPLE_PERK_COUNT", "3" )
		end,
	},
	{
		id = "PEACE_WITH_GODS",
		ui_name = "$perk_peace_with_steve",
		ui_description = "$dpeace_with_steve",
		ui_icon = "data/ui_gfx/perk_icons/peace_with_gods.png",
		perk_icon = "data/items_gfx/perks/peace_with_gods.png",
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name )
			GlobalsSetValue( "TEMPLE_PEACE_WITH_GODS", "1" )
			GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "0" )
			
			local steves = EntityGetWithTag( "necromancer_shop" )
			if ( steves ~= nil ) then
				for index,entity_steve in ipairs(steves) do
					GetGameEffectLoadTo( entity_steve, "CHARM", true )
				end
			end

			add_halo_level(entity_who_picked, 1)

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local holy_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "holy" ))
					holy_resistance = holy_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "holy", tostring(holy_resistance) )
					local curse_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "curse" ))
					curse_resistance = curse_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "curse", tostring(curse_resistance) )
					--[[
					local healing_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "healing" ))
					healing_resistance = healing_resistance * 1.2
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "healing", tostring(healing_resistance) )
					]]--
				end
			end
		end,
		func_remove = function( entity_who_picked )
			GlobalsSetValue( "TEMPLE_PEACE_WITH_GODS", "0" )
			GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "0" )
		end,
	},
	{
		id = "LASER_AIM",
		ui_name = "$perk_laser_aim",
		ui_description = "$dperk_LASER_AIM",
		ui_icon = "data/ui_gfx/perk_icons/laser_aim.png",
		perk_icon = "data/items_gfx/perks/laser_aim.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/laser_aim.xml", x, y )

			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
			
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{
				_tags = "perk_component",
				extra_modifier = "laser_aim",
			} )
		end,
	},
	{
		id = "STRENGTH",
		ui_name = "$STRENGTH",
		ui_description = "$dSTRENGTH",
		ui_icon = "data/ui_gfx/perk_icons/strength.png",
		perk_icon = "data/items_gfx/perks/strength.png",
		not_in_default_perk_pool = true,
		one_off_effect = true,
		do_not_remove = true,
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name ) 
			local x, y = EntityGetTransform( entity_who_picked )
			-- SetRandomSeed( x, y )
			if EntityHasTag( entity_who_picked, "blessed" ) then
				-- EntityKill( entity_who_picked )
				GamePrintImportant( "You Can't Take More Blessings!", "Man of mould!" )
			else
				local perk_reroll_count = tonumber( GlobalsGetValue( "TEMPLE_PERK_REROLL_COUNT", "0" ) )
				GlobalsSetValue( "TEMPLE_PERK_REROLL_COUNT", tostring( perk_reroll_count + 1 ) )

				if ( not EntityHasTag( entity_who_picked, "de_strength" ) ) then EntityAddTag( entity_who_picked, "de_strength") end -- GameAddFlagRun()
			end

			EntityAddTag( entity_who_picked, "blessed")

			local neow_perks = EntityGetWithTag( "neow" )
			if ( #neow_perks > 0 ) then
				for i,neow_perk in ipairs( neow_perks ) do
					EntityKill( neow_perk )
				end
			end
		end,
	},
	{
		id = "WEALTH",
		ui_name = "$WEALTH",
		ui_description = "$dWEALTH",
		ui_icon = "data/ui_gfx/perk_icons/wealth.png",
		perk_icon = "data/items_gfx/perks/wealth.png",
		not_in_default_perk_pool = true,
		one_off_effect = true,
		do_not_remove = true,
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name ) 
			local x, y = EntityGetTransform( entity_who_picked )
			SetRandomSeed( x, y )

			if EntityHasTag( entity_who_picked, "blessed" ) then
				-- EntityKill( entity_who_picked )
				GamePrintImportant( "You Can't Take More Blessings!", "Man of mould!" )
			else
				local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )

				if ( damagemodels ~= nil ) then
					for i,damagemodel in ipairs(damagemodels) do
						local max_hp = ComponentGetValue2( damagemodel, "max_hp" )

						ComponentSetValue2( damagemodel, "max_hp_old", max_hp )
						ComponentSetValue2( damagemodel, "hp", max_hp )
						ComponentSetValue2( damagemodel, "mLastMaxHpChangeFrame", GameGetFrameNum() )
					end
				end

				local child_id = EntityLoad( "data/entities/misc/perks/deep_end_wealth_perk_curse.xml", x, y )
				-- EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )

				local torque = 1024
				local types = {1,2,3,4,5,6,7}

				local chest_type = Random( 1, #types )
				local chest = EntityLoad("data/entities/items/pickup/chest_random_harder_" .. chest_type .. ".xml", 408, -256)
				EntityAddTag( chest, "deep_end_rain_chest" )
				PhysicsApplyTorque( chest, torque )
				table.remove( types, chest_type )

				chest_type = Random( 1, #types )
				chest = EntityLoad("data/entities/items/pickup/chest_random_harder_" .. chest_type .. ".xml", 430, -260)
				EntityAddTag( chest, "deep_end_rain_chest" )
				PhysicsApplyTorque( chest, torque )
				table.remove( types, chest_type )

				chest_type = Random( 1, #types )
				chest = EntityLoad("data/entities/items/pickup/chest_random_harder_" .. chest_type .. ".xml", 452, -264)
				EntityAddTag( chest, "deep_end_rain_chest" )
				PhysicsApplyTorque( chest, torque )
				table.remove( types, chest_type )
			end

			EntityAddTag( entity_who_picked, "blessed")

			local neow_perks = EntityGetWithTag( "neow" )
			if ( #neow_perks > 0 ) then
				for i,neow_perk in ipairs( neow_perks ) do
					EntityKill( neow_perk )
				end
			end
		end,
	},
	{
		id = "HEALTH",
		ui_name = "$HEALTH",
		ui_description = "$dHEALTH",
		ui_icon = "data/ui_gfx/perk_icons/health.png",
		perk_icon = "data/items_gfx/perks/health.png",
		not_in_default_perk_pool = true,
		one_off_effect = true,
		do_not_remove = true,
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name ) 
			local x, y = EntityGetTransform( entity_who_picked )
			-- SetRandomSeed( x, y )
			if EntityHasTag( entity_who_picked, "blessed" ) then
				-- EntityKill( entity_who_picked )
				GamePrintImportant( "You Can't Take More Blessings!", "Man of mould!" )
			else
				GameAddFlagRun( "deep_end_wealth_perk_curse" )

				if ( not EntityHasTag( entity_who_picked, "de_health" ) ) then EntityAddTag( entity_who_picked, "de_health") end
			end

			EntityAddTag( entity_who_picked, "blessed")

			local neow_perks = EntityGetWithTag( "neow" )
			if ( #neow_perks > 0 ) then
				for i,neow_perk in ipairs( neow_perks ) do
					EntityKill( neow_perk )
				end
			end
		end,
	},
	{
		id = "CHAOS",
		ui_name = "$perk_CHAOS",
		ui_description = "$dCHAOS",
		ui_icon = "data/ui_gfx/perk_icons/worth.png",
		perk_icon = "data/items_gfx/perks/worth.png",
		game_effect = "HEALING_BLOOD",
		game_effect2 = "PROTECTION_FOOD_POISONING",
		not_in_default_perk_pool = true,
		one_off_effect = true,
		do_not_remove = true,
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name ) 
			local x, y = EntityGetTransform( entity_who_picked )

			if EntityHasTag( entity_who_picked, "blessed" ) then
				-- EntityKill( entity_who_picked )
				GamePrintImportant( "You Can't Take More Blessings!", "Man of mould!" )
			else
				EntityAddComponent( entity_who_picked, "LuaComponent", 
				{ 
					_tags = "perk_component",
					remove_after_executed = "0",
					script_source_file = "data/scripts/perks/chaos.lua",
					execute_every_n_frame = "1",
				} )

				EntityAddComponent( entity_who_picked, "BossHealthBarComponent", {} )

				local shield_id = EntityLoad( "data/entities/misc/perks/chaos_shield.xml", x, y )
				local drug_id = EntityLoad( "data/entities/misc/perks/chaos_effect.xml", x, y )
				local laser_id = EntityLoad( "data/entities/misc/perks/personal_laser.xml", x, y )

				EntityAddTag( shield_id, "perk_entity" )
				EntityAddTag( drug_id, "perk_entity" )
				EntityAddTag( laser_id, "perk_entity" )

				EntityAddChild( entity_who_picked, shield_id )
				EntityAddChild( entity_who_picked, drug_id )
				EntityAddChild( entity_who_picked, laser_id )

				local child_id = 0

				for i=1,2 do
					child_id = EntityLoad( "data/entities/misc/perks/attack_foot/limb_walker.xml", x, y )
					EntityAddTag( child_id, "perk_entity" )
					EntityAddChild( entity_who_picked, child_id )

					child_id = EntityLoad( "data/entities/animals/boss_centipede/limbs/limb_long.xml", x, y )
					EntityAddTag( child_id, "perk_entity" )
					EntityAddChild( entity_who_picked, child_id )
					
					child_id = EntityLoad( "data/entities/animals/boss_limbs/limb.xml", x, y )
					EntityAddTag( child_id, "perk_entity" )
					EntityAddChild( entity_who_picked, child_id )

					child_id = EntityLoad( "data/entities/animals/boss_meat/limb.xml", x, y )
					EntityAddTag( child_id, "perk_entity" )
					EntityAddChild( entity_who_picked, child_id )

					child_id = EntityLoad( "data/entities/animals/boss_robot/limb.xml", x, y )
					EntityAddTag( child_id, "perk_entity" )
					EntityAddChild( entity_who_picked, child_id )

					child_id = EntityLoad( "data/entities/animals/lukki/lukki_feet/lukki_limb_long2.xml", x, y )
					EntityAddTag( child_id, "perk_entity" )
					EntityAddChild( entity_who_picked, child_id )
					EntityAddComponent( child_id, "IKLimbWalkerComponent", {} )

					child_id = EntityLoad( "data/entities/animals/lukki/lukki_feet/lukki_limb_long_animated.xml", x, y )
					EntityAddTag( child_id, "perk_entity" )
					EntityAddChild( entity_who_picked, child_id )
					EntityAddComponent( child_id, "IKLimbWalkerComponent", {} )

					child_id = EntityLoad( "data/entities/animals/lukki/lukki_feet/lukki_dark_limb_animated.xml", x, y )
					EntityAddTag( child_id, "perk_entity" )
					EntityAddChild( entity_who_picked, child_id )
					EntityAddComponent( child_id, "IKLimbWalkerComponent", {} )
				end

				child_id = EntityLoad( "data/entities/misc/perks/attack_leggy/leggy_limb_left.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )

				child_id = EntityLoad( "data/entities/misc/perks/attack_leggy/leggy_limb_right.xml", x, y )
				EntityAddTag( child_id, "perk_entity" )
				EntityAddChild( entity_who_picked, child_id )

				for _,v in ipairs(EntityGetAllChildren(entity_who_picked)) do
					if EntityHasTag(v, "leggy_foot_walker") then
						component_readwrite(EntityGetFirstComponent(v, "IKLimbComponent"), { length = 50 }, function(comp)
							comp.length = comp.length * 2
						end)
					end
				end

				local perks_give = { "IRON_STOMACH", "BREATH_UNDERWATER", "TELEKINESIS", "FUNGAL_DISEASE", "WORM_SMALLER_HOLES", "REPELLING_CAPE" }
				for i=1,#perks_give do
					local perk_give = perk_spawn(x, y, perks_give[i])
					perk_pickup(perk_give, entity_who_picked, EntityGetName(perk_give), false, false)
				end

				local itemcomp = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" )
				ComponentSetValue2( itemcomp, "full_inventory_slots_x", 1 )
				ComponentSetValue2( itemcomp, "full_inventory_slots_y", 17 )
				
				local platformingcomponents = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
				if ( platformingcomponents ~= nil ) then
					for i,component in ipairs(platformingcomponents) do
						local run_speed = tonumber( ComponentGetMetaCustom( component, "run_velocity" ) ) * 1.2
						local vel_x = math.abs( tonumber( ComponentGetMetaCustom( component, "velocity_max_x" ) ) ) * 1.2
						
						local vel_x_min = 0 - vel_x
						local vel_x_max = vel_x
						
						ComponentSetMetaCustom( component, "run_velocity", run_speed )
						ComponentSetMetaCustom( component, "velocity_min_x", vel_x_min )
						ComponentSetMetaCustom( component, "velocity_max_x", vel_x_max )
						ComponentSetValue2( component, "jump_velocity_y", -950 ) -- "-95"
						ComponentSetValue2( component, "jump_velocity_x", 560 ) -- "56"
						ComponentSetValue2( component, "pixel_gravity", 125 ) -- "350"
					end
				end

				local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
				if ( damagemodels ~= nil ) then
					for i,damagemodel in ipairs(damagemodels) do
						ComponentSetValue( damagemodel, "blood_material", "magic_liquid_worm_attractor" )
						ComponentSetValue( damagemodel, "blood_spray_material", "magic_liquid_worm_attractor" )
						ComponentSetValue( damagemodel, "blood_multiplier", "7.0" )

						ComponentObjectSetValue2( damagemodel, "damage_multipliers", "radioactive", -0.2 )
						ComponentObjectSetValue2( damagemodel, "damage_multipliers", "poison", 0.5 )
					end
				end

				EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", x, y )
				EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y)
				EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y )

				perk_pickup_event("LUKKI")
				perk_pickup_event("GHOST")
				perk_pickup_event("FUNGI")
				perk_pickup_event("RAT")

				GamePrintImportant( "$dpCHAOS_1", "$dpCHAOS_2" )
			end

			if ( not EntityHasTag( entity_who_picked, "de_respawn" ) ) then EntityAddTag( entity_who_picked, "de_respawn") end

			EntityAddTag( entity_who_picked, "blessed")
			EntityAddTag( entity_who_picked, "fish_attractor")
			EntityAddTag( entity_who_picked, "chaos_frankenstein")
			if not EntityHasTag( entity_who_picked, "forgeable" ) then EntityAddTag( entity_who_picked, "forgeable") end

			GlobalsSetValue( "TEMPLE_PERK_COUNT", "0" )

			local neow_perks = EntityGetWithTag( "neow" )
			if ( #neow_perks > 0 ) then
				for i,neow_perk in ipairs( neow_perks ) do
					EntityKill( neow_perk )
				end
			end
		end,
	},
	{
		id = "DE_DUPLICATE",
		ui_name = "$perk_DE_DUPLICATE",
		ui_description = "$dDE_DUPLICATE",
		ui_icon = "data/ui_gfx/perk_icons/de_perk_duplicate.png",
		perk_icon = "data/items_gfx/perks/de_perk_duplicate.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		one_off_effect = true,
		do_not_remove = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x, y = EntityGetTransform( entity_who_picked )
			EntityAddChild( entity_who_picked, EntityLoad( "data/entities/misc/what_is_this/de_perk_duplicater.xml", x, y ) )
		end,	-- "damage_multipliers" will not be reset, so it is very powerful in some cases
	},
	--[[
	{
		id = "ABYSS",
		ui_name = "$Abyss",
		ui_description = "$dAbyss",
		ui_icon = "data/ui_gfx/perk_icons/abyss.png",
		perk_icon = "data/items_gfx/perks/abyss.png",
		game_effect = "STAINS_DROP_FASTER",
		game_effect2 = "NO_SLIME_SLOWDOWN",
		not_in_default_perk_pool = true,
		one_off_effect = true,
		do_not_remove = true,
		stackable = STACKABLE_NO,
		func = function( entity_perk_item, entity_who_picked, item_name ) 

			local x, y = EntityGetTransform( entity_who_picked )

			CreateItemActionEntity( "DE_SNIPER_BULLET", x-24, y-12 )
			CreateItemActionEntity( "DE_TELEPORT_PROJECTILE_GRENADE", x-8, y-12 )
			CreateItemActionEntity( "LUMINOUS_DRILL", x+8, y-12 )
			CreateItemActionEntity( "GRENADE_TIER_3", x+24, y-12 )

			GlobalsSetValue( "STEVARI_DEATHS", tostring(deaths) )
			GlobalsSetValue( "TEMPLE_PERK_DESTROY_CHANCE", "0" )
			GlobalsSetValue( "TEMPLE_PERK_REROLL_COUNT", "34" )
			GlobalsSetValue( "TEMPLE_PERK_COUNT", "2" )
			GlobalsSetValue( "HELPLESS_KILLS", "18" )

			IMPL_remove_all_perks( entity_who_picked )

			local plx, ply, plr, plsx, plsy = EntityGetTransform( entity_who_picked )
			EntitySetTransform( entity_who_picked, plx, ply, 0, 1, 1)
			
			local all_perks = EntityGetWithTag( "perk" )
			if ( #all_perks > 0 ) then
				for i,entity_perk in ipairs(all_perks) do
					if ( entity_perk ~= entity_perk_item ) and not EntityHasTag( entity_perk, "dash" ) and ( not EntityHasTag( entity_perk, "neow" ) ) then
						EntityKill( entity_perk )
					end
				end
			end

			EntityAddComponent( entity_who_picked, "VariableStorageComponent", 
			{ 
				name="deepth_state",
				value_int="1",
			} )

			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				remove_after_executed="0",
				script_source_file="data/scripts/perks/abyss.lua",
				execute_every_n_frame="2",
			} )

			local moneycomp = EntityGetFirstComponent( entity_who_picked, "WalletComponent" )
			ComponentSetValue2( moneycomp, "money", 0 )

			local itemcomp = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" )
			ComponentSetValue2( itemcomp, "full_inventory_slots_x", 13 )
			ComponentSetValue2( itemcomp, "full_inventory_slots_y", 1 )

			local dmgmodel = EntityGetFirstComponent( entity_who_picked, "DamageModelComponent" )
			if ( dmgmodel ~= nil ) then
				ComponentSetValue( dmgmodel, "materials_damage_proportional_to_maxhp", "1" )
			end

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local max_hp = 13
					local max_hp_cap = tonumber( ComponentGetValue2( damagemodel, "max_hp_cap" ) )
					local hp = tonumber( ComponentGetValue2( damagemodel, "hp" ) )
					
					if EntityHasTag( entity_who_picked, "blessed" ) and ( not EntityHasTag( entity_who_picked, "chaos_frankenstein" ) ) then max_hp = 8 end
					
					ComponentSetValue( damagemodel, "hp", max_hp)
					ComponentSetValue( damagemodel, "max_hp", max_hp)
					ComponentSetValue( damagemodel, "max_hp_cap", max_hp_cap)

					ComponentObjectSetValue( damagemodel, "damage_multipliers", "melee", tostring(2.25) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(2.0) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(0.5) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "electricity", tostring(1.2) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(1.5) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "drill", tostring(1.5) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "slice", tostring(1.5) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "ice", tostring(1.5) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "healing", tostring(2) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "physics_hit", tostring(0.25) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "radioactive", tostring(1.5) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "poison", tostring(2.5) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "curse", tostring(0.7) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "holy", tostring(0.7) )
				end

				local give_perk = perk_spawn(px, py, "EDIT_WANDS_EVERYWHERE")
				perk_pickup(give_perk, entity_who_picked, EntityGetName(give_perk), false, false)

				give_perk = perk_spawn(px, py, "UNLIMITED_SPELLS")
				perk_pickup(give_perk, entity_who_picked, EntityGetName(give_perk), false, false)

				give_perk = perk_spawn(px, py, "NO_MORE_SHUFFLE")
				perk_pickup(give_perk, entity_who_picked, EntityGetName(give_perk), false, false)

				give_perk = perk_spawn(px, py, "REMOVE_FOG_OF_WAR")
				perk_pickup(give_perk, entity_who_picked, EntityGetName(give_perk), false, false)

				if ( not EntityHasTag( entity_who_picked, "de_respawn" ) ) then
					give_perk = perk_spawn(px, py, "RESPAWN")
					perk_pickup(give_perk, entity_who_picked, EntityGetName(give_perk), false, false)
				end

				EntityAddTag( entity_who_picked, "abyss_player")

				ConvertMaterialEverywhere( CellFactory_GetType( "rock_box2d_hard" ), CellFactory_GetType( "water_static" ) )

				EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", x, y )
				EntityLoad( "data/entities/particles/supernova.xml", x, y )

				GameScreenshake( 300, x, y )
				GamePlaySound( "data/audio/Desktop/misc.bank", "misc/sun/supernova", x, y )
				GamePrintImportant( "$dAbyss_1", "$dAbyss_2" )
			end
		end,
	},
	]]--
}

function remove_perk( perk_name )
	local key_to_perk = nil

	for key,perk in pairs(perk_list) do
		if ( perk.id == perk_name) then
			key_to_perk = key
		end
	end

	if ( key_to_perk ~= nil ) then
		table.remove( perk_list, key_to_perk )
	end
end

function remove_from_default_perk_pool( perk_name )
	local key_to_perk = nil

	for i=1,#de_perk_list_recompose do
		if ( de_perk_list_recompose[i].id == perk_name ) then
			de_perk_list_recompose[i].not_in_default_perk_pool = true
			break
		end
	end
end

remove_perk( "INVISIBILITY" )
remove_perk( "TELEPORTITIS" )
remove_perk( "FREEZE_FIELD" )
remove_perk( "BLEED_OIL" )
remove_perk( "BLEED_GAS" )
remove_perk( "MEGA_BEAM_STONE" )
remove_perk( "ABILITY_ACTIONS_MATERIALIZED" )
remove_perk( "ATTRACT_ITEMS" )
remove_perk( "FASTER_LEVITATION" )
remove_perk( "HOMUNCULUS" )
remove_perk( "LEVITATION_TRAIL" )
remove_perk( "MANA_FROM_KILLS" )
remove_perk( "GLOBAL_GORE" )
remove_perk( "FOOD_CLOCK" )
remove_perk( "PERSONAL_LASER" )
remove_perk( "VAMPIRISM" )
remove_perk( "GENOME_MORE_HATRED" )
remove_perk( "GENOME_MORE_LOVE" )
remove_perk( "ANGRY_LEVITATION" )
remove_perk( "DUPLICATE_PROJECTILE" )
remove_perk( "ITEM_RADAR" )

if ( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then
	remove_from_default_perk_pool( "NO_WAND_EDITING" )
	remove_from_default_perk_pool( "TRICK_BLOOD_MONEY" )
	remove_from_default_perk_pool( "SAVING_GRACE" )
	remove_from_default_perk_pool( "EXTRA_SHOP_ITEM" )
	remove_from_default_perk_pool( "EXTRA_PERK" )
	remove_from_default_perk_pool( "PERKS_LOTTERY" )
	remove_from_default_perk_pool( "DE_DUPLICATE" )
end

for i=1,#de_perk_list_recompose do -- inefficient and wild
	local find = false

	for j=1,#perk_list do
		if de_perk_list_recompose[i].id == perk_list[j].id then
			table.remove( perk_list, j )
			table.insert( perk_list, de_perk_list_recompose[i] )
			
			find = true
			break
		end
	end

	if not find then
		table.insert( perk_list, de_perk_list_recompose[i] )
	end
end

-- ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" )
DEEP_END_VAILD_PERKS = {}
			
for i,perk_data in ipairs( perk_list ) do
	if perk_data.usable_by_enemies ~= nil and perk_data.usable_by_enemies then
		local hah_amount = math.max( math.floor( ModSettingGet( "DEEP_END.HELL_AND_HELL_AMOUNT" ) + 0.5 ), 1 )

		if hah_amount > 1 then
			if perk_data.usable_by_mult_enemies == nil or perk_data.usable_by_mult_enemies then
				table.insert( DEEP_END_VAILD_PERKS, i )
			end
		else
			table.insert( DEEP_END_VAILD_PERKS, i )
		end
	end
end