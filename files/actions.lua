dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/gun/gun_enums.lua")
dofile_once("data/entities/misc/what_is_this/BSOD.lua")

DE_DRAW_STATE = 0

local DE_USAGE = 20
local DE_ULTIMATE_MANA = 343

-- data/scripts/gun/gun.lua
function de_str_finder( game_effect_entities, add_entity )
	local str_check = false

	if type( game_effect_entities ) == "table" or type( add_entit ) == "table" then
		return false
	else
		str_check = string.find( game_effect_entities, add_entity )
		return str_check
	end
end

function de_effect_entities_add( game_effect_entities, add_entity )
	local judge = de_str_finder( game_effect_entities, add_entity )
	local effect_entities = game_effect_entities

	if judge == nil then effect_entities = effect_entities .. add_entity end

	return effect_entities
end

function DEEP_END_add_projectile_trigger_customized( entity_filename, customized_timer_list, action_draw_count_list, can_reload_at_end )
	if reflecting then 
		Reflection_RegisterProjectile( entity_filename )
		return 
	end

	if nil == entity_filename then return end
	if nil == action_draw_count_list then action_draw_count_list = {} end
	if nil == can_reload_at_end then can_reload_at_end = true end
	if nil == customized_timer_list then
		add_projectile( entity_filename )
		return
	end

	BeginProjectile( entity_filename )

	for i=1,#customized_timer_list do
		if customized_timer_list[i] == 0 then
		BeginTriggerDeath()
		elseif customized_timer_list[i] < 0 then
		BeginTriggerHitWorld()
		elseif customized_timer_list[i] > 0 then
		BeginTriggerTimer( customized_timer_list[i] )
		end

			draw_shot( create_shot( action_draw_count_list[i] or 1 ), can_reload_at_end )

		EndTrigger()
	end

	--[[

	For BeginTriggerHitWorld() and BeginTriggerTimer(),
	the last (n-1)\1 draw_shot still creat projs only if the trigger hits the creatures.
	( normally, hitting terrain should also work )
	
	]]--

	EndProjectile() -- Honestly, I didn't know what I was doing at the time
end

function DEEP_END_add_projectile_trigger_add_effect( add_entity, entity_filename, customized_timer, action_draw_count, can_reload_at_end )
	if reflecting then 
		Reflection_RegisterProjectile( entity_filename )
		return 
	end

	if nil == entity_filename then return end
	if nil == customized_timer then customized_timer = 0 end
	if nil == action_draw_count then action_draw_count = 1 end
	if nil == can_reload_at_end then can_reload_at_end = true end

	BeginProjectile( entity_filename )

		if customized_timer == 0 then
		BeginTriggerDeath()
		elseif customized_timer < 0 then
		BeginTriggerHitWorld()
		elseif customized_timer > 0 then
		BeginTriggerTimer( customized_timer )
		end

			-- draw_shot( create_shot( action_draw_count ), can_reload_at_end )
			local shot = create_shot( action_draw_count )
			local c_old = c
			c = shot.state
			c.extra_entities = de_effect_entities_add( c.extra_entities, add_entity )
			
			shot_structure = {}
			draw_actions( shot.num_of_cards_to_draw, can_reload_at_end )
			register_action( shot.state )
			SetProjectileConfigs()

			c = c_old

		EndTrigger()

	EndProjectile()
end

function DEEP_END_add_projectile_trigger_heritable( heritance, entity_filename, customized_timer, action_draw_count, can_reload_at_end )
	if reflecting then 
		Reflection_RegisterProjectile( entity_filename )
		return 
	end

	if nil == entity_filename then return end
	if nil == customized_timer then customized_timer = 0 end
	if nil == action_draw_count then action_draw_count = 1 end
	if nil == can_reload_at_end then can_reload_at_end = true end

	BeginProjectile( entity_filename )

		if customized_timer == 0 then
		BeginTriggerDeath()
		elseif customized_timer < 0 then
		BeginTriggerHitWorld()
		elseif customized_timer > 0 then
		BeginTriggerTimer( customized_timer )
		end

			-- draw_shot( create_shot( action_draw_count ), can_reload_at_end )
			local shot = create_shot( action_draw_count )
			local c_old = c
			c = shot.state
			
			c.damage_melee_add = heritance.damage_melee_add
            c.damage_drill_add = heritance.damage_drill_add
            c.damage_slice_add = heritance.damage_slice_add
            c.damage_fire_add = heritance.damage_fire_add
            c.damage_ice_add = heritance.damage_ice_add
            c.damage_electricity_add = heritance.damage_electricity_add
            c.damage_curse_add = heritance.damage_curse_add
            c.damage_healing_add = heritance.damage_healing_add
            c.damage_explosion_add = heritance.damage_explosion_add
            c.damage_explosion = heritance.damage_explosion
			c.explosion_radius = heritance.explosion_radius
 			c.damage_projectile_add = heritance.damage_projectile_add
            c.damage_critical_chance = heritance.damage_critical_chance
            c.damage_null_all = heritance.damage_null_all
            c.gore_particles = heritance.gore_particles
			c.knockback_force = heritance.knockback_force
			c.trail_material = heritance.trail_material
			c.trail_material_amount = heritance.trail_material_amount
			c.extra_entities = heritance.extra_entities
			c.game_effect_entities = heritance.game_effect_entities
			c.lifetime_add = heritance.lifetime_add
			c.bounces = heritance.bounces
			c.gravity = heritance.gravity
			c.speed_multiplier = heritance.speed_multiplier
			c.spread_degrees = heritance.spread_degrees
			c.pattern_degrees = heritance.pattern_degrees
			c.material = heritance.material
			c.lightning_count = heritance.lightning_count
			-- c.child_speed_multiplier
			-- c.friendly_fire
			
			shot_structure = {}
			draw_actions( shot.num_of_cards_to_draw, can_reload_at_end )
			register_action( shot.state )
			SetProjectileConfigs()

			c = c_old
			
		EndTrigger()

	EndProjectile()
end

local de_actions_recompose =
{
	-- projectiles --
	--[[{
		id          = "TESTBULLET", -- REMOVE THIS ONCE PHYSICS_EXPLOSION_POWER IS ADJUSTED, JUST FOR TESTING
		name 		= "$action_testbullet",
		description = "$actiondesc_testbullet",
		sprite 		= "data/debug/icon_testbullet.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- TESTBULLET
		spawn_probability                        = "", -- TESTBULLET
		price = 100,
		mana = 0,
		max_uses = 999,
		action 		= function()
			add_projectile("data/entities/animals/boss_centipede/firepillar.xml")
			c.fire_rate_wait = 0
			current_reload_time = current_reload_time * 0.01
		end,
	},]]--
	{
		id          = "BOMB",
		name 		= "$action_bomb",
		description = "$actiondesc_bomb",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bomb.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb_no_beep.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3", -- BOMB
		spawn_probability                 = "0.35,0.25,0.15,0.05", -- BOMB
		price = 200,
		mana = 40, 
		max_uses    = 6, 
		custom_xml_file = "data/entities/misc/custom_cards/bomb.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/bomb_beep.xml")
			c.fire_rate_wait = c.fire_rate_wait + 35
		end,
	},
	{
		id          = "LIGHT_BULLET",
		name 		= "$action_light_bullet",
		description = "$actiondesc_light_bullet",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/light_bullet.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_light_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2", -- LIGHT_BULLET
		spawn_probability                 = "1.5,1,0.5", -- LIGHT_BULLET
		price = 100,
		mana = 5,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_light_bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait + 2
			c.screenshake = c.screenshake + 0.2
			c.damage_critical_chance = c.damage_critical_chance + 5
		end,
	},
	{
		id          = "LIGHT_BULLET_TRIGGER",
		name 		= "$action_light_bullet_trigger",
		description = "$actiondesc_light_bullet_trigger",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/light_bullet_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_light_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3,4", -- LIGHT_BULLET_TRIGGER
		spawn_probability                   = "0.7,0.8,0.5,0.4,0.3", -- LIGHT_BULLET_TRIGGER
		price = 140,
		mana = 10,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 2
			c.screenshake = c.screenshake + 0.2
			c.damage_critical_chance = c.damage_critical_chance + 5
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/de_light_bullet.xml", 1)
		end,
	},
	{
		id          = "LIGHT_BULLET_TRIGGER_2",
		name 		= "$action_light_bullet_trigger_2",
		description = "$actiondesc_light_bullet_trigger_2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/light_bullet_trigger_2.png",
		related_projectiles	= {"data/entities/projectiles/deck/light_bullet_blue.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "2,3,5,6,10", -- LIGHT_BULLET_TRIGGER_2
		spawn_probability                   = "0.5,0.5,0.75,0.75,0.05", -- LIGHT_BULLET_TRIGGER_2
		price = 250,
		mana = 12,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			c.damage_critical_chance = c.damage_critical_chance + 5
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/light_bullet_blue.xml", 2)
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_HERITABLE_BULLET",
		name 		= "$HERITABLE_BULLET",
		description = "$dHERITABLE_BULLET",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/heritable_bullet.png",
		related_projectiles	= {"data/entities/projectiles/deck/heritable_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "4,5,6,7,10", -- LIGHT_BULLET_TRIGGER_2
		spawn_probability                   = "0.05,0.15,0.15,0.05,0.15", -- LIGHT_BULLET_TRIGGER_2
		price = 250,
		mana = 24,
		-- max_uses = 128,
		custom_xml_file = "data/entities/misc/custom_cards/heritable_bullet.xml",
		action 		= function()
			c.screenshake = 1.2
			c.fire_rate_wait = c.fire_rate_wait + 7
			current_reload_time = current_reload_time + 7
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 12.0

			local heritance = {}
			heritance.damage_melee_add = c.damage_melee_add
            heritance.damage_drill_add = c.damage_drill_add
            heritance.damage_slice_add = c.damage_slice_add
            heritance.damage_fire_add = c.damage_fire_add
            heritance.damage_ice_add = c.damage_ice_add
            heritance.damage_electricity_add = c.damage_electricity_add
            heritance.damage_curse_add = c.damage_curse_add
            heritance.damage_healing_add = c.damage_healing_add
            heritance.damage_explosion_add = c.damage_explosion_add
            heritance.damage_explosion = c.damage_explosion
			heritance.explosion_radius = c.explosion_radius
 			heritance.damage_projectile_add = c.damage_projectile_add
            heritance.damage_critical_chance = c.damage_critical_chance
            heritance.damage_null_all = c.damage_null_all
            heritance.gore_particles = c.gore_particles
			heritance.knockback_force = c.knockback_force
			heritance.trail_material = c.trail_material
			heritance.trail_material_amount = c.trail_material_amount
			heritance.extra_entities = c.extra_entities
			heritance.game_effect_entities = c.game_effect_entities
			heritance.lifetime_add = c.lifetime_add
			heritance.bounces = c.bounces
			heritance.gravity = c.gravity
			heritance.speed_multiplier = c.speed_multiplier
			heritance.spread_degrees = c.spread_degrees
			heritance.pattern_degrees = c.pattern_degrees
			heritance.material = c.material
			heritance.lightning_count = c.lightning_count
			-- c.child_speed_multiplier
			-- c.friendly_fire

			DEEP_END_add_projectile_trigger_heritable(heritance,"data/entities/projectiles/deck/heritable_bullet.xml",150)
		end,
	},
	{
		id          = "LIGHT_BULLET_TIMER",
		name 		= "$action_light_bullet_timer",
		description = "$actiondesc_light_bullet_timer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/light_bullet_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_light_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "1,2,3,4", -- LIGHT_BULLET_TIMER
		spawn_probability                   = "0.25,0.5,0.75,0.5", -- LIGHT_BULLET_TIMER
		price = 140,
		mana = 10,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 2
			c.screenshake = c.screenshake + 0.2
			c.damage_critical_chance = c.damage_critical_chance + 5
			add_projectile_trigger_timer("data/entities/projectiles/deck/de_light_bullet.xml", 10, 1)
		end,
	},
	{
		id          = "BULLET",
		name 		= "$action_bullet",
		description = "$actiondesc_bullet",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bullet.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- BULLET
		spawn_probability                 = "0.6,0.5,0.4,0.3,0.2", -- BULLET
		price = 150,
		mana = 10,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 1
			c.spread_degrees = c.spread_degrees + 2.0
			c.damage_critical_chance = c.damage_critical_chance + 6
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 15.0
		end,
	},
	{
		id          = "BULLET_TRIGGER",
		name 		= "$action_bullet_trigger",
		description = "$actiondesc_bullet_trigger",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bullet_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bullet_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "1,2,3,4,5", -- BULLET_TRIGGER
		spawn_probability                   = "0.4,0.6,0.4,0.6,0.4", -- BULLET_TRIGGER
		price = 190,
		mana = 14,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 1
			c.spread_degrees = c.spread_degrees + 2.0
			c.damage_critical_chance = c.damage_critical_chance + 6
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bullet.xml", 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 15.0
		end,
	},
	{
		id          = "BULLET_TIMER",
		name 		= "$action_bullet_timer",
		description = "$actiondesc_bullet_timer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bullet_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bullet_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "2,3,4,5,6", -- BULLET_TIMER
		spawn_probability                   = "0.5,0.5,0.5,0.4,0.4", -- BULLET_TIMER
		price = 190,
		mana = 14,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 1
			c.spread_degrees = c.spread_degrees + 2.0
			c.damage_critical_chance = c.damage_critical_chance + 6
			add_projectile_trigger_timer("data/entities/projectiles/deck/bullet.xml", 10, 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 15.0
		end,
	},
	{
		id          = "HEAVY_BULLET",
		name 		= "$action_heavy_bullet",
		description = "$actiondesc_heavy_bullet",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/heavy_bullet.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/heavy_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_heavy.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- HEAVY_BULLET
		spawn_probability                 = "0.5,0.75,0.75,0.75,0.75", -- HEAVY_BULLET
		price = 200,
		mana = 15,
		-- max_uses = DE_USAGE * 12,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bullet_heavy.xml")
			c.fire_rate_wait = c.fire_rate_wait + 5
			c.screenshake = c.screenshake + 1.5
			c.spread_degrees = c.spread_degrees + 5.0
			c.damage_critical_chance = c.damage_critical_chance + 7
			-- c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated_air.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 24.0
		end,
	},
	{
		id          = "HEAVY_BULLET_TRIGGER",
		name 		= "$action_heavy_bullet_trigger",
		description = "$actiondesc_heavy_bullet_trigger",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/heavy_bullet_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/heavy_bullet_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_heavy.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "2,3,4,5,6", -- HEAVY_BULLET_TRIGGER
		spawn_probability                   = "0.5,0.5,0.5,0.75,0.5", -- HEAVY_BULLET_TRIGGER
		price = 240,
		mana = 18,
		-- max_uses = DE_USAGE * 12,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 5
			c.screenshake = c.screenshake + 1.5
			c.spread_degrees = c.spread_degrees + 5.0
			c.damage_critical_chance = c.damage_critical_chance + 7
			-- c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated_air.xml,"
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bullet_heavy.xml", 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 24.0
		end,
	},
	{
		id          = "HEAVY_BULLET_TIMER",
		name 		= "$action_heavy_bullet_timer",
		description = "$actiondesc_heavy_bullet_timer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/heavy_bullet_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/heavy_bullet_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_heavy.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "2,3,4,5,6", -- HEAVY_BULLET_TIMER
		spawn_probability                   = "0.5,0.5,0.5,0.5,0.75", -- HEAVY_BULLET_TIMER
		price = 240,
		mana = 18,
		-- max_uses = DE_USAGE * 12,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 5
			c.screenshake = c.screenshake + 1.5
			c.spread_degrees = c.spread_degrees + 5.0
			c.damage_critical_chance = c.damage_critical_chance + 7
			-- c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated_air.xml,"
			add_projectile_trigger_timer("data/entities/projectiles/deck/bullet_heavy.xml", 10, 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 24.0
		end,
	},
	{
		id          = "AIR_BULLET",
		name 		= "$action_air_bullet",
		description = "$actiondesc_air_bullet",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/air_bullet.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/air_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/light_bullet_air.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2", -- AIR_BULLET
		spawn_probability                 = "0.75,0.75", -- AIR_BULLET
		price = 80,
		mana = 4,
		-- max_uses = DE_USAGE * 12,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/light_bullet_air.xml")
			c.fire_rate_wait = c.fire_rate_wait + 2
			--c.screenshake = c.screenshake + 0.1
			c.spread_degrees = c.spread_degrees - 2.0
			c.damage_critical_chance = c.damage_critical_chance + 3
			--c.knockback_force = c.knockback_force + 2
		end,
	},
	{
		id          = "SLOW_BULLET",
		name 		= "$action_slow_bullet",
		description = "$actiondesc_slow_bullet",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/slow_bullet.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slow_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_slow.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- SLOW_BULLET
		spawn_probability                 = "1,1,1,1", -- SLOW_BULLET
		price = 160,
		mana = 12,
		-- max_uses = DE_USAGE * 12,
		custom_xml_file = "data/entities/misc/custom_cards/bullet_slow.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bullet_slow.xml")
			-- c.fire_rate_wait = c.fire_rate_wait + 5
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 6.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 15.0
		end,
	},
	{
		id          = "SLOW_BULLET_TRIGGER",
		name 		= "$action_slow_bullet_trigger",
		description = "$actiondesc_slow_bullet_trigger",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/slow_bullet_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slow_bullet_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_slow.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- SLOW_BULLET_TRIGGER
		spawn_probability                 = "0.5,0.5,0.5,0.5,1", -- SLOW_BULLET_TRIGGER
		price = 200,
		mana = 15,
		-- max_uses = DE_USAGE * 12,
		custom_xml_file = "data/entities/misc/custom_cards/bullet_slow.xml",
		action 		= function()
			-- c.fire_rate_wait = c.fire_rate_wait + 5
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 6.0
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bullet_slow.xml", 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 15.0
		end,
	},
	{
		id          = "SLOW_BULLET_TIMER",
		name 		= "$action_slow_bullet_timer",
		description = "$actiondesc_slow_bullet_timer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/slow_bullet_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slow_bullet_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_slow.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,6", -- SLOW_BULLET_TIMER
		spawn_probability                 = "0.5,0.5,0.5,0.5,1,1", -- SLOW_BULLET_TIMER
		price = 200,
		mana = 15,
		-- max_uses = DE_USAGE * 12,
		custom_xml_file = "data/entities/misc/custom_cards/bullet_slow.xml",
		action 		= function()
			-- c.fire_rate_wait = c.fire_rate_wait + 5
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 6.0
			add_projectile_trigger_timer("data/entities/projectiles/deck/bullet_slow.xml", 100, 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 15.0
		end,
	},
	{
		id          = "HOOK",
		name 		= "$action_hook",
		description = "$actiondesc_hook",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/hook.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_hook.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- BULLET
		spawn_probability                 = "0.2,0.3,0.4,0.1,0.2", -- BULLET
		price = 120,
		mana = 2,
		-- max_uses = DE_USAGE * 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_hook.xml")
			c.fire_rate_wait = c.fire_rate_wait + 6
			c.damage_critical_chance = c.damage_critical_chance + 4
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 4.0
		end,
	},
	{
		id          = "BLACK_HOLE",
		name 		= "$action_black_hole",
		description = "$actiondesc_black_hole",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/black_hole.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/black_hole_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/black_hole.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,10", -- BLACK_HOLE
		spawn_probability                 = "0.25,0.2,0.2,0.3,0.3,0.45,0.15,0.05", -- BLACK_HOLE
		price = 200,
		mana = 400,
		max_uses    = 4, 
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/black_hole.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/black_hole.xml")
			c.fire_rate_wait = c.fire_rate_wait + 60
			c.screenshake = c.screenshake + 20
		end,
	},
	{
		id          = "BLACK_HOLE_DEATH_TRIGGER",
		name 		= "$action_black_hole_death_trigger",
		description = "$actiondesc_black_hole_death_trigger",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/black_hole_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/black_hole_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/black_hole.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,10", -- BLACK_HOLE
		spawn_probability                 = "0.2,0.2,0.3,0.4,0.05", -- BLACK_HOLE
		price = 220,
		mana = 404,
		max_uses    = 4, 
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/black_hole.xml",
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/black_hole.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 60
			c.screenshake = c.screenshake + 20
		end,
	},
	{
		id          = "WHITE_HOLE",
		name 		= "$action_white_hole",
		description = "$actiondesc_white_hole",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/white_hole.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/black_hole_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/white_hole.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4,6,7,10", -- BLACK_HOLE
		spawn_probability                 = "0.05,0.1,0.2,0.3,0.5,0.1", -- BLACK_HOLE
		price = 200,
		mana = 400,
		max_uses    = 4, 
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/white_hole.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/white_hole.xml")
			c.fire_rate_wait = c.fire_rate_wait + 60
			c.screenshake = c.screenshake + 20
		end,
	},
	{
		id          = "BLACK_HOLE_BIG",
		name 		= "$action_black_hole_big",
		description = "$actiondesc_black_hole_big",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/black_hole_big.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/black_hole_big_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/black_hole_big.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,3,5,6,10", -- BLACK_HOLE_BIG
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.5", -- BLACK_HOLE_BIG
		price = 320,
		mana = 450,
		max_uses    = 6, 
		custom_xml_file = "data/entities/misc/custom_cards/black_hole_big.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/black_hole_big.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
			c.screenshake = c.screenshake + 10
		end,
	},
	{
		id          = "WHITE_HOLE_BIG",
		name 		= "$action_white_hole_big",
		description = "$actiondesc_white_hole_big",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/white_hole_big.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/black_hole_big_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/white_hole_big.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,3,5,6,10", -- BLACK_HOLE_BIG
		spawn_probability                 = "0.05,0.05,0.1,0.4,0.5", -- BLACK_HOLE_BIG
		price = 320,
		mana = 450,
		max_uses    = 6, 
		custom_xml_file = "data/entities/misc/custom_cards/white_hole_big.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/white_hole_big.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
			c.screenshake = c.screenshake + 10
		end,
	},
	{
		id          = "BLACK_HOLE_GIGA",
		name 		= "$action_black_hole_giga",
		description = "$actiondesc_black_hole_giga",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/black_hole_giga.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/black_hole_big_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/black_hole_giga.xml"},
		-- spawn_requires_flag = "card_unlocked_black_hole",
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "7,10", -- BLACK_HOLE_BIG
		spawn_probability                 = "0.6,0.4", -- BLACK_HOLE_BIG
		price = 600,
		mana = 500,
		max_uses    = 6,
		never_unlimited = true,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/black_hole_giga.xml",
		action 		= function()
			local players = EntityGetWithTag( "player_unit" )
			if ( players[1] ~= nil ) then
				local pid = players[1]
				local x,y = EntityGetTransform( pid )
				local black_holes = EntityGetInRadiusWithTag( x, y, 512, "black_hole_giga" )
				
				if ( #black_holes < 4 ) then
					add_projectile("data/entities/projectiles/deck/black_hole_giga.xml")
					c.fire_rate_wait = c.fire_rate_wait + 100
					current_reload_time = current_reload_time + 100
					c.screenshake = c.screenshake + 40
				else
					mana = mana + 450
					c.damage_curse_add = c.damage_curse_add + 0.72
				end
			end
		end,
	},
	{
		id          = "WHITE_HOLE_GIGA",
		name 		= "$action_white_hole_giga",
		description = "$actiondesc_white_hole_giga",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/white_hole_giga.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/black_hole_big_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/white_hole_giga.xml"},
		-- spawn_requires_flag = "card_unlocked_black_hole",
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "7,10", -- BLACK_HOLE_BIG
		spawn_probability                 = "0.6,0.4", -- BLACK_HOLE_BIG
		price = 600,
		mana = 500,
		max_uses    = 6,
		never_unlimited = true,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/white_hole_giga.xml",
		action 		= function()
			local players = EntityGetWithTag( "player_unit" )
			if ( players[1] ~= nil ) then
				local pid = players[1]
				local x,y = EntityGetTransform( pid )
				local black_holes = EntityGetInRadiusWithTag( x, y, 512, "black_hole_giga" )
			
				if ( #black_holes < 4 ) then
					add_projectile("data/entities/projectiles/deck/white_hole_giga.xml")
					c.fire_rate_wait = c.fire_rate_wait + 100
					current_reload_time = current_reload_time + 100
					c.screenshake = c.screenshake + 40
				else
					mana = mana + 450
					c.damage_curse_add = c.damage_curse_add + 0.72
				end
			end
		end,
	},
	{
		id          = "TENTACLE_PORTAL",
		name 		= "$action_tentacle_portal",
		description = "$actiondesc_tentacle_portal",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/tentacle_portal.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tentacle_portal.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,3,4,10", -- TENTACLE_PORTAL
		spawn_probability                 = "0.3,0.3,0.3,0.3,0.025", -- TENTACLE_PORTAL
		price = 220,
		mana = 67,
		max_uses = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/tentacle_portal.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end,
	},
	{
		id          = "SPITTER",
		name 		= "$action_spitter",
		description = "$actiondesc_spitter",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/spitter.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spitter_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3", -- SPITTER
		spawn_probability                 = "0.75,1,1,0.5", -- SPITTER
		price = 110,
		mana = 3,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/spitter.xml")
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 1
			c.screenshake = c.screenshake + 0.1
			c.child_speed_multiplier = c.child_speed_multiplier * 1.05
			c.speed_multiplier = c.speed_multiplier * 1.05
			c.dampening = 0.1
			c.spread_degrees = c.spread_degrees + 3.0
		end,
	},
	{
		id          = "SPITTER_TIMER",
		name 		= "$action_spitter_timer",
		description = "$actiondesc_spitter_timer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/spitter_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spitter_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3", -- SPITTER_TIMER
		spawn_probability                 = "0.5,0.5,0.5,1", -- SPITTER_TIMER
		price = 140,
		mana = 8,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 1
			c.screenshake = c.screenshake + 0.1
			c.child_speed_multiplier = c.child_speed_multiplier * 1.05
			c.speed_multiplier = c.speed_multiplier * 1.05
			c.dampening = 0.1
			c.spread_degrees = c.spread_degrees + 3.0
			add_projectile_trigger_timer("data/entities/projectiles/deck/spitter.xml", 40, 1)
		end,
	},
	{
		id          = "SPITTER_TIER_2",
		name 		= "$action_spitter_tier_2",
		description = "$actiondesc_spitter_tier_2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/spitter_green.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spitter_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter_tier_2.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5", -- SPITTER_TIER_2
		spawn_probability                 = "1,1,1,0.5", -- SPITTER_TIER_2
		price = 190,
		mana = 6,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/spitter_tier_2.xml")
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 2
			c.screenshake = c.screenshake + 0.4
			c.child_speed_multiplier = c.child_speed_multiplier * 1.1
			c.speed_multiplier = c.speed_multiplier * 1.1
			c.dampening = 0.2
			c.spread_degrees = c.spread_degrees + 4
		end,
	},
	{
		id          = "SPITTER_TIER_2_TIMER",
		name 		= "$action_spitter_tier_2_timer",
		description = "$actiondesc_spitter_tier_2_timer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/spitter_green_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spitter_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter_tier_2.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5", -- SPITTER_TIER_2_TIMER
		spawn_probability                 = "0.5,0.5,0.5,1", -- SPITTER_TIER_2_TIMER
		price = 220,
		mana = 10,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/spitter_tier_2.xml", 40, 1)
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 2
			c.screenshake = c.screenshake + 0.4
			c.child_speed_multiplier = c.child_speed_multiplier * 1.1
			c.speed_multiplier = c.speed_multiplier * 1.1
			c.dampening = 0.2
			c.spread_degrees = c.spread_degrees + 4
		end,
	},
	{
		id          = "SPITTER_TIER_3",
		name 		= "$action_spitter_tier_3",
		description = "$actiondesc_spitter_tier_3",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/spitter_purple.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spitter_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter_tier_3.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6", -- SPITTER_TIER_3
		spawn_probability                 = "0.8,0.8,1,1", -- SPITTER_TIER_3
		price = 240,
		mana = 9,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/spitter_tier_3.xml")
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 4
			c.screenshake = c.screenshake + 0.9
			c.child_speed_multiplier = c.child_speed_multiplier * 1.15
			c.speed_multiplier = c.speed_multiplier * 1.15
			c.dampening = 0.3
			c.spread_degrees = c.spread_degrees + 5
		end,
	},
	{
		id          = "SPITTER_TIER_3_TIMER",
		name 		= "$action_spitter_tier_3_timer",
		description = "$actiondesc_spitter_tier_3_timer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/spitter_purple_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spitter_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter_tier_3.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6", -- SPITTER_TIER_3_TIMER
		spawn_probability                 = "0.5,0.65,0.5", -- SPITTER_TIER_3_TIMER
		price = 260,
		mana = 12,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/spitter_tier_3.xml", 40, 1)
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 4
			c.screenshake = c.screenshake + 0.9
			c.child_speed_multiplier = c.child_speed_multiplier * 1.15
			c.speed_multiplier = c.speed_multiplier * 1.15
			c.dampening = 0.3
			c.spread_degrees = c.spread_degrees + 5
		end,
	},
	{
		id          = "BUBBLESHOT",
		name 		= "$action_bubbleshot",
		description = "$actiondesc_bubbleshot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bubbleshot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bubbleshot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bubbleshot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3", -- BUBBLESHOT
		spawn_probability                 = "0.8,0.6,1,0.5", -- BUBBLESHOT
		price = 100,
		mana = 3,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bubbleshot.xml")
			c.bounces = c.bounces + 1
			c.fire_rate_wait = c.fire_rate_wait - 5
			c.spread_degrees = c.spread_degrees - 2.0
			c.lifetime_add = c.lifetime_add + 3
			c.dampening = 0.1
		end,
	},
	{
		id          = "BUBBLESHOT_TRIGGER",
		name 		= "$action_bubbleshot_trigger",
		description = "$actiondesc_bubbleshot_trigger",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bubbleshot_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bubbleshot_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bubbleshot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3", -- BUBBLESHOT_TRIGGER
		spawn_probability                 = "0.5,0.5,1", -- BUBBLESHOT_TRIGGER
		price = 120,
		mana = 6,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait - 5
			c.bounces = c.bounces + 1
			c.spread_degrees = c.spread_degrees - 2.0
			c.lifetime_add = c.lifetime_add + 3
			c.dampening = 0.1
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bubbleshot.xml", 1)
		end,
	},
	{
		id          = "DISC_BULLET",
		name 		= "$action_disc_bullet",
		description = "$actiondesc_disc_bullet",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/disc_bullet.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/disc_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4", -- DISC_BULLET
		spawn_probability                 = "0.8,0.7,0.6", -- DISC_BULLET
		price = 10,
		mana = 7,
		max_uses = DE_USAGE * 2,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/disc_bullet.xml")
			c.bounces = c.bounces + 1
			c.fire_rate_wait = c.fire_rate_wait - 2.0
			c.spread_degrees = c.spread_degrees - 2.0
			shot_effects.recoil_knockback = 10.0
		end,
	},
	{
		id          = "DISC_BULLET_BIG",
		name 		= "$action_disc_bullet_big",
		description = "$actiondesc_disc_bullet_big",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/disc_bullet_big.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/disc_bullet_big.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4", -- DISC_BULLET_BIG
		spawn_probability                 = "0.6,0.7,0.8", -- DISC_BULLET_BIG
		price = 180,
		mana = 35,
		max_uses = DE_USAGE * 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/disc_bullet_big.xml")
			-- damage = 0.3
			c.bounces = c.bounces + 1
			c.fire_rate_wait = c.fire_rate_wait + 4.0
			c.spread_degrees = c.spread_degrees + 3.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 15.0
		end,
	},
	{
		id          = "DISC_BULLET_BIGGER",
		name 		= "$action_omega_disc_bullet",
		description = "$actiondesc_omega_disc_bullet",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/omega_disc_bullet.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_everything",
		related_projectiles	= {"data/entities/projectiles/deck/disc_bullet_bigger.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,5,10", -- DISC_BULLET_BIG
		spawn_probability                 = "0.1,0.4,0.7,0.05", -- DISC_BULLET_BIG
		price = 270,
		mana = 84,
		max_uses = DE_USAGE * 1,
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/disc_bullet_bigger.xml")
			-- damage = 0.3
			c.bounces = c.bounces + 1
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.spread_degrees = c.spread_degrees + 6.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 25.0
			c.damage_projectile_add = c.damage_projectile_add + 0.24
			c.damage_slice_add = c.damage_slice_add + 0.24
			c.damage_healing_add = c.damage_healing_add - 0.24
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_DISC_BULLET_BIGGER_TRIGGER",
		name 		= "$DISC_BULLET_BIGGER_TRIGGER",
		description = "$dDISC_BULLET_BIGGER_TRIGGER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/omega_disc_bullet_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_everything",
		related_projectiles	= {"data/entities/projectiles/deck/disc_bullet_bigger.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "5,6,10", -- DISC_BULLET_BIG
		spawn_probability                 = "0.2,0.2,0.05", -- DISC_BULLET_BIG
		price = 290,
		mana = 85,
		max_uses = 15,
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/disc_bullet_bigger.xml",1)
			-- damage = 0.3
			c.bounces = c.bounces + 1
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.spread_degrees = c.spread_degrees + 6.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 25.0
			c.damage_projectile_add = c.damage_projectile_add + 0.24
			c.damage_slice_add = c.damage_slice_add + 0.24
			c.damage_healing_add = c.damage_healing_add - 0.24
		end,
	},
	{
		id          = "BOUNCY_ORB",
		name 		= "$action_bouncy_orb",
		description = "$actiondesc_bouncy_orb",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bouncy_orb.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_bouncy_orb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4", -- BOUNCY_ORB
		spawn_probability                 = "0.5,0.75,1", -- BOUNCY_ORB
		price = 120,
		mana = 10,
		-- max_uses = DE_USAGE * 8,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_bouncy_orb.xml")
			c.bounces = c.bounces + 1
			c.lifetime_add  = c.lifetime_add + 3
			c.child_speed_multiplier = c.child_speed_multiplier * 1.125
			c.speed_multiplier = c.speed_multiplier * 1.075
			c.fire_rate_wait = c.fire_rate_wait + 10
			shot_effects.recoil_knockback = 20.0
		end,
	},
	{
		id          = "BOUNCY_ORB_TIMER",
		name 		= "$action_bouncy_orb_timer",
		description = "$actiondesc_bouncy_orb_timer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bouncy_orb_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bouncy_orb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4", -- BOUNCY_ORB_TIMER
		spawn_probability                 = "0.5,0.5,0.5", -- BOUNCY_ORB_TIMER
		price = 150,
		mana = 15,
		-- max_uses = DE_USAGE * 8,
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/bouncy_orb.xml",200,1)
			c.bounces = c.bounces + 1
			c.child_speed_multiplier = c.child_speed_multiplier * 1.125
			c.speed_multiplier = c.speed_multiplier * 1.075
			c.fire_rate_wait = c.fire_rate_wait + 10
			shot_effects.recoil_knockback = 20.0
		end,
	},
	{
		id          = "RUBBER_BALL",
		name 		= "$action_rubber_ball",
		description = "$actiondesc_rubber_ball",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/rubber_ball.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rubber_ball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_rubber_ball.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,5,6", -- RUBBER_BALL
		spawn_probability                 = "0.5,0.5,0.5,0.1,0.1", -- RUBBER_BALL
		price = 5,
		mana = 0,
		-- max_uses = 250,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_rubber_ball.xml")
			c.bounces = c.bounces + 1
			c.fire_rate_wait = c.fire_rate_wait - 3
			c.spread_degrees = c.spread_degrees + 8.0
		end,
	},
	{
		id          = "ARROW",
		name 		= "$action_arrow",
		description = "$actiondesc_arrow",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/arrow.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/arrow_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/arrow.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4,5", -- ARROW
		spawn_probability                 = "0.7,0.5,0.5,0.3", -- ARROW
		price = 20,
		mana = 3,
		max_uses = DE_USAGE * 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/arrow.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 0
			c.spread_degrees = c.spread_degrees - 90
			shot_effects.recoil_knockback = 20.0
		end,
	},
	{
		id          = "POLLEN",
		name 		= "$action_pollen",
		description = "$actiondesc_pollen",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/pollen.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/arrow_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/pollen.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,3,4", -- ARROW
		spawn_probability                 = "0.4,0.4,0.5,0.5", -- ARROW
		price = 50,
		mana = 0,
		max_uses = DE_USAGE * 6,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pollen.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait - 2
			c.spread_degrees = c.spread_degrees + 30
		end,
	},
	{
		id          = "LANCE",
		name 		= "$action_lance",
		description = "$actiondesc_lance",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/lance.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/lance_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/lance.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,5,6", -- LANCE
		spawn_probability                 = "0.7,0.7,0.7,0.7", -- LANCE
		price = 180,
		mana = 12,
		max_uses = DE_USAGE * 6,
		custom_xml_file = "data/entities/misc/custom_cards/lance.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/lance.xml")
			-- damage = 0.3
			c.speed_multiplier = c.speed_multiplier * 1.2
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.spread_degrees = c.spread_degrees - 20
			shot_effects.recoil_knockback = 40.0
		end,
	},
	{
		id          = "LANCE_HOLY",
		name 		= "$action_holy",
		description = "$actiondesc_holy",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/lance_holy.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/lance_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_lance_holy.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,5,6,7,10", -- LANCE
		spawn_probability                 = "0.4,0.8,0.8,0.4,0.08", -- LANCE
		price = 250,
		mana = 45,
		max_uses = DE_USAGE * 6,
		custom_xml_file = "data/entities/misc/custom_cards/lance_holy.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_lance_holy.xml")
			-- damage = 0.3
			c.speed_multiplier = c.speed_multiplier * 1.5
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.spread_degrees = c.spread_degrees - 10
			shot_effects.recoil_knockback = 60.0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_ICEY_LANCE",
		name 		= "$ICEY_LANCE",
		description = "$dICEY_LANCE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/icey_lance.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/death_cross_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/icey_lance.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6,10", -- DEATH_CROSS_BIG
		spawn_probability                 = "0.5,0.6,0.7,0.6,0.5,0.05", -- DEATH_CROSS_BIG
		price = 310,
		mana = 21,
		max_uses = 48,
		-- custom_xml_file = "data/entities/misc/custom_cards/death_cross.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/icey_lance.xml")
			c.material = "ice_static"
			c.damage_ice_add = c.damage_ice_add + 0.11
			c.speed_multiplier = c.speed_multiplier * 1.5
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.spread_degrees = c.spread_degrees - 30
		end,
	},
	{
		id          = "ROCKET",
		name 		= "$action_rocket",
		description = "$actiondesc_rocket",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/rocket.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/rocket.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- ROCKET
		spawn_probability                 = "0.5,0.4,0.3,0.2,0.1", -- ROCKET
		price = 220,
		mana = 50,
		max_uses    = 24, 
		custom_xml_file = "data/entities/misc/custom_cards/rocket.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rocket.xml")
			c.fire_rate_wait = c.fire_rate_wait + 48
			--current_reload_time = current_reload_time + 40
			c.ragdoll_fx = 2
			shot_effects.recoil_knockback = 100.0
		end,
	},
	{
		id          = "ROCKET_TIER_2",
		name 		= "$action_rocket_tier_2",
		description = "$actiondesc_rocket_tier_2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/rocket_tier_2.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/rocket_tier_2.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- ROCKET_TIER_2
		spawn_probability                 = "0.3,0.5,0.3,0.2,0.1", -- ROCKET_TIER_2
		price = 240,
		mana = 70,
		max_uses    = 20, 
		custom_xml_file = "data/entities/misc/custom_cards/rocket_tier_2.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rocket_tier_2.xml")
			c.fire_rate_wait = c.fire_rate_wait + 60
			--current_reload_time = current_reload_time + 40
			c.ragdoll_fx = 2
			shot_effects.recoil_knockback = 115.0
		end,
	},
	{
		id          = "ROCKET_TIER_3",
		name 		= "$action_rocket_tier_3",
		description = "$actiondesc_rocket_tier_3",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/rocket_tier_3.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/rocket_tier_3.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- ROCKET_TIER_3
		spawn_probability                 = "0.1,0.3,0.5,0.5,0.3", -- ROCKET_TIER_3
		price = 250,
		mana = 90,
		max_uses    = 16, 
		custom_xml_file = "data/entities/misc/custom_cards/rocket_tier_3.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rocket_tier_3.xml")
			c.fire_rate_wait = c.fire_rate_wait + 72
			--current_reload_time = current_reload_time + 40
			c.ragdoll_fx = 2
			shot_effects.recoil_knockback = 130.0
		end,
	},
	{
		id          = "GRENADE",
		name 		= "$action_grenade",
		description = "$actiondesc_grenade",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/grenade.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/grenade_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4", -- GRENADE
		spawn_probability                 = "0.4,0.4,0.3,0.2,0.1", -- GRENADE
		price = 170,
		mana = 25,
		max_uses    = 50, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade.xml")
			c.fire_rate_wait = c.fire_rate_wait + 27
			c.screenshake = c.screenshake + 4.0
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.15, 0 )
			--current_reload_time = current_reload_time + 40
			shot_effects.recoil_knockback = 40.0
		end,
	},
	{
		id          = "GRENADE_TRIGGER",
		name 		= "$action_grenade_trigger",
		description = "$actiondesc_grenade_trigger",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/grenade_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/grenade_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3,4,5", -- GRENADE_TRIGGER
		spawn_probability                   = "0.2,0.1,0.2,0.1,0.2,0.1", -- GRENADE_TRIGGER
		price = 210,
		max_uses    = 50, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade_trigger.xml",
		mana = 35,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 39
			c.screenshake = c.screenshake + 6.0
			--current_reload_time = current_reload_time + 60
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.15, 0 )
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/grenade.xml", 1)
			shot_effects.recoil_knockback = 60.0
		end,
	},
	{
		id          = "GRENADE_TIER_2",
		name 		= "$action_grenade_tier_2",
		description = "$actiondesc_grenade_tier_2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/grenade_tier_2.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/grenade_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade_tier_2.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- GRENADE_TIER_2
		spawn_probability                 = "0.1,0.3,0.5,0.3,0.1", -- GRENADE_TIER_2
		price = 220,
		mana = 50,
		max_uses    = 35, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade_tier_2.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade_tier_2.xml")
			c.fire_rate_wait = c.fire_rate_wait + 51
			c.screenshake = c.screenshake + 8.0
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.15, 0 )
			--current_reload_time = current_reload_time + 40
			shot_effects.recoil_knockback = 80.0
		end,
	},
	{
		id          = "GRENADE_TIER_3",
		name 		= "$action_grenade_tier_3",
		description = "$actiondesc_grenade_tier_3",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/grenade_tier_3.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/grenade_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade_tier_3.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- GRENADE_TIER_3
		spawn_probability                 = "0.1,0.2,0.3,0.1,0.3", -- GRENADE_TIER_3
		price = 220,
		mana = 75,
		max_uses    = 25, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade_tier_3.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade_tier_3.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
			c.screenshake = c.screenshake + 15.0
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.15, 0 )
			--current_reload_time = current_reload_time + 40
			shot_effects.recoil_knockback = 140.0
		end,
	},
	{
		id          = "GRENADE_ANTI",
		name 		= "$action_grenade_anti",
		description = "$actiondesc_grenade_anti",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/grenade_anti.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/grenade_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade_anti.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4", -- GRENADE_ANTI
		spawn_probability                 = "0.3,0.2,0.1,0.1,0.1", -- GRENADE_ANTI
		price = 50,
		mana = 5,
		max_uses = DE_USAGE * 20, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade_anti.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.screenshake = c.screenshake + 4.0
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 7.5, 20 )
			--current_reload_time = current_reload_time + 40
			shot_effects.recoil_knockback = 80.0
		end,
	},
	{
		id          = "GRENADE_LARGE",
		name 		= "$action_grenade_large",
		description = "$actiondesc_grenade_large",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/grenade_large.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/grenade_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade_large.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- GRENADE_LARGE
		spawn_probability                 = "0.1,0.2,0.2,0.1,0.1", -- GRENADE_LARGE
		price = 150,
		mana = 20,
		max_uses = 45, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade_large.xml")
			c.gravity = c.gravity + 100.0
			c.fire_rate_wait = c.fire_rate_wait + 40
			c.screenshake = c.screenshake + 5.0
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.05, 0 )
			c.speed_multiplier = math.max( c.speed_multiplier * 0.25, 0 )
			--current_reload_time = current_reload_time + 40
			shot_effects.recoil_knockback = 80.0
		end,
	},
	{
		id 			= "MINE",
		name 		= "$action_mine",
		description = "$actiondesc_mine",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mine.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/mine_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mine.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level	           = "1,3,4,6", -- MINE
		spawn_probability	   = "0.3,0.4,0.3,0.2", -- MINE
		price = 200,
		mana = 20,
		max_uses	= 25, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/mine.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.25, 0 )
			c.speed_multiplier = math.max( c.speed_multiplier * 0.75, 0 )
			shot_effects.recoil_knockback = 60.0
		end,
	},
	{
		id 			= "MINE_DEATH_TRIGGER",
		name 		= "$dMINE_DEATH_TRIGGER",
		description = "$ddMINE_DEATH_TRIGGER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mine_death_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/mine_death_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mine.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level	           = "2,6", -- MINE_DEATH_TRIGGER
		spawn_probability	   = "0.3,0.1", -- MINE_DEATH_TRIGGER
		price = 240,
		mana = 20,
		max_uses	= 25, 
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/mine.xml", 2)
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.25, 0 )
			c.speed_multiplier = math.max( c.speed_multiplier * 0.75, 0 )
			shot_effects.recoil_knockback = 60.0
		end,
	},
	{
		id 			= "PIPE_BOMB",
		name 		= "$action_pipe_bomb",
		description = "$actiondesc_pipe_bomb",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/pipe_bomb.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/pipe_bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/pipe_bomb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level	           = "2,3,4", -- PIPE_BOMB
		spawn_probability	   = "0.4,0.3,0.2", -- PIPE_BOMB
		price = 200,
		mana = 20,
		max_uses	= 25, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pipe_bomb.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.25, 0 )
			c.speed_multiplier = math.max( c.speed_multiplier * 0.75, 0 )
		end,
	},
	{
		id          = "PIPE_BOMB_DEATH_TRIGGER",
		name 		= "$dPIPE_BOMB_DEATH_TRIGGER",
		description = "$ddPIPE_BOMB_DEATH_TRIGGER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/pipe_bomb_death_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/pipe_bomb_death_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/pipe_bomb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5", -- PIPE_BOMB_DEATH_TRIGGER
		spawn_probability                 = "0.1,0.2,0.3,0.2", -- PIPE_BOMB_DEATH_TRIGGER
		price = 230,
		mana = 20,
		max_uses    = 25, 
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.25, 0 )
			c.speed_multiplier = c.speed_multiplier * 0.75
			add_projectile_trigger_death("data/entities/projectiles/deck/pipe_bomb.xml", 2)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 60.0
		end,
	},
	{
		id          = "FISH",
		name 		= "$action_fish",
		description = "$actiondesc_fish",
		-- spawn_requires_flag = "card_unlocked_fish",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/fish.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/fish_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/fish.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6,7,10", -- FISH
		spawn_probability                 = "0.09,0.07,0.05,0.03,0.1,0.01", -- FISH
		price = 250,
		mana = 22,
		max_uses    = 33, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/fish.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
		end,
	},
	{
		id          = "EXPLODING_DEER",
		name 		= "$action_exploding_deer",
		description = "$actiondesc_exploding_deer",
		-- spawn_requires_flag = "card_unlocked_exploding_deer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/exploding_deer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/exploding_deer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/exploding_deer.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5", -- EXPLODING_DEER
		spawn_probability                 = "0.4,0.3,0.2", -- EXPLODING_DEER
		price = 170,
		mana = 33,
		max_uses    = 22, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/exploding_deer.xml")
			c.material = "blood_fading_slow"
			c.damage_critical_chance = c.damage_critical_chance + 12
			c.fire_rate_wait = c.fire_rate_wait + 80
		end,
	},
	{
		id          = "EXPLODING_DUCKS",
		name 		= "$action_exploding_ducks",
		description = "$actiondesc_exploding_ducks",
		-- spawn_requires_flag = "card_unlocked_exploding_deer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/duck_2.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/exploding_deer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/duck.xml", 3},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6,7,10", -- EXPLODING_DEER
		spawn_probability                 = "0.4,0.5,0.6,0.1,0.4,0.05", -- EXPLODING_DEER
		price = 200,
		mana = 90,
		max_uses    = 32, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/duck.xml")
			add_projectile("data/entities/projectiles/deck/duck.xml")
			add_projectile("data/entities/projectiles/deck/duck.xml")
			c.damage_projectile_add = c.damage_projectile_add - 0.24
			c.fire_rate_wait = c.fire_rate_wait + 40
			current_reload_time = current_reload_time + 40
		end,
	},
	{
		id          = "WORM_SHOT",
		name 		= "$action_worm_shot",
		description = "$actiondesc_worm_shot",
		-- spawn_requires_flag = "card_unlocked_exploding_deer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/worm.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/exploding_deer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/worm_shot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6,10", -- EXPLODING_DEER
		spawn_probability                 = "0.5,0.6,0.1,0.2,0.1", -- EXPLODING_DEER
		price = 500,
		mana = 250,
		max_uses    = 6,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/worm_shot.xml")
			c.material = "blood_worm"
			c.damage_melee_add = c.damage_melee_add + 0.32
			c.fire_rate_wait = c.fire_rate_wait + 180
			current_reload_time = current_reload_time + 90
			c.spread_degrees = c.spread_degrees + 45
		end,
	},
	{
		id          = "BOMB_DETONATOR",
		name 		= "$action_bomb_detonator",
		description = "$actiondesc_bomb_detonator",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/pipe_bomb_detonator.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/meteor_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bomb_detonator.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- PIPE_BOMB_DETONATOR
		spawn_probability                 = "0.5,1,0.4,0.5,1", -- PIPE_BOMB_DETONATOR
		price = 120,
		mana = 257,
		max_uses = 25,
		ai_never_uses = true,
		action 		= function()
			c.material = "plasma_fading_pink"
			add_projectile("data/entities/projectiles/deck/bomb_detonator.xml")
		end,
	},
	{
		id          = "LASER",
		name 		= "$action_laser",
		description = "$actiondesc_laser",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/laser.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/laser_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/laser.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4", -- LASER
		spawn_probability                 = "1,1,1", -- LASER
		price = 180,
		mana = 20,
		-- max_uses = DE_USAGE * 9,
		custom_xml_file = "data/entities/misc/custom_cards/laser.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/laser.xml")
			c.spread_degrees = c.spread_degrees - 30.0
			c.fire_rate_wait = c.fire_rate_wait - 22
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "MEGALASER",
		name 		= "$action_megalaser",
		description = "$actiondesc_megalaser",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/megalaser.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/megalaser_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/megalaser_beam.xml",6},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,5,6,10", -- MEGALASER
		spawn_probability                 = "0.2,0.4,0.2,0.05", -- MEGALASER
		price = 300,
		mana = 45,
		max_uses = DE_USAGE * 3,
		action 		= function()
			-- beams are added in advance so that they inherit modifiers
			add_projectile("data/entities/projectiles/deck/megalaser_beam.xml")
			add_projectile("data/entities/projectiles/deck/megalaser_beam.xml")
			add_projectile("data/entities/projectiles/deck/megalaser_beam.xml")
			add_projectile("data/entities/projectiles/deck/megalaser.xml")
			add_projectile("data/entities/projectiles/deck/megalaser_beam.xml")
			add_projectile("data/entities/projectiles/deck/megalaser_beam.xml")
			add_projectile("data/entities/projectiles/deck/megalaser_beam.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			c.material = "plasma_fading_green"
			c.spread_degrees = 0
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
		end,
	},
	{
		id          = "LIGHTNING",
		name 		= "$action_lightning",
		description = "$actiondesc_lightning",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/lightning.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/lightning_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/lightning_purple.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,5,6", -- LIGHTNING
		spawn_probability                 = "1,0.7,0.5,0.6", -- LIGHTNING
		price = 250,
		mana = 35,
		max_uses = 45,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
			local lightning_types = { "_blue", "_red", "_purple" }
			
			add_projectile("data/entities/projectiles/deck/lightning" .. lightning_types[Random(1,#lightning_types)] .. ".xml")
			
			c.damage_critical_chance = c.damage_critical_chance + 11
			c.fire_rate_wait = c.fire_rate_wait - 20
			shot_effects.recoil_knockback = 60.0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_LIGHTNING_DEATH_TRIGGER_2",
		name 		= "$LIGHTNING_DEATH_TRIGGER_2",
		description = "$dLIGHTNING_DEATH_TRIGGER_2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/lightning_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/lightning_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/lightning_purple.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,5,6", -- LIGHTNING
		spawn_probability                 = "0.2,0.3,0.4", -- LIGHTNING
		price = 290,
		mana = 45,
		max_uses = 45,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
			local lightning_types = { "_blue", "_red", "_purple" }

			add_projectile_trigger_death("data/entities/projectiles/deck/lightning" .. lightning_types[Random(1,#lightning_types)] .. ".xml",2)
			c.damage_critical_chance = c.damage_critical_chance + 11
			c.fire_rate_wait = c.fire_rate_wait - 20
			shot_effects.recoil_knockback = 60.0
		end,
	},
	{
		id          = "BALL_LIGHTNING",
		name 		= "$action_ball_lightning",
		description = "$actiondesc_ball_lightning",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ball_lightning.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/lightning_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/ball_lightning.xml",3},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4,5", -- LIGHTNING
		spawn_probability                 = "0.3,0.4,0.6,0.7", -- LIGHTNING
		price = 250,
		mana = 33,
		max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ball_lightning.xml")
			add_projectile("data/entities/projectiles/deck/ball_lightning.xml")
			add_projectile("data/entities/projectiles/deck/ball_lightning.xml")
			c.damage_projectile_add = c.damage_projectile_add - 0.12
			c.fire_rate_wait = c.fire_rate_wait - 20
			shot_effects.recoil_knockback = 30.0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_BALL_LIGHTNING_TIMER",
		name 		= "$BALL_LIGHTNING_TIMER",
		description = "$dBALL_LIGHTNING_TIMER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ball_lightning_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/lightning_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/ball_lightning.xml",3},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6,7,10", -- LIGHTNING
		spawn_probability                 = "0.2,0.2,0.3,0.3,0.4,0.1", -- LIGHTNING
		price = 650,
		mana = 111,
		max_uses = 15,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/ball_lightning.xml",10,1)
			add_projectile_trigger_timer("data/entities/projectiles/deck/ball_lightning.xml",15,1)
			add_projectile_trigger_timer("data/entities/projectiles/deck/ball_lightning.xml",10,1)
			c.damage_projectile_add = c.damage_projectile_add - 0.12
			c.fire_rate_wait = c.fire_rate_wait - 20
			shot_effects.recoil_knockback = 30.0
		end,
	},
	{
		id          = "LASER_EMITTER",
		name 		= "$action_laser_emitter",
		description = "$actiondesc_laser_emitter",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/laser_emitter.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/laser_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/orb_laseremitter.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- LASER
		spawn_probability                 = "0.2,0.8,1,0.5", -- LASER
		price = 180,
		mana = 90,
		max_uses = DE_USAGE * 4,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/orb_laseremitter.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
			c.fire_rate_wait = c.fire_rate_wait + 6
			current_reload_time = current_reload_time + 6
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
		end,
	},
	{
		id          = "LASER_EMITTER_FOUR",
		name 		= "$action_laser_emitter_four",
		description = "$actiondesc_laser_emitter_four",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/laser_emitter_four.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/laser_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/orb_laseremitter.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- LASER
		spawn_probability                 = "0.2,0.9,0.3,0.5,1", -- LASER
		price = 200,
		mana = 110,
		max_uses = DE_USAGE * 4,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/orb_laseremitter_four.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
			c.fire_rate_wait = c.fire_rate_wait + 12
			current_reload_time = current_reload_time + 12
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
		end,
	},
	{
		id          = "LASER_EMITTER_CUTTER",
		name 		= "$action_laser_emitter_cutter",
		description = "$actiondesc_laser_emitter_cutter",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/laser_emitter_cutter.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/laser_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/orb_laseremitter_cutter.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6", -- LASER
		spawn_probability                 = "0.3,0.5,0.7,0.6,0.4,0.2,0.1", -- LASER
		price = 120,
		mana = 90,
		max_uses = DE_USAGE * 4,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/orb_laseremitter_cutter.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			c.fire_rate_wait = c.fire_rate_wait + 9
			current_reload_time = current_reload_time + 9
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
		end,
	},
	{
		id          = "DIGGER",
		name 		= "$action_digger",
		description = "$actiondesc_digger",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/digger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/digger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/digger.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,6", -- DIGGER
		spawn_probability                 = "0.5,0.4,0.3,0.5", -- DIGGER
		price = 70,
		mana = 0,
		-- max_uses = DE_USAGE * 40,
		sound_loop_tag = "sound_digger",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/digger.xml")
			c.fire_rate_wait = c.fire_rate_wait + 1
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 5.0
		end,
	},
	{
		id          = "POWERDIGGER",
		name 		= "$action_powerdigger",
		description = "$actiondesc_powerdigger",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/powerdigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/powerdigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/powerdigger.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- POWERDIGGER
		spawn_probability                 = "0.4,0.5,0.6,0.3,0.5", -- POWERDIGGER
		price = 110,
		mana = 0,
		-- max_uses = DE_USAGE * 60,
		sound_loop_tag = "sound_digger",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/powerdigger.xml")
			-- c.fire_rate_wait = c.fire_rate_wait + 1
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 5.0
		end,
	},
	{
		id          = "CHAINSAW",
		name 		= "$action_chainsaw",
		description = "$actiondesc_chainsaw",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/chainsaw.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/chainsaw_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/chainsaw.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2", -- CHAINSAW
		spawn_probability                 = "0.9,0.7,0.5", -- CHAINSAW
		price = 80,
		mana = 8,
		-- max_uses = DE_USAGE * 30,
		sound_loop_tag = "sound_chainsaw",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/chainsaw.xml")
			c.damage_slice_add = c.damage_slice_add + 0.1
			c.fire_rate_wait = 0
			c.spread_degrees = c.spread_degrees + 6.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 2.0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end,
	},
	{
		id          = "LUMINOUS_DRILL",
		name 		= "$action_luminous_drill",
		description = "$actiondesc_luminous_drill",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/luminous_drill.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/chainsaw_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_luminous_drill.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,3,5,10", -- LUMINOUS_DRILL
		spawn_probability                 = "0.6,0.8,0.2,0.2,0.05", -- LUMINOUS_DRILL
		price = 150,
		mana = 4,
		-- max_uses = 1000,
		sound_loop_tag = "sound_digger",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_luminous_drill.xml")
			-- c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
			-- c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/light.xml," )
			c.damage_projectile_add = c.damage_projectile_add - 0.1
			c.damage_drill_add = c.damage_drill_add + 0.1
			c.fire_rate_wait = c.fire_rate_wait - 35
			c.spread_degrees = c.spread_degrees - 30.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end,
	},
	{
		id          = "LASER_LUMINOUS_DRILL",
		name 		= "$action_luminous_drill_timer",
		description = "$actiondesc_luminous_drill_timer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/luminous_drill_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/chainsaw_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_luminous_drill.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4,6,10", -- LASER_LUMINOUS_DRILL
		spawn_probability                 = "0.6,0.8,0.2,0.2,0.05", -- LASER_LUMINOUS_DRILL
		price = 220,
		mana = 6,
		-- max_uses = 1000,
		sound_loop_tag = "sound_digger",
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/de_luminous_drill.xml",4,1)
			-- c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
			-- c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/light.xml," )
			c.damage_projectile_add = c.damage_projectile_add - 0.1
			c.damage_drill_add = c.damage_drill_add + 0.1
			c.fire_rate_wait = c.fire_rate_wait - 35
			c.spread_degrees = c.spread_degrees - 30.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end,
	},
	{
		id          = "TENTACLE",
		name 		= "$action_tentacle",
		description = "$actiondesc_tentacle",
		-- spawn_requires_flag = "card_unlocked_tentacle",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/tentacle.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/tentacle_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tentacle.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6,7", -- TENTACLE
		spawn_probability                 = "0.4,0.5,0.5,0.6,0.7", -- TENTACLE
		price = 200,
		mana = 20,
		max_uses = DE_USAGE * 2,
		custom_xml_file = "data/entities/misc/custom_cards/tentacle.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/tentacle.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "TENTACLE_TIMER",
		name 		= "$action_tentacle_timer",
		description = "$actiondesc_tentacle_timer",
		-- spawn_requires_flag = "card_unlocked_tentacle",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/tentacle_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/tentacle_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tentacle.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6,7", -- TENTACLE
		spawn_probability                 = "0.3,0.4,0.4,0.5,0.5", -- TENTACLE
		price = 250,
		mana = 20,
		max_uses = DE_USAGE * 2,
		custom_xml_file = "data/entities/misc/custom_cards/tentacle_timer.xml",
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/tentacle.xml",20,1)
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	--[[
	{
		id          = "BLOODTENTACLE",
		name 		= "$action_bloodtentacle",
		description = "$actiondesc_bloodtentacle",
		-- spawn_requires_flag = "card_unlocked_pyramid",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bloodtentacle.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/tentacle_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bloodtentacle.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6", -- TENTACLE
		spawn_probability                 = "0.2,0.5,1,1", -- TENTACLE
		price = 170,
		mana = 30,
		--max_uses = 40,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bloodtentacle.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	]]--
	{
		id          = "HEAL_BULLET",
		name 		= "$action_heal_bullet",
		description = "$actiondesc_heal_bullet",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/heal_bullet.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/heal_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/heal_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,7", -- HEAL_BULLET
		spawn_probability                 = "1,1,0.6,0.8", -- HEAL_BULLET
		price = 60,
		mana = 50,
		max_uses = 15,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/heal_bullet.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/heal_bullet.xml")
			c.damage_healing_add = c.damage_healing_add - 0.03
			c.damage_projectile_add = c.damage_projectile_add - 0.12
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.spread_degrees = c.spread_degrees + 10
		end,
	},
	{
		id          = "ANTIHEAL",
		name 		= "$action_antiheal",
		description = "$actiondesc_antiheal",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/antiheal.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/healhurt.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5", -- BULLET
		spawn_probability                 = "0.4,0.3,0.3,0.3", -- BULLET
		price = 200,
		mana = 60,
		max_uses = 15,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/healhurt.xml")
			c.damage_healing_add = c.damage_healing_add - 0.30
			c.damage_projectile_add = c.damage_projectile_add + 0.15
			c.fire_rate_wait = c.fire_rate_wait + 8
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 3.0
			shot_effects.recoil_knockback = 12.0
		end,
	},
	{
		id          = "SPIRAL_SHOT",
		name 		= "$action_spiral_shot",
		description = "$actiondesc_spiral_shot",
		-- spawn_requires_flag = "card_unlocked_spiral_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/spiral_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spiral_shot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6", -- SPIRAL_SHOT
		spawn_probability                 = "0.7,0.8,0.7", -- SPIRAL_SHOT
		price = 190,
		mana = 48,
		max_uses    = 24, 
		custom_xml_file = "data/entities/misc/custom_cards/spiral_shot.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/spiral_shot.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "MAGIC_SHIELD",
		name 		= "$action_magic_shield",
		description = "$actiondesc_magic_shield",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/magic_shield.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/magic_shield_start.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,4,5", -- SPIRAL_SHOT
		spawn_probability                 = "0.03,0.04,0.05,0.06", -- SPIRAL_SHOT
		price = 100,
		mana = 10,
		max_uses = 35,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/magic_shield_start.xml")
			c.fire_rate_wait = c.fire_rate_wait + 12
		end,
	},
	{
		id          = "BIG_MAGIC_SHIELD",
		name 		= "$action_big_magic_shield",
		description = "$actiondesc_big_magic_shield",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/big_magic_shield.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/big_magic_shield_start.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "4,5,6,7", -- SPIRAL_SHOT
		spawn_probability                 = "0.02,0.03,0.04,0.1", -- SPIRAL_SHOT
		price = 120,
		mana = 15,
		max_uses = 35,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/big_magic_shield_start.xml")
			c.fire_rate_wait = c.fire_rate_wait + 18
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_GUIDE_MISSILE",
		name 		= "$GUIDE_MISSILE",
		description = "$dGUIDE_MISSILE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/guided_missile.png",
		related_projectiles	= {"data/entities/projectiles/deck/guided_missile_color.xml",6},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.45,0.6,0.75,0.45,0.01", -- SPIRAL_SHOT
		price = 216,
		mana = 36,
		max_uses = 72,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/guided_missile.xml")
			add_projectile("data/entities/projectiles/deck/guided_missile.xml")
			add_projectile("data/entities/projectiles/deck/guided_missile.xml")
			add_projectile("data/entities/projectiles/deck/guided_missile.xml")
			add_projectile("data/entities/projectiles/deck/guided_missile.xml")
			add_projectile("data/entities/projectiles/deck/guided_missile.xml")
			c.lifetime_add = math.floor( c.lifetime_add * 0.02 )
			c.spread_degrees =  c.spread_degrees + 12
			c.fire_rate_wait = c.fire_rate_wait + 7
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_THERMAL_IMPACT",
		name 		= "$THERMAL_IMPACT",
		description = "$dTHERMAL_IMPACT",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/thermal_impact.png",
		related_projectiles	= {"data/entities/projectiles/deck/thermal_impact.xml",5},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.45,0.6,0.75,0.45,0.01", -- SPIRAL_SHOT
		price = 200,
		mana = 44,
		max_uses = DE_USAGE * 3,
		custom_xml_file = "data/entities/misc/custom_cards/thermal_impact.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/thermal_impact.xml")
			add_projectile("data/entities/projectiles/deck/thermal_impact.xml")
			add_projectile("data/entities/projectiles/deck/thermal_impact.xml")
			add_projectile("data/entities/projectiles/deck/thermal_impact.xml")
			add_projectile("data/entities/projectiles/deck/thermal_impact.xml")
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
			-- c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/burn_powerful.xml," )
			c.speed_multiplier = math.max( c.speed_multiplier * 5.6, 0 )
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.24, 0 )
			c.lifetime_add = c.lifetime_add - 16
			c.gravity = -36.0
			c.spread_degrees = math.max( c.spread_degrees + 18, 42 )
			-- if c.pattern_degrees < 0.5 then c.pattern_degrees = 12 end
			c.screenshake = c.screenshake + 32
			shot_effects.recoil_knockback = 24.0
			current_reload_time = current_reload_time + 2
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_CASCADING_STORM",
		name 		= "$CASCADING_STORM",
		description = "$dCASCADING_STORM",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/geomagnetic_storm.png",
		related_projectiles	= {"data/entities/projectiles/deck/geomagnetic_storm.xml",4},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.45,0.6,0.75,0.45,0.02", -- SPIRAL_SHOT
		price = 177,
		mana = 77,
		max_uses = DE_USAGE * 3,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/geomagnetic_storm_electric.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/geomagnetic_storm.xml")
			add_projectile("data/entities/projectiles/deck/geomagnetic_storm_ex.xml")
			add_projectile("data/entities/projectiles/deck/geomagnetic_storm.xml")
			add_projectile("data/entities/projectiles/deck/geomagnetic_storm_ex.xml")
			c.material = "spark_blue_dark"
			-- c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
			c.gravity = 0.0
			if c.pattern_degrees < 0.5 then c.pattern_degrees = 12 end
			c.screenshake = c.screenshake + 42
			c.damage_electricity_add = c.damage_electricity_add + 0.24
			shot_effects.recoil_knockback = 28.0
			c.fire_rate_wait = c.fire_rate_wait + 21
			current_reload_time = current_reload_time + 7
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_BLOODY_THORN",
		name 		= "$BLOODY_THORN",
		description = "$dBLOODY_THORN",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bloody_thorn.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/death_cross_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bloody_thorn.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.45,0.6,0.75,0.45,0.01", -- SPIRAL_SHOT
		price = 270,
		mana = 30,
		max_uses = 18,
		custom_xml_file = "data/entities/misc/custom_cards/bloody_thorn.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bloody_thorn.xml")
			c.fire_rate_wait = c.fire_rate_wait + 16
			current_reload_time = current_reload_time + 4
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_GHOSTY_BULLET",
		name 		= "$GHOSTY_BULLET",
		description = "$dGHOSTY_BULLET",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ghosty_bullet.png",
		related_projectiles	= {"data/entities/projectiles/deck/ghosty_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.45,0.6,0.75,0.45,0.01", -- SPIRAL_SHOT
		price = 270,
		mana = 42,
		max_uses = 18,
		custom_xml_file = "data/entities/misc/custom_cards/ghosty_bullet.xml",
		action 		= function()
			local x, y = EntityGetTransform( GetUpdatedEntityID() )
			local projectile_ghosty = EntityGetInRadiusWithTag( x, y, 32, "projectile_ghosty" )

			if ( #projectile_ghosty < 18 ) then add_projectile("data/entities/projectiles/deck/ghosty_bullet.xml") end
			-- c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
			
			shot_effects.recoil_knockback = 0
			c.fire_rate_wait = c.fire_rate_wait + 12
			current_reload_time = current_reload_time + 4
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SNIPER_BULLET",
		name 		= "$SNIPER_BULLET",
		description = "$dSNIPER_BULLET",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sniperbullet.png",
		related_projectiles	= {"data/entities/projectiles/deck/sniperbullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4,5,6,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.4,0.3,0.1,0.2,0.1,0.05", -- SPIRAL_SHOT
		price = 200,
		mana = 15,
		-- max_uses = DE_USAGE * 6,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sniperbullet.xml")
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
			
			c.fire_rate_wait = c.fire_rate_wait + 12
			c.spread_degrees = c.spread_degrees - 180.0
			c.damage_critical_chance = c.damage_critical_chance + 9
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 7.0

			local vibra_param = c.damage_projectile_add / math.max( c.speed_multiplier, 0.01 ) * 12 - math.max( shot_effects.recoil_knockback, 0 )
			vibra_param = math.floor( math.min( vibra_param, 1600 ) )
			c.screenshake = math.min( c.screenshake + vibra_param, 3200 )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_LASER_TURRET",
		name 		= "$LASER_TURRET",
		description = "$dLASER_TURRET",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/laser_turret.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.4,0.2,0.3,0.4,0.4,0.5,0.05", -- SPIRAL_SHOT
		price = 200,
		mana = 32,
		-- max_uses = 75,
		custom_xml_file = "data/entities/misc/custom_cards/laser_turret.xml",
		related_projectiles	= {"data/entities/projectiles/deck/laser_turret_new.xml",2},
		action 		= function()
			add_projectile("data/entities/projectiles/deck/laser_turret_new.xml")
			add_projectile("data/entities/projectiles/laser_turret_new.xml")

			c.fire_rate_wait = c.fire_rate_wait + 7
			c.damage_critical_chance = c.damage_critical_chance + 13
			c.spread_degrees = c.spread_degrees - 36.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 15

			local vibra_param = c.damage_projectile_add / math.max( c.speed_multiplier, 0.01 ) * 12 - math.max( shot_effects.recoil_knockback, 0 )
			vibra_param = math.floor( math.min( vibra_param * 0.33 , 1200 ) )
			c.screenshake = math.min( c.screenshake + vibra_param, 3200 )
		end,
		--[[related_projectiles	= {"data/entities/projectiles/deck/laser_turret_c.xml",3},
		action 		= function()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
			local types = {"g","g","g","g","g","g","g","g","g","g","g","h","h","h","b","c","d","e","x","y","z"}
			local rnd = Random(1,#types)

			local laser_name = "data/entities/projectiles/deck/laser_turret_" .. tostring(types[rnd]) .. ".xml"
			add_projectile(laser_name)

			laser_name = "data/entities/projectiles/deck/laser_turret_a.xml"
			add_projectile(laser_name)

			laser_name = "data/entities/projectiles/deck/laser_turret_f.xml"
			add_projectile(laser_name)

			c.fire_rate_wait = c.fire_rate_wait + 14
			c.damage_critical_chance = c.damage_critical_chance + 3
			c.spread_degrees = c.spread_degrees - 36.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + Random(15,45)

			local vibra_param = c.damage_projectile_add / math.max( c.speed_multiplier, 0.01 ) * 12 - math.max( shot_effects.recoil_knockback, 0 )
			vibra_param = math.floor( math.min( vibra_param * 0.33 , 1200 ) )
			c.screenshake = math.min( c.screenshake + vibra_param, 3200 )
		end,]]--
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SOLDIERSHIT", -- shOt
		name 		= "$SOLDIERSHIT",
		description = "$dSOLDIERSHIT",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/soldiershot.png",
		related_projectiles	= {"data/entities/projectiles/deck/soldiers_shot.xml",4},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.3,0.2,0.3,0.3,0.2,0.05", -- SPIRAL_SHOT
		price = 200,
		mana = 49,
		-- max_uses = DE_USAGE * 3,
		custom_xml_file = "data/entities/misc/custom_cards/soldiershot.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			if c.pattern_degrees < 0.5 then c.pattern_degrees = 30 end
			c.damage_critical_chance = c.damage_critical_chance + 10
			c.speed_multiplier = math.min( 1.5, c.speed_multiplier + 0.5 )
			c.fire_rate_wait = c.fire_rate_wait + 15
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 8.0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_DARK_SWORD",
		name 		= "$DARK_SWORD",
		description = "$dDARK_SWORD",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/dark_sword.png",
		related_projectiles	= {"data/entities/projectiles/deck/dark_sword.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.1,0.2,0.3,0.4,0.1", -- SPIRAL_SHOT
		price = 233,
		mana = 65,
		max_uses = 36,
		custom_xml_file = "data/entities/misc/custom_cards/dark_sword.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/dark_sword.xml")
			c.fire_rate_wait = c.fire_rate_wait + 22
			shot_effects.recoil_knockback = 13.0
			c.screenshake = c.screenshake + 1.3
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_ORDER",
		name 		= "$ORDER",
		description = "$dORDER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/order.png",
		related_projectiles	= {"data/entities/projectiles/deck/order_projectile_ex.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "10",
		spawn_probability                 = "0.02",
		-- spawn_requires_flag = "card_unlocked_black_hole",
		price = 400,
		mana = 175,
		max_uses = 15,
		custom_xml_file = "data/entities/misc/custom_cards/de_order.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/order.xml")
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/order_trajectory.xml," )
			c.spread_degrees = 9.0
			c.fire_rate_wait = c.fire_rate_wait + 24
			c.speed_multiplier = math.max( c.speed_multiplier * 0.25, 0 )
			c.child_speed_multiplier = 0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 15.0
			current_reload_time = current_reload_time + 27
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_UAV",
		name 		= "$UAV",
		description = "$dUAV",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/uav.png",
		related_projectiles	= {"data/entities/projectiles/deck/uav_projectile_ex.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.2,0.4,0.5,0.5,0.5,0.1", -- SPIRAL_SHOT
		-- spawn_requires_flag = "card_unlocked_black_hole",
		price = 400,
		mana = 110,
		max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/de_uav.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/uav.xml")
			c.spread_degrees = c.spread_degrees + 90.0
			c.fire_rate_wait = c.fire_rate_wait + 24
			c.speed_multiplier = math.max( c.speed_multiplier * 0.25, 0 )
			c.child_speed_multiplier = 0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 15.0
			current_reload_time = current_reload_time + 24
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_INF_TRAIN",
		name 		= "$INF_TRAIN",
		description = "$dINF_TRAIN",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/inf_train.png",
		related_projectiles	= {"data/entities/projectiles/deck/inf_train_physics.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "10",
		spawn_probability                 = "0.02",
		price = 200,
		mana = 720, 
		max_uses    = 64, 
		custom_xml_file = "data/entities/misc/custom_cards/inf_train.xml",
		action 		= function()
			local players = EntityGetWithTag( "player_unit" )

			if players[1] ~= nil then
				local x,y = EntityGetTransform( players[1] )
				local trians = EntityGetInRadiusWithTag( x, y, 512, "de_inf_train" )
			
				if trians[1] == nil then
					add_projectile("data/entities/projectiles/deck/inf_train_guidance.xml")
					
					c.screenshake = 256
					shot_effects.recoil_knockback = shot_effects.recoil_knockback - 15.0
				else
					local comps = EntityGetComponent( trians[1], "VariableStorageComponent" )

					if comps[3] ~= nil then
					for i,comp in ipairs( comps ) do
					if ComponentGetValue2( comp, "name" ) == "num" then
						ComponentSetValue2( comp, "value_int", clamp( ComponentGetValue2( comp, "value_int" ) + 1, 3, 13 ) )			
					end end end

					mana = mana + 640
				end
			end

			c.spread_degrees = 12.0
			c.fire_rate_wait = c.fire_rate_wait + 48
			c.speed_multiplier = clamp( c.speed_multiplier * 0.25, 0, 0.5 )
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 5, 0 )
			current_reload_time = current_reload_time + 8
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_CLEAVE",
		name 		= "$CLEAVE",
		description = "$dCLEAVE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/katana_arc_slash.png",
		related_projectiles	= {"data/entities/projectiles/deck/projectile_arc_slash_ex.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.2,0.5,0.6,0.7,0.8,0.1", -- SPIRAL_SHOT
		-- spawn_requires_flag = "card_unlocked_black_hole",
		price = 200,
		mana = 60,
		max_uses = DE_USAGE * 3,
		custom_xml_file = "data/entities/misc/custom_cards/de_cleave.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/projectile_circle_slash.xml")
			add_projectile("data/entities/projectiles/deck/projectile_arc_slash.xml")
			add_projectile("data/entities/projectiles/deck/projectile_circle_slash.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SLASH_DOWN",
		name 		= "$SLASH_DOWN",
		description = "$dSLASH_DOWN",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/katana_cross_slash.png",
		related_projectiles	= {"data/entities/projectiles/deck/projectile_cross_slash_ex.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.2,0.4,0.6,0.8,0.7,0.2", -- SPIRAL_SHOT
		-- spawn_requires_flag = "card_unlocked_black_hole",
		price = 240,
		mana = 80,
		max_uses = DE_USAGE * 3,
		custom_xml_file = "data/entities/misc/custom_cards/de_slash.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/projectile_circle_slash.xml")
			add_projectile("data/entities/projectiles/deck/projectile_cross_slash.xml")
			add_projectile("data/entities/projectiles/deck/projectile_circle_slash.xml")
			c.fire_rate_wait = c.fire_rate_wait + 14
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_THRUST",
		name 		= "$THRUST",
		description = "$dTHRUST",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/thrust.png",
		related_projectiles	= {"data/entities/projectiles/deck/thrust.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,7", -- SPIRAL_SHOT
		spawn_probability                 = "0.25,0.35,0.45,0.55,0.65,0.45", -- SPIRAL_SHOT
		-- spawn_requires_flag = "card_unlocked_black_hole",
		price = 110,
		mana = 33,
		max_uses = 120,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/thrust.xml")
			c.spread_degrees = c.spread_degrees + 15
			c.fire_rate_wait = c.fire_rate_wait - 2
			current_reload_time = current_reload_time + 2
		end,
	},
	{
		id          = "CHAIN_BOLT",
		name 		= "$action_chain_bolt",
		description = "$actiondesc_chain_bolt",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/chain_bolt.png",
		related_projectiles	= {"data/entities/projectiles/deck/chain_bolt.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,4,5,6", -- CHAIN_BOLT
		spawn_probability                 = "0.8,0.25,0.7,0.7,0.7", -- CHAIN_BOLT
		price = 240,
		mana = 35,
		max_uses = DE_USAGE * 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/chain_bolt.xml")
			c.spread_degrees = c.spread_degrees + 20.0
			c.fire_rate_wait = c.fire_rate_wait + 40
			c.screenshake = 10
			shot_effects.recoil_knockback = 5.0
		end,
	},
	{
		id          = "FIREBALL",
		name 		= "$action_fireball",
		description = "$actiondesc_fireball",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/fireball.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/fireball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/fireball.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2", -- FIREBALL
		spawn_probability                 = "0.2,0.1,0.1", -- FIREBALL
		price = 220,
		mana = 20,
		max_uses = 60,
		custom_xml_file = "data/entities/misc/custom_cards/fireball.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/fireball.xml")
			c.material = "gunpowder_unstable"
			c.spread_degrees = c.spread_degrees + 4.0
			c.fire_rate_wait = c.fire_rate_wait + 50
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "METEOR",
		name 		= "$action_meteor",
		description = "$actiondesc_meteor",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/meteor.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/meteor_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/meteor.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6,10", -- METEOR
		spawn_probability                 = "0.25,0.75,0.5,0.5,0.1", -- METEOR
		price = 280,
		mana = 75,
		max_uses = 30,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/meteor.xml")
			c.damage_explosion_add = c.damage_explosion_add + 0.24
			c.damage_fire_add = c.damage_fire_add + 0.24
		end,
	},
	{
		id          = "FLAMETHROWER",
		name 		= "$action_flamethrower",
		description = "$actiondesc_flamethrower",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/flamethrower.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/flamethrower_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/flamethrower.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,6", -- FLAMETHROWER
		spawn_probability                 = "0.3,0.6,0.4,0.2", -- FLAMETHROWER
		price = 220,
		mana = 15,
		max_uses = 90,
		custom_xml_file = "data/entities/misc/custom_cards/flamethrower.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/flamethrower.xml")
			c.spread_degrees = c.spread_degrees + 4.0
		end,
	},
	{
		id          = "ICEBALL",
		name 		= "$action_iceball",
		description = "$actiondesc_iceball",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/iceball.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/fireball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/iceball.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,6", -- FIREBALL
		spawn_probability                 = "0.8,0.9,0.9,0.6", -- FIREBALL
		price = 260,
		mana = 25,
		max_uses = 60,
		custom_xml_file = "data/entities/misc/custom_cards/iceball.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/iceball.xml")
			c.material = "blood_cold"
			c.spread_degrees = c.spread_degrees + 8.0
			c.fire_rate_wait = c.fire_rate_wait + 80
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "SLIMEBALL",
		name 		= "$action_slimeball",
		description = "$actiondesc_slimeball",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/slimeball.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/slime.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,3,4", -- SLIMEBALL
		spawn_probability                 = "0.8,0.7,0.6", -- SLIMEBALL
		price = 130,
		mana = 6,
		-- max_uses = DE_USAGE * 4,
		custom_xml_file = "data/entities/misc/custom_cards/slimeball.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/slime.xml")
			c.spread_degrees = c.spread_degrees + 8.0
			c.speed_multiplier = c.speed_multiplier * 1.2
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.8, 0 )
		end,
	},
	{
		id          = "DARKFLAME",
		name 		= "$action_darkflame",
		description = "$actiondesc_darkflame",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/darkflame.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/darkflame_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/darkflame.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,5,6", -- DARKFLAME
		spawn_probability                 = "1,0.9,0.8", -- DARKFLAME
		price = 180,
		mana = 72,
		custom_xml_file = "data/entities/misc/custom_cards/darkflame.xml",
		max_uses    = 48, 
		action 		= function()
			add_projectile("data/entities/projectiles/darkflame.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "MISSILE",
		name 		= "$action_missile",
		description = "$actiondesc_missile",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/missile.png",
		related_projectiles	= {"data/entities/projectiles/deck/rocket_player.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,5", -- MISSILE
		spawn_probability                        = "0.5,0.5,1,1", -- MISSILE
		price = 200,
		mana = 60,
		max_uses    = 36, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rocket_player.xml")
			current_reload_time = current_reload_time + 30
			c.spread_degrees = c.spread_degrees + 3.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 60.0
		end,
	},
	{
		id          = "FUNKY_SPELL",
		name 		= "???",
		description = "???",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/machinegun_bullet.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/machinegun_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		-- spawn_requires_flag = "card_unlocked_funky",
		spawn_level                       = "0,1,2", -- LIGHT_BULLET
		spawn_probability                 = "0.2,0.2,0.2", -- LIGHT_BULLET
		price = 50,
		mana = 1,
		-- max_uses = DE_USAGE * 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/machinegun_bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait - 3
			c.screenshake = c.screenshake + 0.2
			c.spread_degrees = c.spread_degrees + 2.0
			c.damage_critical_chance = c.damage_critical_chance + 3
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_FUNKY_SPELL_TRIGGER",
		name 		= "***",
		description = "***",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/machinegun_bullet_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/machinegun_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		-- spawn_requires_flag = "card_unlocked_funky",
		spawn_level                       = "3,4,5,6,7,10", -- LIGHT_BULLET
		spawn_probability                 = "0.03,0.03,0.03,0.03,0.06,0.03", -- LIGHT_BULLET
		price = 250,
		mana = 4,
		-- max_uses = DE_USAGE * 2,
		action 		= function()
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/machinegun_bullet.xml",3)
			c.fire_rate_wait = c.fire_rate_wait - 3
			c.screenshake = c.screenshake + 0.2
			c.spread_degrees = c.spread_degrees + 2.0
			c.damage_critical_chance = c.damage_critical_chance + 3
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_FUNKY_SPELL_TRIGGER_MULT",
		name 		= [[*"^]],
		description = [[*"^]],
		sprite 		= "data/ui_gfx/gun_actions/deep_end/machinegun_bullet_trigger_mult.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/machinegun_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		-- spawn_requires_flag = "card_unlocked_funky",
		spawn_level                       = "3,4,5,6,7,10", -- LIGHT_BULLET
		spawn_probability                 = "0.03,0.03,0.03,0.03,0.06,0.03", -- LIGHT_BULLET
		price = 250,
		mana = 4,
		-- max_uses = DE_USAGE * 2,
		action 		= function()
			DEEP_END_add_projectile_trigger_customized("data/entities/projectiles/deck/machinegun_bullet.xml",{-1,13,0},{1,1,1})

			c.fire_rate_wait = c.fire_rate_wait - 3
			c.screenshake = c.screenshake + 0.2
			c.spread_degrees = c.spread_degrees + 2.0
			c.damage_critical_chance = c.damage_critical_chance + 3
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SNIPER_BULLET_TRIGGER",
		name 		= "$SNIPER_BULLET_TRIGGER",
		description = "$dSNIPER_BULLET_TRIGGER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sniperbullet_trigger.png",
		related_projectiles	= {"data/entities/projectiles/deck/sniperbullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.1,0.15,0.2,0.25,0.025", -- SPIRAL_SHOT
		price = 300,
		mana = 16,
		-- max_uses = DE_USAGE * 2,
		action 		= function()
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/sniperbullet.xml",3)
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
			
			c.fire_rate_wait = c.fire_rate_wait + 12
			c.spread_degrees = c.spread_degrees - 180.0
			c.damage_critical_chance = c.damage_critical_chance + 9
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 7.0

			local vibra_param = c.damage_projectile_add / math.max( c.speed_multiplier, 0.01 ) * 12 - math.max( shot_effects.recoil_knockback, 0 )
			vibra_param = math.floor( math.min( vibra_param, 1600 ) )
			c.screenshake = math.min( c.screenshake + vibra_param, 3200 )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SNIPER_BULLET_TRIGGER_MULT",
		name 		= "$SNIPER_BULLET_TRIGGER_MULT",
		description = "$dSNIPER_BULLET_TRIGGER_MULT",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sniperbullet_trigger_mult.png",
		related_projectiles	= {"data/entities/projectiles/deck/sniperbullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.1,0.15,0.2,0.25,0.025", -- SPIRAL_SHOT
		price = 300,
		mana = 16,
		-- max_uses = DE_USAGE * 2,
		action 		= function()
			DEEP_END_add_projectile_trigger_customized("data/entities/projectiles/deck/sniperbullet.xml",{-1,4,0},{1,1,1})
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )

			c.fire_rate_wait = c.fire_rate_wait + 12
			c.spread_degrees = c.spread_degrees - 180.0
			c.damage_critical_chance = c.damage_critical_chance + 9
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 7.0

			local vibra_param = c.damage_projectile_add / math.max( c.speed_multiplier, 0.01 ) * 12 - math.max( shot_effects.recoil_knockback, 0 )
			vibra_param = math.floor( math.min( vibra_param, 1600 ) )
			c.screenshake = math.min( c.screenshake + vibra_param, 3200 )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SOLDIERSHIT_TRIGGER", -- shOt
		name 		= "$SOLDIERSHIT_TRIGGER",
		description = "$dSOLDIERSHIT_TRIGGER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/soldiershot_trigger.png",
		related_projectiles	= {"data/entities/projectiles/deck/soldiers_shot.xml",4},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.1,0.15,0.2,0.4,0.04", -- SPIRAL_SHOT
		price = 300,
		mana = 49,
		-- max_uses = DE_USAGE * 1,
		custom_xml_file = "data/entities/misc/custom_cards/soldiershot.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/soldiers_shot.xml",2)
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/soldiers_shot.xml",2)
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			if c.pattern_degrees < 0.5 then c.pattern_degrees = 30 end
			c.damage_critical_chance = c.damage_critical_chance + 10
			c.speed_multiplier = math.min( 1.5, c.speed_multiplier + 0.5 )
			c.fire_rate_wait = c.fire_rate_wait + 15
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 8.0
		end,
	},
	{
		id          = "PEBBLE",
		name 		= "$action_pebble",
		description = "$actiondesc_pebble",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/pebble.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/pebble_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/pebble_player.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4,6", -- PEBBLE
		spawn_probability                 = "0.6,0.7,0.6,0.5", -- PEBBLE
		price = 200,
		mana = 120,
		max_uses    = 100, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pebble_player.xml")
			c.material = "blood_cold_vapour"
			c.fire_rate_wait = c.fire_rate_wait + 80
		end,
	},
	{
		id          = "DYNAMITE",
		name 		= "$action_dynamite",
		description = "$actiondesc_dynamite",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/dynamite.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tnt.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4", -- DYNAMITE
		spawn_probability                 = "0.65,0.5,0.35,0.2,0.05", -- DYNAMITE
		price = 160,
		mana = 50,
		max_uses    = 16,
		custom_xml_file = "data/entities/misc/custom_cards/tnt.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/tnt.xml")
			c.fire_rate_wait = c.fire_rate_wait + 25
			c.spread_degrees = c.spread_degrees + 6.0
		end,
	},
	{
		id          = "GLITTER_BOMB",
		name 		= "$action_glitter_bomb",
		description = "$actiondesc_glitter_bomb",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/glitter_bomb.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/glitter_bomb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4", -- GLITTER_BOMB
		spawn_probability                 = "0.3,0.4,0.3,0.2,0.1", -- GLITTER_BOMB
		price = 200,
		mana = 15,
		max_uses	= 36,
		custom_xml_file = "data/entities/misc/custom_cards/glitter_bomb.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/glitter_bomb.xml")
			c.fire_rate_wait = c.fire_rate_wait + 11
			c.spread_degrees = c.spread_degrees + 12.0
		end,
	},
	{
		id          = "BUCKSHOT",
		name 		= "$action_buckshot",
		description = "$actiondesc_buckshot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/buckshot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/buckshot_player.xml",3},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4", -- BUCKSHOT
		spawn_probability                 = "1,1,0.6,0.6,0.4", -- BUCKSHOT
		price = 160,
		mana = 18,
		-- max_uses = DE_USAGE * 4,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/buckshot_player.xml")
			add_projectile("data/entities/projectiles/deck/buckshot_player.xml")
			add_projectile("data/entities/projectiles/deck/buckshot_player.xml")
			c.fire_rate_wait = c.fire_rate_wait + 5
			c.spread_degrees = c.spread_degrees + 12.0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_BUCKSHOT_TRIGGER_3",
		name 		= "$BUCKSHOT_TRIGGER_3",
		description = "$dBUCKSHOT_TRIGGER_3",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/buckshot_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/buckshot_player.xml",3},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,10", -- BUCKSHOT
		spawn_probability                 = "0.2,0.3,0.4,0.02", -- BUCKSHOT
		price = 160,
		mana = 30,
		-- max_uses = DE_USAGE * 4,
		action 		= function()
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/buckshot_player.xml",1)
			add_projectile_trigger_timer("data/entities/projectiles/deck/buckshot_player.xml",13,1)
			add_projectile_trigger_death("data/entities/projectiles/deck/buckshot_player.xml",1)
			c.fire_rate_wait = c.fire_rate_wait + 5
			c.spread_degrees = c.spread_degrees + 12.0
		end,
	},
	{
		id          = "FREEZING_GAZE",
		name 		= "$action_freezing_gaze",
		description = "$actiondesc_freezing_gaze",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/freezing_gaze.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/freezing_gaze_beam.xml",9},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,6,10", -- FREEZING_GAZE
		spawn_probability                 = "0.8,0.9,1,0.2,0.02", -- FREEZING_GAZE
		price = 180,
		mana = 40,
		max_uses	= 25,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			c.damage_projectile_add = c.damage_projectile_add - 0.16
			if c.pattern_degrees < 0.5 then c.pattern_degrees = 75 end
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "GLOWING_BOLT",
		name 		= "$action_glowing_bolt",
		description = "$actiondesc_glowing_bolt",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/glowing_bolt.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/glowing_bolt.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,10", -- FREEZING_GAZE
		spawn_probability                 = "0.5,0.6,0.7,0.1", -- FREEZING_GAZE
		price = 220,
		mana = 45,
		max_uses = DE_USAGE * 2,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/glowing_bolt.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
			c.spread_degrees = c.spread_degrees - 6.0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_GLOWING_BOLT_WITH_TIMER_2",
		name 		= "$GLOWING_BOLT_WITH_TIMER_2",
		description = "$dGLOWING_BOLT_WITH_TIMER_2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/glowing_bolt_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/glowing_bolt.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6,10", -- FREEZING_GAZE
		spawn_probability                 = "0.2,0.3,0.3,0.2,0.1", -- FREEZING_GAZE
		price = 310,
		mana = 90,
		max_uses = 15,
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/glowing_bolt.xml",60,2)
			c.fire_rate_wait = c.fire_rate_wait + 40
			c.spread_degrees = c.spread_degrees - 6.0
		end,
	},
	{
		id          = "SPORE_POD",
		name 		= "$action_spore_pod",
		description = "$actiondesc_spore_pod",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/spore_pod.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spore_pod_unidentified.png",
		related_projectiles	= {"data/entities/misc/perks/spore_pod_spike.xml",7},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- SPORE_POD
		spawn_probability                 = "0.1,0.25,0.4,0.25,0.1", -- SPORE_POD
		price = 100,
		mana = 16,
		-- max_uses = DE_USAGE * 4,
		custom_xml_file = "data/entities/misc/custom_cards/spore_pod.xml",
		action 		= function()
			add_projectile("data/entities/misc/perks/spore_pod.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "GLUE_SHOT",
		name 		= "$action_glue_shot",
		description = "$actiondesc_glue_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/glue_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/glue_shot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5", -- GLUE_SHOT
		spawn_probability                 = "0.7,0.4,0.2,0.5", -- GLUE_SHOT
		price = 10,
		mana = 0,
		-- max_uses = DE_USAGE * 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/glue_shot.xml")
			c.fire_rate_wait = math.min( c.fire_rate_wait - 1, 27 )
			c.spread_degrees = c.spread_degrees + 18
			c.lifetime_add = c.lifetime_add + 6
			c.speed_multiplier = c.speed_multiplier * 1.2
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.8, 0 )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_STICKY_BOMB",
		name 		= "$STICKY_BOMB",
		description = "$dSTICKY_BOMB",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bomb_sticky.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb_sticky_shoot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- GLITTER_BOMB
		spawn_probability                 = "0.3,0.25,0.2,0.15,0.1,0.05", -- GLITTER_BOMB
		price = 200,
		mana = 45, 
		max_uses    = 6, 
		custom_xml_file = "data/entities/misc/custom_cards/bomb_sticky.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/bomb_sticky_shoot.xml")
			c.fire_rate_wait = c.fire_rate_wait + 35
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_BOUNCY_BOMB",
		name 		= "$BOUNCY_BOMB",
		description = "$dBOUNCY_BOMB",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bomb_bouncy.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb_bouncy.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- GLITTER_BOMB
		spawn_probability                 = "0.3,0.25,0.2,0.15,0.1,0.05", -- GLITTER_BOMB
		price = 200,
		mana = 50, 
		max_uses    = 6, 
		custom_xml_file = "data/entities/misc/custom_cards/bomb_bouncy.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/bomb_bouncy.xml")
			c.fire_rate_wait = c.fire_rate_wait + 35
		end,
	},
	{
		id          = "BOMB_HOLY",
		name 		= "$action_bomb_holy",
		description = "$actiondesc_bomb_holy",
		-- spawn_requires_flag = "card_unlocked_bomb_holy",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bomb_holy.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb_holy.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6,10", -- BOMB_HOLY
		spawn_probability                 = "0.01,0.01,0.01,0.1,0.1,0.01", -- BOMB_HOLY
		price = 400,
		mana = 25, 
		max_uses    = 6, 
		custom_xml_file = "data/entities/misc/custom_cards/bomb_holy.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/bomb_holy.xml")
			current_reload_time = current_reload_time + 80
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "BOMB_HOLY_GIGA",
		name 		= "$action_bomb_holy_giga",
		description = "$actiondesc_bomb_holy_giga",
		-- spawn_requires_flag = "card_unlocked_bomb_holy_giga",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bomb_holy_giga.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb_holy_giga.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "7,10", -- BOMB_HOLY
		spawn_probability                 = "0.1,0.01", -- BOMB_HOLY
		price = 600,
		mana = 35, 
		max_uses    = 4,
		never_unlimited = true,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/bomb_holy_giga.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/bomb_holy_giga.xml")
			current_reload_time = current_reload_time + 160
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0
			c.fire_rate_wait = c.fire_rate_wait + 120
		end,
	},
	{
		id          = "PROPANE_TANK",
		name 		= "$action_propane_tank",
		description = "$actiondesc_propane_tank",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/propane_tank.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/propane_tank.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- PROPANE_TANK
		spawn_probability                 = "1,1,0.8,0.8,0.7", -- PROPANE_TANK
		price = 200,
		mana = 75, 
		max_uses    = 12, 
		custom_xml_file = "data/entities/misc/custom_cards/propane_tank.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/propane_tank.xml")
			c.fire_rate_wait = c.fire_rate_wait + 72
		end,
	},
	{
		id          = "BOMB_CART",
		name 		= "$action_bomb_cart",
		description = "$actiondesc_bomb_cart",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bomb_cart.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb_cart.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- BOMB_CART
		spawn_probability                 = "0.6,0.6,0.5,0.8,0.6", -- BOMB_CART
		price = 200,
		mana = 25, 
		max_uses    = 25, 
		action 		= function()
			add_projectile("data/entities/projectiles/bomb_cart.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 200.0
			c.fire_rate_wait = c.fire_rate_wait + 60
		end,
	},
	{
		id          = "CURSED_ORB",
		name 		= "$action_cursed_orb",
		description = "$actiondesc_cursed_orb",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/cursed_orb.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/orb_cursed.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3", -- CURSED_ORB
		spawn_probability                 = "0.3,0.2,0.1", -- CURSED_ORB
		price = 200,
		mana = 13,
		-- max_uses = DE_USAGE * 5,
		action 		= function()
			add_projectile("data/entities/projectiles/orb_cursed.xml")
			c.spread_degrees = c.spread_degrees - 24
			c.damage_curse_add = c.damage_curse_add + 0.13
			c.fire_rate_wait = c.fire_rate_wait + 13
			shot_effects.recoil_knockback = 78.0
		end,
	},
	{
		id          = "EXPANDING_ORB",
		name 		= "$action_expanding_orb",
		description = "$actiondesc_expanding_orb",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/expanding_orb.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/orb_expanding.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- CURSED_ORB
		spawn_probability                 = "0.5,0.5,1,1,0.5", -- CURSED_ORB
		price = 200,
		mana = 15,
		-- max_uses = DE_USAGE * 5,
		action 		= function()
			add_projectile("data/entities/projectiles/orb_expanding.xml")
			c.damage_projectile_add = c.damage_projectile_add + 0.08
			c.fire_rate_wait = c.fire_rate_wait + 3
			shot_effects.recoil_knockback = 40.0
		end,
	},
	{
		id          = "CRUMBLING_EARTH",
		name 		= "$action_crumbling_earth",
		description = "$actiondesc_crumbling_earth",
		-- spawn_requires_flag = "card_unlocked_crumbling_earth",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/crumbling_earth.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/crumbling_earth.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- CRUMBLING_EARTH
		spawn_probability                 = "0.05,0.04,0.06,0.07,0.08", -- CRUMBLING_EARTH
		price = 300,
		mana = 240, 
		max_uses    = 3, 
		ai_never_uses = true,
		action 		= function()
			c.gravity = 0.0
			add_projectile("data/entities/projectiles/deck/crumbling_earth.xml")
			current_reload_time = 48
		end,
	},
	{
		id          = "SUMMON_ROCK",
		name 		= "$action_summon_rock",
		description = "$actiondesc_summon_rock",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/summon_rock.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/rock.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6", -- SUMMON_ROCK
		spawn_probability                 = "0.7,0.6,0.5,0.4,0.3,0.5,0.7", -- SUMMON_ROCK
		price = 160,
		mana = 100, 
		max_uses    = 5, 
		custom_xml_file = "data/entities/misc/custom_cards/summon_rock.xml",
		action 		= function()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
			if Random(1,8) > 7 then
				add_projectile("data/entities/projectiles/deck/rocker.xml")
			else
				add_projectile("data/entities/projectiles/deck/rock.xml")
			end
		end,
	},
	{
		id          = "SUMMON_EGG",
		name 		= "$action_summon_egg",
		description = "$actiondesc_summon_egg",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/summon_egg.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/items/pickup/egg_monster.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6", -- SUMMON_EGG
		spawn_probability                 = "0.2,0.3,0.3,0.3,0.2,0.2,0.1", -- SUMMON_EGG
		price = 220,
		mana = 500, 
		max_uses    = 8, 
		action 		= function()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
			local types = {"monster","slime","red","fire"}
			local rnd = Random(1,#types)
			local egg_name = "egg_" .. tostring(types[rnd]) .. ".xml"
			add_projectile("data/entities/items/pickup/" .. egg_name)
		end,
	},
	{
		id          = "SUMMON_HOLLOW_EGG",
		name 		= "$action_summon_hollow_egg",
		description = "$actiondesc_summon_hollow_egg",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/summon_hollow_egg.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/items/pickup/egg_hollow.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,5,6", -- SUMMON_HOLLOW_EGG
		spawn_probability                 = "0.6,0.8,0.7,0.8,0.3", -- SUMMON_HOLLOW_EGG
		price = 120,
		mana = 18, 
		max_uses = DE_USAGE * 8,
		action 		= function()
			add_projectile_trigger_death("data/entities/items/pickup/egg_hollow.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait - 12
		end,
	},
	{
		id          = "TNTBOX",
		name 		= "$action_tntbox",
		description = "$actiondesc_tntbox",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/tntbox.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tntbox.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,5", -- SUMMON_ROCK
		spawn_probability                 = "0.8,0.9,0.5,0.4", -- SUMMON_ROCK
		price = 150,
		mana = 45, 
		max_uses    = 20, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/tntbox.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end,
	},
	{
		id          = "TNTBOX_BIG",
		name 		= "$action_tntbox_big",
		description = "$actiondesc_tntbox_big",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/tntbox_big.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tntbox_big.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5", -- SUMMON_ROCK
		spawn_probability                 = "0.8,1,0.7", -- SUMMON_ROCK
		price = 170,
		mana = 60, 
		max_uses    = 15, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/tntbox_big.xml")
			c.fire_rate_wait = c.fire_rate_wait + 45
		end,
	},
	{
		id          = "SWARM_FLY",
		name 		= "$action_swarm_fly",
		description = "$dSWARM_FLY",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/swarm_fly.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		-- related_projectiles	= {"data/entities/projectiles/deck/de_swarm_fly.xml",5},
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "2,3,5", -- SPIRAL_SHOT
		spawn_probability                 = "0.32,0.33,0.35", -- SPIRAL_SHOT
		price = 90,
		mana = 15,
		-- max_uses = DE_USAGE * 2,
		custom_xml_file = "data/entities/misc/custom_cards/swarm_fly.xml",
		action 		= function()
			c.spread_degrees = c.spread_degrees + 1
			c.fire_rate_wait = c.fire_rate_wait + 1
			current_reload_time = current_reload_time + 1
			draw_actions( 1, false )
		end,
	},
	{
		id          = "SWARM_WASP",
		name 		= "$action_swarm_wasp",
		description = "$dSWARM_WASP",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/swarm_wasp.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		-- related_projectiles	= {"data/entities/projectiles/deck/de_swarm_wasp.xml",6},
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "1,4,6", -- SPIRAL_SHOT
		spawn_probability                 = "0.32,0.33,0.35", -- SPIRAL_SHOT
		price = 120,
		mana = 18,
		-- max_uses = DE_USAGE * 2,
		custom_xml_file = "data/entities/misc/custom_cards/swarm_wasp.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 5
			current_reload_time = current_reload_time + 2
			draw_actions( 1, false )
		end,
	},
	{
		id          = "SWARM_FIREBUG",
		name 		= "$action_swarm_firebug",
		description = "$actiondesc_swarm_firebug",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/swarm_firebug.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_swarm_firebug.xml",4},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,5", -- SPIRAL_SHOT
		spawn_probability                 = "0.32,0.33,0.35", -- SPIRAL_SHOT
		price = 100,
		mana = 28,
		max_uses = DE_USAGE * 2,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_swarm_firebug.xml")
			add_projectile("data/entities/projectiles/deck/de_swarm_firebug.xml")
			add_projectile("data/entities/projectiles/deck/de_swarm_firebug.xml")
			add_projectile("data/entities/projectiles/deck/de_swarm_firebug.xml")
			c.spread_degrees = c.spread_degrees + 12.0
			c.fire_rate_wait = c.fire_rate_wait + 55
			current_reload_time = current_reload_time + 20
		end,
	},
	{
		id          = "FRIEND_FLY",
		name 		= "$action_friend_fly",
		description = "$actiondesc_friend_fly",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/friend_fly.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_friend_fly.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,4,6", -- SPIRAL_SHOT
		spawn_probability                 = "0.32,0.33,0.35", -- SPIRAL_SHOT
		price = 160,
		mana = 42,
		max_uses = DE_USAGE * 2,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_friend_fly.xml")
			c.spread_degrees = c.spread_degrees + 24.0
			c.fire_rate_wait = c.fire_rate_wait + 55
			current_reload_time = current_reload_time + 40
		end,
	},
	--[[
	{
		id          = "KNIFE",
		name 		= "$action_knife",
		description = "$actiondesc_knife",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/knife.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- KNIFE
		spawn_probability                 = "", -- KNIFE
		price = 200,
		mana = 50, 
		max_uses    = 5, 
		custom_xml_file = "data/entities/misc/custom_cards/knife.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/knife.xml")
		end,
	},
	{
		id          = "CIRCLESHOT_A",
		name 		= "$action_circleshot_a",
		description = "$actiondesc_circleshot_a",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/phantomshot_a.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- CIRCLESHOT_A
		spawn_probability                        = "", -- CIRCLESHOT_A
		price = 100,
		mana = 80,
		custom_xml_file = "data/entities/misc/custom_cards/circleshot_a.xml",
		max_uses    = 40, 
		action 		= function()
			add_projectile("data/entities/projectiles/orbspawner_green.xml")
			current_reload_time = current_reload_time + 80
		end,
	},
	{
		id          = "CIRCLESHOT_B",
		name 		= "$action_circleshot_b",
		description = "$actiondesc_circleshot_b",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/phantomshot_b.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- CIRCLESHOT_B
		spawn_probability                        = "", -- CIRCLESHOT_B
		price = 100,
		mana = 80,
		max_uses    = 40, 
		custom_xml_file = "data/entities/misc/custom_cards/circleshot_b.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/orbspawner.xml")
			current_reload_time = current_reload_time + 80
		end,
	},
	]]--
	-------------------------------------------------------------------
	{
		id          = "ACIDSHOT",
		name 		= "$action_acidshot",
		description = "$actiondesc_acidshot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/acidshot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/acidshot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/acidshot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- ACIDSHOT
		spawn_probability                 = "0.9,0.9,0.9,0.6", -- ACIDSHOT
		price = 180,
		mana = 20,
		max_uses = 25,
		custom_xml_file = "data/entities/misc/custom_cards/acidshot.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/acidshot.xml")
			c.material = "acid"
			c.fire_rate_wait = c.fire_rate_wait + 2
		end,
	},
	{
		id          = "THUNDERBALL",
		name 		= "$action_thunderball",
		description = "$actiondesc_thunderball",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/thunderball.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/thunderball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/thunderball.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4,6,10", -- THUNDERBALL
		spawn_probability                 = "0.1,0.9,0.8,0.7,0.05", -- THUNDERBALL
		price = 300,
		mana = 63,
		max_uses    = 10, 
		custom_xml_file = "data/entities/misc/custom_cards/thunderball.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/thunderball.xml")
			c.damage_electricity_add = c.damage_electricity_add + 0.24
			c.damage_explosion_add = c.damage_explosion_add + 0.24
			c.bounces = c.bounces + 3
			c.fire_rate_wait = c.fire_rate_wait + 60
		end,
	},
	{
		id          = "FIREBOMB",
		name 		= "$action_firebomb",
		description = "$actiondesc_firebomb",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/firebomb.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/firebomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/firebomb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3", -- FIREBOMB
		spawn_probability                 = "1,0.9,0.7", -- FIREBOMB
		price = 100,
		mana = 10,
		-- max_uses = DE_USAGE * 8, 
		custom_xml_file = "data/entities/misc/custom_cards/firebomb.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/firebomb.xml")
		end,
	},
	{
		id          = "SOILBALL",
		name 		= "$action_soilball",
		description = "$actiondesc_soilball",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/soil.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/firebomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/chunk_of_soil.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,5", -- SOILBALL
		spawn_probability                 = "0.8,0.8,1,0.75", -- SOILBALL
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/chunk_of_soil.xml")
			c.material = "soil"
			c.explosion_radius = clamp( c.explosion_radius * 2 - 32, c.explosion_radius, 256 )
			c.damage_explosion_add = c.damage_explosion_add + 0.03
		end,
	},
	--[[
	{
		id          = "PINK_ORB",
		name 		= "$action_pink_orb",
		description = "$actiondesc_pink_orb",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/pink_orb.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- PINK_ORB
		spawn_probability                        = "", -- PINK_ORB
		price = 160,
		mana = 60,
		max_uses    = 25, 
		custom_xml_file = "data/entities/misc/custom_cards/pink_orb.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pink_orb.xml")
			current_reload_time = current_reload_time + 40
		end,
	},
	]]--
	{
		id          = "DEATH_CROSS",
		name 		= "$action_death_cross",
		description = "$actiondesc_death_cross",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/death_cross.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/death_cross_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_death_cross.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- DEATH_CROSS
		spawn_probability                 = "0.9,0.7,0.5,0.4,0.3", -- DEATH_CROSS
		price = 210,
		mana = 33,
		max_uses = 44,
		-- custom_xml_file = "data/entities/misc/custom_cards/death_cross.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_death_cross.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_DEATH_CROSS_TRIGGER",
		name 		= "$DEATH_CROSS_TRIGGER",
		description = "$dDEATH_CROSS_TRIGGER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/death_cross_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/death_cross_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_death_cross.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,6", -- DEATH_CROSS
		spawn_probability                 = "0.1,0.1,0.1,0.1,0.2,0.3", -- DEATH_CROSS
		price = 210,
		mana = 35,
		max_uses = 45,
		-- custom_xml_file = "data/entities/misc/custom_cards/death_cross.xml",
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/de_death_cross.xml",1)
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "DEATH_CROSS_BIG",
		name 		= "$action_death_cross_big",
		description = "$actiondesc_death_cross_big",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/death_cross_big.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/death_cross_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_death_cross_big.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6,10", -- DEATH_CROSS_BIG
		spawn_probability                 = "0.4,0.5,0.55,0.3,0.4,0.05", -- DEATH_CROSS_BIG
		price = 310,
		mana = 44,
		max_uses = 25,
		-- custom_xml_file = "data/entities/misc/custom_cards/death_cross.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_death_cross_big.xml")
			c.damage_healing_add = c.damage_healing_add - 0.24
			c.fire_rate_wait = c.fire_rate_wait + 70
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_HEAVENLY_WRATH",
		name 		= "$HEAVENLY_WRATH",
		description = "$dHEAVENLY_WRATH",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/heavenly_wrath.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/death_cross_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/heavenly_wrath.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6,7,10", -- DEATH_CROSS_BIG
		spawn_probability                 = "0.2,0.35,0.5,0.2,0.075", -- DEATH_CROSS_BIG
		price = 310,
		mana = 66,
		max_uses = 6,
		ai_never_uses = true,
		-- custom_xml_file = "data/entities/misc/custom_cards/death_cross.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/heavenly_wrath.xml")
			c.damage_healing_add = c.damage_healing_add - 0.52
			c.damage_projectile_add = c.damage_projectile_add + 0.52
			c.fire_rate_wait = c.fire_rate_wait + 180
			current_reload_time = current_reload_time + 180
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 130.0
			c.screenshake = c.screenshake + 130
		end,
	},
	{
		id          = "INFESTATION",
		name 		= "$action_infestation",
		description = "$actiondesc_infestation",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/infestation.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rubber_ball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_infestation.xml",6},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- RUBBER_BALL
		spawn_probability                 = "0.2,0.3,0.3,0.4", -- RUBBER_BALL
		price = 160,
		mana = 20,
		max_uses = DE_USAGE * 4,
		action 		= function()
			for i=1,6 do
				add_projectile("data/entities/projectiles/deck/de_infestation.xml")
			end
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait - 20
			c.spread_degrees = c.spread_degrees + 5
		end,
	},
	{
		id          = "WALL_HORIZONTAL",
		name 		= "$action_wall_horizontal",
		description = "$daction_wall",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/wall_horizontal.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/wall_horizontal.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,4,5", -- WALL_HORIZONTAL
		spawn_probability                 = "0.4,0.4,0.6,0.5,0.2", -- WALL_HORIZONTAL
		price = 160,
		mana = 70,
		max_uses = 22,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/wall_horizontal.xml")
			c.fire_rate_wait = c.fire_rate_wait + 5
		end,
	},
	{
		id          = "WALL_VERTICAL",
		name 		= "$action_wall_vertical",
		description = "$daction_wall",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/wall_vertical.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/wall_vertical.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,4,5", -- WALL_VERTICAL
		spawn_probability                 = "0.4,0.4,0.6,0.5,0.2", -- WALL_VERTICAL
		price = 160,
		mana = 70,
		max_uses = 22,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/wall_vertical.xml")
			c.fire_rate_wait = c.fire_rate_wait + 5
		end,
	},
	{
		id          = "WALL_SQUARE",
		name 		= "$action_wall_square",
		description = "$daction_wall",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/wall_square.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/wall_square.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- WALL_SQUARE
		spawn_probability                 = "0.3,0.2,0.6,0.5,0.4,0.4", -- WALL_SQUARE
		price = 160,
		mana = 110,
		max_uses = 14,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/wall_square.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "TEMPORARY_WALL",
		name 		= "$action_temporary_wall",
		description = "$actiondesc_temporary_wall",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/temporary_wall.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/temporary_wall.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "0,1,2,4,5", -- WALL_SQUARE
		spawn_probability                 = "0.1,0.1,0.3,0.4,0.2", -- WALL_SQUARE
		price = 100,
		mana = 40,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/temporary_wall.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "TEMPORARY_PLATFORM",
		name 		= "$action_temporary_platform",
		description = "$actiondesc_temporary_platform",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/temporary_platform.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/temporary_platform.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "0,1,2,4,5", -- WALL_SQUARE
		spawn_probability                 = "0.1,0.1,0.3,0.4,0.2", -- WALL_SQUARE
		price = 90,
		mana = 30,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/temporary_platform.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "PURPLE_EXPLOSION_FIELD",
		name 		= "$action_purple_explosion_field",
		description = "$actiondesc_purple_explosion_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/purple_explosion_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/purple_explosion_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- PURPLE_EXPLOSION_FIELD
		spawn_probability                 = "0.7,1,0.7,0.5,0.5,0.3", -- PURPLE_EXPLOSION_FIELD
		price = 160,
		mana = 90,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/purple_explosion_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.speed_multiplier = clamp( c.speed_multiplier - 2, 0, 20 )
		end,
	},
	{
		id          = "DELAYED_SPELL",
		name 		= "$action_delayed_spell",
		description = "$actiondesc_delayed_spell",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/delayed_spell.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/delayed_spell_clock.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- DELAYED_SPELL
		spawn_probability                 = "0.8,0.8,1,0.7,0.5,0.4", -- DELAYED_SPELL
		price = 240,
		mana = 0,
		max_uses = DE_USAGE * 2,
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/delayed_spell.xml", 3)
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "LONG_DISTANCE_CAST",
		name 		= "$action_long_distance_cast",
		description = "$actiondesc_long_distance_cast",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/long_distance_cast.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/long_distance_cast.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- LONG_DISTANCE_CAST
		spawn_probability                 = "0.2,0.2,0.3,0.2,0.1,0.1", -- LONG_DISTANCE_CAST
		price = 90,
		mana = 0,
		max_uses = DE_USAGE * 6,
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/long_distance_cast.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait - 20
			shot_effects.recoil_knockback = 0.0
		end,
	},
	{
		id          = "TELEPORT_CAST",
		name 		= "$action_teleport_cast",
		description = "$actiondesc_teleport_cast",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/teleport_cast.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_cast.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4,5,6", -- TELEPORT_CAST
		spawn_probability                 = "0.2,0.2,0.2,0.3,0.3", -- TELEPORT_CAST
		price = 190,
		mana = 55,
		max_uses = DE_USAGE * 4,
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/teleport_cast.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 18
			current_reload_time = current_reload_time + 6
			c.spread_degrees = c.spread_degrees + 60
			shot_effects.recoil_knockback = 2.0
		end,
	},
	{
		id          = "SUPER_TELEPORT_CAST",
		name 		= "$action_super_teleport_cast",
		description = "$dsuper_teleport_cast",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/super_teleport_cast.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_super_teleport_cast.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6", -- SUPER_TELEPORT_CAST
		spawn_probability                 = "0.1,0.2,0.3,0.3", -- SUPER_TELEPORT_CAST
		price = 160,
		mana = 5,
		max_uses = DE_USAGE * 5,
		action 		= function()
			-- add_projectile_trigger_death("data/entities/projectiles/deck/de_super_teleport_cast.xml", 1)

			--[[
			BeginProjectile( "data/entities/projectiles/deck/de_super_teleport_cast.xml" )
				BeginTriggerDeath()
					draw_actions( 1, true )
					c.lifetime_add = -9999
				EndTrigger()
			EndProjectile()
			]]--

			DEEP_END_add_projectile_trigger_add_effect("data/entities/misc/nolla.xml,", "data/entities/projectiles/deck/de_super_teleport_cast.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.spread_degrees = c.spread_degrees - 6
			shot_effects.recoil_knockback = 0.0
		end,
	},
	{
		id          = "CASTER_CAST",
		name 		= "$action_caster_cast",
		description = "$actiondesc_caster_cast",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/caster_cast.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/caster_cast.xml"}, -- wtf
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "2,4,5,6,10", -- CASTER_CAST
		spawn_probability                 = "0.2,0.2,0.4,0.4,0.2", -- CASTER_CAST
		price = 70,
		mana = 2,
		max_uses = DE_USAGE * 4,
		action 		= function()
			c.spread_degrees = c.spread_degrees - 720
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/caster_cast.xml," )
			shot_effects.recoil_knockback = 0.0
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "COMMANDER_BULLET",
		name 		= "$action_commander_bullet",
		description = "$actiondesc_commander_bullet",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/commander_bullet.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- COMMANDER_BULLET
		spawn_probability                 = "", -- COMMANDER_BULLET
		price = 160,
		mana = 50,
		--max_uses = 80,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/commander_bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
			draw_actions( 3, true )
		end,
	},
	{
		id          = "PLASMA_FLARE",
		name 		= "$action_plasma_flare",
		description = "$actiondesc_plasma_flare",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/plasma_flare.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- PLASMA_FLARE
		spawn_probability                        = "", -- PLASMA_FLARE
		price = 230,
		mana = 40,
		max_uses    = 30, 
		custom_xml_file = "data/entities/misc/custom_cards/plasma_flare.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/orb_pink_fast.xml")
		end,
	},
	{
		id          = "KEYSHOT",
		name 		= "$action_keyshot",
		description = "$actiondesc_keyshot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/keyshot.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- KEYSHOT
		spawn_probability                        = "", -- KEYSHOT
		price = 999,
		mana = 300,
		max_uses    = 3, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/keyshot.xml")
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "MANA",
		name 		= "$action_mana",
		description = "$actiondesc_mana",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mana.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- MANA
		spawn_probability                        = "", -- MANA
		price = 100,
		mana = -200,
		max_uses    = 5, 
		custom_xml_file = "data/entities/misc/custom_cards/mana.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/mana.xml")
		end,
	},
	{
		id          = "SKULL",
		name 		= "$action_skull",
		description = "$actiondesc_skull",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/skull.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- SKULL
		spawn_probability                        = "", -- SKULL
		price = 150,
		mana = 60,
		max_uses    = 20, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/skull.xml")
		end,
	},
	-- DEBUG REMOVE ME --
	{
		id          = "MATERIAL_DEBUG",
		name 		= "$action_material_debug",
		description = "$actiondesc_material_debug",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/material_debug.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- MATERIAL_DEBUG
		spawn_probability                 = "", -- MATERIAL_DEBUG
		price = 100,
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_debug.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_LIQUID",
		name 		= "$action_material_liquid",
		description = "$actiondesc_material_liquid",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/material_liquid.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- MATERIAL_LIQUID
		spawn_probability                 = "", -- MATERIAL_LIQUID
		price = 100,
		mana = 0,
		custom_xml_file = "data/entities/misc/custom_cards/material_liquid.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_liquid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	]]--
	{
		id          = "MIST_RADIOACTIVE",
		name 		= "$action_mist_radioactive",
		description = "$actiondesc_mist_radioactive",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mist_radioactive.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_radioactive.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- MIST_RADIOACTIVE
		spawn_probability                 = "0.23,0.22,0.23,0.22", -- MIST_RADIOACTIVE
		price = 80,
		mana = 10,
		max_uses = 45,
		action 		= function()
			c.gravity = 0.0
			add_projectile("data/entities/projectiles/deck/mist_radioactive.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "MIST_ALCOHOL",
		name 		= "$action_mist_alcohol",
		description = "$actiondesc_mist_alcohol",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mist_alcohol.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_alcohol.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- MIST_ALCOHOL
		spawn_probability                 = "0.22,0.23,0.22,0.23", -- MIST_ALCOHOL
		price = 80,
		mana = 10,
		max_uses = 50,
		action 		= function()
			c.gravity = 0.0
			add_projectile("data/entities/projectiles/deck/mist_alcohol.xml")
			c.fire_rate_wait = c.fire_rate_wait + 7
		end,
	},
	{
		id          = "MIST_SLIME",
		name 		= "$action_mist_slime",
		description = "$actiondesc_mist_slime",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mist_slime.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_slime.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- MIST_SLIME
		spawn_probability                 = "0.23,0.23,0.22,0.22", -- MIST_SLIME
		price = 60,
		mana = 10,
		max_uses = 40,
		action 		= function()
			c.gravity = 0.0
			add_projectile("data/entities/projectiles/deck/mist_slime.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "MIST_BLOOD",
		name 		= "$action_mist_blood",
		description = "$actiondesc_mist_blood",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mist_blood.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_blood.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- MIST_BLOOD
		spawn_probability                 = "0.22,0.22,0.23,0.23", -- MIST_BLOOD
		price = 120,
		mana = 10,
		max_uses = 35,
		action 		= function()
			c.gravity = 0.0
			add_projectile("data/entities/projectiles/deck/mist_blood.xml")
			c.fire_rate_wait = c.fire_rate_wait + 13
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_MIST_RADIOACTIVE_TIMER",
		name 		= "$MIST_RADIOACTIVE_TIMER",
		description = "$dMIST_RADIOACTIVE_TIMER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mist_radioactive_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_radioactive.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- MIST_RADIOACTIVE
		spawn_probability                 = "0.25,0.15,0.2,0.2,0.1", -- MIST_RADIOACTIVE
		price = 110,
		mana = 45,
		max_uses = 15,
		action 		= function()
			c.gravity = 0.0
			add_projectile_trigger_timer("data/entities/projectiles/deck/mist_radioactive.xml",60,1)
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_MIST_ALCOHOL_TIMER",
		name 		= "$MIST_ALCOHOL_TIMER",
		description = "$dMIST_ALCOHOL_TIMER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mist_alcohol_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_alcohol.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- MIST_ALCOHOL
		spawn_probability                 = "0.15,0.25,0.2,0.2,0.05", -- MIST_ALCOHOL
		price = 110,
		mana = 45,
		max_uses = 16,
		action 		= function()
			c.gravity = 0.0
			add_projectile_trigger_timer("data/entities/projectiles/deck/mist_alcohol.xml",60,1)
			c.fire_rate_wait = c.fire_rate_wait + 7
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_MIST_SLIME_TIMER",
		name 		= "$MIST_SLIME_TIMER",
		description = "$dMIST_SLIME_TIMER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mist_slime_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_slime.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- MIST_SLIME
		spawn_probability                 = "0.2,0.2,0.25,0.15,0.05", -- MIST_SLIME
		price = 100,
		mana = 45,
		max_uses = 14,
		action 		= function()
			c.gravity = 0.0
			add_projectile_trigger_timer("data/entities/projectiles/deck/mist_slime.xml",60,1)
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_MIST_BLOOD_TIMER",
		name 		= "$MIST_BLOOD_TIMER",
		description = "$dMIST_BLOOD_TIMER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mist_blood_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_blood.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- MIST_BLOOD
		spawn_probability                 = "0.2,0.2,0.15,0.25,0.1", -- MIST_BLOOD
		price = 170,
		mana = 45,
		max_uses = 13,
		action 		= function()
			c.gravity = 0.0
			add_projectile_trigger_timer("data/entities/projectiles/deck/mist_blood.xml",60,1)
			c.fire_rate_wait = c.fire_rate_wait + 13
		end,
	},
	{
		id          = "CIRCLE_WATER",
		name 		= "$dcircle_fart",
		description = "$ddcircle_wtf",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_circle_water.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/circle_another_water.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4", -- CIRCLE_WATER
		spawn_probability                 = "0.02,0.04,0.08,0.06", -- CIRCLE_WATER
		price = 160,
		mana = -666,
		max_uses = 66,
		never_unlimited = true,
		ai_never_uses = true,
		action 		= function()
			mana = math.max( mana - 666, 66 )
			c.gravity = 0.0
			add_projectile("data/entities/projectiles/deck/de_circle_water.xml")
			c.fire_rate_wait = c.fire_rate_wait + 240
		end,
	},
	{
		id          = "CIRCLE_FIRE",
		name 		= "$dcircle_sewll",
		description = "$ddcircle_wtf",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_circle_fire.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/circle_end.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4", -- CIRCLE_FIRE
		spawn_probability                 = "0.02,0.04,0.08,0.06", -- CIRCLE_FIRE
		price = 170,
		mana = -666,
		max_uses = 66,
		never_unlimited = true,
		ai_never_uses = true,
		action 		= function()
			mana = math.max( mana - 666, 66 )
			c.gravity = 0.0
			add_projectile("data/entities/projectiles/deck/de_circle_fire.xml")
			c.fire_rate_wait = c.fire_rate_wait + 240
		end,
	},
	{
		id          = "CIRCLE_OIL",
		name 		= "$dcircle_nightmare",
		description = "$ddcircle_wtf",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_circle_oil.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/animals/boss_pit/boss_pit_spawner_ex.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4", -- CIRCLE_OIL
		spawn_probability                 = "0.02,0.04,0.08,0.06", -- CIRCLE_OIL
		price = 160,
		mana = -666,
		max_uses = 66,
		never_unlimited = true,
		ai_never_uses = true,
		action 		= function()
			mana = math.max( mana - 666, 666 )
			c.gravity = 0.0
			add_projectile("data/entities/projectiles/deck/de_circle_oil.xml")
			c.fire_rate_wait = c.fire_rate_wait + 240
		end,
	},
	{
		id          = "CIRCLE_ACID",
		name 		= "$dcircle_death",
		description = "$ddcircle_wtf",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_circle_acid.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/animals/boss_meat/orb_big.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4", -- CIRCLE_ACID
		spawn_probability                 = "0.02,0.04,0.08,0.06", -- CIRCLE_ACID
		price = 180,
		mana = -666,
		max_uses = 66,
		never_unlimited = true,
		ai_never_uses = true,
		action 		= function()
			mana = math.max( mana - 666, 666 )
			c.gravity = 0.0
			add_projectile("data/entities/projectiles/deck/de_circle_acid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 240
		end,
	},
	-- Materials --
	{
		id          = "MATERIAL_WATER",
		name 		= "$action_material_water",
		description = "$actiondesc_material_water",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/material_water.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/material_water_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/material_water.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5", -- MATERIAL_WATER
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_WATER
		price = 110,
		mana = -1,
		-- max_uses = DE_USAGE * 5,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_water.xml")
			c.gravity = 0.0
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_apply_wet.xml," )
			c.fire_rate_wait = c.fire_rate_wait - 15
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_OIL",
		name 		= "$action_material_oil",
		description = "$actiondesc_material_oil",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/material_oil.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/material_oil_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/material_oil.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5", -- MATERIAL_OIL
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_OIL
		price = 140,
		mana = -1,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_oil.xml")
			c.gravity = 0.0
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_apply_oiled.xml," )
			c.fire_rate_wait = c.fire_rate_wait - 15
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	-- Note( Petri ): 10.7.2019 - this could be just removed (vampirism, the limited uses in these is extremely silly)
	{
		id          = "MATERIAL_BLOOD",
		name 		= "$action_material_blood",
		description = "$actiondesc_material_blood",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/material_blood.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/material_blood_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/material_blood.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5", -- MATERIAL_BLOOD
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_BLOOD
		price = 130,
		-- max_uses = 250,
		mana = -1,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_blood.xml")
			c.gravity = 0.0
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_apply_bloody.xml," )
			c.fire_rate_wait = c.fire_rate_wait - 15
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_ACID",
		name 		= "$action_material_acid",
		description = "$actiondesc_material_acid",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/material_acid.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/material_acid_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/material_acid.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "2,3,4,5,6", -- MATERIAL_ACID
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_ACID
		price = 150,
		-- Note( Petri ): 10.7.2019 - removed uses. We have acid trail already
		-- max_uses = 250,
		mana = -1,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_acid.xml")
			c.gravity = 0.0
			c.fire_rate_wait = c.fire_rate_wait - 15
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_CEMENT",
		name 		= "$action_material_cement",
		description = "$actiondesc_material_cement",
		-- spawn_requires_flag = "card_unlocked_material_cement",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/material_cement.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/material_cement_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/material_cement.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "2,3,4,5,6", -- MATERIAL_CEMENT
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_CEMENT
		price = 100,
		-- Note( Petri ): 10.7.2019 - removed uses. We have acid trail already
		-- max_uses = 250,
		mana = -1,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_cement.xml")
			c.gravity = 0.0
			c.fire_rate_wait = c.fire_rate_wait - 15
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	-- SPELL STUFF
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_TELEPORT_PROJECTILE_GRENADE",
		name 		= "$TELEPORT_PROJECTILE_GRENADE",
		description = "$dTELEPORT_PROJECTILE_GRENADE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/grenade_teleport.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade_teleport.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7", -- TELEPORT_PROJECTILE
		spawn_probability                 = "0.35,0.35,0.35,0.3,0.2,0.2,0.1,0.1", -- TELEPORT_PROJECTILE
		price = 130,
		mana = 35,
		-- max_uses = 100,
		custom_xml_file = "data/entities/misc/custom_cards/grenade_teleport.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade_teleport.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.spread_degrees = math.min( 12.0, c.spread_degrees + 4.0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 5.0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_TELEPORT_PROJECTILE_LIGHTNING",
		name 		= "$TELEPORT_PROJECTILE_LIGHTNING",
		description = "$dTELEPORT_PROJECTILE_LIGHTNING",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/lightning_teleport.png",
		related_projectiles	= {"data/entities/projectiles/deck/lightning_teleport.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "7,10", -- TELEPORT_PROJECTILE
		spawn_probability                 = "0.3,0.06", -- TELEPORT_PROJECTILE
		price = 170,
		mana = 50,
		max_uses = 77,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/lightning_teleport.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/lightning_teleport.xml")
			c.fire_rate_wait = math.min( c.fire_rate_wait - 18, 0 )
			c.spread_degrees = math.min( c.spread_degrees - 30, 0 )
			c.damage_critical_chance = c.damage_critical_chance + 14
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 50.0
		end,
	},
	{
		id          = "TELEPORT_PROJECTILE",
		name 		= "$action_teleport_projectile",
		description = "$actiondesc_teleport_projectile",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/teleport_projectile.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/de_teleport_projectile.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7", -- TELEPORT_PROJECTILE
		spawn_probability                 = "0.35,0.35,0.35,0.3,0.2,0.2,0.1,0.3", -- TELEPORT_PROJECTILE
		price = 130,
		mana = 30,
		-- max_uses = 80,
		custom_xml_file = "data/entities/misc/custom_cards/teleport_projectile.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_teleport_projectile.xml")
			c.fire_rate_wait = c.fire_rate_wait + 2
			c.spread_degrees = math.min( 12.0, c.spread_degrees - 12.0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 20.0
		end,
	},
	{
		id          = "TELEPORT_PROJECTILE_SHORT",
		name 		= "$action_teleport_projectile_short",
		description = "$actiondesc_teleport_projectile_short",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/teleport_projectile_short.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_projectile_short.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7", -- TELEPORT_PROJECTILE
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.25,0.25,0.1,0.9", -- TELEPORT_PROJECTILE
		price = 130,
		mana = 25,
		-- max_uses = 60,
		custom_xml_file = "data/entities/misc/custom_cards/teleport_projectile_short.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_projectile_short.xml")
			c.spread_degrees = math.min( 12.0, c.spread_degrees - 8.0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
		end,
	},
	{
		id          = "TELEPORT_PROJECTILE_STATIC",
		name 		= "$action_teleport_projectile_static",
		description = "$actiondesc_teleport_projectile_static",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/teleport_projectile_static.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_projectile_static.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- TELEPORT_PROJECTILE_STATIC
		spawn_probability                 = "0.6,0.5,0.5,0.4,0.4,0.4", -- TELEPORT_PROJECTILE_STATIC
		price = 90,
		mana = 0,
		-- max_uses = 80,
		custom_xml_file = "data/entities/misc/custom_cards/teleport_projectile_static.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_projectile_static.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.spread_degrees = c.spread_degrees - 2.0
			shot_effects.recoil_knockback = 0
		end,
	},
	{
		id          = "SWAPPER_PROJECTILE",
		name 		= "$action_swapper_projectile",
		description = "$actiondesc_swapper_projectile",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/swapper_projectile.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/swapper.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- SWAPPER_PROJECTILE
		spawn_probability                 = "0.1,0.2,0.3,0.4,0.3,0.2", -- SWAPPER_PROJECTILE
		price = 100,
		mana = 0,
		-- max_uses = 120,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/swapper.xml")
			c.fire_rate_wait = c.fire_rate_wait - 12
			c.screenshake = c.screenshake + 2.5
			c.spread_degrees = c.spread_degrees - 10.0
			c.damage_critical_chance = clamp(  c.damage_critical_chance * 2, c.damage_critical_chance + 10, 10000000 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
		end,
	},
	{
		id          = "TELEPORT_PROJECTILE_CLOSER",
		name 		= "$action_teleport_closer",
		description = "$actiondesc_teleport_closer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/teleport_projectile_closer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_projectile_closer.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- TELEPORT_PROJECTILE
		spawn_probability                 = "0.3,0.4,0.5,0.6,0.4,0.2", -- TELEPORT_PROJECTILE
		price = 130,
		mana = 0,
		-- max_uses = 120,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_projectile_closer.xml")
			c.spread_degrees = c.spread_degrees - 360.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_HOOK_V2",
		name 		= "$HOOK_V2",
		description = "$dHOOK_V2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/hook_v2.png",
		related_projectiles	= {"data/entities/projectiles/deck/hook_v2.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,6", -- BULLET
		spawn_probability                 = "0.1,0.2,0.3,0.2,0.25,0.3", -- BULLET
		price = 130,
		mana = 8,
		-- max_uses = 25,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/hook_v2.xml")
			c.damage_critical_chance = c.damage_critical_chance + 8
			c.fire_rate_wait = c.fire_rate_wait + 36
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 16.0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_TELEPORT_PROJECTILE_V2",
		name 		= "$TELEPORT_PROJECTILE_V2",
		description = "$dTELEPORT_PROJECTILE_V2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/teleport_projectile_v2.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_projectile_v2_no_hole.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "3,4,5,6,7,10", -- TELEPORT_PROJECTILE
		spawn_probability                 = "0.3,0.3,0.4,0.4,0.3,0.05", -- TELEPORT_PROJECTILE
		price = 130,
		mana = 75,
		max_uses = 10,
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_projectile_v2.xml")
			c.lifetime_add = 0
			c.fire_rate_wait = c.fire_rate_wait + 42
			shot_effects.recoil_knockback = 0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SHOCKWAVE",
		name 		= "$SHOCKWAVE",
		description = "$dSHOCKWAVE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/shockwave.png",
		related_projectiles	= {"data/entities/projectiles/deck/shockwave.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- RUBBER_BALL
		spawn_probability                 = "0.3,0.3,0.2,0.4", -- RUBBER_BALL
		price = 60,
		mana = 0,
		max_uses = 45,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/shockwave.xml")
			c.speed_multiplier = 0.01
			c.child_speed_multiplier = 0.01
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 90.0
		end,
	},
	--[[
	{
		id          = "TELEPORT_HOME",
		name 		= "$action_teleport_home",
		description = "$actiondesc_teleport_home",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/teleport_home.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- TELEPORT_HOME
		spawn_probability                 = "", -- TELEPORT_HOME
		price = 100,
		mana = 70,
		max_uses    = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_home.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.screenshake = c.screenshake + 5.0
		end,
	},
	{
		id          = "LEVITATION_PROJECTILE",
		name 		= "$action_levitation_projectile",
		description = "$actiondesc_levitation_projectile",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/levitation_projectile.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- LEVITATION_PROJECTILE
		spawn_probability                        = "", -- LEVITATION_PROJECTILE
		price = 100,
		mana = 80,
		custom_xml_file = "data/entities/misc/custom_cards/levitation_projectile.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/levitation_projectile.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			c.spread_degrees = c.spread_degrees - 1.0
		end,
	},
	]]--
	-- one shot actions -------------------------
	{
		id          = "NUKE",
		name 		= "$action_nuke",
		description = "$actiondesc_nuke",
		-- spawn_requires_flag = "card_unlocked_nuke",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/nuke.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/nuke_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/nuke.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,5,6,10", -- NUKE
		spawn_probability                 = "0.01,0.1,0.1,0.01", -- NUKE
		price = 400,
		mana = 200,
		max_uses    = 10,
		custom_xml_file = "data/entities/misc/custom_cards/nuke.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/nuke.xml")
			c.fire_rate_wait = 20
			c.speed_multiplier = math.max( c.speed_multiplier * 0.75, 0 )
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 1.25, 0 )
			c.material = "fire"
			c.material_amount = c.material_amount + 50
			c.ragdoll_fx = 2
			c.gore_particles = c.gore_particles + 10
			c.screenshake = c.screenshake + 10.5
			current_reload_time = current_reload_time + 600
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 300.0
		end,
	},
	{
		id          = "NUKE_GIGA",
		name 		= "$action_nuke_giga",
		description = "$actiondesc_nuke_giga",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/nuke_giga.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/nuke_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/nuke_giga.xml"},
		-- spawn_requires_flag = "card_unlocked_nukegiga",
		spawn_manual_unlock = true,
		never_unlimited		= true,
		recursive	= true,
		ai_never_uses = true,
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "7,10", -- NUKE
		spawn_probability                 = "0.1,0.01", -- NUKE
		price = 800,
		mana = 250,
		max_uses    = 5,
		custom_xml_file = "data/entities/misc/custom_cards/nuke_giga.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/nuke_giga.xml")
			c.fire_rate_wait = 50
			c.speed_multiplier = math.max( c.speed_multiplier * 0.5, 0 )
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 1.5, 0 )
			c.material = "cloud_radioactive"
			c.material_amount = c.material_amount + 90
			c.ragdoll_fx = 2
			c.gore_particles = c.gore_particles + 30
			c.screenshake = c.screenshake + 30.5
			current_reload_time = current_reload_time + 800
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 300.0
		end,
	},
	--[[
	{
		id          = "HIGH_EXPLOSIVE",
		name 		= "$action_high_explosive",
		description = "$actiondesc_high_explosive",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/high_explosive.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- HIGH_EXPLOSIVE
		spawn_probability                        = "", -- HIGH_EXPLOSIVE
		price = 100,
		max_uses    = 5,
		custom_xml_file = "data/entities/misc/custom_cards/high_explosive.xml",
		action 		= function()
			c.explosion_radius = c.explosion_radius + 64.0
			c.damage_explosion = c.damage_explosion + 3.2
			c.fire_rate_wait   = c.fire_rate_wait + 10
			c.speed_multiplier = c.speed_multiplier * 0.75
			c.ragdoll_fx = 2
			c.explosion_damage_to_materials = c.explosion_damage_to_materials + 300000
		end,
	},
	{
		id          = "DRONE",
		name 		= "$action_drone",
		description = "$actiondesc_drone",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/drone.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- DRONE
		spawn_probability                        = "", -- DRONE
		price = 100,
		mana = 60,
		max_uses    = 5,
		custom_xml_file = "data/entities/misc/custom_cards/action_drone.xml",
		action 		= function()
			add_projectile("data/entities/misc/player_drone.xml")
			c.fire_rate_wait = c.fire_rate_wait + 60
		end,
	},
	]]--
	-- all is code --------------------------------------
	--[[{
		id          = "BAAB_IS",
		name 		= "$action_baab_is",
		description = "$actiondesc_baab_is",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/baab_is.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/baab_is.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_IS
		spawn_probability                 = "", -- BAAB_IS
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "is" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_ALL",
		name 		= "$action_baab_all",
		description = "$actiondesc_baab_all",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/baab_all.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/baab_all.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_ALL
		spawn_probability                 = "", -- BAAB_ALL
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "all" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_EMPTY",
		name 		= "$action_baab_empty",
		description = "$actiondesc_baab_empty",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/baab_empty.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/baab_empty.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_EMPTY
		spawn_probability                 = "", -- BAAB_EMPTY
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "empty" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_LAVA",
		name 		= "$action_baab_lava",
		description = "$actiondesc_baab_lava",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/baab_lava.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/baab_lava.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_LAVA
		spawn_probability                 = "", -- BAAB_LAVA
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "lava" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_WATER",
		name 		= "$action_baab_water",
		description = "$actiondesc_baab_water",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/baab_water.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/baab_water.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_WATER
		spawn_probability                 = "", -- BAAB_WATER
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "water" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_POOP",
		name 		= "$action_baab_poop",
		description = "$actiondesc_baab_poop",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/baab_poop.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/baab_poop.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_POOP
		spawn_probability                 = "", -- BAAB_POOP
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "poo" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_LOVE",
		name 		= "$action_baab_love",
		description = "$actiondesc_baab_love",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/baab_love.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/baab_love.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_LOVE
		spawn_probability                 = "", -- BAAB_LOVE
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "magic_liquid_charm" )
			draw_actions( 1, true )
		end,
	},]]--
	{
		id          = "FIREWORK",
		name 		= "$action_firework",
		description = "$actiondesc_firework",
		-- spawn_requires_flag = "card_unlocked_firework",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/fireworks.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/fireworks/firework_pink.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,6", -- FIREWORK
		spawn_probability                 = "1,0.8,1,1,0.5,0.3", -- FIREWORK
		price = 220,
		mana = 35,
		max_uses = 42, 
		action 		= function()
			local year, month, day = GameGetDateAndTimeLocal()

			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )

			local types = {"pink","green","blue","orange"}
			local rnd = Random(1,#types)
			local firework_name = "firework_"

			if ( month ~= 4 and day ~= 1 ) or ( Random(1,10) > 7 ) then
				firework_name = "new_year/" .. firework_name
			else
				firework_name = "fireworks/" .. firework_name
			end

			firework_name = firework_name .. tostring(types[rnd]) .. ".xml"

			add_projectile("data/entities/projectiles/deck/" .. firework_name)

			c.fire_rate_wait = c.fire_rate_wait + 30
			c.ragdoll_fx = 2
			shot_effects.recoil_knockback = 30.0
		end,
	},
	{	
		id          = "SUMMON_WANDGHOST",
		name 		= "$action_summon_wandghost",
		description = "$actiondesc_summon_wandghost",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/summon_wandghost.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/wand_ghost_player.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "2,4,5,6,7,10", -- SUMMON_WANDGHOST
		spawn_probability                 = "0.08,0.1,0.3,0.3,0.5,0.25", -- SUMMON_WANDGHOST
		price = 420,
		mana = 648,
		max_uses    = 4, 
		never_unlimited = true,
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/wand_ghost_player.xml")
			add_projectile("data/entities/particles/image_emitters/wand_effect.xml")
		end,
	},
	{
		id          = "TOUCH_GOLD",
		name 		= "$action_touch_gold",
		description = "$actiondesc_touch_gold",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/touch_gold.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_gold.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,10", -- TOUCH_GOLD
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.002", -- TOUCH_GOLD
		price = 480,
		mana = 99,
		max_uses    = 1,
		never_unlimited = true,
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_gold.xml")
		end,
	},
	{
		id          = "TOUCH_WATER",
		name 		= "$action_touch_water",
		description = "$actiondesc_touch_water",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/touch_water.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_water.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,10", -- TOUCH_WATER
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.002", -- TOUCH_WATER
		price = 420,
		mana = 99,
		max_uses    = 5, 
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_water.xml")
		end,
	},
	{
		id          = "TOUCH_OIL",
		name 		= "$action_touch_oil",
		description = "$actiondesc_touch_oil",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/touch_oil.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_oil.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,10", -- TOUCH_OIL
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.002", -- TOUCH_OIL
		price = 380,
		mana = 99,
		max_uses    = 5, 
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_oil.xml")
		end,
	},
	{
		id          = "TOUCH_ALCOHOL",
		name 		= "$action_touch_alcohol",
		description = "$actiondesc_touch_alcohol",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/touch_alcohol.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_alcohol.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,10", -- TOUCH_ALCOHOL
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.002", -- TOUCH_ALCOHOL
		price = 360,
		mana = 99,
		max_uses    = 5, 
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_alcohol.xml")
		end,
	},
	{
		id          = "TOUCH_PISS",
		name 		= "$action_touch_piss",
		description = "$actiondesc_touch_piss",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/touch_piss.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_piss.xml"},
		-- spawn_requires_flag = "card_unlocked_piss",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,10", -- TOUCH_PISS
		spawn_probability                 = "0,0,0,0,0.035,0.035,0.001", -- TOUCH_PISS
		price = 360,
		mana = 99,
		max_uses    = 4, 
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_piss.xml")
		end,
	},
	{
		id          = "TOUCH_GRASS",
		name 		= "$action_touch_grass",
		description = "$actiondesc_touch_grass",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/touch_grass.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_grass.xml"},
		-- spawn_requires_flag = "card_unlocked_touch_grass",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,10", -- TOUCH_GRASS
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.002", -- TOUCH_GRASS
		-- spawn_requires_flag = "card_unlocked_touch_grass",
		price = 360,
		mana = 99,
		max_uses    = 4, 
		ai_never_uses = true,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/touch_grass.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_grass.xml")
		end,
	},
	{
		id          = "TOUCH_BLOOD",
		name 		= "$action_touch_blood",
		description = "$actiondesc_touch_blood",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/touch_blood.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_blood.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,10", -- TOUCH_BLOOD
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.002", -- TOUCH_BLOOD
		price = 390,
		mana = 99,
		max_uses    = 3, 
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_blood.xml")
		end,
	},
	{
		id          = "TOUCH_SMOKE",
		name 		= "$action_touch_smoke",
		description = "$actiondesc_touch_smoke",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/touch_smoke.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_smoke.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,10", -- TOUCH_SMOKE
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.002", -- TOUCH_SMOKE
		price = 350,
		mana = 99,
		max_uses    = 5, 
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_smoke.xml")
		end,
	},
	{
		id          = "DESTRUCTION",
		name 		= "$action_destruction",
		description = "$actiondesc_destruction",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/destruction.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/destruction.xml"},
		-- spawn_requires_flag = "card_unlocked_destruction",
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "7,10", -- DESTRUCTION
		spawn_probability                 = "0.1,0.9", -- DESTRUCTION
		price = 600,
		mana = 240,
		max_uses    = 5,
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/destruction.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "MASS_POLYMORPH",
		name 		= "$action_mass_polymorph",
		description = "$actiondesc_mass_polymorph",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/polymorph.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mass_polymorph.xml"},
		-- spawn_requires_flag = "card_unlocked_polymorph",
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "7,10", -- DESTRUCTION
		spawn_probability                 = "0.1,0.9", -- DESTRUCTION
		price = 600,
		mana = 220,
		max_uses    = 3,
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/mass_polymorph.xml")
			c.fire_rate_wait = c.fire_rate_wait + 140
			current_reload_time = current_reload_time + 240
		end,
	},
	-- modifiers
	{
		id          = "BURST_2",
		name 		= "$action_burst_2",
		description = "$actiondesc_burst_2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/burst_2.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/burst_2_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6", -- BURST_2
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.8,0.8,0.8", -- BURST_2
		price = 140,
		mana = 0,
		-- max_uses = DE_USAGE * 20,
		action 		= function()
			draw_actions( 2, true )
		end,
	},
	{
		id          = "BURST_3",
		name 		= "$action_burst_3",
		description = "$actiondesc_burst_3",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/burst_3.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/burst_3_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3,4,5,6", -- BURST_3
		spawn_probability                 = "0.7,0.7,0.7,0.7,0.7,0.7", -- BURST_3
		price = 160,
		mana = 2,
		-- max_uses = DE_USAGE * 6,
		action 		= function()
			draw_actions( 3, true )
		end,
	},
	{
		id          = "BURST_4",
		name 		= "$action_burst_4",
		description = "$actiondesc_burst_4",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/burst_4.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/burst_4_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "2,3,4,5,6", -- BURST_4
		spawn_probability                 = "0.4,0.5,0.6,0.6,0.6", -- BURST_4
		price = 180,
		mana = 4,
		-- max_uses = DE_USAGE * 4,
		action 		= function()
			draw_actions( 4, true )
		end,
	},
	{
		id          = "BURST_8",
		name 		= "$action_burst_8",
		description = "$actiondesc_burst_8",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/burst_8.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/burst_4_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "5,6,10", -- BURST_4
		spawn_probability                 = "0.1,0.1,0.5", -- BURST_4
		price = 300,
		mana = 8,
		-- max_uses = DE_USAGE * 4,
		action 		= function()
			draw_actions( 8, true )
		end,
	},
	{
		id          = "BURST_X",
		name 		= "$action_burst_x",
		description = "$actiondesc_burst_x",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/burst_x.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/burst_4_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "5,6,10", -- BURST_4
		spawn_probability                 = "0.1,0.1,0.15", -- BURST_4
		price = 500,
		mana = 20,
		-- max_uses = 50,
		action 		= function()
			if ( #deck > 0 ) then
				draw_actions( #deck, true )
			end
		end,
	},
	{

		id          = "SCATTER_2",
		name 		= "$action_scatter_2",
		description = "$actiondesc_scatter_2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/scatter_2.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/scatter_2_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2", -- SCATTER_2
		spawn_probability                 = "0.8,0.8,0.7", -- SCATTER_2
		price = 100,
		mana = 0,
		-- max_uses = DE_USAGE * 24,
		action 		= function()
			draw_actions( 2, true )
			c.spread_degrees = c.spread_degrees + 10.0
		end,
	},
	{
		id          = "SCATTER_3",
		name 		= "$action_scatter_3",
		description = "$actiondesc_scatter_3",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/scatter_3.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/scatter_3_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                      = "0,1,2,3", -- SCATTER_3
		spawn_probability                = "0.6,0.7,0.7,0.8", -- SCATTER_3
		price = 120,
		mana = 1,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			draw_actions( 3, true )
			c.spread_degrees = c.spread_degrees + 20.0
		end,
	},
	{
		id          = "SCATTER_4",
		name 		= "$action_scatter_4",
		description = "$actiondesc_scatter_4",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/scatter_4.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/scatter_4_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3,4,5,6", -- SCATTER_4
		spawn_probability                 = "0.5,0.6,0.7,0.8,0.8,0.6", -- SCATTER_4
		price = 140,
		mana = 2,
		-- max_uses = DE_USAGE * 10,
		action 		= function()
			draw_actions( 4, true )
			c.spread_degrees = c.spread_degrees + 40.0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SCATTER_32",
		name 		= "$SCATTER_32",
		description = "$dSCATTER_32",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/scatter_32.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/scatter_4_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		-- spawn_requires_flag = "card_unlocked_musicbox",
		spawn_level                       = "3,4,10", -- SCATTER_4
		spawn_probability                 = "0.1,0.1,0.15", -- SCATTER_4
		price = 140,
		mana = 8,
		-- max_uses = 125,
		action 		= function()
			draw_actions( 32, true )
			c.spread_degrees = c.spread_degrees + 180.0
		end,
	},
	-- Hexapentacontadicta Scatter Spell 256
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SINGLE_SHAPE",
		name 		= "$SINGLE_SHAPE",
		description = "$dSINGLE_SHAPE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/single_shape.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		-- spawn_requires_flag = "card_unlocked_musicbox",
		spawn_level                       = "0,1,2", -- I_SHAPE
		spawn_probability                 = "0.1,0.2,0.3", -- I_SHAPE
		price = 10,
		mana = 0,
		-- max_uses = DE_USAGE * 50,
		action 		= function()
			c.pattern_degrees = 0.5
			draw_actions(1, true)
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
		end,
	},
	{
		id          = "I_SHAPE",
		name 		= "$action_i_shape",
		description = "$actiondesc_i_shape",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/i_shape.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3", -- I_SHAPE
		spawn_probability                 = "0.4,0.5,0.3", -- I_SHAPE
		price = 30,
		mana = 0,
		-- max_uses = DE_USAGE * 30,
		action 		= function()
			c.pattern_degrees = 180
			draw_actions(2, true)
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
		end,
	},
	{
		id          = "Y_SHAPE",
		name 		= "$action_y_shape",
		description = "$actiondesc_y_shape",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/y_shape.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/y_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3", -- Y_SHAPE
		spawn_probability                 = "0.8,0.5,0.4,0.3", -- Y_SHAPE
		price = 30,
		mana = 0,
		-- max_uses = DE_USAGE * 30,
		action 		= function()
			c.pattern_degrees = 45
			draw_actions(2, true)
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
		end,
	},
	{
		id          = "T_SHAPE",
		name 		= "$action_t_shape",
		description = "$actiondesc_t_shape",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/t_shape.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/t_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3,4", -- T_SHAPE
		spawn_probability                 = "0.4,0.5,0.4,0.3", -- T_SHAPE
		price = 30,
		mana = 1,
		-- max_uses = DE_USAGE * 15,
		action 		= function()
			c.pattern_degrees = 90
			draw_actions(3, true)
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
		end,
	},
	{
		id          = "W_SHAPE",
		name 		= "$action_w_shape",
		description = "$actiondesc_w_shape",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/w_shape.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/w_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "2,3,4,5,6", -- W_SHAPE
		spawn_probability                 = "0.4,0.3,0.5,0.3,0.3", -- W_SHAPE
		price = 50,
		mana = 1,
		-- max_uses = DE_USAGE * 15,
		action 		= function()
			c.pattern_degrees = 20
			draw_actions(3, true)
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
		end,
	},
	{
		id          = "CIRCLE_SHAPE",
		name 		= "$action_circle_shape",
		description = "$actiondesc_circle_shape",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/circle_shape.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/circle_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3,4,5,6", -- CIRCLE_SHAPE
		spawn_probability                 = "0.1,0.2,0.3,0.3,0.3,0.3", -- CIRCLE_SHAPE
		price = 50,
		mana = 4,
		-- max_uses = DE_USAGE * 14,
		action 		= function()
			c.pattern_degrees = 180
			draw_actions(6, true)
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
		end,
	},
	{
		id          = "PENTAGRAM_SHAPE",
		name 		= "$action_pentagram_shape",
		description = "$actiondesc_pentagram_shape",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/pentagram_shape.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/pentagram_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3,4,5", -- PENTAGRAM_SHAPE
		spawn_probability                 = "0.4,0.4,0.3,0.2,0.1", -- PENTAGRAM_SHAPE
		price = 50,
		mana = 3,
		-- max_uses = DE_USAGE * 14,
		action 		= function()
			c.pattern_degrees = 180
			draw_actions(5, true)
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
			--c.rad_pattern_degrees_offset = 150 // TODO: implement this
			--c.pattern_pos_offset = 30
		end,
	},
	{
		id          = "I_SHOT",
		name 		= "$action_i_shot",
		description = "$actiondesc_i_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/i_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "1,2,3", -- I_SHAPE
		spawn_probability                 = "0.1,0.2,0.5", -- I_SHAPE
		price = 130,
		mana = 2,
		max_uses = 10,
		action 		= function()
			local data
			
			if ( #deck > 0 ) then
				data = deck[1]
			end
			
			if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local count = 2
				for i=1,count-1 do
					if ( mana >= data.mana ) then
						local proj = data.related_projectiles[1]
						local proj_count = data.related_projectiles[2] or 1
						
						for a=1,proj_count do
							add_projectile(proj)
						end
						
						mana = mana - data.mana
					else
						OnNotEnoughManaForAction()
						break
					end
				end
			end
			
			c.pattern_degrees = 180
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "Y_SHOT",
		name 		= "$action_y_shot",
		description = "$actiondesc_y_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/y_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "1,2,3", -- I_SHAPE
		spawn_probability                 = "0.1,0.2,0.5", -- I_SHAPE
		price = 135,
		mana = 4,
		max_uses = 10,
		action 		= function()
			local data
			
			if ( #deck > 0 ) then
				data = deck[1]
			end
			
			if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local count = 2
				for i=1,count-1 do
					if ( mana >= data.mana ) then
						local proj = data.related_projectiles[1]
						local proj_count = data.related_projectiles[2] or 1
						
						for a=1,proj_count do
							add_projectile(proj)
						end
						
						mana = mana - data.mana
					else
						OnNotEnoughManaForAction()
						break
					end
				end
			end
			
			c.pattern_degrees = 45
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "T_SHOT",
		name 		= "$action_t_shot",
		description = "$actiondesc_t_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/t_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "2,3,5", -- I_SHAPE
		spawn_probability                 = "0.1,0.2,0.5", -- I_SHAPE
		price = 160,
		mana = 5,
		max_uses = 10,
		action 		= function()
			local data
			
			if ( #deck > 0 ) then
				data = deck[1]
			end
			
			if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local count = 3
				for i=1,count-1 do
					if ( mana >= data.mana ) then
						local proj = data.related_projectiles[1]
						local proj_count = data.related_projectiles[2] or 1
						
						for a=1,proj_count do
							add_projectile(proj)
						end
						
						mana = mana - data.mana
					else
						OnNotEnoughManaForAction()
						break
					end
				end
			end
			
			c.pattern_degrees = 90
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "W_SHOT",
		name 		= "$action_w_shot",
		description = "$actiondesc_w_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/w_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "2,3,5,6", -- I_SHAPE
		spawn_probability                 = "0.1,0.2,0.5,0.4", -- I_SHAPE
		price = 180,
		mana = 6,
		max_uses = 10,
		action 		= function()
			local data
			
			if ( #deck > 0 ) then
				data = deck[1]
			end
			
			if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local count = 3
				for i=1,count-1 do
					if ( mana >= data.mana ) then
						local proj = data.related_projectiles[1]
						local proj_count = data.related_projectiles[2] or 1
						
						for a=1,proj_count do
							add_projectile(proj)
						end
						
						mana = mana - data.mana
					else
						OnNotEnoughManaForAction()
						break
					end
				end
			end
			
			c.pattern_degrees = 20
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "QUAD_SHOT",
		name 		= "$action_quad_shot",
		description = "$actiondesc_quad_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/quad_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "1,2,4", -- I_SHAPE
		spawn_probability                 = "0.1,0.2,0.5", -- I_SHAPE
		price = 200,
		mana = 10,
		max_uses = 10,
		action 		= function()
			local data
			
			if ( #deck > 0 ) then
				data = deck[1]
			end
			
			if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local count = 4
				for i=1,count-1 do
					if ( mana >= data.mana ) then
						local proj = data.related_projectiles[1]
						local proj_count = data.related_projectiles[2] or 1
						
						for a=1,proj_count do
							add_projectile(proj)
						end
						
						mana = mana - data.mana
					else
						OnNotEnoughManaForAction()
						break
					end
				end
			end
			
			c.pattern_degrees = 180
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "PENTA_SHOT",
		name 		= "$action_penta_shot",
		description = "$actiondesc_penta_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/penta_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "3,4,5,6,10", -- I_SHAPE
		spawn_probability                 = "0.1,0.2,0.5,0.5,0.2", -- I_SHAPE
		price = 250,
		mana = 15,
		max_uses = 10,
		action 		= function()
			local data
			
			if ( #deck > 0 ) then
				data = deck[1]
			end
			
			if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local count = 5
				for i=1,count-1 do
					if ( mana >= data.mana ) then
						local proj = data.related_projectiles[1]
						local proj_count = data.related_projectiles[2] or 1
						
						for a=1,proj_count do
							add_projectile(proj)
						end
						
						mana = mana - data.mana
					else
						OnNotEnoughManaForAction()
						break
					end
				end
			end
			
			c.pattern_degrees = 180
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HEXA_SHOT",
		name 		= "$action_hexa_shot",
		description = "$actiondesc_hexa_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/hexa_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "3,4,5,6,10", -- I_SHAPE
		spawn_probability                 = "0.1,0.2,0.5,0.5,0.2", -- I_SHAPE
		price = 280,
		mana = 20,
		max_uses = 10,
		action 		= function()
			local data
			
			if ( #deck > 0 ) then
				data = deck[1]
			end
			
			if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local count = 6
				for i=1,count-1 do
					if ( mana >= data.mana ) then
						local proj = data.related_projectiles[1]
						local proj_count = data.related_projectiles[2] or 1
						
						for a=1,proj_count do
							add_projectile(proj)
						end
						
						mana = mana - data.mana
					else
						OnNotEnoughManaForAction()
						break
					end
				end
			end
			
			c.pattern_degrees = 180
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_INF_SHOT",
		name 		= "$INF_SHOT",
		description = "$dINF_SHOT",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/inf_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "4,5,6,7,10", -- I_SHAPE
		spawn_probability                 = "0.1,0.35,0.6,0.2,0.25", -- I_SHAPE
		price = 330,
		mana = 30,
		max_uses = 4,
		action 		= function()
			local degrees, count = 180, 0
			local data, proj, proj_count, mana_need
			
			if #deck > 0 then data = deck[1] end

			-- won't check ACTION_TYPE now
			if data ~= nil and data.related_projectiles ~= nil
				and ( data.uses_remaining == nil or data.uses_remaining ~= 0 )
			then
				proj = data.related_projectiles[1]
				proj_count = data.related_projectiles[2] or 1

				proj_count = math.max( proj_count, 1 )
				mana_need = data.mana / proj_count

				mana_need = math.max( mana_need, 0.01 )
				count = math.floor( mana / mana_need )

				if count > 0 then
					proj_count = math.max( proj_count, 180 - proj_count )
					count = math.min( count, proj_count )

					mana_need = math.ceil( mana_need * count )
					mana = clamp( mana - mana_need, 0, mana )

					degrees = clamp( count * 5 - 5, 0.5, degrees )
					for i=1,count do add_projectile( proj ) end
				else
					OnNotEnoughManaForAction()
				end
			end
			
			c.pattern_degrees = degrees
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
			c.fire_rate_wait = c.fire_rate_wait + 20
			current_reload_time = current_reload_time + 20
			
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_MULT_TRIGGER",
		name 		= "$MULT_TRIGGER",
		description = "$dMULT_TRIGGER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mult_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "5,6,7,10", -- I_SHAPE
		spawn_probability                 = "0.25,0.45,0.15,0.05", -- I_SHAPE
		price = 360,
		mana = 60,
		max_uses = 45,
		action 		= function()
			if #deck > 0 then
				local data,find
				local timer_list = {-3,-3,-3}
				local length_max = clamp( #deck, 1, 31 )

				for i=1,#deck do
					data = deck[i]
					
					if ( data == nil ) or ( i > length_max ) then
						draw_actions( 1, false )
						break
					elseif ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
						find = i
						break
					elseif data.id == "DE_MULT_TRIGGER" then
						table.insert( timer_list, -3 )
						table.insert( timer_list, -3 )
					elseif data.id == "DE_MULT_DEATH" then
						table.insert( timer_list, 0 )
						table.insert( timer_list, 0 )
					elseif data.id == "DE_MULT_TIMER" then
						table.insert( timer_list, timer_list[#timer_list] + 15 )
						table.insert( timer_list, timer_list[#timer_list] + 15 )
					else
						draw_actions( 1, true )
						break
					end
				end

				if find ~= nil then
					for i=1,find do
						if #deck == 0 then break end
						
						table.insert( discarded, deck[1] )
						table.remove( deck, 1 )
					end

					DEEP_END_add_projectile_trigger_customized( data.related_projectiles[1], timer_list, nil, false )
				end
			end

			c.fire_rate_wait = math.min( c.fire_rate_wait + 26, 26 )
			current_reload_time = clamp( current_reload_time + 26, 26, 52)
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_MULT_TIMER",
		name 		= "$MULT_TIMER",
		description = "$dMULT_TIMER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mult_timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "5,6,7,10", -- I_SHAPE
		spawn_probability                 = "0.25,0.45,0.15,0.05", -- I_SHAPE
		price = 360,
		mana = 55,
		max_uses = 45,
		action 		= function()
			if #deck > 0 then
				local data,find
				local timer_list = {15,30,45}
				local length_max = clamp( #deck, 1, 31 )

				for i=1,#deck do
					data = deck[i]
					
					if ( data == nil ) or ( i > length_max ) then
						draw_actions( 1, false )
						break
					elseif ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
						find = i
						break
					elseif data.id == "DE_MULT_TRIGGER" then
						table.insert( timer_list, -3 )
						table.insert( timer_list, -3 )
					elseif data.id == "DE_MULT_DEATH" then
						table.insert( timer_list, 0 )
						table.insert( timer_list, 0 )
					elseif data.id == "DE_MULT_TIMER" then
						table.insert( timer_list, timer_list[#timer_list] + 15 )
						table.insert( timer_list, timer_list[#timer_list] + 15 )
					else
						draw_actions( 1, true )
						break
					end
				end

				if find ~= nil then
					for i=1,find do
						if #deck == 0 then break end
						
						table.insert( discarded, deck[1] )
						table.remove( deck, 1 )
					end

					DEEP_END_add_projectile_trigger_customized( data.related_projectiles[1], timer_list, nil, false )
				end
			end

			c.fire_rate_wait = math.min( c.fire_rate_wait + 26, 26 )
			current_reload_time = clamp( current_reload_time + 26, 26, 52)
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_MULT_DEATH",
		name 		= "$MULT_DEATH",
		description = "$dMULT_DEATH",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mult_death.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "5,6,7,10", -- I_SHAPE
		spawn_probability                 = "0.25,0.45,0.15,0.05", -- I_SHAPE
		price = 360,
		mana = 50,
		max_uses = 45,
		action 		= function()
			if #deck > 0 then
				local data,find
				local timer_list = {0,0,0}
				local length_max = clamp( #deck, 1, 31 )

				for i=1,#deck do
					data = deck[i]
					
					if ( data == nil ) or ( i > length_max ) then
						draw_actions( 1, false )
						break
					elseif ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
						find = i
						break
					elseif data.id == "DE_MULT_TRIGGER" then
						table.insert( timer_list, -3 )
						table.insert( timer_list, -3 )
					elseif data.id == "DE_MULT_DEATH" then
						table.insert( timer_list, 0 )
						table.insert( timer_list, 0 )
					elseif data.id == "DE_MULT_TIMER" then
						table.insert( timer_list, timer_list[#timer_list] + 15 )
						table.insert( timer_list, timer_list[#timer_list] + 15 )
					else
						draw_actions( 1, true )
						break
					end
				end

				if find ~= nil then
					for i=1,find do
						if #deck == 0 then break end
						
						table.insert( discarded, deck[1] )
						table.remove( deck, 1 )
					end

					DEEP_END_add_projectile_trigger_customized( data.related_projectiles[1], timer_list, nil, false )
				end
			end

			c.fire_rate_wait = math.min( c.fire_rate_wait + 26, 26 )
			current_reload_time = clamp( current_reload_time + 26, 26, 52)
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_CAST_FOLD",
		name 		= "$CAST_FOLD",
		description = "$dCAST_FOLD",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/cast_fold.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "6,7,10", -- I_SHAPE
		spawn_probability                 = "0.2,0.05,0.025", -- I_SHAPE
		price = 10,
		mana = 0,
		max_uses = 9999,
		action 		= function()
			draw_actions( 0, false )
			dont_draw_actions = true

			if DE_DRAW_STATE == GameGetFrameNum() then
				reloading = true -- stop drawing anything until next cast
			else
				DE_DRAW_STATE = GameGetFrameNum() -- bug may occur when multiple wands are used at the same time
			end
		end,
	},
	{
		id          = "SPREAD_REDUCE",
		name 		= "$action_spread_reduce",
		description = "$actiondesc_spread_reduce",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/spread_reduce.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- SPREAD_REDUCE
		spawn_probability                 = "0.5,0.4,0.5,0.4,0.5,0.4", -- SPREAD_REDUCE
		price = 100,
		mana = 1,
		--max_uses = 150,
		action 		= function()
			c.spread_degrees = c.spread_degrees - 90.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HEAVY_SPREAD",
		name 		= "$action_heavy_spread",
		description = "$actiondesc_heavy_spread",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/heavy_spread.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,4,5,6", -- HEAVY_SPREAD
		spawn_probability                 = "0.4,0.5,0.6,0.6,0.5,0.4", -- HEAVY_SPREAD
		price = 100,
		mana = 2,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait - 16
			current_reload_time = current_reload_time - 16
			c.spread_degrees = c.spread_degrees + 720
			draw_actions( 1, true )
		end,
	},
	{
		id          = "RECHARGE",
		name 		= "$action_recharge",
		description = "$actiondesc_recharge",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/recharge.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- RECHARGE
		spawn_probability                 = "0.5,0.6,0.7,0.5,0.6,0.7", -- RECHARGE
		price = 200,
		mana = 9,
		--max_uses = 150,
		action 		= function()
			c.fire_rate_wait    = c.fire_rate_wait - 20
			current_reload_time = current_reload_time - 20
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIFETIME",
		name 		= "$action_lifetime",
		description = "$actiondesc_lifetime",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/lifetime.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,6,10", -- LIFETIME
		spawn_probability                 = "0.48,0.56,0.64,0.72,0.1", -- LIFETIME
		price = 250,
		mana = 25,
		max_uses = 120,
		custom_xml_file = "data/entities/misc/custom_cards/lifetime.xml",
		action 		= function()
			c.lifetime_add = c.lifetime_add + 75
			c.fire_rate_wait = c.fire_rate_wait + 13
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIFETIME_DOWN",
		name 		= "$action_lifetime_down",
		description = "$actiondesc_lifetime_down",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/lifetime_down.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,6,10", -- LIFETIME_DOWN
		spawn_probability                 = "0.72,0.64,0.56,0.48,0.1", -- LIFETIME_DOWN
		price = 90,
		mana = 5,
		max_uses = 120,
		custom_xml_file = "data/entities/misc/custom_cards/lifetime_down.xml",
		action 		= function()
			c.lifetime_add = c.lifetime_add - 42
			c.fire_rate_wait = c.fire_rate_wait - 15
			draw_actions( 1, true )
		end,
	},
	{
		id          = "NOLLA",
		name 		= "$action_nolla",
		description = "$actiondesc_nolla",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/nolla.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_pyramid",
		related_extra_entities = { "data/entities/misc/nolla.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,5,6,7,10", -- LIFETIME_DOWN
		spawn_probability                 = "0.45,0.3,0.45,0.6,0.4,0.25", -- LIFETIME_DOWN
		price = 55,
		mana = 1,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/nolla.xml," )
			c.fire_rate_wait = c.fire_rate_wait - 15
			draw_actions( 1, true )
		end,
	},
	{
		id          = "SLOW_BUT_STEADY",
		name 		= "$action_slow_but_steady",
		description = "$ddSLOW_BUT_STEADY",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/slow_but_steady.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/misc/de_slow_but_steady.xml" },
		-- spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,6,10", -- LIFETIME
		spawn_probability                 = "0.25,0.25,0.5,0.5,0.25", -- LIFETIME
		price = 55,
		mana = 15,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/de_slow_but_steady.xml," )
			current_reload_time = clamp( math.max( math.ceil( shot_effects.recoil_knockback * 2 ) + 24, current_reload_time - 36 ), 18, 78 )
			shot_effects.recoil_knockback = 0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "EXPLOSION_REMOVE",
		name 		= "$action_explosion_remove",
		description = "$actiondesc_explosion_remove",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/explosion_remove.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/misc/explosion_remove.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,5,6", -- LIFETIME_DOWN
		spawn_probability                 = "0.2,0.6,0.6,0.2", -- LIFETIME_DOWN
		price = 50,
		mana = 0,
		max_uses = 150,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/explosion_remove.xml," )
			c.fire_rate_wait = c.fire_rate_wait - 15
			c.explosion_radius = clamp( c.explosion_radius - 30.0, 0, 256 )
			c.damage_explosion_add = c.damage_explosion_add - 0.8
			draw_actions( 1, true )
		end,
	},
	{
		id          = "EXPLOSION_TINY",
		name 		= "$action_explosion_tiny",
		description = "$actiondesc_explosion_tiny",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/explosion_tiny.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/misc/explosion_tiny.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,5,6", -- LIFETIME_DOWN
		spawn_probability                 = "0.2,0.3,0.3,0.2", -- LIFETIME_DOWN
		price = 160,
		mana = 30,
		max_uses = 150,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/explosion_tiny.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.explosion_radius = clamp( c.explosion_radius - 30.0, 0, 256 )
			c.damage_explosion_add = c.damage_explosion_add + 0.8
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LASER_EMITTER_WIDER",
		name 		= "$action_laser_emitter_wider",
		description = "$actiondesc_laser_emitter_wider",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/laser_emitter_wider.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/burn_trail_unidentified.png",
		related_extra_entities = { "data/entities/misc/laser_emitter_wider.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- BURN_TRAIL
		spawn_probability                 = "0.3,0.3,0.3", -- BURN_TRAIL
		price = 40,
		mana = 5,
		max_uses = 120,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/laser_emitter_wider.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 5
			current_reload_time = current_reload_time - 3
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "LIFETIME_INFINITE",
		name 		= "$action_lifetime_infinite",
		description = "$actiondesc_lifetime_infinite",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/lifetime_infinite.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,6", -- LIFETIME
		spawn_probability                 = "0.5,0.5,0.5,0.5", -- LIFETIME
		spawn_requires_flag	= "card_unlocked_infinite",
		price = 350,
		mana = 120,
		max_uses = 3,
		custom_xml_file = "data/entities/misc/custom_cards/lifetime_infinite.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/lifetime_infinite.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 13
			draw_actions( 1, true )
		end,
	},
	]]--
	{
		id          = "MANA_REDUCE",
		name 		= "$action_mana_reduce",
		description = "$dmana_reduce",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mana.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.7,0.6,0.7,0.6,0.7,0.6,0.5", -- MANA_REDUCE
		price = 250,
		mana = -20,
		-- max_uses = 1500,
		custom_xml_file = "data/entities/misc/custom_cards/mana_reduce.xml",
		action 		= function()
			if mana < 100 then mana = mana + 10 end
			c.fire_rate_wait = c.fire_rate_wait + 18
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_DIPLOMANA",
		name 		= "$DIPLOMANA",
		description = "$dDIPLOMANA",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/diplomana.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "5,6,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.2,0.3,0.4", -- MANA_REDUCE
		price = 1024,
		mana = 0,
		max_uses = 0,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/diplomana.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + math.floor( clamp( mana, 0, 240 ) * 0.16667 ) * 6 -- close to 1 mana : 1 frame delay
			mana = mana + clamp( mana, 0, 100000 )

			if GameGetFrameNum() < 60 then c.fire_rate_wait = 0 end
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BLOOD_MAGIC",
		name 		= "$action_blood_magic",
		description = "$dblood_magic",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/blood_magic.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/particles/blood_sparks.xml" },
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "5,6,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.3,0.6,0.5,0.5", -- MANA_REDUCE
		price = 150,
		mana = -1000,
		max_uses = 1500,
		custom_xml_file = "data/entities/misc/custom_cards/blood_magic.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait - 20
			current_reload_time = current_reload_time - 20
			draw_actions( 1, true )
			
			local entity_id = GetUpdatedEntityID()
			local dcomps = EntityGetComponent( entity_id, "DamageModelComponent" )
			
			if ( dcomps ~= nil ) and ( #dcomps > 0 ) then
				local hp = 2

				for a,b in ipairs( dcomps ) do
					hp = ComponentGetValue2( b, "hp" )
					ComponentSetValue2( b, "hp", math.max( hp - 0.16, 0.04 ) )
				end

				if hp <= 4 then
					c.material = "blood_fading"
					c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/blood_sparks.xml," )
					c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_hemokinesis.xml," )
				end

				mana = clamp( mana, 1000, mana+1000 )
			else
				mana = clamp( mana-1000, 0, mana )
			end
		end,
	},
	{
		id          = "MONEY_MAGIC",
		name 		= "$action_money_magic",
		description = "$ddMONEY_MAGIC",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/golden_punch.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/particles/gold_sparks.xml" },
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "3,5,6,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.8,0.3,0.2,0.5", -- MANA_REDUCE
		price = 200,
		mana = 30,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/money_magic.xml",
		action 		= function()
			local entity_id = GetUpdatedEntityID()
			local dcomp = EntityGetFirstComponent( entity_id, "WalletComponent" )
			
			if ( dcomp ~= nil ) then
				local money = ComponentGetValue2( dcomp, "money" )
				local moneyspent = ComponentGetValue2( dcomp, "money_spent" )
				
				if ( money >= 1 ) then
					ComponentSetValue2( dcomp, "money", 0 )
					ComponentSetValue2( dcomp, "money_spent", moneyspent + money )
					
					-- print( "Spent " .. tostring( damage ) )
				
					c.damage_projectile_add = c.damage_projectile_add + ( money * 0.04 )
					c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/gold_sparks.xml," )
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BLOOD_TO_POWER",
		name 		= "$action_blood_to_power",
		description = "$actiondesc_blood_to_power",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/blood_punch.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/particles/blood_sparks.xml" },
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "2,5,6,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.8,0.2,0.2,0.5", -- MANA_REDUCE
		price = 150,
		mana = 20,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/blood_to_power.xml",
		action 		= function()
			local entity_id = GetUpdatedEntityID()
			local dcomp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
			
			if ( dcomp ~= nil ) then
				local hp = ComponentGetValue2( dcomp, "hp" )
				local damage = hp * 50
				local self_damage = hp * 0.2
				
				if ( hp >= 0.2 ) then
					-- print( "Spent " .. tostring( damage ) )
					if ( hp > 16 ) then c.extra_entities = c.extra_entities .. "data/entities/particles/blood_sparks.xml," end

					if ( hp > 80 ) then
						self_damage = hp * 0.5
						damage = 4000
						c.damage_projectile_add = c.damage_projectile_add * 2.0
					end

					EntityInflictDamage( entity_id, self_damage, "DAMAGE_HEALING", "$action_blood_to_power", "NONE", 0, 0, entity_id )
					c.damage_projectile_add = c.damage_projectile_add + damage
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_TR_PRISMA",
		name 		= "$TR_PRISMA",
		description = "$dTR_PRISMA",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_terraprisma.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "1,2,3,4,5,6", -- MANA_REDUCE
		spawn_probability                 = "0.07,0.07,0.07,0.07,0.07,0.07", -- MANA_REDUCE
		price = 777,
		max_uses = 7,
		mana = 0,
		never_unlimited = true,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/de_terraprisma.xml",
		action 		= function()
			local entity_id = GetUpdatedEntityID()
			local dcomp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
			local swords = EntityGetWithTag( "de_terraprisma" )
			
			-- GamePrint( tostring(#swords) .. " + 1" )
			if EntityHasTag( entity_id, "player_unit" ) and dcomp ~= nil and #swords < 7 then
				local maxhp = ComponentGetValue2( dcomp, "max_hp" )

				if maxhp < 2 then
					GamePrint( "$ddTR_PRISMA" )
				else
					local px, py = EntityGetTransform( entity_id )
					local vcomps = EntityGetComponent( EntityLoad( "data/entities/misc/what_is_this/de_terraprisma.xml", px, py ), "VariableStorageComponent" )

					for i,v in ipairs( vcomps ) do if ComponentGetValue2( v, "name" ) == "prey_info" then
						ComponentSetValue2( v, "value_string", #swords + 1 )
						break
					end end

					ComponentSetValue2( dcomp, "max_hp", maxhp - 1 )

					-- GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/orb/create", px, py )
					GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/perk/create", px, py )
				end
			end
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SUICIDE_KING",
		name 		= "$SUICIDE_KING",
		description = "$dSUICIDE_KING",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/suicide_king.png",
		never_unlimited	= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "0,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.001,0.25,0.4", -- MANA_REDUCE
		price = 999,
		mana = 0,
		max_uses    = 13, 
		action 		= function()
			local entity_id = GetUpdatedEntityID()

			if ( entity_id ~= nil ) and ( entity_id ~= NULL_ENTITY ) then
				local x,y = EntityGetTransform( entity_id )
				local childs = EntityGetAllChildren( entity_id )

				if ( childs ~= nil ) then
					for i=1,#childs do
						local childcomps = EntityGetComponent( childs[i], "GameEffectComponent" )

						if ( childcomps ~= nil ) then
							for j=1,#childcomps do
								local effect_str = ComponentGetValue2( childcomps[j], "effect" )

								if ( effect_str == "PROTECTION_ALL" ) then
									EntitySetComponentIsEnabled( childs[i], childcomps[j], false )
								end
							end
						end
					end
				end

				if EntityHasTag( entity_id, "player_unit" ) then
					EntityRemoveIngestionStatusEffect( entity_id, "PROTECTION_ALL" )
					EntityRemoveIngestionStatusEffect( entity_id, "DEEP_END_HARDEN_EFFECT" )

					EntityRemoveStainStatusEffect( entity_id, "PROTECTION_ALL", 15 )
					EntityRemoveStainStatusEffect( entity_id, "DEEP_END_HARDEN_EFFECT", 15 )
				end

				if ( x ~= nil ) and ( y ~= nil ) then
					GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/heartbeat/create", x, y-4 )

					local killer = EntityLoad( "data/entities/misc/what_is_this/galactic_phantom.xml", x, y )
					local comp = EntityGetFirstComponent( killer, "VariableStorageComponent" )
					
					if ( comp ~= nil ) then
						ComponentSetValue2( comp, "value_int", entity_id )
					end

					local chest_rain = EntityLoad("data/entities/misc/chest_rain_rainbow.xml", x, y)
					-- EntityAddChild( entity_id, chest_rain )
				end

				local dcomp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
				
				if ( dcomp ~= nil ) then
					ComponentSetValue2( dcomp, "hp", 0.02 )
					EntityInflictDamage( entity_id, ComponentGetValue2( dcomp, "max_hp" ) * 100, "DAMAGE_HEALING", "$SUICIDE_KING", "NONE", 0, 0, entity_id )
				else
					EntityKill( entity_id )
				end
			end

			for i,v in ipairs( deck ) do
				-- print( "removed " .. v.id .. " from deck" )
				table.insert( discarded, v )
			end
			
			deck = {}
			force_stop_draws = true

			c.friendly_fire	= true
			c.damage_critical_chance = 2^64-1
			c.damage_projectile_add = 2^64-1
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_RESET_ALL",
		name 		= "$DE_RESET_ALL",
		description = "$dDE_RESET_ALL",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/just_reset_all.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/deep_end/just_reset_all_unidentified_2.png",
		-- spawn_requires_flag = "card_unlocked_everything",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", 
		spawn_probability                 = "0", 
		price = 2521,
		mana = 55,
		-- max_uses = 1,
		ai_never_uses = true,
		action 		= function()
			local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
			local entity_id = GetUpdatedEntityID()

			if EntityHasTag( entity_id, "player_unit" ) then
				local x,y = EntityGetTransform( entity_id )

				if math.abs(newgame_n) > 9999 or newgame_n == -579 then
					EntityLoad( "data/entities/misc/what_is_this/forget_everything.xml", x, y )
				else
					-- this is crazy!
					local comp = EntityGetFirstComponent( EntityLoad( "data/entities/misc/what_is_this/just_reset_all.xml", x, y ), "VariableStorageComponent", "de_ng_pre" )
					if comp ~= nil then ComponentSetValue2( comp, "value_int", newgame_n ) end
				end
			end

			for i,v in ipairs( deck ) do
				-- print( "removed " .. v.id .. " from deck" )
				table.insert( discarded, v )
			end
			
			deck = {}
			force_stop_draws = true

			c.friendly_fire	= false
		end,
	},
	{
		id          = "DUPLICATE",
		name 		= "$action_duplicate",
		description = "$ddDUPLICATE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/duplicate.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_mestari",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.2,0.5,0.75", -- MANA_REDUCE
		price = 250,
		mana = 100,
		max_uses = 9999,
		action 		= function( recursion_level, iteration )
			local hand_count = #hand
			
			for i,v in ipairs( hand ) do
				local rec = check_recursion( v, recursion_level )

				-- won't copy divide_n in cast_fold
				if DE_DRAW_STATE == GameGetFrameNum() and ( v.id == "DIVIDE_2" or v.id == "DIVIDE_3" or v.id == "DIVIDE_4" or v.id == "DIVIDE_10" ) then rec = -1 end
				if v.id ~= "DUPLICATE" and i <= hand_count and rec > -1 then v.action( rec ) end
			end
			
			c.fire_rate_wait = c.fire_rate_wait + 9
			current_reload_time = current_reload_time + 9
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "QUANTUM_SPLIT",
		name 		= "$action_quantum_split",
		description = "$actiondesc_quantum_split",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/quantum_split.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/misc/quantum_split.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- MANA_REDUCE
		spawn_probability                 = "0.5,0.6,0.5,0.5,1", -- MANA_REDUCE
		price = 1234,
		mana = 10,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/quantum_split.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 5
			draw_actions( 1, true )
		end,
	},
	{
		id          = "GRAVITY",
		name 		= "$action_gravity",
		description = "$actiondesc_gravity",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/gravity.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/w_shape_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- GRAVITY
		spawn_probability                 = "0.3,0.2,0.2,0.1,0.1", -- GRAVITY
		price = 50,
		mana = 1,
		max_uses = 100,
		action 		= function()
			c.gravity = c.gravity + 600.0
			c.fire_rate_wait = c.fire_rate_wait - 10
			draw_actions( 1, true )
		end,
	},
	{
		id          = "GRAVITY_ANTI",
		name 		= "$action_gravity_anti",
		description = "$actiondesc_gravity_anti",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/gravity_anti.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/w_shape_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- GRAVITY_ANTI
		spawn_probability                 = "0.3,0.1,0.1,0.2,0.2", -- GRAVITY_ANTI
		price = 50,
		mana = 1,
		max_uses = 100,
		action 		= function()
			c.gravity = c.gravity - 600.0
			c.fire_rate_wait = c.fire_rate_wait - 10
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "PENETRATE_WALLS",
		name 		= "$action_penetrate_walls",
		description = "$actiondesc_penetrate_walls",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/penetrate_walls.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- PENETRATE_WALLS
		spawn_probability                        = "", -- PENETRATE_WALLS
		price = 100,
		action 		= function()
			penetration_power = penetration_power + 1
		end,
	},]]--
	{
		id          = "SINEWAVE",
		name 		= "$action_sinewave",
		description = "$actiondesc_sinewave",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sinewave.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/sinewave.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,6", -- SINEWAVE
		spawn_probability                 = "0.2,0.4,0.2", -- SINEWAVE
		price = 10,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/sinewave.xml,"
			c.speed_multiplier = c.speed_multiplier * 2
			c.gravity = 0
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CHAOTIC_ARC",
		name 		= "$action_chaotic_arc",
		description = "$actiondesc_chaotic_arc",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/chaotic_arc.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/chaotic_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- CHAOTIC_ARC
		spawn_probability                 = "0.2,0.3,0.2", -- CHAOTIC_ARC
		price = 10,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/chaotic_arc.xml,"
			c.speed_multiplier = c.speed_multiplier * 2
			c.gravity = 0
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "PINGPONG_PATH",
		name 		= "$action_pingpong_path",
		description = "$actiondesc_pingpong_path",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/pingpong_path.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/pingpong_path.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- PINGPONG_PATH
		spawn_probability                 = "0.3,0.5,0.3", -- PINGPONG_PATH
		price = 20,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/pingpong_path.xml,"
			c.gravity = 0
			c.lifetime_add = c.lifetime_add + 25
			draw_actions( 1, true )
		end,
	},
	{
		id          = "AVOIDING_ARC",
		name 		= "$action_avoiding_arc",
		description = "$actiondesc_avoiding_arc",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/avoiding_arc.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/avoiding_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,6", -- AVOIDING_ARC
		spawn_probability                 = "0.3,0.1,0.1", -- AVOIDING_ARC
		price = 30,
		mana = 0,
		max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/avoiding_arc.xml,"
			c.fire_rate_wait    = c.fire_rate_wait - 15
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FLOATING_ARC",
		name 		= "$action_floating_arc",
		description = "$actiondesc_floating_arc",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/floating_arc.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/floating_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- FLOATING_ARC
		spawn_probability                 = "0.1,0.1,0.3", -- FLOATING_ARC
		price = 30,
		mana = 0,
		max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/floating_arc.xml,"
			c.fire_rate_wait    = c.fire_rate_wait - 15
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FLY_DOWNWARDS",
		name 		= "$action_fly_downwards",
		description = "$actiondesc_fly_downwards",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/fly_downwards.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/fly_downwards.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- FLY_DOWNWARDS
		spawn_probability                 = "0.1,0.3,0.1", -- FLY_DOWNWARDS
		price = 30,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/fly_downwards.xml,"
			c.gravity = c.gravity * 2
			c.fire_rate_wait    = c.fire_rate_wait - 8
			c.speed_multiplier	= c.speed_multiplier * 1.2
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FLY_UPWARDS",
		name 		= "$action_fly_upwards",
		description = "$actiondesc_fly_upwards",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/fly_upwards.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/fly_upwards.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,6", -- FLY_UPWARDS
		spawn_probability                 = "0.1,0.3,0.1", -- FLY_UPWARDS
		price = 20,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/fly_upwards.xml,"
			c.gravity = c.gravity * 2
			c.fire_rate_wait    = c.fire_rate_wait - 8
			c.speed_multiplier	= c.speed_multiplier * 1.2
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HORIZONTAL_ARC",
		name 		= "$action_horizontal_arc",
		description = "$actiondesc_horizontal_arc",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/horizontal_arc.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/horizontal_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- HORIZONTAL_ARC
		spawn_probability                 = "0.3,0.3,0.3", -- HORIZONTAL_ARC
		price = 20,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/horizontal_arc.xml,"
			c.gravity = 0
			c.damage_projectile_add = c.damage_projectile_add + 0.3
			c.fire_rate_wait    = c.fire_rate_wait - 6
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LINE_ARC",
		name 		= "$action_line_arc",
		description = "$actiondesc_line_arc",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/line_arc.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/line_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- HORIZONTAL_ARC
		spawn_probability                 = "0.2,0.3,0.4", -- HORIZONTAL_ARC
		price = 30,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/line_arc.xml,"
			c.gravity = 0
			c.damage_projectile_add = c.damage_projectile_add + 0.2
			c.fire_rate_wait    = c.fire_rate_wait - 4
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ORBIT_SHOT",
		name 		= "$action_orbit_shot",
		description = "$actiondesc_orbit_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/orbit_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/spiraling_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- HORIZONTAL_ARC
		spawn_probability                 = "0.4,0.3,0.2,0.1", -- HORIZONTAL_ARC
		price = 30,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/spiraling_shot.xml,"
			c.gravity = 0
			c.damage_projectile_add = c.damage_projectile_add + 0.1
			c.fire_rate_wait = c.fire_rate_wait - 6
			c.lifetime_add = c.lifetime_add + 25
			draw_actions( 1, true )
		end,
	},
	{
		id          = "SPIRALING_SHOT",
		name 		= "$action_spiraling_shot",
		description = "$actiondesc_spiraling_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/spiraling_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- HORIZONTAL_ARC
		spawn_probability                 = "0.1,0.2,0.3,0.4", -- HORIZONTAL_ARC
		price = 30,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_shot.xml,"
			c.gravity = c.gravity * 2
			c.damage_projectile_add = c.damage_projectile_add + 0.1
			c.fire_rate_wait = c.fire_rate_wait - 6
			c.lifetime_add = c.lifetime_add + 50
			draw_actions( 1, true )
		end,
	},
	{
		id          = "PHASING_ARC",
		name 		= "$action_phasing_arc",
		description = "$actiondesc_phasing_arc",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/phasing_arc.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/phasing_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5", -- HORIZONTAL_ARC
		spawn_probability                 = "0.2,0.3,0.4,0.1", -- HORIZONTAL_ARC
		price = 170,
		mana = 2,
		--max_uses = 150,
		action 		= function()
			local judge = de_str_finder( c.extra_entities, "data/entities/misc/chaotic_arc.xml," )

			if judge == nil then
				c.extra_entities = c.extra_entities .. "data/entities/misc/phasing_arc.xml,"
			else
				c.extra_entities = c.extra_entities:gsub( "data/entities/misc/chaotic_arc.xml,", "data/entities/misc/phasing_arc_reverse.xml,", 1 )
			end

			c.gravity = 0
			c.fire_rate_wait = c.fire_rate_wait - 12
			c.lifetime_add = c.lifetime_add + 80
			c.speed_multiplier = math.max( c.speed_multiplier * 0.33, 0 )
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.33, 0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TRUE_ORBIT",
		name 		= "$action_true_orbit",
		description = "$actiondesc_true_orbit",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/true_orbit.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/true_orbit.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- HORIZONTAL_ARC
		spawn_probability                 = "0.1,0.2,0.3", -- HORIZONTAL_ARC
		price = 40,
		mana = 2,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/true_orbit.xml,"
			c.gravity = 0
			c.damage_projectile_add = c.damage_projectile_add + 0.11
			c.fire_rate_wait = c.fire_rate_wait - 28
			c.lifetime_add = c.lifetime_add + 80
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_METASTABLE_ARC",
		name 		= "$METASTABLE_ARC",
		description = "$dMETASTABLE_ARC",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/metastable_trajectory.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/metastable_trajectory.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,2,4", -- CHAOTIC_ARC
		spawn_probability                 = "0.3,0.1,0.3", -- CHAOTIC_ARC
		price = 300,
		mana = 1,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/metastable_trajectory.xml," )
			c.speed_multiplier = math.max( c.speed_multiplier * 0.15, 0 )
			c.lifetime_add = c.lifetime_add + 60
			c.gravity = 0
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE",
		name 		= "$action_bounce",
		description = "$actiondesc_bounce",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bounce.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bounce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,6", -- BOUNCE
		spawn_probability                 = "0.8,0.8,0.4,0.2", -- BOUNCE
		price = 50,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.bounces = c.bounces * 2 + 10
			c.gravity = c.gravity * 2
			draw_actions( 1, true )
		end,
	},
	{
		id          = "REMOVE_BOUNCE",
		name 		= "$action_remove_bounce",
		description = "$actiondesc_remove_bounce",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/remove_bounce.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bounce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5", -- BOUNCE
		spawn_probability                 = "0.2,0.4,0.8,0.8", -- BOUNCE
		price = 50,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/remove_bounce.xml," )
			c.gravity = c.gravity * 2
			c.bounces = 0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING",
		name 		= "$action_homing",
		description = "$actiondesc_homing",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/homing.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing.xml", "data/entities/particles/tinyspark_white_small.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7", -- HOMING
		spawn_probability                 = "0.15,0.25,0.35,0.45,0.35,0.45,0.55,0.1", -- HOMING
		price = 220,
		mana = 45,
		max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing.xml,"
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_white_small.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ANTI_HOMING",
		name 		= "$action_anti_homing",
		description = "$actiondesc_anti_homing",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/anti_homing.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/anti_homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/anti_homing.xml", "data/entities/misc/anti_homing_shooter.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- ANTI_HOMING
		spawn_probability                 = "0.05,0.25,0.25,0.15,0.15,0.05", -- ANTI_HOMING
		price = 110,
		mana = 1,
		max_uses = 100,
		action 		= function()
			local mdf_1 = de_str_finder( c.extra_entities, "data/entities/misc/anti_homing.xml," )
			local mdf_2 = de_str_finder( c.extra_entities, "data/entities/misc/anti_homing_shooter.xml," )
			
			if mdf_1 == nil then
				c.extra_entities = c.extra_entities .. "data/entities/misc/anti_homing.xml,"
			elseif mdf_2 == nil then
				c.extra_entities = c.extra_entities:gsub( "data/entities/misc/anti_homing.xml,", "data/entities/misc/anti_homing_shooter.xml,", 1 )
			end

			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_white_small.xml," )
			
			c.fire_rate_wait    = c.fire_rate_wait - 28
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_WAND",
		name 		= "$action_homing_wand",
		description = "$actiondesc_homing_wand",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/homing_wand.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_homing_wand",
		related_extra_entities = { "data/entities/misc/homing_wand.xml", "data/entities/particles/tinyspark_white_small.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5,6,10", -- HOMING_WAND
		spawn_probability                 = "0.002,0.1,0.1,0.15,0.15,0.002", -- SUMMON_WANDGHOST
		price = 500,
		mana = 128,
		max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_wand.xml,"
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_white_small.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_SHORT",
		name 		= "$action_homing_short",
		description = "$actiondesc_homing_short",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/homing_short.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing_short.xml", "data/entities/particles/tinyspark_white_weak.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7", -- HOMING
		spawn_probability                 = "0.25,0.35,0.45,0.5,0.4,0.3,0.2,0.1", -- HOMING
		price = 160,
		mana = 40,
		max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_short.xml,"
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_white_small.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_ROTATE",
		name 		= "$action_homing_rotate",
		description = "$actiondesc_homing_rotate",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/homing_rotate.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing_rotate.xml", "data/entities/particles/tinyspark_white_small.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6,7", -- HOMING_ROTATE
		spawn_probability                 = "0.15,0.35,0.55,0.35,0.35,0.1", -- HOMING_ROTATE
		price = 175,
		mana = 10,
		max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_rotate.xml,"
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_white_small.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_SHOOTER",
		name 		= "$action_homing_shooter",
		description = "$actiondesc_homing_shooter",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/homing_shooter.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing_shooter.xml", "data/entities/particles/tinyspark_white_small.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,2,3,4,6,7", -- HOMING_SHOOTER
		spawn_probability                 = "0.2,0.2,0.3,0.4,0.3,0.1", -- HOMING_SHOOTER
		price = 100,
		mana = 20,
		max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_shooter.xml,"
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_white_small.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "AUTOAIM",
		name 		= "$action_autoaim",
		description = "$actiondesc_autoaim",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/autoaim.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/autoaim_unidentified.png",
		related_extra_entities = { "data/entities/misc/autoaim.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4", -- AUTOAIM
		spawn_probability                 = "0.2,0.3,0.2,0.3,0.2", -- AUTOAIM
		price = 100,
		mana = 5,
		max_uses = 100,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/autoaim.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_ACCELERATING",
		name 		= "$action_homing_accelerating",
		description = "$actiondesc_homing_accelerating",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/homing_accelerating.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing_accelerating.xml", "data/entities/particles/tinyspark_white_small.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- HOMING
		spawn_probability                 = "0.1,0.25,0.4,0.4,0.1", -- HOMING
		price = 180,
		mana = 30,
		max_uses = 100,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/homing_accelerating.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_white_small.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_CURSOR",
		name 		= "$action_homing_cursor",
		description = "$actiondesc_homing_cursor",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/homing_cursor.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/de_homing_cursor.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,10", -- HOMING_ROTATE
		spawn_probability                 = "0.05,0.05,0.45,0.35,0.25,0.15,0.55,0.05,0.025", -- HOMING_ROTATE
		price = 175,
		mana = 15,
		max_uses = 100,
		action 		= function()
			local mdf_1 = de_str_finder( c.extra_entities, "data/entities/misc/homing_cursor.xml," )
			local mdf_2 = de_str_finder( c.extra_entities, "data/entities/misc/de_homing_cursor.xml," )
			
			if mdf_2 == nil then
				if mdf_1 == nil then
					c.extra_entities = c.extra_entities .. "data/entities/misc/homing_cursor.xml,"
				else
					c.extra_entities = c.extra_entities:gsub( "data/entities/misc/homing_cursor.xml,", "data/entities/misc/de_homing_cursor.xml,", 1 )
				end

				c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_white_small.xml," )
			end

			c.spread_degrees = 0.0
			shot_effects.recoil_knockback = 0.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_AREA",
		name 		= "$action_homing_area",
		description = "$actiondesc_homing_area",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/homing_area.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing_area.xml", "data/entities/particles/tinyspark_white_small.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6,7,10", -- HOMING_ROTATE
		spawn_probability                 = "0.25,0.35,0.45,0.55,0.5,0.15,0.025", -- HOMING_ROTATE
		price = 175,
		mana = 50,
		max_uses = 100,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/homing_area.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_white_small.xml," )
			c.fire_rate_wait    = c.fire_rate_wait + 8
			c.spread_degrees = c.spread_degrees + 6
			c.speed_multiplier	= clamp( c.speed_multiplier * 0.75, 0, 20 )
			
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "HOMING_PROJECTILE",
		name 		= "$action_homing_projectile",
		description = "$actiondesc_homing_projectile",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/homing_projectile.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- HOMING_SHOOTER
		spawn_probability                 = "0.2,0.2,0.2,0.2,0.2", -- HOMING_SHOOTER
		price = 100,
		mana = 10,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_projectile.xml,data/entities/particles/tinyspark_white_small.xml,"
			draw_actions( 1, true )
		end,
	},
	]]--
	{
		id          = "PIERCING_SHOT",
		name 		= "$action_piercing_shot",
		description = "$actiondesc_piercing_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/piercing_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/piercing_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6,7,10", -- PIERCING_SHOT
		spawn_probability                 = "0.35,0.45,0.55,0.45,0.35,0.05,0.025", -- PIERCING_SHOT
		price = 190,
		mana = 200,
		max_uses = 125,
		action 		= function()
			c.damage_projectile_add = math.min( c.damage_projectile_add - 0.72, 0 )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/piercing_shot.xml," )
			c.friendly_fire	= true
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CLIPPING_SHOT",
		name 		= "$action_clipping_shot",
		description = "$actiondesc_clipping_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/clipping_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/clipping_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- CLIPPING_SHOT
		spawn_probability                 = "0.2,0.3,0.4,0.3,0.4", -- CLIPPING_SHOT
		price = 200,
		mana = 100,
		max_uses = 125,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/clipping_shot.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 3
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DAMAGE",
		name 		= "$action_damage",
		description = "$actiondesc_damage",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/damage.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_yellow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- DAMAGE
		spawn_probability                 = "0.68,0.66,0.64,0.62,0.6", -- DAMAGE
		price = 140,
		mana = 5,
		-- max_uses = 150,
		custom_xml_file = "data/entities/misc/custom_cards/damage.xml",
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 0.4
			c.gore_particles    = c.gore_particles + 5
			c.fire_rate_wait    = c.fire_rate_wait + 5
			c.extra_entities    = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_yellow.xml," )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DAMAGE_RANDOM",
		name 		= "$action_damage_random",
		description = "$actiondesc_damage_random",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/damage_random.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_pyramid",
		related_extra_entities = { "data/entities/particles/tinyspark_yellow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,2,4", -- DAMAGE
		spawn_probability                 = "0.22,0.44,0.66", -- DAMAGE
		price = 200,
		mana = 10,
		-- max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/damage_random.xml",
		action 		= function()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() + 253 )
			local multiplier = 0
			multiplier = Random( -3, 5 ) * Random( 0, 4 )
			local result = 0
			result = math.max( c.damage_projectile_add + 0.2 * multiplier, -0.4 )

			if GameGetFrameNum() > 60 then
				c.damage_projectile_add = result
			else -- display the average damage
				c.damage_projectile_add = c.damage_projectile_add + 0.4
			end

			-- c.gore_particles    = c.gore_particles + 5 * multiplier
			c.fire_rate_wait    = c.fire_rate_wait + 5
			-- c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 2.0 * multiplier
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BLOODLUST",
		name 		= "$action_bloodlust",
		description = "$actiondesc_bloodlust",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bloodlust.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,3,4,5,6", -- PIERCING_SHOT
		spawn_probability                 = "0.3,0.35,0.3,0.4,0.35,0.4", -- PIERCING_SHOT
		price = 160,
		mana = 2,
		--max_uses = 100,
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 1.3
			c.gore_particles    = c.gore_particles + 15
			c.fire_rate_wait    = c.fire_rate_wait + 8
			c.friendly_fire		= true
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
			c.spread_degrees = c.spread_degrees + 6
			c.extra_entities    = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_red.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DAMAGE_FOREVER",
		name 		= "$action_damage_forever",
		description = "$actiondesc_damage_forever",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/damage_forever.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6,7,10", -- DAMAGE
		spawn_probability                 = "0.2,0.3,0.4,0.3,0.2,0.1,0.2", -- DAMAGE
		price = 240,
		mana = 0,
		max_uses = 25,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/damage_forever.xml",
		action 		= function()
			if mana > 50 then
				mana = mana - 40

				if mana > 22055 then mana = mana * math.log(mana) * 0.1 end

				c.damage_projectile_add = c.damage_projectile_add + 0.06 * mana
				c.gore_particles    = c.gore_particles + 15
				c.extra_entities    = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_red.xml," )
				shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0

				mana = 50
			end
			
			c.fire_rate_wait    = c.fire_rate_wait + 6
			current_reload_time = current_reload_time + 6
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_DAMAGE_TO_TIME",
		name 		= "$DAMAGE_TO_TIME",
		description = "$dDAMAGE_TO_TIME",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/damage_fallout.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml", "data/entities/particles/light_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "4,5,6,7,10",
		spawn_probability                 = "0.5,0.4,0.3,0.1,0.025",
		price = 250,
		mana = 50,
		max_uses = 5,
		-- never_unlimited = true,
		action 		= function()
			local dmg_add = math.floor( c.damage_projectile_add * 25 )

			-- c.damage_projectile_add = 0
			c.gore_particles = 0
			c.lifetime_add = c.lifetime_add + dmg_add
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_red.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/light_shot.xml," )
			-- c.game_effect_entities = ""
			c.trail_material_amount = 0

			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CRITICAL_HIT",
		name 		= "$action_critical_hit",
		description = "$actiondesc_critical_hit",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/critical_hit.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- CRITICAL_HIT
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5", -- CRITICAL_HIT
		price = 140,
		mana = 2,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/critical_hit.xml",
		action 		= function()
			c.damage_critical_chance = c.damage_critical_chance + 15
			draw_actions( 1, true )
		end,
	},
	{
		id          = "AREA_DAMAGE",
		name 		= "$action_area_damage",
		description = "$actiondesc_area_damage",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/area_damage.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/area_damage.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- AREA_DAMAGE
		spawn_probability                 = "0.15,0.3,0.45,0.6,0.45,0.45", -- AREA_DAMAGE
		price = 140,
		mana = 30,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/area_damage.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "SPELLS_TO_POWER",
		name 		= "$action_spells_to_power",
		description = "$actiondesc_spells_to_power",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/spells_to_power.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/spells_to_power.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6,10", -- AREA_DAMAGE
		spawn_probability                 = "0.3,0.3,0.5,0.5,0.5,0.1", -- AREA_DAMAGE
		price = 140,
		mana = 40,
		max_uses = 50,
		action 		= function()
			if de_str_finder( c.extra_entities, "spells_to_power_no_spark" ) ~= nil then
				c.extra_entities = c.extra_entities .. "data/entities/misc/spells_to_power_simple.xml,"
			elseif de_str_finder( c.extra_entities, "spells_to_power" ) ~= nil then
				c.extra_entities = c.extra_entities .. "data/entities/misc/spells_to_power_no_spark.xml,"
			else
				c.extra_entities = c.extra_entities .. "data/entities/misc/spells_to_power.xml,"
			end

			c.fire_rate_wait    = c.fire_rate_wait + 40
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ESSENCE_TO_POWER",
		name 		= "$action_enemies_to_power",
		description = "$actiondesc_enemies_to_power",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/essence_to_power.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/essence_to_power.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,6,10", -- AREA_DAMAGE
		spawn_probability                 = "0.2,0.3,0.4,0.5,0.01", -- AREA_DAMAGE
		price = 120,
		mana = 40,
		max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/essence_to_power.xml,"
			c.fire_rate_wait    = c.fire_rate_wait + 20
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ZERO_DAMAGE",
		name 		= "$action_zero_damage",
		description = "$actiondesc_zero_damage",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/zero_damage.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_white_small.xml", "data/entities/misc/zero_damage.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,10", -- DAMAGE
		spawn_probability                 = "0.2,0.3,0.4,0.03", -- DAMAGE
		price = 50,
		mana = 5,
		--max_uses = 50,
		action 		= function()
			c.damage_melee_add = 0
			c.damage_drill_add = 0
			c.damage_slice_add = 0
			c.damage_fire_add = 0
			c.damage_ice_add = 0
			c.damage_electricity_add = 0
			c.damage_curse_add = 0
			c.damage_healing_add = 0
			c.damage_explosion_add = 0
			c.damage_explosion = 0
			c.damage_critical_chance = 0
			c.damage_projectile_add = 0
			c.damage_null_all = 1
			c.gore_particles    = 0
			c.fire_rate_wait    = c.fire_rate_wait - 5
			c.extra_entities    = de_effect_entities_add( c.extra_entities, "data/entities/misc/zero_damage.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_white_small.xml," )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
			c.lifetime_add 		= c.lifetime_add + 180
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		-- NOTE( Petri ): Why doesn't this work?
		id          = "DAMAGE_FRIENDLY",
		name 		= "$action_damage_friendly",
		description = "$actiondesc_damage_friendly",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/damage_friendly.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_friendly_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DAMAGE_FRIENDLY
		spawn_probability                 = "", -- DAMAGE_FRIENDLY
		price = 140,
		mana = 5,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/damage_friendly.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.8
			c.friendly_fire		= true
			c.gore_particles    = c.gore_particles + 5
			c.fire_rate_wait    = c.fire_rate_wait + 5
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
		end,
	},
	{
		-- NOTE( Petri ): This doesn't work now!
		id          = "DAMAGE_X2",
		name 		= "$action_damage_x2",
		description = "$actiondesc_damage_x2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/damage_x2.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_x2_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DAMAGE_X2
		spawn_probability                 = "", -- DAMAGE_X2
		price = 200,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/damage_x2.xml",
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 2
			c.fire_rate_wait    = c.fire_rate_wait + 5
			c.gore_particles    = c.gore_particles + 10
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
			draw_actions( 1, true )
		end,
	},
	{
		-- NOTE( Petri ): This doesn't work now!
		id          = "DAMAGE_X5",
		name 		= "$action_damage_x5",
		description = "$actiondesc_damage_x5",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/damage_x5.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_x2_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DAMAGE_X5
		spawn_probability                 = "", -- DAMAGE_X5
		price = 220,
		mana = 50,
		max_uses = 5,
		custom_xml_file = "data/entities/misc/custom_cards/damage_x2.xml",
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 5
			c.fire_rate_wait    = c.fire_rate_wait + 10
			c.gore_particles    = c.gore_particles + 30
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 60.0
			draw_actions( 1, true )
		end,
	},
	]]--
	{
		id          = "HEAVY_SHOT",
		name 		= "$action_heavy_shot",
		description = "$actiondesc_heavy_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/heavy_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/heavy_shot_unidentified.png",
		related_extra_entities = { "data/entities/particles/heavy_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- HEAVY_SHOT
		spawn_probability                 = "0.1,0.35,0.5,0.35,0.1", -- HEAVY_SHOT
		price = 150,
		mana = 7,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/heavy_shot.xml",
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 1.75
			c.fire_rate_wait    = c.fire_rate_wait + 10
			c.gore_particles    = c.gore_particles + 7
			c.speed_multiplier = math.max( c.speed_multiplier * 0.3, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 40.0
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/heavy_shot.xml," )
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIGHT_SHOT",
		name 		= "$action_light_shot",
		description = "$actiondesc_light_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/light_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/heavy_shot_unidentified.png",
		related_extra_entities = { "data/entities/particles/light_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4", -- LIGHT_SHOT
		spawn_probability                 = "0.1,0.1,0.2,0.3,0.4", -- LIGHT_SHOT
		price = 60,
		mana = 5,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/light_shot.xml",
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add - 1.0
			c.explosion_radius = clamp( c.explosion_radius - 10.0, 0, 256 )
			c.fire_rate_wait    = c.fire_rate_wait - 12
			c.speed_multiplier = clamp( c.speed_multiplier * 7.5, 1, 20 )
			c.spread_degrees = c.spread_degrees - 6
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 20.0
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/light_shot.xml," )
			
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "SHORTLIVED_SHOT",
		name 		= "$action_shortlived_shot",
		description = "$actiondesc_shortlived_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/shortlived_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/heavy_shot_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- SHORTLIVED_SHOT
		spawn_probability                 = "", -- SHORTLIVED_SHOT
		price = 120,
		mana = 7,
		--max_uses = 50,
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 2.4
			c.fire_rate_wait    = c.fire_rate_wait + 10
			c.gore_particles    = c.gore_particles + 15
			c.lifetime_add 		= c.lifetime_add - 200
			draw_actions( 1, true )
		end,
	},
	]]--
	{
		id          = "KNOCKBACK",
		name 		= "$action_knockback",
		description = "$actiondesc_knockback",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/knockback.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/knockback_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,5", -- KNOCKBACK
		spawn_probability                 = "0.7,0.6", -- KNOCKBACK
		price = 100,
		mana = 5,
		--max_uses = 150,
		action 		= function()
			c.knockback_force = c.knockback_force + 5
			draw_actions( 1, true )
		end,
	},
	{
		id          = "RECOIL",
		name 		= "$action_recoil",
		description = "$actiondesc_recoil",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/recoil.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/recoil_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4", -- RECOIL
		spawn_probability                 = "0.6,0.7", -- RECOIL
		price = 100,
		mana = -50,
		--max_uses = 150,
		action 		= function()
			shot_effects.recoil_knockback = math.max( shot_effects.recoil_knockback + 240, 240 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "RECOIL_DAMPER",
		name 		= "$action_recoil_damper",
		description = "$actiondesc_recoil_damper",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/recoil_damper.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/recoil_damper_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,6", -- RECOIL_DAMPER
		spawn_probability                 = "0.6,0.7", -- RECOIL_DAMPER
		price = 100,
		mana = 5,
		--max_uses = 150,
		action 		= function()
			shot_effects.recoil_knockback = math.min( shot_effects.recoil_knockback - 240, -240 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "SPEED",
		name 		= "$action_speed",
		description = "$actiondesc_speed",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/speed.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/speed_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- SPEED
		spawn_probability                 = "0.8,0.6,0.4,0.2", -- SPEED
		price = 100,
		mana = 3,
		--max_uses = 100,
		custom_xml_file = "data/entities/misc/custom_cards/speed.xml",
		action 		= function()
			c.speed_multiplier = clamp( c.speed_multiplier * 2.5, 0, 20 )
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ACCELERATING_SHOT",
		name 		= "$action_accelerating_shot",
		description = "$actiondesc_accelerating_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/accelerating_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/heavy_shot_unidentified.png",
		related_extra_entities = { "data/entities/misc/accelerating_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- ACCELERATING_SHOT
		spawn_probability                 = "0.2,0.4,0.6,0.8", -- ACCELERATING_SHOT
		price = 190,
		mana = 20,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/accelerating_shot.xml",
		action 		= function()
			c.fire_rate_wait    = c.fire_rate_wait + 8
			c.speed_multiplier = math.max( c.speed_multiplier * 0.32, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			c.extra_entities = c.extra_entities .. "data/entities/misc/accelerating_shot.xml,"
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DECELERATING_SHOT",
		name 		= "$action_decelerating_shot",
		description = "$actiondesc_decelerating_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/decelerating_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/heavy_shot_unidentified.png",
		related_extra_entities = { "data/entities/misc/decelerating_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- ACCELERATING_SHOT
		spawn_probability                 = "0.1,0.4,0.7", -- ACCELERATING_SHOT
		price = 80,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/decelerating_shot.xml",
		action 		= function()
			c.fire_rate_wait    = c.fire_rate_wait - 8
			c.speed_multiplier = math.max( c.speed_multiplier * 1.68, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
			c.extra_entities = c.extra_entities .. "data/entities/misc/decelerating_shot.xml,"
			
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "GORE",
		name 		= "$action_gore",
		description = "$actiondesc_gore",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/gore.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- GORE
		spawn_probability                        = "", -- GORE
		price = 100,
		mana = 0,
		action 		= function()
			c.ragdoll_fx = 3
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 90.0
		end,
	},
	]]--
	{
		id          = "EXPLOSIVE_PROJECTILE",
		name 		= "$action_explosive_projectile",
		description = "$actiondesc_explosive_projectile",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/explosive_projectile.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- EXPLOSIVE_PROJECTILE
		spawn_probability                 = "0.6,0.7,0.8", -- EXPLOSIVE_PROJECTILE
		price = 120,
		mana = 20,
		max_uses = 75,
		custom_xml_file = "data/entities/misc/custom_cards/explosive_projectile.xml",
		action 		= function()
			c.explosion_radius = clamp( c.explosion_radius + 15, 0, 256 )
			c.damage_explosion_add = c.damage_explosion_add + 0.2
			c.fire_rate_wait   = c.fire_rate_wait + 40
			c.speed_multiplier = math.max( c.speed_multiplier * 0.75, 0 )
			c.child_speed_multiplier = math.max( c.child_speed_multiplier * 0.75, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CLUSTERMOD",
		name 		= "$action_clustermod",
		description = "$actiondesc_clustermod",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/clusterbomb.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3", -- EXPLOSIVE_PROJECTILE
		spawn_probability                 = "0.4,0.5,0.6", -- EXPLOSIVE_PROJECTILE
		price = 160,
		mana = 15,
		max_uses = 75,
		custom_xml_file = "data/entities/misc/custom_cards/clusterbomb.xml",
		action 		= function()
			c.explosion_radius = clamp( c.explosion_radius + 4.0, 0, 256 )
			c.damage_explosion_add = c.damage_explosion_add + 0.2
			c.fire_rate_wait   = c.fire_rate_wait + 20
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/clusterbomb.xml," )
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "WATER_TO_POISON",
		name 		= "$action_water_to_poison",
		description = "$actiondesc_water_to_poison",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/water_to_poison.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/water_to_poison.xml", "data/entities/particles/tinyspark_purple.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- WATER_TO_POISON
		spawn_probability                 = "0.2,0.2,0.2", -- WATER_TO_POISON
		price = 80,
		mana = 0,
		max_uses = 50,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/water_to_poison.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_purple.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 2
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BLOOD_TO_ACID",
		name 		= "$pus_to_oil",
		description = "$dpus_to_oil",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/pus_to_oil.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/pus_to_oil.xml", "data/entities/particles/tinyspark_red.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- BLOOD_TO_ACID
		spawn_probability                 = "0.4,0.4,0.4", -- BLOOD_TO_ACID
		price = 80,
		mana = 0,
		max_uses = 50,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/pus_to_oil.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_red.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 2
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LAVA_TO_BLOOD",
		name 		= "$action_lava_to_blood",
		description = "$actiondesc_lava_to_blood",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/lava_to_blood.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/lava_to_blood.xml", "data/entities/particles/tinyspark_orange.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- LAVA_TO_BLOOD
		spawn_probability                 = "0.4,0.4,0.4", -- LAVA_TO_BLOOD
		price = 80,
		mana = 0,
		max_uses = 50,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/lava_to_blood.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_orange.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 2
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIQUID_TO_EXPLOSION",
		name 		= "$action_liquid_to_explosion",
		description = "$actiondesc_liquid_to_explosion",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/liquid_to_explosion.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/liquid_to_explosion.xml", "data/entities/particles/light_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- BLOOD_TO_ACID
		spawn_probability                 = "0.3,0.3,0.3", -- BLOOD_TO_ACID
		price = 120,
		mana = 0,
		max_uses = 50,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/liquid_to_explosion.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/light_shot.xml," )
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 2
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TOXIC_TO_ACID",
		name 		= "$action_toxic_to_acid",
		description = "$actiondesc_toxic_to_acid",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/toxic_to_acid.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/toxic_to_acid.xml", "data/entities/particles/tinyspark_green.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- TOXIC_TO_ACID
		spawn_probability                 = "0.2,0.2,0.2", -- TOXIC_TO_ACID
		price = 120,
		mana = 0,
		max_uses = 50,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/toxic_to_acid.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_green.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 2
			draw_actions( 1, true )
		end,
	},
	{
		id          = "STATIC_TO_SAND",
		name 		= "$action_static_to_sand",
		description = "$actiondesc_static_to_sand",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/static_to_sand.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/static_to_sand.xml", "data/entities/particles/tinyspark_yellow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- STATIC_TO_SAND
		spawn_probability                 = "0.3,0.3,0.3", -- STATIC_TO_SAND
		price = 140,
		mana = 20,
		max_uses = 16,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/static_to_sand.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_yellow.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 30
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TRANSMUTATION",
		name 		= "$action_transmutation",
		description = "$actiondesc_transmutation",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/transmutation.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/transmutation.xml", "data/entities/particles/tinyspark_purple_bright.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6,7,10", -- TRANSMUTATION
		spawn_probability                 = "0.2,0.3,0.2,0.3,0.2,0.8,0.2", -- TRANSMUTATION
		price = 180,
		mana = 24,
		max_uses = 16,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/transmutation.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_purple_bright.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 20
			draw_actions( 1, true )
		end,
	},
	{
		id          = "RANDOM_EXPLOSION",
		name 		= "$action_random_explosion",
		description = "$actiondesc_random_explosion",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/random_explosion.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/random_explosion.xml", "data/entities/particles/tinyspark_purple_bright.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,5,6", -- TRANSMUTATION
		spawn_probability                 = "0.3,0.5,0.7", -- TRANSMUTATION
		price = 240,
		mana = 120,
		max_uses = 30,
		ai_never_uses = true,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities .. "data/entities/misc/random_explosion.xml,", "data/entities/particles/tinyspark_purple_bright.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 40
			draw_actions( 1, true )
		end,
	},
	{
		id          = "NECROMANCY",
		name 		= "$action_necromancy",
		description = "$actiondesc_necromancy",
		-- spawn_requires_flag = "card_unlocked_necromancy",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/necromancy.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,2,4", -- NECROMANCY
		spawn_probability                 = "0.3,0.2,0.1", -- NECROMANCY
		price = 200,
		mana = 2,
		max_uses = 30,
		action 		= function()
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_necromancy.xml," )
			c.damage_curse_add = c.damage_curse_add + 0.03
			c.fire_rate_wait = c.fire_rate_wait - 3
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_PUTREFY",
		name 		= "$PUTREFY",
		description = "$dPUTREFY",
		-- spawn_requires_flag = "card_unlocked_necromancy",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/putrefy.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,7,10", -- NECROMANCY
		spawn_probability                 = "0.2,0.3,0.4,0.2,0.1,0.05", -- NECROMANCY
		price = 200,
		mana = 28,
		max_uses = 32,
		action 		= function()
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_de_drowning.xml," )
			c.damage_curse_add = c.damage_curse_add + 0.39
			c.fire_rate_wait = c.fire_rate_wait + 13
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_METALLIZATION",
		name 		= "$METALLIZATION",
		description = "$dMETALLIZATION",
		-- spawn_requires_flag = "card_unlocked_necromancy",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/metallization.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,10", -- NECROMANCY
		spawn_probability                 = "0.4,0.6,0.5,0.3,0.01", -- NECROMANCY
		price = 200,
		mana = 12,
		max_uses = 128,
		action 		= function()
			SetRandomSeed( GameGetFrameNum() + 81, GameGetFrameNum() + 13 )

			local rnd_a = Random( 7, 13 ) * 3
			local rnd_b = Random( 0, math.floor( rnd_a * 0.34 ) )
			local rnd_c = Random( 0, rnd_a - rnd_b )

			rnd_a = rnd_a - rnd_b - rnd_c + 0.2 * Random( -4, 7 )
			rnd_b = rnd_b + 0.8 * Random( -4, 7 ) * Random( 0, 13 )
			rnd_c = rnd_c + 0.2 * Random( -4, 7 )

			if GameGetFrameNum() > 60 then -- display the average damage
				c.damage_slice_add = c.damage_slice_add + 0.01 * rnd_a
				c.damage_drill_add = c.damage_drill_add + 0.01 * rnd_b
				c.damage_melee_add = c.damage_melee_add + 0.01 * rnd_c

				c.fire_rate_wait = c.fire_rate_wait + Random( 8, 18 )
			else
				c.damage_slice_add = c.damage_slice_add + 0.128
				c.damage_drill_add = c.damage_drill_add + 0.128
				c.damage_melee_add = c.damage_melee_add + 0.128

				c.fire_rate_wait = c.fire_rate_wait + 13
			end
			
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_movement_slower_once.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_metallization.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIGHT",
		name 		= "$action_light",
		description = "$actiondesc_light",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/light.png",
		related_extra_entities = { "data/entities/misc/light.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4", -- LIGHT
		spawn_probability                 = "1,0.8,0.6,0.4,0.2", -- LIGHT
		price = 20,
		mana = 1,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/light.xml," )
			c.fire_rate_wait = c.fire_rate_wait - 3
			draw_actions( 1, true )
		end,
	},
	{
		id          = "EXPLOSION",
		name 		= "$action_explosion",
		description = "$actiondesc_explosion",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/explosion.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosion_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/explosion.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,2,4,5", -- EXPLOSION
		spawn_probability                 = "0.5,1,1,0.7", -- EXPLOSION
		price = 160,
		mana = 40,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/explosion.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/explosion.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 2.5
		end,
	},
	{
		id          = "EXPLOSION_LIGHT",
		name 		= "$action_explosion_light",
		description = "$actiondesc_explosion_light",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/explosion_light.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosion_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/explosion_light.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,5,6", -- EXPLOSION
		spawn_probability                 = "0.5,1,0.7,0.5", -- EXPLOSION
		price = 160,
		mana = 60,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/explosion_light.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/explosion_light.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 2.5
		end,
	},
	{
		id          = "FIRE_BLAST",
		name 		= "$action_fire_blast",
		description = "$actiondesc_fire_blast",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/fire_blast.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/fire_blast_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/fireblast.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,3,5", -- FIRE_BLAST
		spawn_probability                 = "0.5,0.7,0.6,0.4", -- FIRE_BLAST
		price = 120,
		mana = 0,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/fire_blast.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/fireblast.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
		end,
	},
	{
		id          = "POISON_BLAST",
		name 		= "$action_poison_blast",
		description = "$actiondesc_poison_blast",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/poison_blast.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/poison_blast_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/poison_blast.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,4,6", -- POISON_BLAST
		spawn_probability                 = "0.5,0.8,0.4,0.3", -- POISON_BLAST
		price = 140,
		mana = 0,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/poison_blast.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/poison_blast.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
		end,
	},
	{
		id          = "ALCOHOL_BLAST",
		name 		= "$action_alcohol_blast",
		description = "$actiondesc_alcohol_blast",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/alcohol_blast.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/poison_blast_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/alcohol_blast.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,4,6", -- ALCOHOL_BLAST
		spawn_probability                 = "0.5,0.6,0.65,0.3", -- ALCOHOL_BLAST
		price = 140,
		mana = 0,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/alcohol_blast.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/alcohol_blast.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
		end,
	},
	{
		id          = "THUNDER_BLAST",
		name 		= "$action_thunder_blast",
		description = "$actiondesc_thunder_blast",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/thunder_blast.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/thunder_blast_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/thunder_blast.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,3,5,6,10", -- THUNDER_BLAST
		spawn_probability                 = "0.5,0.6,0.7,0.5,0.1", -- THUNDER_BLAST
		price = 180,
		mana = 75,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/thunder_blast.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/thunder_blast.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.screenshake = c.screenshake + 3.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "CHARM_FIELD",
		name 		= "$action_charm_field",
		description = "$actiondesc_charm_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/charm_field.png",
		related_projectiles	= {"data/entities/projectiles/deck/charm_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,4,7,10", -- CHARM_FIELD
		spawn_probability                 = "0.33,0.33,0.33,0.3,0.01", -- CHARM_FIELD
		price = 100,
		mana = 240,
		max_uses = 20,
		-- never_unlimited = true,
		action 		= function()
			local fields = EntityGetWithTag( "de_charm_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end

			add_projectile("data/entities/projectiles/deck/charm_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "BERSERK_FIELD",
		name 		= "$action_berserk_field",
		description = "$actiondesc_berserk_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/berserk_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/berserk_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/berserk_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,4", -- BERSERK_FIELD
		spawn_probability                 = "0.3,0.4,0.3", -- BERSERK_FIELD
		price = 200,
		mana = 160,
		max_uses = 20,
		-- never_unlimited = true,
		action 		= function()
			local fields = EntityGetWithTag( "de_berserk_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end
			
			add_projectile("data/entities/projectiles/deck/berserk_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "POLYMORPH_FIELD",
		name 		= "$action_polymorph_field",
		description = "$actiondesc_polymorph_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/polymorph_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/polymorph_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6", -- POLYMORPH_FIELD
		spawn_probability                 = "0.3,0.3,0.3,0.8,0.8,0.3,0.3", -- POLYMORPH_FIELD
		price = 200,
		mana = 200,
		max_uses = 10,
		-- never_unlimited = true,
		action 		= function()
			local fields = EntityGetWithTag( "de_polymorph_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end
			
			add_projectile("data/entities/projectiles/deck/polymorph_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "CHAOS_POLYMORPH_FIELD",
		name 		= "$action_chaos_polymorph_field",
		description = "$actiondesc_chaos_polymorph_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/chaos_polymorph_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/chaos_polymorph_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,6", -- CHAOS_POLYMORPH_FIELD
		spawn_probability                 = "0.3,0.3,0.5,0.6,0.3,0.3", -- CHAOS_POLYMORPH_FIELD
		price = 200,
		mana = 80,
		max_uses = 15,
		-- never_unlimited = true,
		action 		= function()
			local fields = EntityGetWithTag( "de_chaos_polymorph_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end
			
			add_projectile("data/entities/projectiles/deck/chaos_polymorph_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "ELECTROCUTION_FIELD",
		name 		= "$action_electrocution_field",
		description = "$actiondesc_electrocution_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/electrocution_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electrocution_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/electrocution_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,3,5,6", -- ELECTROCUTION_FIELD
		spawn_probability                 = "0.3,0.5,0.7,0.3", -- ELECTROCUTION_FIELD
		price = 200,
		mana = 120,
		max_uses = 20,
		-- never_unlimited = true,
		action 		= function()
			local fields = EntityGetWithTag( "de_electrocution_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end
			
			add_projectile("data/entities/projectiles/deck/electrocution_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "FREEZE_FIELD",
		name 		= "$action_freeze_field",
		description = "$actiondesc_freeze_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/freeze_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/freeze_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,2,4,5", -- FREEZE_FIELD
		spawn_probability                 = "0.3,0.5,0.7,0.3", -- FREEZE_FIELD
		price = 200,
		mana = 180,
		max_uses = 20,
		-- never_unlimited = true,
		action 		= function()
			local fields = EntityGetWithTag( "de_freeze_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end
			
			add_projectile("data/entities/projectiles/deck/freeze_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "REGENERATION_FIELD",
		name 		= "$action_regeneration_field",
		description = "$actiondesc_regeneration_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/regeneration_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/regeneration_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/regeneration_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,3,4,10", -- REGENERATION_FIELD
		spawn_probability                 = "0.15,0.15,0.2,0.15,0.0001", -- REGENERATION_FIELD
		price = 250,
		mana = 259,
		max_uses = 1,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/regeneration_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 60
			c.damage_healing_add = c.damage_healing_add - 0.48
			c.damage_melee_add = -0.48
			c.damage_drill_add = -0.48
			c.damage_slice_add = -0.48
			c.damage_fire_add = -0.48
			c.damage_ice_add = -0.48
			c.damage_electricity_add = -0.48
			c.damage_curse_add = -0.48
			c.damage_explosion_add = -0.48
			c.damage_projectile_add = -0.48
		end,
	},
	{
		id          = "TELEPORTATION_FIELD",
		name 		= "$action_teleportation_field",
		description = "$actiondesc_teleportation_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/teleportation_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/teleportation_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleportation_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,10", -- TELEPORTATION_FIELD
		spawn_probability                 = "0.15,0.3,0.15,0.15,0.3,0.15,0.0001", -- TELEPORTATION_FIELD
		price = 150,
		mana = 258,
		max_uses = 5,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleportation_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 120
		end,
	},
	{
		id          = "LEVITATION_FIELD",
		name 		= "$action_levitation_field",
		description = "$actiondesc_levitation_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/levitation_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/levitation_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/levitation_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- LEVITATION_FIELD
		spawn_probability                 = "0.3,0.5,0.5,0.3", -- LEVITATION_FIELD
		price = 120,
		mana = 60,
		max_uses = 25,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/levitation_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	--[[{
		id          = "TELEPATHY_FIELD",
		name 		= "$action_telepathy_field",
		description = "$actiondesc_telepathy_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/telepathy_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/telepathy_field_unidentified.png",
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "", -- TELEPATHY_FIELD
		spawn_probability                 = "", -- TELEPATHY_FIELD
		price = 150,
		mana = 60,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/telepathy_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},]]--
	{
		id          = "SHIELD_FIELD",
		name 		= "$action_shield_field",
		description = "$actiondesc_shield_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/shield_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/shield_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/shield_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- SHIELD_FIELD
		spawn_probability                 = "0.2,0.2,0.3,0.4,0.2", -- SHIELD_FIELD
		price = 160,
		mana = 100,
		max_uses = 16,
		-- never_unlimited = true,
		action 		= function()
			local fields = EntityGetWithTag( "de_shield_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end

			add_projectile("data/entities/projectiles/deck/shield_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_ENCHANTER_FIELD",
		name 		= "$denchantment_field",
		description = "$ddenchantment_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/enchantment_field.png",
		related_projectiles	= {"data/entities/projectiles/deck/enchantment_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,6,7", -- SHIELD_FIELD
		spawn_probability                 = "0.3,0.4,0.5,0.05", -- SHIELD_FIELD
		price = 250,
		mana = 150,
		max_uses = 3,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/enchantment_field.xml",
		action 		= function()
			local fields = EntityGetWithTag( "de_enchantment_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end

			add_projectile("data/entities/projectiles/deck/enchantment_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_GUIDANCE_FIELD",
		name 		= "$dguidance_field",
		description = "$ddguidance_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/guidance_field.png",
		related_projectiles	= {"data/entities/projectiles/deck/guidance_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,2,5,7", -- SHIELD_FIELD
		spawn_probability                 = "0.3,0.4,0.5,0.05", -- SHIELD_FIELD
		price = 250,
		mana = 120,
		max_uses = 3,
		never_unlimited = true,
		action 		= function()
			local fields = EntityGetWithTag( "de_guidance_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end

			add_projectile("data/entities/projectiles/deck/guidance_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_STP_FIELD",
		name 		= "$dassimilation_field",
		description = "$ddassimilation_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/assimilation_field.png",
		related_projectiles	= {"data/entities/projectiles/deck/assimilation_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,3,4,7", -- SHIELD_FIELD
		spawn_probability                 = "0.3,0.4,0.5,0.05", -- SHIELD_FIELD
		price = 250,
		mana = 90,
		max_uses = 3,
		never_unlimited = true,
		action 		= function()
			local fields = EntityGetWithTag( "de_assimilation_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end

			add_projectile("data/entities/projectiles/deck/assimilation_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "PROJECTILE_TRANSMUTATION_FIELD",
		name 		= "$action_projectile_transmutation_field",
		description = "$actiondesc_projectile_transmutation_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/projectile_transmutation_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/projectile_transmutation_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "3,4,5,6", -- PROJECTILE_GRAVITY_FIELD
		spawn_probability                 = "0.2,0.6,0.1,0.3", -- PROJECTILE_GRAVITY_FIELD
		price = 350,
		mana = 90,
		max_uses = 13,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/projectile_transmutation_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "PROJECTILE_THUNDER_FIELD",
		name 		= "$action_projectile_thunder_field",
		description = "$actiondesc_projectile_thunder_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/projectile_thunder_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/projectile_thunder_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,5,6", -- PROJECTILE_THUNDER_FIELD
		spawn_probability                 = "0.4,0.4,0.2,0.2", -- PROJECTILE_THUNDER_FIELD
		price = 300,
		mana = 80,
		max_uses = 13,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/projectile_thunder_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "PROJECTILE_GRAVITY_FIELD",
		name 		= "$action_projectile_gravity_field",
		description = "$actiondesc_projectile_gravity_field",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/projectile_gravity_field.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/projectile_gravity_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,5,6", -- PROJECTILE_TRANSMUTATION_FIELD
		spawn_probability                 = "0.6,0.2,0.3,0.1", -- PROJECTILE_TRANSMUTATION_FIELD
		price = 250,
		mana = 70,
		max_uses = 13,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/projectile_gravity_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "VACUUM_POWDER",
		name 		= "$action_vacuum_powder",
		description = "$actiondesc_vacuum_powder",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/vacuum_powder.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/vacuum_powder.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,5,6", -- PROJECTILE_GRAVITY_FIELD
		spawn_probability                 = "0.3,0.7,0.3,0.4", -- PROJECTILE_GRAVITY_FIELD
		price = 150,
		mana = 40,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/vacuum_powder.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "VACUUM_LIQUID",
		name 		= "$action_vacuum_liquid",
		description = "$actiondesc_vacuum_liquid",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/vacuum_liquid.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/vacuum_liquid.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,4,5,6", -- PROJECTILE_GRAVITY_FIELD
		spawn_probability                 = "0.3,0.7,0.4,0.3", -- PROJECTILE_GRAVITY_FIELD
		price = 150,
		mana = 40,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/vacuum_liquid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "VACUUM_ENTITIES",
		name 		= "$action_vacuum_entities",
		description = "$actiondesc_vacuum_entities",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/vacuum_entities.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/vacuum_entities.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,5,6", -- PROJECTILE_GRAVITY_FIELD
		spawn_probability                 = "0.3,0.7,0.3,0.4", -- PROJECTILE_GRAVITY_FIELD
		price = 200,
		mana = 50,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/vacuum_entities.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "SEA_LAVA",
		name 		= "$action_sea_lava",
		description = "$actiondesc_sea_lava",
		-- spawn_requires_flag = "card_unlocked_sea_lava",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sea_lava.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sea_lava_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_lava.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_LAVA
		spawn_probability                 = "0.02,0.02,0.03,0.04", -- SEA_LAVA
		price = 350,
		mana = 60,
		max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_lava.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_ALCOHOL",
		name 		= "$action_sea_alcohol",
		description = "$actiondesc_sea_alcohol",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sea_alcohol.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sea_lava_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_alcohol.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_ALCOHOL
		spawn_probability                 = "0.03,0.05,0.04,0.01", -- SEA_ALCOHOL
		price = 350,
		mana = 10,
		-- max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_alcohol.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_OIL",
		name 		= "$action_sea_oil",
		description = "$actiondesc_sea_oil",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sea_oil.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sea_oil_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_oil.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_OIL
		spawn_probability                 = "0.03,0.05,0.04,0.01", -- SEA_OIL
		price = 350,
		mana = 20,
		-- max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_oil.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_WATER",
		name 		= "$action_sea_water",
		description = "$actiondesc_sea_water",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sea_water.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sea_water_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_water.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_WATER
		spawn_probability                 = "0.04,0.04,0.01,0.01", -- SEA_WATER
		price = 350,
		mana = 50,
		-- max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_water.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_SWAMP",
		name 		= "$action_sea_swamp",
		description = "$actiondesc_sea_swamp",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sea_swamp.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sea_swamp_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_swamp.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0", -- SEA_SWAMP
		spawn_probability                 = "0.01", -- SEA_SWAMP
		price = 350,
		mana = 40,
		-- max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_swamp.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_ACID",
		name 		= "$action_sea_acid",
		description = "$actiondesc_sea_acid",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sea_acid.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sea_acid_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_acid.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_ACID
		spawn_probability                 = "0.01,0.01,0.03,0.04", -- SEA_ACID
		price = 350,
		mana = 70,
		max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_acid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_ACID_GAS",
		name 		= "$action_sea_acid_gas",
		description = "$actiondesc_sea_acid_gas",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sea_acid_gas.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sea_acid_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_acid_gas.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_ACID_GAS
		spawn_probability                 = "0.01,0.03,0.03,0.03", -- SEA_ACID_GAS
		price = 200,
		mana = 30,
		-- max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_acid_gas.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_MIMIC",
		name 		= "$action_sea_mimic",
		description = "$actiondesc_sea_mimic",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sea_mimic.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sea_acid_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_mimic.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6,7,10", -- SEA_MIMIC
		spawn_probability                 = "0.01,0.01,0.02,0.02,0.1,0.02", -- SEA_MIMIC
		-- spawn_requires_flag = "card_unlocked_sea_mimic",
		price = 350,
		mana = 80,
		max_uses = 1,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_mimic.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "CLOUD_WATER",
		name 		= "$dcloud_fire",
		description = "$ddcloud_passive",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_cloud_fire.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/cloud_water_unidentified.png",
		-- related_projectiles	= {"data/entities/projectiles/deck/cloud_water.xml"},
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5", -- CLOUD_WATER
		spawn_probability                 = "0.1,0.2,0.3,0.3,0.2,0.1", -- CLOUD_WATER
		price = 70,
		mana = 0,
		-- max_uses = 0,
		custom_xml_file = "data/entities/misc/custom_cards/cloud_water.xml",
		action 		= function()
			-- add_projectile("data/entities/projectiles/deck/cloud_water.xml")
			-- c.fire_rate_wait = c.fire_rate_wait + 15
			draw_actions( 1, false )
		end,
	},
	{
		id          = "CLOUD_OIL",
		name 		= "$dcloud_pus",
		description = "$ddcloud_passive",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_cloud_pus.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/cloud_water_unidentified.png",
		-- related_projectiles	= {"data/entities/projectiles/deck/cloud_oil.xml"},
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5", -- CLOUD_WATER
		spawn_probability                 = "0.4,0.5,0.6,0.6,0.5,0.4", -- CLOUD_WATER
		price = 50,
		mana = 0,
		-- max_uses = 0,
		custom_xml_file = "data/entities/misc/custom_cards/cloud_oil.xml",
		action 		= function()
			-- add_projectile("data/entities/projectiles/deck/cloud_oil.xml")
			-- c.fire_rate_wait = c.fire_rate_wait + 15
			draw_actions( 1, false )
		end,
	},
	{
		id          = "CLOUD_BLOOD",
		name 		= "$dcloud_blood",
		description = "$ddcloud_passive",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_cloud_blood.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/cloud_water_unidentified.png",
		-- related_projectiles	= {"data/entities/projectiles/deck/cloud_blood.xml"},
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5", -- CLOUD_BLOOD
		spawn_probability                 = "0.1,0.2,0.2,0.3,0.2,0.1", -- CLOUD_BLOOD
		price = 100,
		mana = 0,
		-- max_uses = 0,
		custom_xml_file = "data/entities/misc/custom_cards/cloud_blood.xml",
		action 		= function()
			-- add_projectile("data/entities/projectiles/deck/cloud_blood.xml")
			-- c.fire_rate_wait = c.fire_rate_wait + 30
			draw_actions( 1, false )
		end,
	},
	{
		id          = "CLOUD_ACID",
		name 		= "$dcloud_pee",
		description = "$ddcloud_passive",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_cloud_pee.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/cloud_water_unidentified.png",
		-- related_projectiles	= {"data/entities/projectiles/deck/cloud_acid.xml"},
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5", -- CLOUD_ACID
		spawn_probability                 = "0.3,0.3,0.5,0.3,0.3,0.6", -- CLOUD_ACID
		price = 90,
		mana = 0,
		-- max_uses = 0,
		custom_xml_file = "data/entities/misc/custom_cards/cloud_acid.xml",
		action 		= function()
			-- add_projectile("data/entities/projectiles/deck/cloud_acid.xml")
			-- c.fire_rate_wait = c.fire_rate_wait + 15
			draw_actions( 1, false )
		end,
	},
	{
		id          = "CLOUD_THUNDER",
		name 		= "$dcloud_na",
		description = "$ddcloud_passive",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_cloud_na.png",
		-- spawn_requires_flag = "card_unlocked_cloud_thunder",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/cloud_water_unidentified.png",
		-- related_projectiles	= {"data/entities/projectiles/deck/cloud_thunder.xml"},
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5", -- CLOUD_THUNDER
		spawn_probability                 = "0.2,0.2,0.1,0.2,0.2,0.3", -- CLOUD_THUNDER
		price = 110,
		mana = 0,
		-- max_uses = 0,
		custom_xml_file = "data/entities/misc/custom_cards/cloud_thunder.xml",
		action 		= function()
			-- add_projectile("data/entities/projectiles/deck/cloud_thunder.xml")
			-- c.fire_rate_wait = c.fire_rate_wait + 30
			draw_actions( 1, false )
		end,
	},
	{
		id          = "ELECTRIC_CHARGE",
		name 		= "$action_electric_charge",
		description = "$actiondesc_electric_charge",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/electric_charge.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/particles/electricity.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5", -- ELECTRIC_CHARGE
		spawn_probability                 = "1,1,0.8,0.7", -- ELECTRIC_CHARGE
		price = 150,
		mana = 20,
		max_uses = 150,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			c.lightning_count = 1
			c.damage_electricity_add = c.damage_electricity_add + 0.32
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/electricity.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "MATTER_EATER",
		name 		= "$action_matter_eater",
		description = "$actiondesc_matter_eater",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/matter_eater.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/matter_eater.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5,10", -- MATTER_EATER
		spawn_probability                 = "0.1,0.9,0.1,0.2,0.2", -- MATTER_EATER
		price = 280,
		mana = 200,
		max_uses = 8,
		never_unlimited = true,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/matter_eater.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FREEZE",
		name 		= "$action_freeze",
		description = "$actiondesc_freeze",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/freeze.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/particles/freeze_charge.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- FREEZE
		spawn_probability                 = "1,1,0.9,0.8", -- FREEZE
		price = 140,
		mana = 4,
		max_uses = 150,
		custom_xml_file = "data/entities/misc/custom_cards/freeze.xml",
		action 		= function()
			c.damage_ice_add = c.damage_ice_add + 0.08
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_frozen.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/freeze_charge.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_BURNING_CRITICAL_HIT",
		name 		= "$action_hitfx_burning_critical_hit",
		description = "$actiondesc_hitfx_burning_critical_hit",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/burning_critical.png",
		-- sprite_unidentified = "data/entities/misc/hitfx_burning_critical_hit.xml",
		related_extra_entities = { "data/entities/particles/freeze_charge.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_BURNING_CRITICAL_HIT
		spawn_probability                 = "0.2,0.4,0.2,0.2", -- HITFX_BURNING_CRITICAL_HIT
		price = 70,
		mana = 2,
		--max_uses = 50,
		action 		= function()
			local mdf = de_str_finder( c.extra_entities, "hitfx_burning_critical_hit" )
			
			if mdf ~= nil then
				c.damage_critical_chance = math.max( c.damage_critical_chance + 25, 100 )
			else
				c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_burning_critical_hit.xml,"
			end

			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_CRITICAL_WATER",
		name 		= "$action_hitfx_critical_water",
		description = "$actiondesc_hitfx_critical_water",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/critical_water.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_critical_water.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_CRITICAL_WATER
		spawn_probability                 = "0.2,0.2,0.4,0.2", -- HITFX_CRITICAL_WATER
		price = 70,
		mana = 2,
		--max_uses = 50,
		action 		= function()
			local mdf = de_str_finder( c.extra_entities, "hitfx_critical_water" )
			
			if mdf ~= nil then
				c.damage_critical_chance = math.max( c.damage_critical_chance + 25, 100 )
			else
				c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_critical_water.xml,"
			end

			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_CRITICAL_OIL",
		name 		= "$action_hitfx_critical_oil",
		description = "$actiondesc_hitfx_critical_oil",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/critical_oil.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_critical_oil.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_CRITICAL_OIL
		spawn_probability                 = "0.2,0.4,0.2,0.2", -- HITFX_CRITICAL_OIL
		price = 70,
		mana = 2,
		--max_uses = 50,
		action 		= function()
			local mdf = de_str_finder( c.extra_entities, "hitfx_critical_oil" )
			
			if mdf ~= nil then
				c.damage_critical_chance = math.max( c.damage_critical_chance + 25, 100 )
			else
				c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_critical_oil.xml,"
			end

			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_CRITICAL_BLOOD",
		name 		= "$action_hitfx_critical_blood",
		description = "$actiondesc_hitfx_critical_blood",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/critical_blood.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_critical_blood.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_CRITICAL_BLOOD
		spawn_probability                 = "0.2,0.2,0.2,0.4", -- HITFX_CRITICAL_BLOOD
		price = 70,
		mana = 2,
		--max_uses = 50,
		action 		= function()
			local mdf = de_str_finder( c.extra_entities, "hitfx_critical_blood" )
			
			if mdf ~= nil then
				c.damage_critical_chance = math.max( c.damage_critical_chance + 25, 100 )
			else
				c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_critical_blood.xml,"
			end

			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_TOXIC_CHARM",
		name 		= "$action_hitfx_toxic_charm",
		description = "$actiondesc_hitfx_toxic_charm",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/charm_on_toxic.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_toxic_charm.xml", "data/entities/particles/tinyspark_green.xml"},
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_TOXIC_CHARM
		spawn_probability                 = "0.2,0.2,0.3,0.2", -- HITFX_TOXIC_CHARM
		price = 150,
		mana = 10,
		max_uses = 36,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_toxic_charm.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_green.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_EXPLOSION_SLIME_GIGA",
		name 		= "$action_hitfx_explosion_slime_giga",
		description = "$actiondesc_hitfx_explosion_slime_giga",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/explode_on_slime_giga.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_explode_slime_giga.xml", "data/entities/particles/tinyspark_purple.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_EXPLOSION_SLIME_GIGA
		spawn_probability                 = "0.05,0.05,0.1,0.05", -- HITFX_EXPLOSION_SLIME_GIGA
		price = 300,
		mana = 10,
		max_uses = 36,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_explode_slime_giga.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_purple.xml," )
			c.material_amount = c.material_amount + 20
			c.material = "cloud_slime"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_EXPLOSION_ALCOHOL",
		name 		= "$action_hitfx_explosion_alcohol",
		description = "$actiondesc_hitfx_explosion_alcohol",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/explode_on_alcohol.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_explode_alcohol.xml", "data/entities/particles/tinyspark_orange.xml"},
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_EXPLOSION_ALCOHOL
		spawn_probability                 = "0.1,0.05,0.05,0.05", -- HITFX_EXPLOSION_ALCOHOL
		price = 140,
		mana = 5,
		max_uses = 108,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_explode_alcohol.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_orange.xml," )
			c.material = "alcohol_gas"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_PETRIFY",
		name 		= "$action_petrify",
		description = "$actiondesc_petrify_a",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/petrify.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_petrify.xml", "data/entities/particles/tinyspark_purple_bright.xml"},
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,5", -- PETRIFY
		spawn_probability                 = "0.1,0.15,0.2,0.15,0.1", -- PETRIFY
		price = 140,
		mana = 6,
		max_uses = 108,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_petrify.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_purple_bright.xml," )
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_saving_grace_once.xml," )
			-- c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/curse_strong.xml," )
			-- c.damage_curse_add = c.damage_curse_add + 0.16
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_HITFX_MIDAS",
		name 		= "$HITFX_MIDAS",
		description = "$dHITFX_MIDAS",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/petrify_midas.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_petrify_midas.xml", "data/entities/particles/tinyspark_yellow.xml"},
		type 		= ACTION_TYPE_MODIFIER,
		-- spawn_requires_flag = "card_unlocked_divide",
		spawn_level                       = "2,3,5,6,7,10", -- PETRIFY
		spawn_probability                 = "0.1,0.1,0.2,0.2,0.2,0.01", -- PETRIFY
		price = 999,
		mana = 24,
		max_uses = 72,
		custom_xml_file = "data/entities/misc/custom_cards/petrify_midas.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_petrify_midas.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_yellow.xml," )
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_saving_grace_once.xml," )
			-- c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/curse_strong.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_RAPE",
		name 		= "$RAPE",
		description = "$dRAPE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bloody_reap.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_bloody_reap.xml", "data/entities/particles/tinyspark_red.xml"},
		type 		= ACTION_TYPE_MODIFIER,
		-- spawn_requires_flag = "card_unlocked_divide",
		spawn_level                       = "2,3,5,6,7,10", -- PETRIFY
		spawn_probability                 = "0.1,0.1,0.2,0.2,0.2,0.01", -- PETRIFY
		price = 999,
		mana = 32,
		max_uses = 72,
		custom_xml_file = "data/entities/misc/custom_cards/bloody_reap.xml",
		action 		= function()
			local entity_id = GetUpdatedEntityID()
			local dcomps = EntityGetComponent( entity_id, "DamageModelComponent" )
			
			if ( dcomps ~= nil ) and ( #dcomps > 0 ) then
				for a,b in ipairs( dcomps ) do
					local hp = ComponentGetValue2( b, "hp" )
					hp = math.max( hp - 0.16, 0.04 )
					ComponentSetValue2( b, "hp", hp )
				end

				c.material = "cloud_blood"
				c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_bloody_reap.xml," )
				c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_red.xml," )
				c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_saving_grace_once.xml," )
				-- c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/curse_strong.xml," )
			else
				mana = math.max( mana + 32, 0 )
			end
	
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SLIVER_BULLET", -- silver bullet
		name 		= "$SLIVER_BULLET",
		description = "$dSLIVER_BULLET",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sliver_bullet.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_sliver_bullet.xml", "data/entities/particles/light_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "7,10", -- PETRIFY
		spawn_probability                 = "0.01,0.01", -- PETRIFY
		price = 777,
		mana = 100,
		max_uses = 6,
		never_unlimited = true,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/sliver_bullet.xml",
		action 		= function()
			local mdf = de_str_finder( c.extra_entities, "hitfx_sliver_bullet" )

			if mdf ~= nil then
				c.damage_critical_chance = math.max( c.damage_critical_chance + 50, 100 )
			else
				c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_sliver_bullet.xml,"
				c.damage_critical_chance = c.damage_critical_chance + 20
			end

			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/light_shot.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_F_T_L",
		name 		= "$F_T_L",
		description = "$dF_T_L",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/f_t_l.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/f_t_l.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,10", -- PETRIFY
		spawn_probability                 = "0.04,0.04,0.04,0.04,0.04,0.04,0.02,0.2,0.04", -- PETRIFY
		price = 512,
		mana = 25,
		max_uses = 64,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/f_t_l.xml," )
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
			
			c.speed_multiplier = c.speed_multiplier * 1024
			c.material = "spark_white_bright"

			if ( c.screenshake == 256 ) or ( c.screenshake == 0 ) then
				c.screenshake = 0
			else
				c.screenshake = 256
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_HEMOKINESIS",
		name 		= "$HEMOKINESIS",
		description = "$dHEMOKINESIS",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/hemokinesis.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/hemokinesis.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,4,10", -- PETRIFY
		spawn_probability                 = "0.2,0.3,0.2,0.3,0.02", -- PETRIFY
		price = 666,
		mana = 10,
		max_uses = 66,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/hemokinesis.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_hemokinesis.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hemokinesis.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_CHAIN_BLAST",
		name 		= "$CHAIN_BLAST",
		description = "$dCHAIN_BLAST",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/blasting_chain_reaction.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/blasting_chain_reaction.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5,7,10", -- PETRIFY
		spawn_probability                 = "0.2,0.3,0.4,0.5,0.06", -- PETRIFY
		price = 512,
		mana = 64,
		max_uses = 12,
		custom_xml_file = "data/entities/misc/custom_cards/blasting_chain_reaction.xml",
		action 		= function()
			local mdf_1 = de_str_finder( c.extra_entities, "data/entities/misc/blasting_chain_reaction.xml," )
			local mdf_2 = de_str_finder( c.extra_entities, "data/entities/misc/blasting_chain_reaction_rapid.xml," )
			
			if mdf_2 == nil then
				if mdf_1 == nil then
					c.extra_entities = c.extra_entities .. "data/entities/misc/blasting_chain_reaction.xml,"
				else
					c.extra_entities = c.extra_entities:gsub( "data/entities/misc/blasting_chain_reaction.xml,", "data/entities/misc/blasting_chain_reaction_rapid.xml,", 1 )
				end

				c.screenshake = c.screenshake + 15
				shot_effects.recoil_knockback = shot_effects.recoil_knockback + 45.0
			end

			c.explosion_radius = clamp( c.explosion_radius + 6.0, 0, 256 )
			c.fire_rate_wait = c.fire_rate_wait + 42
			c.lifetime_add	= c.lifetime_add + 12
			c.speed_multiplier = math.max( c.speed_multiplier * 0.6, 0 )

			draw_actions( 1, true )
		end,
	},
	--[[ { WIP
		id          = "HITFX_POLTERGEIST",
		name 		= "$action_hitfx_poltergeist",
		description = "$actiondesc_hitfx_poltergeist",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/critical_blood.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/critical_blood.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- HITFX_POLTERGEIST
		spawn_probability                 = "", -- HITFX_POLTERGEIST
		price = 70,
		mana = 10,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_poltergeist.xml,"
			draw_actions( 1, true )
		end,
	},]]--
	{
		id          = "ROCKET_DOWNWARDS",
		name 		= "$action_rocket_downwards",
		description = "$actiondesc_rocket_downwards",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/rocket_downwards.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/rocket_downwards.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3", -- ROCKET_DOWNWARDS
		spawn_probability                 = "0.5,0.3,0.1", -- ROCKET_DOWNWARDS
		price = 200,
		mana = 27,
		max_uses = 75,
		action 		= function()
			c.gravity = c.gravity - 100.0
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/rocket_downwards.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 25
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ROCKET_OCTAGON",
		name 		= "$action_rocket_octagon",
		description = "$actiondesc_rocket_octagon",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/rocket_octagon.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/rocket_octagon.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- ROCKET_DOWNWARDS
		spawn_probability                 = "0.1,0.3,0.5", -- ROCKET_DOWNWARDS
		price = 200,
		mana = 27,
		max_uses = 75,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/rocket_octagon.xml," )
			c.fire_rate_wait = c.fire_rate_wait + 20
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FIZZLE",
		name 		= "$action_fizzle",
		description = "$actiondesc_fizzle",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/fizzle.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/fizzle.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5", -- CHAOTIC_ARC
		spawn_probability                 = "0.05,0.1,0.15,0.05,0.1,0.15", -- CHAOTIC_ARC
		price = 0,
		mana = -10,
		max_uses = 150,
		action 		= function()
			c.gravity = 0.0
			c.fire_rate_wait = c.fire_rate_wait - 20
			c.speed_multiplier = c.speed_multiplier * 1.2
			if c.screenshake < 256 then c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/fizzle.xml," ) end
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_EXPLOSION",
		name 		= "$action_bounce_explosion",
		description = "$actiondesc_bounce_explosion",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bounce_explosion.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_explosion.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5", -- BOUNCE_EXPLOSION
		spawn_probability                 = "0.1,0.2,0.1,0.1", -- BOUNCE_EXPLOSION
		price = 180,
		mana = 1,
		max_uses = 150,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/bounce_explosion.xml," )
			c.bounces = c.bounces + 5
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_SPARK",
		name 		= "$action_bounce_spark",
		description = "$actiondesc_bounce_spark",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bounce_spark.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_spark.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- BOUNCE_SPARK
		spawn_probability                 = "0.1,0.1,0.2,0.1", -- BOUNCE_SPARK
		price = 120,
		mana = 1,
		max_uses = 150,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/bounce_spark.xml," )
			c.bounces = c.bounces + 5
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 5.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_LASER",
		name 		= "$action_bounce_laser",
		description = "$actiondesc_bounce_laser",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bounce_laser.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_laser.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5", -- BOUNCE_SPARK
		spawn_probability                 = "0.1,0.1,0.1", -- BOUNCE_SPARK
		price = 180,
		mana = 1,
		max_uses = 150,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/bounce_laser.xml," )
			c.bounces = c.bounces + 5
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 5.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_LASER_EMITTER",
		name 		= "$action_bounce_laser_emitter",
		description = "$actiondesc_bounce_laser_emitter",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bounce_laser_emitter.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_laser_emitter.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5", -- BOUNCE_SPARK
		spawn_probability                 = "0.1,0.1,0.2", -- BOUNCE_SPARK
		price = 180,
		mana = 5,
		max_uses = 150,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/bounce_laser_emitter.xml," )
			c.bounces = c.bounces + 5
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 5.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_LARPA",
		name 		= "$action_bounce_larpa",
		description = "$actiondesc_bounce_larpa",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bounce_larpa.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_larpa.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "4,5,6", -- BOUNCE_SPARK
		spawn_probability                 = "0.1,0.2,0.1", -- BOUNCE_SPARK
		price = 250,
		mana = 20,
		max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/bounce_larpa.xml,"
			c.bounces = c.bounces + 3
			c.fire_rate_wait = c.fire_rate_wait + 6
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_LIGHTNING",
		name 		= "$action_bounce_lightning",
		description = "$actiondesc_bounce_lightning",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bounce_lightning.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_lightning.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- BOUNCE_EXPLOSION
		spawn_probability                 = "0.1,0.1,0.2", -- BOUNCE_EXPLOSION
		price = 180,
		mana = 5,
		max_uses = 150,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/bounce_lightning.xml," )
			c.bounces = c.bounces + 5
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_HOLE",
		name 		= "$action_bounce_hole",
		description = "$actiondesc_bounce_hole",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bounce_hole.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_hole.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,2,4,6,10", -- BOUNCE_EXPLOSION
		spawn_probability                 = "0.1,0.05,0.1,0.1,0.05", -- BOUNCE_EXPLOSION
		price = 220,
		mana = 20,
		max_uses = 20,
		never_unlimited = true,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/bounce_hole.xml," )
			c.bounces = c.bounces + 3
			c.fire_rate_wait = c.fire_rate_wait + 24
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FIREBALL_RAY",
		name 		= "$action_fireball_ray",
		description = "$actiondesc_fireball_ray",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/fireball_ray.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/fireball_ray.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5", -- FIREBALL_RAY
		spawn_probability                 = "0.1,0.2,0.1,0.05", -- FIREBALL_RAY
		price = 150,
		mana = 10,
		max_uses = 16,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = c.extra_entities .. "data/entities/misc/fireball_ray.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIGHTNING_RAY",
		name 		= "$action_lightning_ray",
		description = "$actiondesc_lightning_ray",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/lightning_ray.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/lightning_ray.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5", -- LIGHTNING_RAY
		spawn_probability                 = "0.05,0.1,0.1,0.2", -- LIGHTNING_RAY
		price = 180,
		mana = 10,
		max_uses = 16,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = c.extra_entities .. "data/entities/misc/lightning_ray.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TENTACLE_RAY",
		name 		= "$action_tentacle_ray",
		description = "$actiondesc_tentacle_ray",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/tentacle_ray.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/tentacle_ray.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- TENTACLE_RAY
		spawn_probability                 = "0.1,0.1,0.2,0.05", -- TENTACLE_RAY
		price = 150,
		mana = 10,
		max_uses = 16,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = c.extra_entities .. "data/entities/misc/tentacle_ray.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LASER_EMITTER_RAY",
		name 		= "$action_laser_emitter_ray",
		description = "$actiondesc_laser_emitter_ray",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/laser_emitter_ray.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/laser_emitter_ray.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4", -- TENTACLE_RAY
		spawn_probability                 = "0.1,0.05,0.1,0.05,0.1", -- TENTACLE_RAY
		price = 150,
		mana = 10,
		max_uses = 16,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = c.extra_entities .. "data/entities/misc/laser_emitter_ray.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FIREBALL_RAY_LINE",
		name 		= "$dFIREBALL_RAY_LINE",
		description = "$ddFIREBALL_RAY_LINE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_fireball_ray_line.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/fireball_ray_line.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- FIREBALL_RAY_LINE
		spawn_probability                 = "0.3,0.2,0.1,0.2,0.3", -- FIREBALL_RAY_LINE
		price = 120,
		mana = 10,
		max_uses = 20,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = c.extra_entities .. "data/entities/misc/fireball_ray_line.xml,"
			c.speed_multiplier = math.max( c.speed_multiplier * 0.5, 0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FIREBALL_RAY_ENEMY",
		name 		= "$action_fireball_ray_enemy",
		description = "$actiondesc_fireball_ray_enemy",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/fireball_ray_enemy.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_fireball_ray_enemy.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.05,0.1,0.05,0.1,0.05", -- FIREBALL_RAY_ENEMY
		price = 100,
		mana = 10,
		max_uses = 20,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_fireball_ray_enemy.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIGHTNING_RAY_ENEMY",
		name 		= "$action_lightning_ray_enemy",
		description = "$actiondesc_lightning_ray_enemy",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/lightning_ray_enemy.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_lightning_ray_enemy.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- LIGHTNING_RAY_ENEMY
		spawn_probability                 = "0.05,0.05,0.05,0.1,0.1", -- LIGHTNING_RAY_ENEMY
		price = 150,
		mana = 10,
		max_uses = 20,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_lightning_ray_enemy.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TENTACLE_RAY_ENEMY",
		name 		= "$action_tentacle_ray_enemy",
		description = "$actiondesc_tentacle_ray_enemy",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/tentacle_ray_enemy.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_tentacle_ray_enemy.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- TENTACLE_RAY_ENEMY
		spawn_probability                 = "0.1,0.1,0.05,0.05,0.05", -- TENTACLE_RAY_ENEMY
		price = 150,
		mana = 10,
		max_uses = 20,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_tentacle_ray_enemy.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "GRAVITY_FIELD_ENEMY",
		name 		= "$action_gravity_field_enemy",
		description = "$actiondesc_gravity_field_enemy",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/gravity_field_enemy.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_gravity_field_enemy.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5,6", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.2,0.2,0.35,0.5,0.5", -- GRAVITY_FIELD_ENEMY
		price = 250,
		mana = 60,
		max_uses = 20,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_gravity_field_enemy.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CURSE",
		name 		= "$action_curse",
		description = "$actiondesc_curse",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/curse.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_curse.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,5,6,10", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.2,0.3,0.3,0.2,0.1", -- FIREBALL_RAY_ENEMY
		price = 140,
		mana = 45,
		max_uses = 66,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_curse.xml," )
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_apply_poison.xml," )
			-- c.damage_curse_add = c.damage_curse_add + 0.15
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CURSE_WITHER_PROJECTILE",
		name 		= "$action_curse_wither_projectile",
		description = "$actiondesc_curse_wither_projectile",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/curse_wither_projectile.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_curse_wither_projectile.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "4,5,6,7,10", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.5,0.5,0.6,0.1,0.1", -- FIREBALL_RAY_ENEMY
		price = 100,
		mana = 15,
		max_uses = 66,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_curse_wither_projectile.xml," )
			c.damage_projectile_add = c.damage_projectile_add + 0.02
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CURSE_WITHER_EXPLOSION",
		name 		= "$action_curse_wither_explosion",
		description = "$actiondesc_curse_wither_explosion",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/curse_wither_explosion.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_curse_wither_explosion.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "4,5,6,7,10", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.6,0.6,0.4,0.1,0.1", -- FIREBALL_RAY_ENEMY
		price = 100,
		mana = 15,
		max_uses = 66,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_curse_wither_explosion.xml," )
			c.damage_explosion_add = c.damage_explosion_add + 0.02
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CURSE_WITHER_MELEE",
		name 		= "$action_curse_wither_melee",
		description = "$actiondesc_curse_wither_melee",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/curse_wither_melee.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_curse_wither_melee.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "4,5,6,7,10", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.4,0.6,0.6,0.1,0.1", -- FIREBALL_RAY_ENEMY
		price = 100,
		mana = 15,
		max_uses = 66,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_curse_wither_melee.xml," )
			c.damage_melee_add = c.damage_melee_add + 0.02
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CURSE_WITHER_ELECTRICITY",
		name 		= "$action_curse_wither_electricity",
		description = "$actiondesc_curse_wither_electricity",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/curse_wither_electricity.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_curse_wither_electricity.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "4,5,6,7,10", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.5,0.6,0.5,0.1,0.1", -- FIREBALL_RAY_ENEMY
		price = 100,
		mana = 15,
		max_uses = 66,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/hitfx_curse_wither_electricity.xml," )
			c.damage_electricity_add = c.damage_electricity_add + 0.02
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ORBIT_DISCS",
		name 		= "$action_orbit_discs",
		description = "$actiondesc_orbit_discs",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/orbit_discs.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_discs.xml" },
		-- spawn_requires_flag = "card_unlocked_dragon",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.3,0.4,0.4,0.3", -- GRAVITY_FIELD_ENEMY
		price = 200,
		mana = 20,
		max_uses = DE_USAGE * 5,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_discs.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ORBIT_FIREBALLS",
		name 		= "$action_orbit_fireballs",
		description = "$actiondesc_orbit_fireballs",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/orbit_fireballs.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_fireballs.xml" },
		-- spawn_requires_flag = "card_unlocked_dragon",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,4,5", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.3,0.4,0.5,0.3,0.1", -- GRAVITY_FIELD_ENEMY
		price = 140,
		mana = 25,
		max_uses = DE_USAGE * 5,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_fireballs.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ORBIT_NUKES",
		name 		= "$action_orbit_nukes",
		description = "$actiondesc_orbit_nukes",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/orbit_nukes.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_nukes.xml" },
		-- spawn_requires_flag = "card_unlocked_dragon",
		type 		= ACTION_TYPE_MODIFIER,
		ai_never_uses = true,
		spawn_level                       = "2,4,5,6,10", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.01,0.01,0.01,0.01,0.01", -- GRAVITY_FIELD_ENEMY
		price = 400,
		mana = -250,
		max_uses = 666,
		action 		= function()
			local strf = de_str_finder( c.extra_entities, "data/entities/misc/orbit_nukes.xml," )
			if ( strf == nil ) then mana = math.max( mana - 250, math.floor( mana / 2 ) + 50 ) end
			
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_nukes.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ORBIT_LASERS",
		name 		= "$action_orbit_lasers",
		description = "$actiondesc_orbit_lasers",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/orbit_lasers.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_lasers.xml" },
		-- spawn_requires_flag = "card_unlocked_dragon",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5,10", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.3,0.4,0.5,0.3,0.1", -- GRAVITY_FIELD_ENEMY
		price = 200,
		mana = 75,
		max_uses = DE_USAGE * 5,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_lasers.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ORBIT_LARPA",
		name 		= "$action_orbit_larpa",
		description = "$actiondesc_orbit_larpa",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/orbit_larpa.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_larpa.xml" },
		-- spawn_requires_flag = "card_unlocked_dragon",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,6,10", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.15,0.3,0.45,0.05", -- GRAVITY_FIELD_ENEMY
		price = 240,
		mana = 125,
		max_uses = DE_USAGE * 5,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_larpa.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CHAIN_SHOT",
		name 		= "$action_chain_shot",
		description = "$actiondesc_chain_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/chain_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/chain_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- AREA_DAMAGE
		spawn_probability                 = "0.2,0.3,0.5", -- AREA_DAMAGE
		price = 240,
		mana = 30,
		max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/chain_shot.xml,"
			c.lifetime_add = c.lifetime_add - 30
			c.damage_projectile_add = c.damage_projectile_add - 0.2
			c.explosion_radius = clamp( c.explosion_radius - 5.0, 0, 256 )
			c.spread_degrees = c.spread_degrees + 60.0
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "HITFX_OILED_FREEZE",
		name 		= "$action_hitfx_oiled_freeze",
		description = "$actiondesc_hitfx_oiled_freeze",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/oiled_freeze.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- HITFX_OILED_FREEZE
		spawn_probability                 = "", -- HITFX_OILED_FREEZE
		price = 70,
		mana = 10,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_oiled_freeze.xml,"
			draw_actions( 1, true )
		end,
	},
	]]--
	--[[
	{
		id          = "ALCOHOL_SHOT",
		name 		= "$action_alcohol_shot",
		description = "$actiondesc_alcohol_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/inebriation.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- ALCOHOL_SHOT
		spawn_probability                 = "", -- ALCOHOL_SHOT
		price = 70,
		mana = 10,
		--max_uses = 50,
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_drunk.xml,"
			draw_actions( 1, true )
		end,
	},
	]]--
	--[[
	{
		id          = "FREEZE_IF_WET_SHOOTER",
		name 		= "$action_freeze_if_wet_shooter",
		description = "$actiondesc_freeze_if_wet_shooter",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/freeze.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- FREEZE_IF_WET_SHOOTER
		spawn_probability                 = "", -- FREEZE_IF_WET_SHOOTER
		price = 140,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/freeze_if_wet_shooter.xml", -- shoteffectcomponent in this effect applies the effect
		action 		= function()
			draw_actions( 1, true )
		end,
	},
	--]]
	--[[
	{
		id          = "BLINDNESS",
		name 		= "$action_blindness",
		description = "$actiondesc_blindness",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/blindness.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BLINDNESS
		spawn_probability                        = "", -- BLINDNESS
		price = 100,
		mana = 10,
		max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/blindness.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_blindness.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/blindness.xml,"
		end,
	},
	{
		id          = "TELEPORTATION",
		name 		= "$action_teleportation",
		description = "$actiondesc_teleportation",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/teleportation.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- TELEPORTATION
		spawn_probability                        = "", -- TELEPORTATION
		price = 100,
		mana = 10,
		max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/teleportation.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_teleportation.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/teleportation.xml,"
		end,
	},
	{
		id          = "TELEPATHY",
		name 		= "$action_telepathy",
		description = "$actiondesc_telepathy",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/telepathy.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "", -- TELEPATHY
		spawn_probability                        = "", -- TELEPATHY
		price = 100,
		mana = 10,
		max_uses = 50,
		--custom_xml_file = "data/entities/misc/custom_cards/freeze.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_telepathy.xml,"
		end,
	},
	]]--
	{
		id          = "ARC_ELECTRIC",
		name 		= "$action_arc_electric",
		description = "$actiondesc_arc_electric",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/arc_electric.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/arc_electric_unidentified.png",
		related_extra_entities = { "data/entities/misc/arc_electric.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5", -- ARC_ELECTRIC
		spawn_probability                 = "0.2,0.2,0.2,0.2", -- ARC_ELECTRIC
		price = 170,
		--max_uses 	= 15,
		mana = 12,
		custom_xml_file = "data/entities/misc/custom_cards/arc_electric.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/arc_electric.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ARC_FIRE",
		name 		= "$action_arc_fire",
		description = "$actiondesc_arc_fire",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/arc_fire.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/arc_fire_unidentified.png",
		related_extra_entities = { "data/entities/misc/arc_fire.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- ARC_FIRE
		spawn_probability                 = "0.1,0.1,0.15,0.15", -- ARC_FIRE
		price = 160,
		--max_uses 	= 15,
		mana = 6,
		custom_xml_file = "data/entities/misc/custom_cards/arc_fire.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/arc_fire.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ARC_POISON",
		name 		= "$action_arc_poison",
		description = "$actiondesc_arc_poison",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/arc_poison.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/arc_fire_unidentified.png",
		related_extra_entities = { "data/entities/misc/arc_poison.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- ARC_POISON
		spawn_probability                 = "0.2,0.1,0.2,0.1,0.2", -- ARC_POISON
		price = 160,
		--max_uses 	= 15,
		mana = 8,
		-- custom_xml_file = "data/entities/misc/custom_cards/arc_poison.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/arc_poison.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CRUMBLING_EARTH_PROJECTILE",
		name 		= "$action_crumbling_earth_projectile",
		description = "$actiondesc_crumbling_earth_projectile",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/crumbling_earth_projectile.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/arc_fire_unidentified.png",
		related_extra_entities = { "data/entities/misc/crumbling_earth_projectile.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- ARC_POISON
		spawn_probability                 = "0.04,0.08,0.04,0.08,0.04", -- ARC_POISON
		price = 200,
		max_uses 	= 15,
		mana = 45,
		-- custom_xml_file = "data/entities/misc/custom_cards/arc_poison.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/crumbling_earth_projectile.xml," )
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "POLYMORPH",
		name 		= "$action_polymorph",
		description = "$actiondesc_polymorph",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/polymorph.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- POLYMORPH
		spawn_probability                        = "", -- POLYMORPH
		price = 100,
		max_uses 	= 7,
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/polymorph.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile - 0.003
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_polymorph.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/polymorph.xml,"
			-- c.extra_entities = c.extra_entities .. "data/entities/particles/freeze_charge.xml,"
		end,
	},
	{
		id          = "BERSERK",
		name 		= "$action_berserk",
		description = "$actiondesc_berserk",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/berserk.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BERSERK
		spawn_probability                        = "", -- BERSERK
		price = 100,
		max_uses    = 12,
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/berserk.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.2
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_berserk.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/berserk.xml,"
		end,
	},
	{
		id          = "CHARM",
		name 		= "$action_charm",
		description = "$actiondesc_charm",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/charm.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level       = "", -- CHARM
		spawn_probability = "", -- CHARM
		price = 100,
		max_uses    = 12,
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/charm.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.2
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_charm.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/charm.xml,"
		end,
	},
	]]--
	{
		id          = "X_RAY",
		name 		= "$action_x_ray",
		description = "$actiondesc_x_ray",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/x_ray.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/x_ray_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/xray.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level       = "0,1,2,3,4,5,6,10", -- X_RAY
		spawn_probability = "0.8,0.8,0.8,0.0.8,0.6,0.4,0.2,0.02", -- X_RAY
		price = 230,
		max_uses    = 16,
		mana = 20,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/xray.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/xray.xml")
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_GFUEL",
		name 		= "$GFUEL",
		description = "$dGFUEL",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/g_fuel.png",
		related_projectiles	= {"data/entities/projectiles/deck/epinephrine.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level       = "0,1,2,3,4,5,6,10", -- X_RAY
		spawn_probability = "0.2,0.4,0.6,0.6,0.4,0.2,0.2,0.01", -- X_RAY
		price = 170,
		max_uses    = 8,
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/epinephrine.xml")

			current_reload_time = current_reload_time + c.fire_rate_wait
			c.fire_rate_wait = 0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_CHARGE",
		name 		= "$CHARGE",
		description = "$dCHARGE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/charge.png",
		related_projectiles	= {"data/entities/misc/mana_from_spell_side.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level       = "0,1,2,3,4,5,6,10", -- X_RAY
		spawn_probability = "0.1,0.2,0.3,0.3,0.2,0.1,0.1,0.04", -- X_RAY
		price = 200,
		max_uses    = 128,
		mana = 0,
		action 		= function()
			local entity_id, eid = GetUpdatedEntityID(), nil

			if entity_id ~= nil and entity_id ~= NULL_ENTITY then
				local px, py = EntityGetTransform( entity_id )

				if EntityHasTag( entity_id, "de_effect_charge" ) then
    				eid = EntityLoad( "data/entities/misc/mana_from_spell_init.xml", px, py )
				else
					eid = EntityLoad( "data/entities/misc/mana_from_spell.xml", px, py )

					EntityAddTag( entity_id, "de_effect_charge" )
				end
				EntityAddChild( entity_id, eid )
			end
			
			-- c.screenshake = c.screenshake + clamp( math.floor( mana * 0.04 - 3 ), -0.5, 16.0 )
			if GameGetFrameNum() < 60 then
				c.fire_rate_wait = c.fire_rate_wait + 20
				current_reload_time = current_reload_time + 20
			else
				c.fire_rate_wait = c.fire_rate_wait - math.min( math.floor( mana * 0.08 - 20 ), 10 )
				current_reload_time = current_reload_time - math.min( math.floor( mana * 0.08 - 20 ), 10 )
			end
			
			mana = clamp( math.ceil( mana * 0.5 ), 25, 200 )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_HAEMOSPASIA",
		name 		= "$HAEMOSPASIA",
		description = "$dHAEMOSPASIA",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/haemospasia.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level       = "0,1,2,3,4,5,6,10", -- X_RAY
		spawn_probability = "0.2,0.4,0.6,0.6,0.4,0.2,0.2,0.03", -- X_RAY
		price = 10,
		mana = -1,
		max_uses    = 8,
		never_unlimited = true,
		action 		= function()
			local entity_id, eid = GetUpdatedEntityID(), nil

			if entity_id ~= nil and entity_id ~= NULL_ENTITY then
				local px, py = EntityGetTransform( entity_id )

				if EntityHasTag( entity_id, "de_effect_cannon" ) then
    				eid = EntityLoad( "data/entities/misc/glass_cannon_short_init.xml", px, py )
				else
					eid = EntityLoad( "data/entities/misc/effect_glass_cannon_short.xml", px, py )

					EntityAddTag( entity_id, "de_effect_cannon" )
				end

				EntityAddChild( entity_id, eid )
				EntityInflictDamage( entity_id, 0.16, "DAMAGE_HEALING", "$HAEMOSPASIA", "NONE", 0, 0, entity_id )
				-- EntityAddRandomStains( entity_id, CellFactory_GetType("blood"), 600 )
				GamePlaySound( "data/audio/Desktop/animals.bank", "animals/boss_centipede/damage/projectile", px, py )
			end

			c.fire_rate_wait = c.fire_rate_wait + 12
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_CAPE_PURIFY",
		name 		= "$CAPE_PURIFY",
		description = "$dCAPE_PURIFY",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/cape_purification.png",
		related_projectiles	= {"data/entities/misc/cape_purification.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level       = "0,1,2,3,4,5,6,10", -- X_RAY
		spawn_probability = "0.2,0.4,0.6,0.6,0.4,0.2,0.2,0.03", -- X_RAY
		price = 10,
		max_uses    = 24,
		mana = 10,
		action 		= function()
			local entity_id = GetUpdatedEntityID()

			if ( entity_id ~= nil ) and ( entity_id ~= NULL_ENTITY ) then
				local px, py = EntityGetTransform( entity_id )
    			EntityAddChild( entity_id, EntityLoad( "data/entities/misc/cape_purification.xml", px, py ) )
			end

			c.fire_rate_wait = c.fire_rate_wait + 20
			current_reload_time = current_reload_time + 20
		end,
	},
	--[[
	{
		id          = "X_RAY_MODIFIER",
		name 		= "$action_x_ray_modifier",
		description = "$actiondesc_x_ray_modifier",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/x_ray.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/x_ray_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- X_RAY_MODIFIER
		spawn_probability                 = "", -- X_RAY_MODIFIER
		price = 150,
		mana = 8,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/fogofwar_radius.xml",
		action 		= function()
			c.lightning_count = c.lightning_count + 1
			c.damage_electricity_add = c.damage_electricity_add + 0.1
			c.extra_entities = c.extra_entities .. "data/entities/particles/electricity.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ACID",
		name 		= "$action_acid",
		description = "$actiondesc_acid",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/acid.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- ACID
		spawn_probability                        = "", -- ACID
		price = 100,
		action 		= function()
			material = "acid"
			material_amount = material_amount + 20
		end,
	},]]--
	{
		id          = "HITFX_EXPLOSION_ALCOHOL_GIGA",
		name 		= "$dEXP_MAT_FUNGI",
		description = "$ddEXP_MAT_FUNGI",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/exp_mat_fungi.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_purple.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_EXPLOSION_ALCOHOL_GIGA
		spawn_probability                 = "0.2,0.1,0.05,0.1", -- HITFX_EXPLOSION_ALCOHOL_GIGA
		price = 140,
		mana = 2,
		max_uses = 55,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_purple.xml," )
			c.material = "blood_fungi"
			c.material_amount = c.material_amount + 33
			shot_effects.recoil_knockback = math.max( shot_effects.recoil_knockback - 10, 0.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_EXPLOSION_SLIME",
		name 		= "$dEXP_MAT_TOXIC",
		description = "$ddEXP_MAT_TOXIC",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/exp_mat_toxic.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_green.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_EXPLOSION_SLIME
		spawn_probability                 = "0.2,0.1,0.05,0.1", -- HITFX_EXPLOSION_SLIME
		price = 140,
		mana = 5,
		max_uses = 45,
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_green.xml," )
			c.material = "radioactive_liquid_fading"
			c.material_amount = c.material_amount + 33
			shot_effects.recoil_knockback = math.max( shot_effects.recoil_knockback - 10, 0.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "UNSTABLE_GUNPOWDER",
		name 		= "$dUNSTABLE_GUNPOWDER",
		description = "$ddUNSTABLE_GUNPOWDER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_water_fading.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/unstable_gunpowder_unidentified.png",
		related_extra_entities = { "data/entities/particles/light_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                      = "1,2,3,4", -- UNSTABLE_GUNPOWDER
		spawn_probability                = "0.3,0.1,0.1,0.1", -- UNSTABLE_GUNPOWDER
		price = 140,
		mana = 2,
		max_uses = 35, 
		-- custom_xml_file = "data/entities/misc/custom_cards/unstable_gunpowder.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/light_shot.xml," )
			c.material = "water_fading"
			c.material_amount = c.material_amount + 33
			shot_effects.recoil_knockback = math.max( shot_effects.recoil_knockback - 10, 0.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ARC_GUNPOWDER",
		name 		= "$dARC_GUNPOWDER",
		description = "$ddARC_GUNPOWDER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_concrete_static.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/arc_fire_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_white_weak.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- ARC_GUNPOWDER
		spawn_probability                 = "0.3,0.1,0.1,0.1", -- ARC_GUNPOWDER
		price = 160,
		max_uses = 15,
		mana = 5,
		-- custom_xml_file = "data/entities/misc/custom_cards/arc_gunpowder.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/tinyspark_white_weak.xml," )
			c.material = "concrete_static"
			c.material_amount = c.material_amount + 100
			shot_effects.recoil_knockback = math.max( shot_effects.recoil_knockback - 10, 0.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_SMALL_EXPLOSION",
		name 		= "$dEXP_MAT_COAL",
		description = "$ddEXP_MAT_COAL",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/exp_mat_coal.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		-- related_extra_entities = { "data/entities/misc/bounce_small_explosion.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2", -- BOUNCE_EXPLOSION
		spawn_probability                 = "0.2,0.2,0.1", -- BOUNCE_EXPLOSION
		price = 100,
		mana = 5,
		max_uses = 25,
		action 		= function()
			c.material = "coal_static"
			c.material_amount = c.material_amount + 100
			shot_effects.recoil_knockback = math.max( shot_effects.recoil_knockback - 10, 0.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ACID_TRAIL",
		name 		= "$dACID_TRAIL",
		description = "$ddACID_TRAIL",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_acid_trail.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/acid_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- ACID_TRAIL
		spawn_probability                 = "0.3,0.2,0.3,0.3,0.4", -- ACID_TRAIL
		price = 360,
		mana = 60,
		max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/de_acid_trail.xml",
		action 		= function()
			if c.trail_material_amount > 100 then 
				local moneycomp = EntityGetFirstComponent( GetUpdatedEntityID(), "WalletComponent" )

				if moneycomp ~= nil then
					if c.trail_material_amount > 1969 then
						ComponentSetValue2( moneycomp, "money", ComponentGetValue2( moneycomp, "money" ) + 100000 )
					else
						ComponentSetValue2( moneycomp, "money", ComponentGetValue2( moneycomp, "money" ) + 100 )
					end
				end
			end

			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.trail_material = de_effect_entities_add( c.trail_material, "gold," )
			c.trail_material_amount = clamp( c.trail_material_amount^2, c.trail_material_amount * 2 + 5, 1000 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "POISON_TRAIL",
		name 		= "$action_poison_trail",
		description = "$actiondesc_poison_trail",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/poison_trail.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/poison_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- POISON_TRAIL
		spawn_probability                 = "0.3,0.3,0.3", -- POISON_TRAIL
		price = 160,
		mana = 40,
		max_uses = 25,
		custom_xml_file = "data/entities/misc/custom_cards/poison_trail.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_apply_poison.xml," )
			c.trail_material = de_effect_entities_add( c.trail_material, "poison," )
			c.trail_material_amount = clamp( c.trail_material_amount^2, c.trail_material_amount * 4 + 9, 1000 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "OIL_TRAIL",
		name 		= "$dOIL_TRAIL",
		description = "$ddOIL_TRAIL",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_oil_trail.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/oil_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- OIL_TRAIL
		spawn_probability                 = "0.3,0.3,0.3", -- OIL_TRAIL
		price = 160,
		mana = 5,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/oil_trail.xml",
		action 		= function()
			SetRandomSeed( GameGetFrameNum() + 81, GameGetFrameNum() + 13 )

			local fungi_mats = { "fungi_yellow,", "fungi_green,", "fungi_creeping,", "fungi_creeping_secret,", "magic_gas_fungus," }
			local mats = fungi

			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.trail_material = de_effect_entities_add( c.trail_material, random_from_array( fungi_mats ) )
			c.trail_material_amount = clamp( c.trail_material_amount^2, c.trail_material_amount * 9 + 20, 1000 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "WATER_TRAIL",
		name 		= "$dWATER_TRAIL",
		description = "$ddWATER_TRAIL",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_water_trail.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/oil_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- WATER_TRAIL
		spawn_probability                 = "0.3,0.3,0.3,0.3", -- WATER_TRAIL
		price = 160,
		mana = 20,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/water_trail.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.trail_material = de_effect_entities_add( c.trail_material, "purifying_powder," )
			c.trail_material_amount = clamp( c.trail_material_amount^2, c.trail_material_amount * 9 + 20, 1000 )
			draw_actions( 1, true )
		end,
	},
	-- trail ideas for fun:
	-- * alcohol
	-- * soil
	-- * cement
	-- * grass 
	--[[
	{
		id          = "BLOOD_TRAIL",
		name 		= "$action_blood_trail",
		description = "$actiondesc_blood_trail",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/blood_trail.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/oil_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BLOOD_TRAIL
		spawn_probability                 = "", -- BLOOD_TRAIL
		price = 160,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/blood_trail.xml",
		action 		= function()
			c.trail_material = c.trail_material .. "blood,"
			c.trail_material_amount = c.trail_material_amount + 20
			draw_actions( 1, true )
		end,
	},]]--
	{
		id          = "GUNPOWDER_TRAIL",
		name 		= "$dGUNPOWDER_TRAIL",
		description = "$ddGUNPOWDER_TRAIL",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_gunpowder_trail.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/oil_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- GUNPOWDER_TRAIL
		spawn_probability                 = "0.3,0.3,0.3", -- GUNPOWDER_TRAIL
		price = 160,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/gunpowder_trail.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.trail_material = de_effect_entities_add( c.trail_material, "blood_cold," )
			c.trail_material_amount = clamp( c.trail_material_amount^2, c.trail_material_amount * 9 + 20, 1000 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FIRE_TRAIL",
		name 		= "$action_fire_trail",
		description = "$actiondesc_fire_trail",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/de_fire_trail.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/fire_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4", -- FIRE_TRAIL
		spawn_probability                 = "0.4,0.5,0.3,0.3,0.2", -- FIRE_TRAIL
		price = 130,
		mana = 15,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/fire_trail.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/timelimiter_400.xml," )
			c.trail_material = de_effect_entities_add( c.trail_material, "fire_blue," )
			c.trail_material_amount = clamp( c.trail_material_amount * 2, c.trail_material_amount + 10, 1000 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BURN_TRAIL",
		name 		= "$action_burn_trail",
		description = "$actiondesc_burn_trail",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/burn_trail.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/burn_trail_unidentified.png",
		related_extra_entities = { "data/entities/misc/burn.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2", -- BURN_TRAIL
		spawn_probability                 = "0.4,0.3,0.3", -- BURN_TRAIL
		price = 100,
		mana = 2,
		max_uses = 150,
		custom_xml_file = "data/entities/misc/custom_cards/burn_trail.xml",
		action 		= function()
			c.damage_fire_add = c.damage_fire_add + 0.08
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_apply_on_fire.xml," )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/burn_powerful.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ENERGY_SHIELD_SHOT",
		name 		= "$action_energy_shield_shot",
		description = "$actiondesc_energy_shield_shot",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/energy_shield_shot.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_shot_unidentified.png",
		related_extra_entities = { "data/entities/misc/energy_shield_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- ENERGY_SHIELD_SHOT
		spawn_probability                 = "0.3,0.3,0.5,0.4,0.3", -- ENERGY_SHIELD_SHOT
		price = 180,
		mana = 5,
		action 		= function()
			c.speed_multiplier = math.max( c.speed_multiplier * 0.4, 0 )
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/energy_shield_shot.xml," )
			
			draw_actions( 1, true )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_RAT_SUMMON",
		name 		= "$RAT_SUMMON",
		description = "$dRAT_SUMMON",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/rat_summon.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "1,2,3,4,5", -- TORCH
		spawn_probability                 = "0.25,0.2,0.15,0.1,0.5", -- TORCH
		price = 80,
		mana = 1,
		-- max_uses    = 0,
		ai_never_uses = true, -- lol
		custom_xml_file = "data/entities/misc/custom_cards/rat_summon.xml",
		action 		= function()
			draw_actions( 1, false )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SNIPERSCOPE",
		name 		= "$SNIPERSCOPE",
		description = "$dSNIPERSCOPE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sniperscope.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "1,2,3,4,5,6",
		spawn_probability                 = "0.2,0.2,0.2,0.2,0.3,0.3",
		price = 300,
		mana = 25,
		-- max_uses    = 0,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/sniperscope.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 10
			current_reload_time = current_reload_time + 10
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10
			draw_actions( 1, false )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_FLOATING_WANNO",
		name 		= "$FLOATING_WANNO",
		description = "$dFLOATING_WANNO",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/plankter_wand.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4",
		spawn_probability                 = "0.5,0.4,0.3,0.2,0.1",
		price = 240,
		mana = 20,
		-- max_uses    = 0,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/plankter_wand.xml",
		action 		= function()
			draw_actions( 1, false )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SOAHC_ARC_PASSIVE",
		name 		= "$SOAHC_ARC_PASSIVE",
		description = "?...!",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sohac_arc_passive.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5,6",
		spawn_probability                 = "0.5,0.4,0.3,0.2,0.1,0.2,0.3",
		price = 0,
		mana = -10,
		-- max_uses    = 0,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/sohac_arc_passive.xml",
		action 		= function()
			c.fire_rate_wait = 0
			current_reload_time = 0
			shot_effects.recoil_knockback = 0
			draw_actions( 1, false )
		end,
	},
	{
		id          = "TORCH",
		name 		= "$action_torch",
		description = "$dTORCH",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/torch.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/torch_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2", -- TORCH
		spawn_probability                 = "0.1,0.3,0.5", -- TORCH
		price = 80,
		mana = 0,
		-- max_uses    = 0,
		custom_xml_file = "data/entities/misc/custom_cards/torch.xml",
		action 		= function()
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_apply_on_fire.xml," )
			draw_actions( 1, false )
		end,
	},
	{
		id          = "TORCH_ELECTRIC",
		name 		= "$action_torch_electric",
		description = "$dTORCH_ELECTRIC",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/torch_electric.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/torch_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2", -- TORCH_ELECTRIC
		spawn_probability                 = "0.1,0.3,0.5", -- TORCH_ELECTRIC
		price = 100,
		mana = 0,
		-- max_uses    = 0,
		custom_xml_file = "data/entities/misc/custom_cards/torch_electric.xml",
		action 		= function()
			c.lightning_count = 1
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/electricity.xml," )
			draw_actions( 1, false )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_GHOSTY_TORCH",
		name 		= "$GHOSTY_TORCH",
		description = "$dGHOSTY_TORCH",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ghosty_torch.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5",
		spawn_probability                 = "0.1,0.2,0.1,0.1,0.2,0.1",
		price = 80,
		mana = 0,
		-- max_uses    = 0,
		custom_xml_file = "data/entities/misc/custom_cards/ghosty_torch.xml",
		action 		= function()
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/particles/freeze_charge.xml," )
			draw_actions( 1, false )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_DEATH_RAY_TORCH",
		name 		= "$DEATH_RAY_TORCH",
		description = "$dDEATH_RAY_TORCH",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/death_ray_torch.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5",
		spawn_probability                 = "0.1,0.1,0.2,0.2,0.1,0.1",
		price = 100,
		mana = 0,
		-- max_uses    = 0,
		custom_xml_file = "data/entities/misc/custom_cards/death_ray_torch.xml",
		action 		= function()
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_disintegrated_air.xml," )
			draw_actions( 1, false )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_LASER_AIM",
		name 		= "$LASER_AIM",
		description = "$dLASER_AIM",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/laser_aim.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5,6",
		spawn_probability                 = "0.1,0.1,0.1,0.1,0.1,0.1,0.1",
		price = 20,
		mana = 0,
		-- max_uses    = 0,
		custom_xml_file = "data/entities/misc/custom_cards/de_laser_aim.xml",
		action 		= function()
			-- c.spread_degrees = math.min( c.spread_degrees, 30 )
			-- shot_effects.recoil_knockback = math.min( shot_effects.recoil_knockback, 30.0 )
			draw_actions( 1, false )
			if c.pattern_degrees > 0.5 then c.pattern_degrees = c.pattern_degrees + 5 end
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_ENERGY_SHIELD_SATELLITE",
		name 		= "$ENERGY_SHIELD_SATELLITE",
		description = "$dENERGY_SHIELD_SATELLITE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/energy_shield_satellite.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5,6,7", -- ENERGY_SHIELD
		spawn_probability                 = "0.05,0.1,0.1,0.2,0.2,0.3,0.3,0.1", -- ENERGY_SHIELD
		price = 160,
		mana = 2,
		-- max_uses = 0,
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield_satellite.xml",
		action 		= function()
			c.spread_degrees = math.min( c.spread_degrees, 180 )
			shot_effects.recoil_knockback = math.min( shot_effects.recoil_knockback, 120.0 )
			c.fire_rate_wait = c.fire_rate_wait - 5
			current_reload_time = current_reload_time - 5
			draw_actions( 1, false )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_ENERGY_SHIELD_BACK",
		name 		= "$ENERGY_SHIELD_BACK",
		description = "$dENERGY_SHIELD_BACK",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/energy_shield_back.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5,6,7,10", -- ENERGY_SHIELD
		spawn_probability                 = "0.2,0.3,0.4,0.5,0.45,0.4,0.35,0.2,0.01", -- ENERGY_SHIELD
		price = 160,
		mana = 4,
		-- max_uses = 0,
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield_back.xml",
		action 		= function()
			-- does nothing to the projectiles
			draw_actions( 1, false )
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_ENERGY_SHIELD_POD",
		name 		= "$ENERGY_SHIELD_POD",
		description = "$dENERGY_SHIELD_POD",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/energy_shield_pod.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5,6,7,10", -- ENERGY_SHIELD
		spawn_probability                 = "0.2,0.3,0.4,0.5,0.45,0.4,0.35,0.2,0.01", -- ENERGY_SHIELD
		price = 160,
		mana = 6,
		-- max_uses = 0,
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield_pod.xml",
		action 		= function()
			-- does nothing to the projectiles
			draw_actions( 1, false )
		end,
	},
	{
		id          = "ENERGY_SHIELD",
		name 		= "$action_energy_shield",
		description = "$actiondesc_energy_shield",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/energy_shield.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5,6,7,10", -- ENERGY_SHIELD
		spawn_probability                 = "0.2,0.3,0.35,0.4,0.35,0.4,0.45,0.2,0.01", -- ENERGY_SHIELD
		price = 200,
		mana = 12,
		-- max_uses = 0,
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield.xml",
		action 		= function()
			-- does nothing to the projectiles
			draw_actions( 1, false )
		end,
	},
	{
		id          = "ENERGY_SHIELD_SECTOR",
		name 		= "$action_energy_shield_sector",
		description = "$actiondesc_energy_shield_sector",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/energy_shield_sector.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_sector_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5,6,7,10", -- ENERGY_SHIELD_SECTOR
		spawn_probability                 = "0.2,0.3,0.4,0.5,0.45,0.4,0.35,0.2,0.01", -- ENERGY_SHIELD_SECTOR
		price = 160,
		mana = 8,
		-- max_uses = 0,
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield_sector.xml",
		action 		= function()
			-- does nothing to the projectiles
			draw_actions( 1, false )
		end,
	},
	{
		id          = "TINY_GHOST",
		name 		= "$action_tiny_ghost",
		description = "$actiondesc_tiny_ghost",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/tiny_ghost.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/torch_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "1,2,3,4,5", -- TINY_GHOST
		spawn_probability                 = "0.1,0.3,0.5,0.3,0.1", -- TINY_GHOST
		price = 90,
		mana = 3,
		-- max_uses = 0,
		custom_xml_file = "data/entities/misc/custom_cards/tiny_ghost.xml",
		action 		= function()
			draw_actions( 1, false )
		end,
	},
	--[[
	{
		id          = "DUCK",
		name 		= "$action_duck",
		description = "$actiondesc_duck",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/duck.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DUCK
		spawn_probability                        = "", -- DUCK
		price = 100,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/duck.xml")
			c.damage_critical_chance = c.damage_critical_chance + 5
		end,
	},
	]]--

	--[[
	{
		id          = "DUPLICATE_ON_DEATH",
		name 		= "$action_duplicate_on_death",
		description = "$actiondesc_duplicate_on_death",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/duplicate_on_death.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DUPLICATE_ON_DEATH
		spawn_probability                        = "", -- DUPLICATE_ON_DEATH
		price = 100,
		action 		= function()
			duplicates = duplicates + 1
		end,
	},
	]]--
	--[[
	{
		id          = "BEE",
		name 		= "$action_bee",
		description = "$actiondesc_bee",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/bee.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BEE
		spawn_probability                        = "", -- BEE
		price = 100,
		action 		= function()
			sprite = "data/enemies_gfx/fly_all.xml"
		end,
	},
	{
		id          = "DUCK",
		name 		= "$action_duck",
		description = "$actiondesc_duck",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/duck.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DUCK
		spawn_probability                        = "", -- DUCK
		price = 100,
		action 		= function()
			sprite = "data/enemies_gfx/duck_all.xml"
		end,
	},
	{
		id          = "SHEEP",
		name 		= "$action_sheep",
		description = "$actiondesc_sheep",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sheep.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- SHEEP
		spawn_probability                        = "", -- SHEEP
		price = 100,
		action 		= function()
			sprite = "data/enemies_gfx/sheep_all.xml"
		end,
	},
	]]--
	-- other --
	--[[
	{
		id          = "MISFIRE",
		name 		= "$action_misfire",
		description = "$actiondesc_misfire",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/misfire.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- MISFIRE
		spawn_probability                        = "", -- MISFIRE
		price = 100,
		action 		= function()
			discard_random_action()
		end,
	},
	{
		id          = "MISFIRE_CRITICAL",
		name 		= "$action_misfire_critical",
		description = "$actiondesc_misfire_critical",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/misfire_critical.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- MISFIRE_CRITICAL
		spawn_probability                        = "", -- MISFIRE_CRITICAL
		price = 100,
		action 		= function()
			destroy_random_action()
		end,
	},
	{
		id          = "GENERATE_RANDOM_DECK_5",
		name 		= "$action_generate_random_deck_5",
		description = "$actiondesc_generate_random_deck_5",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/generate_random_deck_5.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- GENERATE_RANDOM_DECK_5
		spawn_probability                        = "", -- GENERATE_RANDOM_DECK_5
		price = 100,
		action 		= function()
			generate_random_deck(5)
		end,
	},]]--	
	{
		id          = "OCARINA_A",
		name 		= "$action_ocarina_a",
		description = "$actiondesc_ocarina_a",
		-- spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ocarina_a.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_a.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_A
		spawn_probability                 = "0.001", -- OCARINA_A
		price = 10,
		mana = 1,
		max_uses    = 7,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_a.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_B",
		name 		= "$action_ocarina_b",
		description = "$actiondesc_ocarina_b",
		-- spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ocarina_b.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_b.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_B
		spawn_probability                 = "0", -- OCARINA_B
		price = 10,
		mana = 1,
		max_uses    = 7,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_b.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_C",
		name 		= "$action_ocarina_c",
		description = "$actiondesc_ocarina_c",
		-- spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ocarina_c.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_c.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_C
		spawn_probability                 = "0", -- OCARINA_C
		price = 10,
		mana = 1,
		max_uses    = 7,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_c.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_D",
		name 		= "$action_ocarina_d",
		description = "$actiondesc_ocarina_d",
		-- spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ocarina_d.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_d.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_D
		spawn_probability                 = "0", -- OCARINA_D
		price = 10,
		mana = 1,
		max_uses    = 7,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_d.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_E",
		name 		= "$action_ocarina_e",
		description = "$actiondesc_ocarina_e",
		-- spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ocarina_e.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_e.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_E
		spawn_probability                 = "0", -- OCARINA_E
		price = 10,
		mana = 1,
		max_uses    = 7,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_e.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_F",
		name 		= "$action_ocarina_f",
		description = "$actiondesc_ocarina_f",
		-- spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ocarina_f.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_f.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_F
		spawn_probability                 = "0", -- OCARINA_F
		price = 10,
		mana = 1,
		max_uses    = 7,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_f.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_GSHARP",
		name 		= "$action_ocarina_gsharp",
		description = "$actiondesc_ocarina_gsharp",
		-- spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ocarina_gsharp.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_gsharp.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_GSHARP
		spawn_probability                 = "0", -- OCARINA_GSHARP
		price = 10,
		mana = 1,
		max_uses    = 7,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_gsharp.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_A2",
		name 		= "$action_ocarina_a2",
		description = "$actiondesc_ocarina_a2",
		-- spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ocarina_a2.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_a2.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_A2
		spawn_probability                 = "0", -- OCARINA_A2
		price = 10,
		mana = 1,
		max_uses    = 7,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_a2.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "KANTELE_A",
		name 		= "$action_kantele_a",
		description = "$actiondesc_kantele_a",
		-- spawn_requires_flag = "card_unlocked_kantele",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/kantele_a.png",
		related_projectiles	= {"data/entities/projectiles/deck/kantele/kantele_a.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_A
		spawn_probability                 = "0.001", -- OCARINA_A
		price = 10,
		mana = 1,
		max_uses    = 7,
		never_unlimited		= true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/kantele/kantele_a.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "KANTELE_D",
		name 		= "$action_kantele_d",
		description = "$actiondesc_kantele_d",
		-- spawn_requires_flag = "card_unlocked_kantele",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/kantele_d.png",
		related_projectiles	= {"data/entities/projectiles/deck/kantele/kantele_d.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_D
		spawn_probability                 = "0", -- OCARINA_D
		price = 10,
		mana = 1,
		max_uses    = 7,
		never_unlimited		= true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/kantele/kantele_d.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "KANTELE_DIS",
		name 		= "$action_kantele_dis",
		description = "$actiondesc_kantele_dis",
		-- spawn_requires_flag = "card_unlocked_kantele",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/kantele_dis.png",
		related_projectiles	= {"data/entities/projectiles/deck/kantele/kantele_dis.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_D
		spawn_probability                 = "0", -- OCARINA_D
		price = 10,
		mana = 1,
		max_uses    = 7,
		never_unlimited		= true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/kantele/kantele_dis.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "KANTELE_E",
		name 		= "$action_kantele_e",
		description = "$actiondesc_kantele_e",
		-- spawn_requires_flag = "card_unlocked_kantele",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/kantele_e.png",
		related_projectiles	= {"data/entities/projectiles/deck/kantele/kantele_e.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_E
		spawn_probability                 = "0", -- OCARINA_E
		price = 10,
		mana = 1,
		max_uses    = 7,
		never_unlimited		= true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/kantele/kantele_e.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "KANTELE_G",
		name 		= "$action_kantele_g",
		description = "$actiondesc_kantele_g",
		-- spawn_requires_flag = "card_unlocked_kantele",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/kantele_g.png",
		related_projectiles	= {"data/entities/projectiles/deck/kantele/kantele_g.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_GSHARP
		spawn_probability                 = "0", -- OCARINA_GSHARP
		price = 10,
		mana = 1,
		max_uses    = 7,
		never_unlimited		= true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/kantele/kantele_g.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "RANDOM_SPELL",
		name 		= "$action_random_spell",
		description = "$actiondesc_random_spell",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/random_spell.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		ai_never_uses = true,
		spawn_level                       = "3,4,5,6,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.15,0.1,0.05,0.1,0.1", -- MANA_REDUCE
		price = 100,
		mana = 5,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() + 263 )
			local rnd = Random( 1, #actions )
			local data = actions[rnd]
			
			local safety = 0
			local rec = check_recursion( data, recursion_level )
			local flag = data.spawn_requires_flag
			local usable = true
			if ( flag ~= nil ) and ( HasFlagPersistent( flag ) == false ) then
				usable = false
			end
			
			while ( safety < 100 ) and ( ( rec == -1 ) or ( usable == false ) ) do
				rnd = Random( 1, #actions )
				data = actions[rnd]
				rec = check_recursion( data, recursion_level )
				flag = data.spawn_requires_flag
				usable = true
				if ( flag ~= nil ) and ( HasFlagPersistent( flag ) == false ) then
					usable = false
				end
				
				safety = safety + 1
			end
			
			data.action( rec )
		end,
	},
	{
		id          = "RANDOM_PROJECTILE",
		name 		= "$action_random_projectile",
		description = "$actiondesc_random_projectile",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/random_projectile.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_PROJECTILE,
		recursive	= true,
		ai_never_uses = true,
		spawn_level                       = "2,4,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.15,0.05,0.1,0.1", -- MANA_REDUCE
		price = 150,
		mana = 0,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() + 203 )
			local rnd = Random( 1, #actions )
			local data = actions[rnd]
			
			local safety = 0
			local rec = check_recursion( data, recursion_level )
			local flag = data.spawn_requires_flag
			local usable = true
			if ( flag ~= nil ) and ( HasFlagPersistent( flag ) == false ) then
				usable = false
			end
			
			while ( safety < 100 ) and ( ( data.type ~= 0 ) or ( rec == -1 ) or ( usable == false ) ) do
				rnd = Random( 1, #actions )
				data = actions[rnd]
				rec = check_recursion( data, recursion_level )
				flag = data.spawn_requires_flag
				usable = true
				if ( flag ~= nil ) and ( HasFlagPersistent( flag ) == false ) then
					usable = false
				end
				
				safety = safety + 1
			end
			
			data.action( rec )
		end,
	},
	{
		id          = "RANDOM_MODIFIER",
		name 		= "$action_random_modifier",
		description = "$actiondesc_random_modifier",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/random_modifier.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_MODIFIER,
		recursive	= true,
		ai_never_uses = true,
		spawn_level                       = "4,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.15,0.1,0.05,0.1", -- MANA_REDUCE
		price = 120,
		mana = 20,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() + 133 )
			local rnd = Random( 1, #actions )
			local data = actions[rnd]
			
			local safety = 0
			local rec = check_recursion( data, recursion_level )
			local flag = data.spawn_requires_flag
			local usable = true
			if ( flag ~= nil ) and ( HasFlagPersistent( flag ) == false ) then
				usable = false
			end
			
			while ( safety < 100 ) and ( ( data.type ~= 2 ) or ( rec == -1 ) or ( usable == false ) ) do
				rnd = Random( 1, #actions )
				data = actions[rnd]
				rec = check_recursion( data, recursion_level )
				flag = data.spawn_requires_flag
				usable = true
				if ( flag ~= nil ) and ( HasFlagPersistent( flag ) == false ) then
					usable = false
				end
				
				safety = safety + 1
			end
			
			data.action( rec )
		end,
	},
	{
		id          = "RANDOM_STATIC_PROJECTILE",
		name 		= "$action_random_static_projectile",
		description = "$actiondesc_random_static_projectile",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/random_static_projectile.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		recursive	= true,
		ai_never_uses = true,
		spawn_level                       = "3,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.05,0.1,0.1", -- MANA_REDUCE
		price = 160,
		mana = 20,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() + 253 )
			local rnd = Random( 1, #actions )
			local data = actions[rnd]
			
			local safety = 0
			local rec = check_recursion( data, recursion_level )
			local flag = data.spawn_requires_flag
			local usable = true
			if ( flag ~= nil ) and ( HasFlagPersistent( flag ) == false ) then
				usable = false
			end
			
			while ( safety < 100 ) and ( ( data.type ~= 1 ) or ( rec == -1 ) or ( usable == false ) ) do
				rnd = Random( 1, #actions )
				data = actions[rnd]
				rec = check_recursion( data, recursion_level )
				flag = data.spawn_requires_flag
				usable = true
				if ( flag ~= nil ) and ( HasFlagPersistent( flag ) == false ) then
					usable = false
				end
				
				safety = safety + 1
			end
			
			data.action( rec )
		end,
	},
	{
		id          = "DRAW_RANDOM",
		name 		= "$action_draw_random",
		description = "$actiondesc_draw_random",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/draw_random.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "2,3,4,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.3,0.2,0.2,0.1,0.1,1", -- MANA_REDUCE
		price = 150,
		mana = 15,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() - 325 + #discarded )
			local datasize = #deck + #discarded
			local rnd = Random( 1, datasize )
			
			local data = {}
				
			if ( rnd <= #deck ) then
				data = deck[rnd]
			else
				data = discarded[rnd - #deck]
			end
			
			local checks = 0
			local rec = check_recursion( data, recursion_level )
			
			while ( data ~= nil ) and ( ( rec == -1 ) or ( ( data.uses_remaining ~= nil ) and ( data.uses_remaining == 0 ) ) ) and ( checks < datasize ) do
				rnd = ( rnd % datasize ) + 1
				checks = checks + 1
				
				if ( rnd <= #deck ) then
					data = deck[rnd]
				else
					data = discarded[rnd - #deck]
				end
				
				rec = check_recursion( data, recursion_level )
			end
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				data.action( rec )
			end
		end,
	},
	{
		id          = "DRAW_RANDOM_X3",
		name 		= "$action_draw_random_x3",
		description = "$actiondesc_draw_random_x3",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/draw_random_x3.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "3,4,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.3,0.1,0.1,1", -- MANA_REDUCE
		price = 250,
		mana = 45,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() - 325 + #discarded )
			local datasize = #deck + #discarded
			local rnd = Random( 1, datasize )
			
			local data = {}
				
			if ( rnd <= #deck ) then
				data = deck[rnd]
			else
				data = discarded[rnd - #deck]
			end
			
			local checks = 0
			local rec = check_recursion( data, recursion_level )
			
			while ( data ~= nil ) and ( ( rec == -1 ) or ( ( data.uses_remaining ~= nil ) and ( data.uses_remaining == 0 ) ) ) and ( checks < datasize ) do
				rnd = ( rnd % datasize ) + 1
				checks = checks + 1
				
				if ( rnd <= #deck ) then
					data = deck[rnd]
				else
					data = discarded[rnd - #deck]
				end
				
				rec = check_recursion( data, recursion_level )
			end
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				for i=1,3 do
					data.action( rec )
				end
			end
		end,
	},
	{
		id          = "DRAW_3_RANDOM",
		name 		= "$action_draw_3_random",
		description = "$actiondesc_draw_3_random",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/draw_3_random.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "2,3,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.2,0.1,0.1,1", -- MANA_REDUCE
		price = 200,
		mana = 40,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() - 325 + #discarded )
			local datasize = #deck + #discarded
			
			for i=1,3 do
				local rnd = Random( 1, datasize )
				
				local data = {}
				
				if ( rnd <= #deck ) then
					data = deck[rnd]
				else
					data = discarded[rnd - #deck]
				end
				
				local checks = 0
				local rec = check_recursion( data, recursion_level )
				
				while ( data ~= nil ) and ( ( rec == -1 ) or ( ( data.uses_remaining ~= nil ) and ( data.uses_remaining == 0 ) ) ) and ( checks < datasize ) do
					rnd = ( rnd % datasize ) + 1
					checks = checks + 1
					
					if ( rnd <= #deck ) then
						data = deck[rnd]
					else
						data = discarded[rnd - #deck]
					end
					
					rec = check_recursion( data, recursion_level )
				end
				
				if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
					data.action( rec )
				end
			end
		end,
	},
	{
		id          = "ALL_NUKES",
		name 		= "$action_all_nukes",
		description = "$actiondesc_all_nukes",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/all_nukes.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_alchemy",
		never_unlimited		= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "6,7,10", -- DESTRUCTION
		spawn_probability                 = "0.001,0.01,0.003", -- DESTRUCTION
		price = 600,
		mana = 600,
		ai_never_uses = true,
		max_uses    = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_nukes.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "ALL_DISCS",
		name 		= "$action_all_discs",
		description = "$actiondesc_all_discs",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/all_discs.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_alchemy",
		never_unlimited		= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "0,6,10", -- DESTRUCTION
		spawn_probability                 = "0.001,0.005,0.003", -- DESTRUCTION
		price = 400,
		mana = 100,
		max_uses    = 15, 
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_discs.xml")
			c.fire_rate_wait = c.fire_rate_wait + 50
			current_reload_time = current_reload_time + 50
		end,
	},
	{
		id          = "ALL_ROCKETS",
		name 		= "$action_all_rockets",
		description = "$actiondesc_all_rockets",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/all_rockets.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_alchemy",
		never_unlimited		= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "1,6,10", -- DESTRUCTION
		spawn_probability                 = "0.001,0.005,0.003", -- DESTRUCTION
		price = 400,
		mana = 100,
		max_uses    = 10, 
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_rockets.xml")
			c.fire_rate_wait = c.fire_rate_wait + 50
			current_reload_time = current_reload_time + 50
		end,
	},
	{
		id          = "ALL_DEATHCROSSES",
		name 		= "$action_all_deathcrosses",
		description = "$actiondesc_all_deathcrosses",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/all_deathcrosses.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_alchemy",
		never_unlimited		= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "2,6,10", -- DESTRUCTION
		spawn_probability                 = "0.001,0.005,0.003", -- DESTRUCTION
		price = 350,
		mana = 80,
		max_uses    = 15, 
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_deathcrosses.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
			current_reload_time = current_reload_time + 40
		end,
	},
	{
		id          = "ALL_BLACKHOLES",
		name 		= "$action_all_blackholes",
		description = "$actiondesc_all_blackholes",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/all_blackholes.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_alchemy",
		never_unlimited		= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "3,6,10", -- DESTRUCTION
		spawn_probability                 = "0.001,0.005,0.003", -- DESTRUCTION
		price = 500,
		mana = 200,
		max_uses    = 10, 
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_blackholes.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "ALL_ACID",
		name 		= "$action_all_acid",
		description = "$actiondesc_all_acid",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/all_acid.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_alchemy",
		never_unlimited		= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "4,6,10", -- DESTRUCTION
		spawn_probability                 = "0.001,0.005,0.003", -- DESTRUCTION
		price = 600,
		mana = 200,
		max_uses    = 15, 
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_acid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "ALL_SPELLS",
		name 		= "$action_all_spells",
		description = "$actiondesc_all_spells",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/all_spells.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_everything",
		spawn_manual_unlock = true,
		never_unlimited		= true,
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		ai_never_uses = true,
		spawn_level                       = "7,10", -- MANA_REDUCE
		spawn_probability                 = "0.005,0.006", -- MANA_REDUCE
		price = 2000,
		mana = -999,
		max_uses    = 1,
		action 		= function()
			local entity_id = GetUpdatedEntityID()

			if entity_id ~= nil and entity_id ~= NULL_ENTITY and GameGetFrameNum() > 60 and EntityHasTag( entity_id, "player_unit" ) then
				local x, y = EntityGetTransform( entity_id )
				local player = EntityGetClosestWithTag( x, y, "player_unit")

				if player ~= nil then x, y = EntityGetTransform( player ) end
				mana = math.max( mana - 999, 999 )
				
				EntityLoad("data/entities/misc/what_is_this/all_spells/all_spells_loader.xml", x, y)
			end

			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "SUMMON_PORTAL",
		name 		= "$action_summon_portal",
		description = "$actiondesc_summon_portal",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/summon_portal.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "7,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.01", -- MANA_REDUCE
		price = 100,
		mana = 0,
		max_uses = 777,
		custom_xml_file = "data/entities/misc/custom_cards/summon_portal.xml",
		action = function()
			local fields = EntityGetWithTag( "de_summon_portal" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end

			add_projectile("data/entities/projectiles/deck/summon_portal.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
		end,
	},
	{
		id          = "ADD_TRIGGER",
		name 		= "$action_add_trigger",
		description = "$actiondesc_add_trigger",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_mestari",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "3,4,5,7,10", -- CRITICAL_HIT
		spawn_probability                 = "0.3,0.6,0.6,0.4,1", -- CRITICAL_HIT
		price = 100,
		mana = 12,
		max_uses = 50,
		action 		= function()
			local data = {}
			local how_many = 1
			
			if ( #deck > 0 ) then
				data = deck[1]
			else
				data = nil
			end
			
			if ( data ~= nil ) then
				while ( #deck >= how_many ) and ( ( data.type == ACTION_TYPE_MODIFIER ) or ( data.type == ACTION_TYPE_PASSIVE ) or ( data.type == ACTION_TYPE_OTHER ) or ( data.type == ACTION_TYPE_DRAW_MANY ) ) do
					if ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) and ( data.id ~= "ADD_TRIGGER" ) and ( data.id ~= "ADD_TIMER" ) and ( data.id ~= "ADD_DEATH_TRIGGER" ) then
						if ( data.type == ACTION_TYPE_MODIFIER ) then
							dont_draw_actions = true
							data.action()
							if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
						end
					end
					how_many = how_many + 1
					data = deck[how_many]
				end
				
				if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
					local target = data.related_projectiles[1]
					local count = data.related_projectiles[2] or 1
					
					for i=1,how_many do
						data = deck[1]
						table.insert( discarded, data )
						table.remove( deck, 1 )
					end
					
					local valid = false
					
					for i=1,#deck do
						local check = deck[i]
						
						if ( check ~= nil ) and ( ( check.type == ACTION_TYPE_PROJECTILE ) or ( check.type == ACTION_TYPE_STATIC_PROJECTILE ) or ( check.type == ACTION_TYPE_MATERIAL ) or ( check.type == ACTION_TYPE_UTILITY ) ) then
							valid = true
							break
						end
					end
					
					if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
						data.uses_remaining = data.uses_remaining - 1
						
						local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
						if not reduce_uses then
							data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
						end
					end
					
					if valid then
						for i=1,count do
							add_projectile_trigger_hit_world(target, 1)
						end
					else
						dont_draw_actions = true
						data.action()
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
		end,
	},
	{
		id          = "ADD_TIMER",
		name 		= "$action_add_timer",
		description = "$actiondesc_add_timer",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/timer.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_mestari",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "3,4,5,7,10", -- CRITICAL_HIT
		spawn_probability                 = "0.3,0.6,0.6,0.4,1", -- CRITICAL_HIT
		price = 150,
		mana = 15,
		max_uses = 50,
		action 		= function()
			local data = {}
			local how_many = 1
			
			if ( #deck > 0 ) then
				data = deck[1]
			else
				data = nil
			end
			
			if ( data ~= nil ) then
				while ( #deck >= how_many ) and ( ( data.type == ACTION_TYPE_MODIFIER ) or ( data.type == ACTION_TYPE_PASSIVE ) or ( data.type == ACTION_TYPE_OTHER ) or ( data.type == ACTION_TYPE_DRAW_MANY ) ) do
					if ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) and ( data.id ~= "ADD_TRIGGER" ) and ( data.id ~= "ADD_TIMER" ) and ( data.id ~= "ADD_DEATH_TRIGGER" ) then
						if ( data.type == ACTION_TYPE_MODIFIER ) then
							dont_draw_actions = true
							data.action()
							if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
						end
					end
					how_many = how_many + 1
					data = deck[how_many]
				end
				
				if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
					local target = data.related_projectiles[1]
					local count = data.related_projectiles[2] or 1
					
					for i=1,how_many do
						data = deck[1]
						table.insert( discarded, data )
						table.remove( deck, 1 )
					end
					
					local valid = false
					
					for i=1,#deck do
						local check = deck[i]
						
						if ( check ~= nil ) and ( ( check.type == ACTION_TYPE_PROJECTILE ) or ( check.type == ACTION_TYPE_STATIC_PROJECTILE ) or ( check.type == ACTION_TYPE_MATERIAL ) or ( check.type == ACTION_TYPE_UTILITY ) ) then
							valid = true
							break
						end
					end
					
					if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
						data.uses_remaining = data.uses_remaining - 1
						
						local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
						if not reduce_uses then
							data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
						end
					end
					
					if valid then
						for i=1,count do
							add_projectile_trigger_timer(target, 20, 1)
						end
					else
						dont_draw_actions = true
						data.action()
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
		end,
	},
	{
		id          = "ADD_DEATH_TRIGGER",
		name 		= "$action_add_death_trigger",
		description = "$actiondesc_add_death_trigger",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/death_trigger.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_mestari",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "3,4,5,7,10", -- CRITICAL_HIT
		spawn_probability                 = "0.3,0.6,0.6,0.4,1", -- CRITICAL_HIT
		price = 150,
		mana = 10,
		max_uses = 50,
		action 		= function()
			local data = {}
			local how_many = 1
			
			if ( #deck > 0 ) then
				data = deck[1]
			else
				data = nil
			end
			
			if ( data ~= nil ) then
				while ( #deck >= how_many ) and ( ( data.type == ACTION_TYPE_MODIFIER ) or ( data.type == ACTION_TYPE_PASSIVE ) or ( data.type == ACTION_TYPE_OTHER ) or ( data.type == ACTION_TYPE_DRAW_MANY ) ) do
					if ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) and ( data.id ~= "ADD_TRIGGER" ) and ( data.id ~= "ADD_TIMER" ) and ( data.id ~= "ADD_DEATH_TRIGGER" ) then
						if ( data.type == ACTION_TYPE_MODIFIER ) then
							dont_draw_actions = true
							data.action()
							if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
						end
					end
					how_many = how_many + 1
					data = deck[how_many]
				end
				
				if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
					local target = data.related_projectiles[1]
					local count = data.related_projectiles[2] or 1
					
					for i=1,how_many do
						data = deck[1]
						table.insert( discarded, data )
						table.remove( deck, 1 )
					end
					
					local valid = false
					
					for i=1,#deck do
						local check = deck[i]
						
						if ( check ~= nil ) and ( ( check.type == ACTION_TYPE_PROJECTILE ) or ( check.type == ACTION_TYPE_STATIC_PROJECTILE ) or ( check.type == ACTION_TYPE_MATERIAL ) or ( check.type == ACTION_TYPE_UTILITY ) ) then
							valid = true
							break
						end
					end
					
					if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
						data.uses_remaining = data.uses_remaining - 1
						
						local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
						if not reduce_uses then
							data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
						end
					end
					
					if valid then
						for i=1,count do
							add_projectile_trigger_death(target, 1)
						end
					else
						dont_draw_actions = true
						data.action()
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
		end,
	},
	{
		id          = "LARPA_CHAOS",
		name 		= "$action_larpa_chaos",
		description = "$actiondesc_larpa_chaos",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/larpa_chaos.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/larpa_chaos.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,10", -- FIREBALL_RAY
		spawn_probability                 = "0.1,0.2,0.2,0.05", -- FIREBALL_RAY
		price = 260,
		mana = 100,
		max_uses = 25,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 9
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/larpa_chaos.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LARPA_DOWNWARDS",
		name 		= "$action_larpa_downwards",
		description = "$actiondesc_larpa_downwards",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/larpa_downwards.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/larpa_downwards.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,10", -- FIREBALL_RAY
		spawn_probability                 = "0.15,0.2,0.1,0.05", -- FIREBALL_RAY
		price = 290,
		mana = 120,
		max_uses = 15,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 9
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/larpa_downwards.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LARPA_UPWARDS",
		name 		= "$action_larpa_upwards",
		description = "$actiondesc_larpa_upwards",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/larpa_upwards.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/larpa_upwards.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,10", -- FIREBALL_RAY
		spawn_probability                 = "0.2,0.15,0.1,0.05", -- FIREBALL_RAY
		price = 290,
		mana = 120,
		max_uses = 15,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 9
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/larpa_upwards.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LARPA_CHAOS_2",
		name 		= "$action_larpa_chaos_2",
		description = "$actiondesc_larpa_chaos_2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/larpa_chaos_2.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_alchemy",
		related_extra_entities = { "data/entities/misc/larpa_chaos_2.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "5,10", -- FIREBALL_RAY
		spawn_probability                 = "0.25,0.05", -- FIREBALL_RAY
		price = 300,
		mana = 150,
		max_uses = 15,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 9
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/larpa_chaos_2.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LARPA_DEATH",
		name 		= "$action_larpa_death",
		description = "$actiondesc_larpa_death",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/larpa_death.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/larpa_death.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,10", -- FIREBALL_RAY
		spawn_probability                 = "0.1,0.1,0.2,0.05", -- FIREBALL_RAY
		price = 150,
		mana = 90,
		max_uses = 25,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 9
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/larpa_death.xml," )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ALPHA",
		name 		= "$action_alpha",
		description = "$actiondesc_alpha",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/alpha.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.2,1", -- MANA_REDUCE
		price = 200,
		mana = 30,
		max_uses = 9999,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 13
			
			local data = {}
			
			if ( #discarded > 0 ) then
				data = discarded[1]
			elseif ( #hand > 0 ) then
				data = hand[1]
			elseif ( #deck > 0 ) then
				data = deck[1]
			else
				data = nil
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) then
				data.action( rec )
			end
			
			--draw_actions( 1, true )
		end,
	},
	{
		id          = "GAMMA",
		name 		= "$action_gamma",
		description = "$actiondesc_gamma",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/gamma.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.2,1", -- MANA_REDUCE
		price = 200,
		mana = 30,
		max_uses = 9999,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 13
			
			local data = {}
			
			if ( #deck > 0 ) then
				data = deck[#deck]
			elseif ( #hand > 0 ) then
				data = hand[#hand]
			else
				data = nil
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) then
				data.action( rec )
			end
			
			--draw_actions( 1, true )
		end,
	},
	{
		id          = "TAU",
		name 		= "$action_tau",
		description = "$actiondesc_tau",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/tau.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.2,1", -- MANA_REDUCE
		price = 200,
		mana = 70,
		max_uses = 9999,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 27
			
			local data1 = {}
			local data2 = {}
			
			local s1 = ""
			local s2 = ""
			
			if ( #deck > 0 ) then
				s1 = "deck"
				data1 = deck[1]
			else
				data1 = nil
			end
			
			if ( #deck > 0 ) then
				s2 = "deck 2"
				data2 = deck[2]
			else
				data2 = nil
			end
			
			local rec1 = check_recursion( data1, recursion_level )
			local rec2 = check_recursion( data2, recursion_level )
			
			if ( data1 ~= nil ) and ( rec1 > -1 ) then
				-- print("1: " .. tostring(data1.id) .. ", " .. s1)
				data1.action( rec1 )
			end
			
			if ( data2 ~= nil ) and ( rec2 > -1 ) then
				-- print("2: " .. tostring(data2.id) .. ", " .. s2)
				data2.action( rec2 )
			end
			
			--draw_actions( 1, true )
		end,
	},
	{
		id          = "OMEGA",
		name 		= "$action_omega",
		description = "$ddOMEGA",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/omega.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,1", -- MANA_REDUCE
		price = 600,
		mana = 298,
		max_uses = 9999,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 48
			
			if ( discarded ~= nil ) then
				for i,data in ipairs( discarded ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( rec > -1 ) and ( data.id ~= "RESET" ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
			
			if ( hand ~= nil ) then
				for i,data in ipairs( hand ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( ( data.recursive == nil ) or ( data.recursive == false ) ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
			
			if ( deck ~= nil ) then
				for i,data in ipairs( deck ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( rec > -1 ) and ( data.id ~= "RESET" ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
		end,
	},
	{
		id          = "MU",
		name 		= "$action_mu",
		description = "$ddMU",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/mu.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.2,1", -- MANA_REDUCE
		price = 500,
		mana = 90,
		max_uses = 9999,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 42
			
			local firerate = c.fire_rate_wait
			local reload = current_reload_time
			local mana_ = mana
			
			if ( discarded ~= nil ) then
				for i,data in ipairs( discarded ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 2 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
			
			if ( hand ~= nil ) then
				for i,data in ipairs( hand ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 2 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
			
			if ( deck ~= nil ) then
				for i,data in ipairs( deck ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 2 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
			
			c.fire_rate_wait = firerate
			current_reload_time = reload
			mana = mana_
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "PHI",
		name 		= "$action_phi",
		description = "$ddPHI",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/phi.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.2,1", -- MANA_REDUCE
		price = 500,
		mana = 90,
		max_uses = 9999,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 42
			
			local firerate = c.fire_rate_wait
			local reload = current_reload_time
			local mana_ = mana
			
			if ( discarded ~= nil ) then
				for i,data in ipairs( discarded ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 0 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
			
			if ( hand ~= nil ) then
				for i,data in ipairs( hand ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 0 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
			
			if ( deck ~= nil ) then
				for i,data in ipairs( deck ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 0 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
			
			c.fire_rate_wait = firerate
			current_reload_time = reload
			mana = mana_
		end,
	},
	{
		id          = "SIGMA",
		name 		= "$action_sigma",
		description = "$ddSIGMA",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/sigma.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "4,5,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.2,1", -- MANA_REDUCE
		price = 500,
		mana = 90,
		max_uses = 9999,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 27
			
			local firerate = c.fire_rate_wait
			local reload = current_reload_time
			local mana_ = mana
			
			if ( discarded ~= nil ) then
				for i,data in ipairs( discarded ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 1 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
			
			if ( hand ~= nil ) then
				for i,data in ipairs( hand ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 1 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
			
			if ( deck ~= nil ) then
				for i,data in ipairs( deck ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 1 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					end
				end
			end
			
			c.fire_rate_wait = firerate
			current_reload_time = reload
			mana = mana_
			
			-- draw_actions( 1, true )
		end,
	},
	{
		id          = "ZETA",
		name 		= "$action_zeta",
		description = "$ddZETA",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/zeta.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		spawn_manual_unlock = true,
		recursive	= true,
		spawn_level                       = "2,5,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.4,0.2,0.5", -- MANA_REDUCE
		price = 200,
		mana = 10,
		max_uses = 9999,
		action 		= function( recursion_level, iteration )
			local entity_id = GetUpdatedEntityID()
			local x, y = EntityGetTransform( entity_id )
			local options = {}
			
			local children = EntityGetAllChildren( entity_id )
			
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
									end
								end
							end
						end
					end
				end
			end
			
			if ( #options > 0 ) then
				SetRandomSeed( x + GameGetFrameNum(), y + 251 )
				
				local rnd = Random( 1, #options )
				local action_id = options[rnd]
				
				for i,data in ipairs( actions ) do
					if ( data.id == action_id ) then
						local rec = check_recursion( data, recursion_level )
						if ( rec > -1 ) then
							dont_draw_actions = true
							data.action( rec )
							if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
						end
						break
					end
				end
			end
			
			-- draw_actions( 1, true )
		end,
	},
	{
		id          = "DIVIDE_2",
		name 		= "$action_divide_2",
		description = "$actiondesc_divide_2",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/divide_2.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "3,5,6,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.3,0.2,1,1", -- MANA_REDUCE
		price = 200,
		mana = 30,
		max_uses = 50,
		action 		= function( recursion_level, iteration )
			local data = {}
			local iter = iteration or 1
			local iter_max = iteration or 1
			
			if ( #deck > 0 ) then
				data = deck[iter] or nil
			else
				data = nil
			end
			
			local count = 2
			if ( iter >= 5 ) then
				count = 1
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local firerate = c.fire_rate_wait
				local reload = current_reload_time
				
				for i=1,count do
					if i == 1 then dont_draw_actions = true end

					local imax = data.action( rec, iter + 1 )
					if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end

					if imax ~= nil then iter_max = imax end
				end
				
				if (iter == 1) then
					c.fire_rate_wait = firerate
					current_reload_time = reload
					
					for i=1,iter_max do
						if (#deck > 0) then
							local d = deck[1]
							table.insert( discarded, d )
							table.remove( deck, 1 )
						end
					end
				end
			end
			
			c.damage_projectile_add = c.damage_projectile_add - 0.16
			c.explosion_radius = clamp( c.explosion_radius - 4.0, 0, 256 )
			c.pattern_degrees = 5
			c.fire_rate_wait = c.fire_rate_wait + 6
			
			return iter_max
		end,
	},
	{
		id          = "DIVIDE_3",
		name 		= "$action_divide_3",
		description = "$actiondesc_divide_3",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/divide_3.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "4,5,6,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,0.2,1,1", -- MANA_REDUCE
		price = 250,
		mana = 45,
		max_uses = 40,
		action 		= function( recursion_level, iteration )
			local data = {}
			local iter = iteration or 1
			local iter_max = iteration or 1
			
			if ( #deck > 0 ) then
				data = deck[iter] or nil
			else
				data = nil
			end
			
			local count = 3
			if ( iter >= 4 ) then
				count = 1
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local firerate = c.fire_rate_wait
				local reload = current_reload_time
				
				for i=1,count do
					if i == 1 then dont_draw_actions = true end

					local imax = data.action( rec, iter + 1 )
					if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					
					if imax ~= nil then iter_max = imax end
				end
				
				if (iter == 1) then
					c.fire_rate_wait = firerate
					current_reload_time = reload
					
					for i=1,iter_max do
						if (#deck > 0) then
							local d = deck[1]
							table.insert( discarded, d )
							table.remove( deck, 1 )
						end
					end
				end
			end
			
			c.damage_projectile_add = c.damage_projectile_add - 0.28
			c.explosion_radius = clamp( c.explosion_radius - 6, 0, 256 )
			c.pattern_degrees = 5
			c.fire_rate_wait = c.fire_rate_wait + 12
			
			return iter_max
		end,
	},
	{
		id          = "DIVIDE_4",
		name 		= "$action_divide_4",
		description = "$actiondesc_divide_4",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/divide_4.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "5,6,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,1,1", -- MANA_REDUCE
		price = 300,
		mana = 60,
		max_uses = 30,
		action 		= function( recursion_level, iteration )
			local data = {}
			local iter = iteration or 1
			local iter_max = iteration or 1
			
			if ( #deck > 0 ) then
				data = deck[iter] or nil
			else
				data = nil
			end
			
			local count = 4
			if ( iter >= 4 ) then
				count = 1
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local firerate = c.fire_rate_wait
				local reload = current_reload_time
				
				for i=1,count do
					if i == 1 then dont_draw_actions = true end

					local imax = data.action( rec, iter + 1 )
					if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					
					if imax ~= nil then iter_max = imax end
				end
				
				if (iter == 1) then
					c.fire_rate_wait = firerate
					current_reload_time = reload
					
					for i=1,iter_max do
						if (#deck > 0) then
							local d = deck[1]
							table.insert( discarded, d )
							table.remove( deck, 1 )
						end
					end
				end
			end
			
			c.damage_projectile_add = c.damage_projectile_add - 0.4
			c.explosion_radius = clamp( c.explosion_radius - 8.0, 0, 256 )
			c.pattern_degrees = 5
			c.fire_rate_wait = c.fire_rate_wait + 18
			
			return iter_max
		end,
	},
	{
		id          = "DIVIDE_10",
		name 		= "$action_divide_10",
		description = "$actiondesc_divide_10",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/divide_10.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_divide",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "7,10", -- MANA_REDUCE
		spawn_probability                 = "1,1", -- MANA_REDUCE
		price = 400,
		mana = 150,
		max_uses = 10,
		action 		= function( recursion_level, iteration )
			local data = {}
			local iter = iteration or 1
			local iter_max = iteration or 1
			
			if ( #deck > 0 ) then
				data = deck[iter] or nil
			else
				data = nil
			end
			
			local count = 10
			if ( iter >= 3 ) then
				count = 1
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local firerate = c.fire_rate_wait
				local reload = current_reload_time
				
				for i=1,count do
					if i == 1 then dont_draw_actions = true end

					local imax = data.action( rec, iter + 1 )
					if DE_DRAW_STATE ~= GameGetFrameNum() then dont_draw_actions = false end
					
					if imax ~= nil then iter_max = imax end
				end
				
				if (iter == 1) then
					c.fire_rate_wait = firerate
					current_reload_time = reload
					
					for i=1,iter_max do
						if (#deck > 0) then
							local d = deck[1]
							table.insert( discarded, d )
							table.remove( deck, 1 )
						end
					end
				end
			end
			
			c.damage_projectile_add = c.damage_projectile_add - 1.0
			c.explosion_radius = clamp( c.explosion_radius - 20.0, 0, 256 )
			c.pattern_degrees = 5
			c.fire_rate_wait = c.fire_rate_wait + 30
			current_reload_time = current_reload_time + 12
			
			return iter_max
		end,
	},
	{
		id          = "METEOR_RAIN",
		name 		= "$action_meteor_rain",
		description = "$dMETEOR_RAIN",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/meteor_rain.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= { "data/entities/projectiles/deck/meteor_rain_newsun.xml" },
		related_extra_entities = { "data/entities/misc/effect_meteor_rain.xml" },
		-- spawn_requires_flag = "card_unlocked_rain",
		-- never_unlimited		= true,
		ai_never_uses = true,
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "7,10",
		spawn_probability                 = "0.1,0.02",
		price = 300,
		mana = 575, 
		max_uses    = 2, 
		custom_xml_file = "data/entities/misc/custom_cards/meteor_rain.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/meteor_rain.xml")
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/effect_meteor_rain.xml," )
			c.damage_fire_add = c.damage_fire_add + 0.96
			c.speed_multiplier = math.max( c.speed_multiplier * 0.25, 0 )
			c.child_speed_multiplier = 0.25
			c.fire_rate_wait = c.fire_rate_wait + 54
			current_reload_time = current_reload_time + 54
		end,
	},
	{
		id          = "WORM_RAIN",
		name 		= "$action_worm_rain",
		description = "$dWORM_RAIN",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/worm_rain.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/animals/worm_big.xml"},
		-- spawn_requires_flag = "card_unlocked_rain",
		-- never_unlimited		= true,
		ai_never_uses = true,
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "6,7,10", -- BOMB
		spawn_probability                 = "0.1,1,0.5", -- BOMB
		price = 300,
		mana = 225, 
		max_uses    = 2, 
		custom_xml_file = "data/entities/misc/custom_cards/worm_rain.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/worm_rain.xml")
			c.damage_melee_add = c.damage_melee_add + 0.96
			c.speed_multiplier = math.max( c.speed_multiplier * 0.25, 0 )
			c.child_speed_multiplier = 0.25
			c.fire_rate_wait = c.fire_rate_wait + 54
			current_reload_time = current_reload_time + 54
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_SAKUYA",
		name 		= "$SAKUYA",
		description = "$dSAKUYA",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/maid_knife.png",
		related_projectiles	= {"data/entities/projectiles/deck/summon_knife_freeze_timer.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "7,10",
		spawn_probability                 = "0.1,0.02",
		-- spawn_requires_flag = "card_unlocked_rain",
		price = 560,
		mana = 0,
		max_uses = 360,
		custom_xml_file = "data/entities/misc/custom_cards/maid_knife.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/knife_summon.xml")
			c.damage_critical_chance = c.damage_critical_chance + 16
			c.spread_degrees = c.spread_degrees - 360.0
			c.speed_multiplier = c.speed_multiplier * 2.0
			c.fire_rate_wait = 9												-- the best shoot speed
			current_reload_time = 0
			shot_effects.recoil_knockback = 0
			c.bounces = 0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_I_NEED_MORE_POWER",
		name 		= "$I_NEED_MORE_POWER",
		description = "$dI_NEED_MORE_POWER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/summon_sword.png",
		related_projectiles	= {"data/entities/projectiles/deck/summon_sword_shoot_powerful.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "10",
		spawn_probability                 = "0.02",
		-- spawn_requires_flag = "card_unlocked_rain",
		price = 600,
		mana = 37,
		max_uses = 666,
		custom_xml_file = "data/entities/misc/custom_cards/summon_sword.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sword_summon.xml")
			c.damage_projectile_add = c.damage_projectile_add + 0.28
			c.damage_critical_chance = c.damage_critical_chance + 24
			c.spread_degrees = c.spread_degrees - 30.0
			c.speed_multiplier = c.speed_multiplier * 2.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 2.0
			current_reload_time = current_reload_time + 6
			c.bounces = 0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_MELODY",
		name 		= "$MELODY",
		description = "$dMELODY",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/melody.png",
		related_projectiles	= {"data/entities/projectiles/deck/melody.xml",2},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "7,10",
		spawn_probability                 = "0.1,0.02",
		-- spawn_requires_flag = "card_unlocked_everything",
		price = 400,
		mana = 12,
		max_uses    = 1437, 
		custom_xml_file = "data/entities/misc/custom_cards/de_note.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/melody.xml")
			c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/melody_trajectory.xml," )
			c.damage_explosion_add = c.damage_explosion_add + 0.32
			c.damage_critical_chance = c.damage_critical_chance + 7
			c.spread_degrees = -12
			c.fire_rate_wait = 6
			current_reload_time = math.floor( current_reload_time * 0.6 )
			shot_effects.recoil_knockback = 0
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_ULTIMATE",
		name 		= "$ULTIMATE",
		description = "$dULTIMATE",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/ultimate_spark.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/deep_end/just_reset_all_unidentified_1.png",
		related_projectiles	= {"data/entities/projectiles/deck/ultimate_flash.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10",
		spawn_probability                 = "0",
		-- spawn_requires_flag = "card_unlocked_everything",
		price = 418,
		mana = DE_ULTIMATE_MANA,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/ultimate_spark.xml",
		-- max_uses    = 12, 
		action 		= function()
			local players = EntityGetWithTag( "player_unit" )
			if ( players ~= nil ) then
				local pid = GetUpdatedEntityID()
				local x,y = EntityGetTransform( pid )
				local ultra = EntityGetInRadiusWithTag( x, y, 512, "ultra" )
			
				if ( #ultra < 1 ) then
					add_projectile("data/entities/projectiles/deck/ultimate_spark.xml")

					c.spread_degrees = math.min( -720, c.spread_degrees )
					shot_effects.recoil_knockback = math.min( -90, shot_effects.recoil_knockback )
					c.fire_rate_wait = math.min( 54, c.fire_rate_wait )
					current_reload_time = math.floor( current_reload_time * 0.5 + 42 )
				else
					c.damage_critical_chance = clamp( math.ceil( c.damage_critical_chance * 1.2 ), c.damage_critical_chance, 10000000 )
					mana = mana + DE_ULTIMATE_MANA -- how to use this mechanism
				end
			end
		end,
	},
	{
		id          = "RESET",
		name 		= "$action_reset",
		description = "$actiondesc_reset",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/reset.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_mestari",
		type 		= ACTION_TYPE_UTILITY,
		recursive	= true,
		spawn_level                       = "7,10", -- BOMB
		spawn_probability                 = "1,1", -- BOMB
		price = 120,
		mana = 10, 
		max_uses    = 1, 
		action 		= function()
			current_reload_time = math.min( current_reload_time - 25, math.floor( current_reload_time * 0.5 ), 90 )
			
			for i,v in ipairs( hand ) do
				-- print( "removed " .. v.id .. " from hand" )
				table.insert( discarded, v )
			end
			
			for i,v in ipairs( deck ) do
				-- print( "removed " .. v.id .. " from deck" )
				table.insert( discarded, v )
			end
			
			hand = {}
			deck = {}
			
			if ( force_stop_draws == false ) then
				force_stop_draws = true
				move_discarded_to_deck()
				order_deck()
			end
		end,
	},
	{
		Deep_End_Unique_Spell = true,
		id          = "DE_LINE_BREAKER",
		name 		= "$LINE_BREAKER",
		description = "$dLINE_BREAKER",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/line_breaker.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "7,10", -- BOMB
		spawn_probability                 = "1,1", -- BOMB
		price = 10,
		mana = -10, 
		max_uses    = 999, 
		action 		= function()
			current_reload_time = current_reload_time + 7

			for i,v in ipairs( deck ) do
				-- print( "removed " .. v.id .. " from deck" )
				table.insert( discarded, v )
			end
			
			deck = {}
			force_stop_draws = true
		end,
	},
	{
		id          = "IF_ENEMY",
		name 		= "$action_if_enemy",
		description = "$actiondesc_if_enemy",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/if_enemy.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "1,10", -- MANA_REDUCE
		spawn_probability                 = "0.01,0.9", -- MANA_REDUCE
		price = 100,
		mana = 0,
		action 		= function( recursion_level, iteration )
			local endpoint = -1
			local elsepoint = -1
			local x,y = EntityGetTransform( GetUpdatedEntityID() )
			local enemies = EntityGetInRadiusWithTag( x, y, 240, "homing_target" )
			
			local doskip = false
			if ( #enemies < 15 ) then
				doskip = true
			end
			
			if ( #deck > 0 ) then
				for i,v in ipairs( deck ) do
					if ( v ~= nil ) then
						if ( string.sub( v.id, 1, 3 ) == "IF_" ) and ( v.id ~= "IF_END" ) and ( v.id ~= "IF_ELSE" ) then
							endpoint = -1
							break
						end
						
						if ( v.id == "IF_ELSE" ) then
							endpoint = i
							elsepoint = i
						end
						
						if ( v.id == "IF_END" ) then
							endpoint = i
							break
						end
					end
				end
				
				local envelope_min = 1
				local envelope_max = 1
					
				if doskip then
					if ( elsepoint > 0 ) then
						envelope_max = elsepoint
					elseif ( endpoint > 0 ) then
						envelope_max = endpoint
					end
					
					for i=envelope_min,envelope_max do
						local v = deck[envelope_min]
						
						if ( v ~= nil ) then
							table.insert( discarded, v )
							table.remove( deck, envelope_min )
						end
					end
				else
					if ( elsepoint > 0 ) then
						envelope_min = elsepoint
						
						if ( endpoint > 0 ) then
							envelope_max = endpoint
						else
							envelope_max = #deck
						end
						
						for i=envelope_min,envelope_max do
							local v = deck[envelope_min]
							
							if ( v ~= nil ) then
								table.insert( discarded, v )
								table.remove( deck, envelope_min )
							end
						end
					end
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "IF_PROJECTILE",
		name 		= "$action_if_projectile",
		description = "$actiondesc_if_projectile",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/if_projectile.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "1,10", -- MANA_REDUCE
		spawn_probability                 = "0.01,0.9", -- MANA_REDUCE
		price = 100,
		mana = 0,
		action 		= function( recursion_level, iteration )
			local endpoint = -1
			local elsepoint = -1
			local x,y = EntityGetTransform( GetUpdatedEntityID() )
			local enemies = EntityGetInRadiusWithTag( x, y, 160, "projectile" )
			
			local doskip = false
			if ( #enemies < 20 ) then
				doskip = true
			end
			
			if ( #deck > 0 ) then
				for i,v in ipairs( deck ) do
					if ( v ~= nil ) then
						if ( string.sub( v.id, 1, 3 ) == "IF_" ) and ( v.id ~= "IF_END" ) and ( v.id ~= "IF_ELSE" ) then
							endpoint = -1
							break
						end
						
						if ( v.id == "IF_ELSE" ) then
							endpoint = i
							elsepoint = i
						end
						
						if ( v.id == "IF_END" ) then
							endpoint = i
							break
						end
					end
				end
				
				local envelope_min = 1
				local envelope_max = 1
					
				if doskip then
					if ( elsepoint > 0 ) then
						envelope_max = elsepoint
					elseif ( endpoint > 0 ) then
						envelope_max = endpoint
					end
					
					for i=envelope_min,envelope_max do
						local v = deck[envelope_min]
						
						if ( v ~= nil ) then
							table.insert( discarded, v )
							table.remove( deck, envelope_min )
						end
					end
				else
					if ( elsepoint > 0 ) then
						envelope_min = elsepoint
						
						if ( endpoint > 0 ) then
							envelope_max = endpoint
						else
							envelope_max = #deck
						end
						
						for i=envelope_min,envelope_max do
							local v = deck[envelope_min]
							
							if ( v ~= nil ) then
								table.insert( discarded, v )
								table.remove( deck, envelope_min )
							end
						end
					end
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "IF_HP",
		name 		= "$action_if_hp",
		description = "$actiondesc_if_hp",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/if_hp.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "1,10", -- MANA_REDUCE
		spawn_probability                 = "0.01,0.9", -- MANA_REDUCE
		price = 100,
		mana = 0,
		action 		= function( recursion_level, iteration )
			local endpoint = -1
			local elsepoint = -1
			local entity_id = GetUpdatedEntityID()
			local comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
			local hpdiff = 1.0
			
			if ( comp ~= nil ) then
				local hp = ComponentGetValue2( comp, "hp" )
				local max_hp = ComponentGetValue2( comp, "max_hp" )
				
				hpdiff = hp / max_hp
			end
			
			local doskip = false
			if ( hpdiff > 0.25 ) then
				doskip = true
			end
			
			if ( #deck > 0 ) then
				for i,v in ipairs( deck ) do
					if ( v ~= nil ) then
						if ( string.sub( v.id, 1, 3 ) == "IF_" ) and ( v.id ~= "IF_END" ) and ( v.id ~= "IF_ELSE" ) then
							endpoint = -1
							break
						end
						
						if ( v.id == "IF_ELSE" ) then
							endpoint = i
							elsepoint = i
						end
						
						if ( v.id == "IF_END" ) then
							endpoint = i
							break
						end
					end
				end
				
				local envelope_min = 1
				local envelope_max = 1
					
				if doskip then
					if ( elsepoint > 0 ) then
						envelope_max = elsepoint
					elseif ( endpoint > 0 ) then
						envelope_max = endpoint
					end
					
					for i=envelope_min,envelope_max do
						local v = deck[envelope_min]
						
						if ( v ~= nil ) then
							table.insert( discarded, v )
							table.remove( deck, envelope_min )
						end
					end
				else
					if ( elsepoint > 0 ) then
						envelope_min = elsepoint
						
						if ( endpoint > 0 ) then
							envelope_max = endpoint
						else
							envelope_max = #deck
						end
						
						for i=envelope_min,envelope_max do
							local v = deck[envelope_min]
							
							if ( v ~= nil ) then
								table.insert( discarded, v )
								table.remove( deck, envelope_min )
							end
						end
					end
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "IF_HALF",
		name 		= "$action_if_half",
		description = "$actiondesc_if_half",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/if_half.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "1,10", -- MANA_REDUCE
		spawn_probability                 = "0.01,0.9", -- MANA_REDUCE
		price = 100,
		mana = 0,
		action 		= function( recursion_level, iteration )
			local endpoint = -1
			local elsepoint = -1
			local doskip = false
			
			if ( reflecting == false ) then
				local status = tonumber( GlobalsGetValue( "GUN_ACTION_IF_HALF_STATUS", "0" ) ) or 0
				
				if ( status == 1 ) then
					doskip = true
				end
				
				status = 1 - status
				GlobalsSetValue( "GUN_ACTION_IF_HALF_STATUS", tostring( status ) )
			end
			
			if ( #deck > 0 ) then
				for i,v in ipairs( deck ) do
					if ( v ~= nil ) then
						if ( string.sub( v.id, 1, 3 ) == "IF_" ) and ( v.id ~= "IF_END" ) and ( v.id ~= "IF_ELSE" ) then
							endpoint = -1
							break
						end
						
						if ( v.id == "IF_ELSE" ) then
							endpoint = i
							elsepoint = i
						end
						
						if ( v.id == "IF_END" ) then
							endpoint = i
							break
						end
					end
				end
				
				local envelope_min = 1
				local envelope_max = 1
				
				if doskip then
					if ( elsepoint > 0 ) then
						envelope_max = elsepoint
					elseif ( endpoint > 0 ) then
						envelope_max = endpoint
					end
					
					for i=envelope_min,envelope_max do
						local v = deck[envelope_min]
					
						if ( v ~= nil ) then
							table.insert( discarded, v )
							table.remove( deck, envelope_min )
						end
					end
				else
					if ( elsepoint > 0 ) then
						envelope_min = elsepoint
						
						if ( endpoint > 0 ) then
							envelope_max = endpoint
						else
							envelope_max = #deck
						end
						
						for i=envelope_min,envelope_max do
							local v = deck[envelope_min]
							
							if ( v ~= nil ) then
								table.insert( discarded, v )
								table.remove( deck, envelope_min )
							end
						end
					end
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "IF_END",
		name 		= "$action_if_end",
		description = "$actiondesc_if_end",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/if_end.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "1,10", -- MANA_REDUCE
		spawn_probability                 = "0.01,0.9", -- MANA_REDUCE
		price = 10,
		mana = 0,
		action 		= function( recursion_level, iteration )			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "IF_ELSE",
		name 		= "$action_if_else",
		description = "$actiondesc_if_else",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/if_else.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "1,10", -- MANA_REDUCE
		spawn_probability                 = "0.01,0.9", -- MANA_REDUCE
		price = 10,
		mana = 0,
		action 		= function( recursion_level, iteration )			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_RED",
		name 		= "$action_colour_red",
		description = "$ddCOLOUR",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/colour_red.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/colour_red.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4", -- HOMING
		spawn_probability                 = "0.075,0.075,0.15", -- HOMING
		-- spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			local colour = "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_red.xml,"
			local judge = de_str_finder( c.extra_entities, colour )

			if ( judge == nil ) then
				c.extra_entities = c.extra_entities .. colour
			else
				c.material = "spark_red"
				c.material_amount = c.material_amount + 50
			end

			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = math.min( c.screenshake - 2.5, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 12.5
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_ORANGE",
		name 		= "$action_colour_orange",
		description = "$ddCOLOUR",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/colour_orange.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/colour_orange.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- HOMING
		spawn_probability                 = "0.075,0.15,0.075", -- HOMING
		-- spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			local colour = "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_orange.xml,"
			local judge = de_str_finder( c.extra_entities, colour )

			if ( judge == nil ) then
				c.extra_entities = c.extra_entities .. colour
			else
				c.material = "spark"
				c.material_amount = c.material_amount + 50
			end

			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = math.min( c.screenshake - 2.5, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 12.5
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_GREEN",
		name 		= "$action_colour_green",
		description = "$ddCOLOUR",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/colour_green.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/colour_green.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4", -- HOMING
		spawn_probability                 = "0.075,0.15,0.075", -- HOMING
		-- spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			local colour = "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_green.xml,"
			local judge = de_str_finder( c.extra_entities, colour )

			if ( judge == nil ) then
				c.extra_entities = c.extra_entities .. colour
			else
				c.material = "spark_green"
				c.material_amount = c.material_amount + 50
			end

			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = math.min( c.screenshake - 2.5, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 12.5
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_YELLOW",
		name 		= "$action_colour_yellow",
		description = "$ddCOLOUR",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/colour_yellow.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/colour_yellow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,4,5", -- HOMING
		spawn_probability                 = "0.075,0.15,0.075", -- HOMING
		-- spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			local colour = "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_yellow.xml,"
			local judge = de_str_finder( c.extra_entities, colour )

			if ( judge == nil ) then
				c.extra_entities = c.extra_entities .. colour
			else
				c.material = "spark_yellow"
				c.material_amount = c.material_amount + 50
			end

			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = math.min( c.screenshake - 2.5, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 12.5
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_PURPLE",
		name 		= "$action_colour_purple",
		description = "$ddCOLOUR",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/colour_purple.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/colour_purple.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,5", -- HOMING
		spawn_probability                 = "0.075,0.075,0.15", -- HOMING
		-- spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			local colour = "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_purple.xml,"
			local judge = de_str_finder( c.extra_entities, colour )

			if ( judge == nil ) then
				c.extra_entities = c.extra_entities .. colour
			else
				c.material = "air" -- spark_purple does not have it's unique fire_colors_index
				c.material_amount = c.material_amount + 50
			end

			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = math.min( c.screenshake - 2.5, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 12.5
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_BLUE",
		name 		= "$action_colour_blue",
		description = "$ddCOLOUR",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/colour_blue.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/colour_blue.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,5", -- HOMING
		spawn_probability                 = "0.15,0.075,0.075", -- HOMING
		-- spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			local colour = "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_blue.xml,"
			local judge = de_str_finder( c.extra_entities, colour )

			if ( judge == nil ) then
				c.extra_entities = c.extra_entities .. colour
			else
				c.material = "spark_blue"
				c.material_amount = c.material_amount + 50
			end

			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = math.min( c.screenshake - 2.5, 0 )
			
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 12.5
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_RAINBOW",
		name 		= "$action_colour_rainbow",
		description = "$actiondesc_colour_rainbow",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/colour_rainbow.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/colour_rainbow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,10", -- HOMING
		spawn_probability                 = "0.075,0.075,0.075,0.15", -- HOMING
		-- spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			local colour = "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_rainbow.xml,"
			local judge = de_str_finder( c.extra_entities, colour )

			if ( judge == nil ) then
				c.extra_entities = c.extra_entities .. colour
			else
				c.extra_entities = colour .. colour .. colour
			end
			
			c.fire_rate_wait = c.fire_rate_wait - 12
			c.screenshake = math.min( c.screenshake - 20, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_INVIS",
		name 		= "$action_colour_invis",
		description = "$ddCOLOUR_INVIS",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/colour_invis.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/colour_invis.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5,10", -- HOMING
		spawn_probability                 = "0.075,0.075,0.075,0.075", -- HOMING
		-- spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			local colour = "data/entities/misc/colour_invis.xml,"
			local judge = de_str_finder( c.extra_entities, colour )

			if judge == nil then
				c.extra_entities = c.extra_entities .. colour
			else
				c.extra_entities = "" -- invis all
			end
			
			c.fire_rate_wait = c.fire_rate_wait - 12
			c.screenshake = math.min( c.screenshake - 20, 0 )
			c.trail_material_amount = 0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 25.0

			c.material = "air"
			c.material_amount = 0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "RAINBOW_TRAIL",
		name 		= "$action_rainbow_trail",
		description = "$actiondesc_rainbow_trail",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/rainbow_trail.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/oil_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "7,10", -- rainbow_trail
		spawn_probability                 = "0.02,0.02", -- rainbow_trail
		-- spawn_requires_flag = "card_unlocked_rainbow_trail",
		price = 100,
		mana = 0,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/rainbow_trail.xml",
		action 		= function()
			c.game_effect_entities = de_effect_entities_add( c.game_effect_entities, "data/entities/misc/effect_rainbow_farts.xml," )
			c.trail_material = c.trail_material .. "material_rainbow,"
			c.trail_material_amount = clamp( c.trail_material_amount * 2, c.trail_material_amount + 20, 1000 )
			draw_actions( 1, true )
		end,

	},
	{
		id          = "CESSATION",
		name 		= "$action_cessation",
		description = "$actiondesc_cessation",
		sprite 		= "data/ui_gfx/gun_actions/deep_end/cessation.png",
		-- sprite_unidentified = "data/ui_gfx/gun_actions/cessation_unidentified.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "5,6,7,10",
		spawn_probability                 = "0.1,0.2,0.4,0.8",
		-- spawn_requires_flag = "card_unlocked_cessation",
		price = 3930,
		mana = 0,
		max_uses = 0,
		ai_never_uses = true,
		--custom_xml_file = "data/entities/misc/custom_cards/rainbow_trail.xml",
		action = function()
			c.fire_rate_wait = c.fire_rate_wait + 300
			current_reload_time = current_reload_time + 300

			if reflecting then return end

			local caster_entity = GetUpdatedEntityID()
			local wand_entity = find_the_wand_held( caster_entity )

			if not EntityHasTag( caster_entity, "player_unit" ) then return end

			local frame = GameGetFrameNum()
			local lifetime = 20 + c.lifetime_add -- math.abs( 20 + c.lifetime_add )

			if wand_entity then
				local ability = EntityGetFirstComponentIncludingDisabled( wand_entity, "AbilityComponent" )
				if ability ~= nil then
					ComponentSetValue2( ability, "mNextFrameUsable", frame + lifetime + c.fire_rate_wait )
					ComponentSetValue2( ability, "mCastDelayStartFrame", frame + lifetime )
				end
			end

			local inventory = EntityGetFirstComponentIncludingDisabled( caster_entity, "InventoryGuiComponent" )
			if inventory ~= nil then
				ComponentSetValue2( inventory, "mDisplayFireRateWaitBar", true )
			end

			if lifetime >= -1 then
				local platformshooter = EntityGetFirstComponentIncludingDisabled( caster_entity, "PlatformShooterPlayerComponent" )
				if platformshooter ~= nil then
					ComponentSetValue2( platformshooter, "mCessationDo", true )
					ComponentSetValue2( platformshooter, "mCessationLifetime", lifetime )
				end
			else
				EntityAddTag( caster_entity, "de_attempt_BSOD" )
				DEEP_END_BSOD(true)
			end

			StartReload( current_reload_time )
		end,
	},
}

local orgsps = ModSettingGet( "DEEP_END.ORIGINAL_SPELLS" ) and not ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" )
local actions_clone = {}

for i=1,#de_actions_recompose do
	local find = false

	if de_actions_recompose[i].Deep_End_Unique_Spell == nil then
	for j=1,#actions do
	if de_actions_recompose[i].id == actions[j].id then
		find = true

		if orgsps then	table.insert( actions_clone, actions[j] )
		else 			table.insert( actions_clone, de_actions_recompose[i] ) end

		table.remove( actions, j )
		break
	end end end

	if not find then table.insert( actions_clone, de_actions_recompose[i] ) end
end

for i=1,#actions_clone do table.insert( actions, actions_clone[i] ) end

--[[

for i=1,#de_actions_recompose do
	local find = false

	if de_actions_recompose[i].Deep_End_Unique_Spell == nil then
		for j=1,#actions do
			if de_actions_recompose[i].id == actions[j].id then
				if not orgsps then
					table.remove( actions, j )
					table.insert( actions, de_actions_recompose[i] )
				end
				
				find = true
				break
			end
		end
	end

	if not find then table.insert( actions, de_actions_recompose[i] ) end
end

]]--