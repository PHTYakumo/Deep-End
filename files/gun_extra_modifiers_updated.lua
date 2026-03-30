--[[
function extra_modifiers.critical_hit_boost()
	c.damage_critical_chance = c.damage_critical_chance + 5
end
]]--

function extra_modifiers.critical_plus_small()
	SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() - c.damage_critical_chance )
	c.damage_critical_chance = c.damage_critical_chance + 5 * Random( -10, 10 ) + 50
end

function extra_modifiers.damage_plus_small()
	c.damage_projectile_add = c.damage_projectile_add + 0.36
	c.damage_projectile_add = c.damage_projectile_add * 1.25
	c.damage_healing_add = c.damage_healing_add * 1.25
end

function extra_modifiers.powerful_shot()
	c.damage_explosion_add = c.damage_explosion_add + 0.12
	c.damage_projectile_add = c.damage_projectile_add + 0.6
	c.speed_multiplier = c.speed_multiplier * 1.6
	c.lifetime_add = c.lifetime_add + 12
end

function extra_modifiers.extra_knockback()
	c.damage_projectile_add = c.damage_projectile_add + 0.2
	c.knockback_force = c.knockback_force + 15
end

function extra_modifiers.lower_spread()
	c.spread_degrees = c.spread_degrees - 30
	c.damage_projectile_add = c.damage_projectile_add + 0.6
	c.damage_explosion_add = c.damage_explosion_add + 0.4
	c.explosion_radius = clamp( c.explosion_radius -5, 1, 200 )
	-- c.fire_rate_wait   = c.fire_rate_wait + 2
	-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 8.0
end

function extra_modifiers.laser_aim()
	c.screenshake = 0
	c.pattern_degrees = 0.5
	c.spread_degrees = clamp( c.spread_degrees - 15, -60, 60 )
	c.speed_multiplier = clamp( c.speed_multiplier * 1.5, 0, 1024 )
end

function extra_modifiers.low_recoil()
	-- c.speed_multiplier = math.max( c.speed_multiplier * 0.875, 0 )
	c.gravity = 0
	shot_effects.recoil_knockback = math.min( shot_effects.recoil_knockback * 0.5 - 16.0, 8 )
end

function extra_modifiers.bounce()
	c.bounces = math.max( c.bounces + 1, 8 )
	c.lifetime_add = c.lifetime_add + 24
end

function extra_modifiers.fast_projectiles()
	c.fire_rate_wait   = c.fire_rate_wait - 3
	c.speed_multiplier = clamp( c.speed_multiplier * 2, 0, 1024 )
	-- c.extra_entities = c.extra_entities .. "data/entities/misc/accelerating_shot.xml,"
end

function extra_modifiers.duplicate_projectile()
	local data = hand[#hand]
	if data ~= nil then data.action() end

	c.pattern_degrees = c.pattern_degrees + 1
end

function extra_modifiers.explosive_projectile()
	c.material = "liquid_fire"
	c.explosion_radius = clamp( c.explosion_radius + 1, 3, 600 )
	c.speed_multiplier = clamp( c.speed_multiplier * 0.9, 0, 7.5 )
	if c.fire_rate_wait < 60 then c.fire_rate_wait = c.fire_rate_wait + 8 end
	shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10
end

function extra_modifiers.high_spread()
	SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() + c.gravity - c.spread_degrees )
	c.gravity = c.gravity + 20 * Random( -10, 10 )
	c.spread_degrees = c.spread_degrees + 30
end

function extra_modifiers.extreme_spread()
	SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() + c.gravity - c.spread_degrees )
	c.gravity = c.gravity + 60 * Random( -10, 10 )
	c.spread_degrees = c.spread_degrees + 90
end

function extra_modifiers.laser_aim_passive()
	c.screenshake = 0
	c.spread_degrees = math.min( c.spread_degrees - 10, 30 )
	shot_effects.recoil_knockback = math.min( shot_effects.recoil_knockback - 2, 40 )
end

function extra_modifiers.projectile_homing_shooter_wizard()
	c.extra_entities = c.extra_entities .. "data/entities/misc/perks/projectile_homing_shooter.xml,"
	c.screenshake = c.screenshake + 10
	shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
end

function extra_modifiers.shot_swarm_fly()
	SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() - c.spread_degrees )

	c.spread_degrees = c.spread_degrees + 1
	if c.fire_rate_wait <= current_reload_time then c.fire_rate_wait = c.fire_rate_wait + 1
	else current_reload_time = current_reload_time + 1 end

	local x,y = EntityGetTransform(GetUpdatedEntityID())
	local degree = Random(1,100) * 0.062832

	shoot_projectile( GetUpdatedEntityID(), "data/entities/projectiles/deck/de_swarm_fly.xml", x + 9 * math.sin(degree), y - 9 * math.cos(degree), 169 * math.cos(degree), 169 * math.sin(degree) )
end

function extra_modifiers.plankter_wand()
	local x,y = EntityGetTransform(GetUpdatedEntityID())
	local plankter_wands = EntityGetInRadiusWithTag( x, y, 16, "de_plankter_wand" )

	if plankter_wands[1] ~= nil then
		for i=1,#plankter_wands do
			local bcomp = EntityGetFirstComponent( plankter_wands[i], "VariableStorageComponent" )
			if bcomp ~= nil then ComponentSetValue2( bcomp, "value_int", ComponentGetValue2( bcomp, "value_int" )+1 ) end
		end
	else
		add_projectile("data/entities/projectiles/deck/light_bullet_blue.xml")
	end
end

function extra_modifiers.chaosoahc_arc()
	SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() - c.speed_multiplier )
	c.speed_multiplier = clamp( c.speed_multiplier + Random( -25, 25 ) * 0.01, 0, 1024 )

	local soahc_arcs =
	{
		"laser_emitter_wider", "sinewave", "chaotic_arc", "pingpong_path",
		"avoiding_arc", "floating_arc", "fly_downwards", "fly_upwards",
		"horizontal_arc", "line_arc", "orbit_shot", "spiraling_shot",
		"phasing_arc", "homing", "anti_homing", "homing_wand",
		"metastable_trajectory", "order_trajectory", "melody_trajectory"
	}

	if Random( -25, 25 ) > 0 then c.extra_entities = de_effect_entities_add( c.extra_entities, "data/entities/misc/" .. soahc_arcs[Random( 1, #soahc_arcs )] .. ".xml," ) end
end

function extra_modifiers.slow_firing()
	if c.fire_rate_wait < 60 then c.fire_rate_wait = c.fire_rate_wait + 5 end
	if current_reload_time < 100 then current_reload_time = current_reload_time + 5 end
end
