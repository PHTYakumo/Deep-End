biomes =
{
	{"coalmine","coalmine_alt"},
	{"excavationsite"},
	{"snowcave"},
	{"snowcastle"},
	{"fungicave","fungiforest"},
	{"wandcave","wizardcave"},
	{"rainforest","rainforest_open"},
	{"vault","vault_frozen"},
	{"crypt","pyramid"},

	{"clouds"},
	{"meat"},
	{"robobase"},
}

-- cosmetic freeze - does not add biome reactions
biome_modifier_cosmetic_freeze = {
	id = "FREEZING_COSMETIC",
	ui_description="$biomemodifierdesc_freezing",
	probability=0,
	action = function( biome_name, biome_filename )

		-- replace grass, moss etc with snow
		local frozen_veg_type = "snow"
		if random_next( rnd, 0, 1 ) >= 0.5 then frozen_veg_type = "ice_static" end
		BiomeVegetationSetValue( biome_filename, "grass", "tree_material", frozen_veg_type )
		BiomeVegetationSetValue( biome_filename, "moss", "tree_material", frozen_veg_type )
		BiomeVegetationSetValue( biome_filename, "snow", "tree_probability", 0.83 ) -- enable disabled snow VegetationComponents
		BiomeVegetationSetValue( biome_filename, frozen_veg_type, "grass_requires_neighbors", false )
		-- cosmetic
		BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.6 )
		BiomeSetValue( biome_filename, "color_grading_r", 0.85 )
		BiomeSetValue( biome_filename, "color_grading_g", 0.90 )
		BiomeSetValue( biome_filename, "color_grading_b", 1.10 )
		BiomeSetValue( biome_filename, "color_grading_grayscale", 0.1 )
	end,
}

biome_modifier_fog_of_war_clear_at_player = {
	id = "FOG_OF_WAR_CLEAR_AT_PLAYER",
	ui_description="$biomemodifierdesc_fog_of_war_clear_at_player",
	ui_decoration_file="data/ui_gfx/decorations_biome_modifier/fog_of_war_clear_at_player.png",
	probability=0,
	action = function( biome_name, biome_filename )
		BiomeSetValue( biome_filename, "fog_of_war_type", "HEAVY_CLEAR_AT_PLAYER" )
	end,
}

biome_modifiers =
{
	-- fire extinguishes easily, projectiles are slowed down, characters slowly get wet stains, -- TODO: swamp guys spawn, material corrosion
	{
		id = "MOIST",
		ui_description="$biomemodifierdesc_moist",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/moist.png",
		probability=0.6,
		does_not_apply_to_biome={"robobase",},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.75 )
			BiomeObjectSetValue( biome_filename, "modifiers", "fire_extinguish_chance", 11 )
			BiomeObjectSetValue( biome_filename, "modifiers", "random_water_stains_chance", 5 )
			BiomeObjectSetValue( biome_filename, "modifiers", "random_water_stains_amount", 5 )
			BiomeObjectSetValue( biome_filename, "modifiers", "projectile_drag_coeff", 0.965 )
		end,
	},
	{
		id = "MOIST_SUPER",
		ui_description="$biomemodifierdesc_MOIST_SUPER",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/moist.png",
		probability=0.3,
		does_not_apply_to_biome={"robobase",},
		action = function( biome_name, biome_filename )
			BiomeSetValue( biome_filename, "color_grading_r", 0.78 )
			BiomeSetValue( biome_filename, "color_grading_g", 0.78 )
			BiomeSetValue( biome_filename, "color_grading_b", 1.22 )
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.5 )
			BiomeObjectSetValue( biome_filename, "modifiers", "fire_extinguish_chance", 99 )
			BiomeObjectSetValue( biome_filename, "modifiers", "random_water_stains_chance", 25 )
			BiomeObjectSetValue( biome_filename, "modifiers", "random_water_stains_amount", 10 )
			BiomeObjectSetValue( biome_filename, "modifiers", "projectile_drag_coeff", 0.812 )
		end,
	},
	-- fog of war slowly reappears
	{
		id = "FOG_OF_WAR_REAPPEARS",
		ui_description="$biomemodifierdesc_fog_of_war_reappears",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/fog_of_war.png",
		probability=0.5,
		does_not_apply_to_biome={"mountain_hall",},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "fog_of_war_delta", 2 )
		end,
	},
	-- projectiles and most entities get higher gravity (doesn't affect physics or particles)
	{
		id = "HIGH_GRAVITY",
		ui_description="$biomemodifierdesc_high_gravity",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/high_gravity.png",
		probability=0.5,
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "entity_gravity_y_multiplier", 1.5 )
		end,
	},
	-- projectiles and most entities get lower gravity (doesn't affect physics or particles)
	{
		id = "LOW_GRAVITY",
		ui_description="$biomemodifierdesc_low_gravity",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/low_gravity.png",
		probability=0.5,
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "entity_gravity_y_multiplier", 0.5 )
		end,
	},
	{
		id = "HYPERGRAVITY",
		ui_description="$biomemodifierdesc_HYPERGRAVITY",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/low_gravity.png",
		probability=0.2,
		action = function( biome_name, biome_filename )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.4 )
			BiomeObjectSetValue( biome_filename, "modifiers", "projectile_drag_coeff", 1.028 )
			BiomeObjectSetValue( biome_filename, "modifiers", "entity_gravity_y_multiplier", 16.0 )
		end,
	},
	{
		id = "ZERO_GRAVITY",
		ui_description="$biomemodifierdesc_ZERO_GRAVITY",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/low_gravity.png",
		probability=0.2,
		action = function( biome_name, biome_filename )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.4 )
			BiomeObjectSetValue( biome_filename, "modifiers", "projectile_drag_coeff", 1.028 )
			BiomeObjectSetValue( biome_filename, "modifiers", "entity_gravity_y_multiplier", 0.001 )
		end,
	},
	-- conductive - all materials conduct electricity
	{
		id = "CONDUCTIVE",
		ui_description="$biomemodifierdesc_conductive",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/conductive.png",
		probability=0.2,
		does_not_apply_to_biome={"mountain_hall","coalmine"},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "everything_is_conductive", true )
		end,
		inject_spawns_action = function()
			inject_spawn( g_props, 2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics/trap_electricity_enabled.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics/trap_laser_enabled.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics/trap_laser_enabled_left.xml",
			})
			inject_spawn( g_small_enemies, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/animals/thunderskull.xml"
			})
			inject_spawn( g_lamp, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_hanging_wire.xml",
			})
			inject_spawn( g_vines, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_hanging_wire.xml",
			})
		end,
	},
	-- freezing - liquids freeze
	{
		id = "FREEZING",
		ui_description="$biomemodifierdesc_freezing",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/freezing.png",
		probability=0.0,
		action = function( biome_name, biome_filename )

			BiomeObjectSetValue( biome_filename, "modifiers", "reaction_freeze_chance", 5 )
			-- replace grass, moss etc with snow
			local frozen_veg_type = "grass_ice"
			--if random_next( rnd, 0, 1 ) >= 0.5 then frozen_veg_type = "ice_static" end
			BiomeVegetationSetValue( biome_filename, "grass", "tree_material", frozen_veg_type )
			BiomeVegetationSetValue( biome_filename, "moss", "tree_material", frozen_veg_type )
			BiomeVegetationSetValue( biome_filename, "snow", "tree_probability", 0.9 ) -- enable disabled snow VegetationComponents
			BiomeVegetationSetValue( biome_filename, frozen_veg_type, "grass_requires_neighbors", false )
			-- cosmetic
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.6 )
			BiomeSetValue( biome_filename, "color_grading_r", 0.90 )
			BiomeSetValue( biome_filename, "color_grading_g", 0.95 )
			BiomeSetValue( biome_filename, "color_grading_b", 1.10 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.107 )
		end,
	},
	-- hot - frozen materials melt
	{
		id = "HOT",
		ui_description="$biomemodifierdesc_hot",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/hot.png",
		probability=0.6,
		does_not_apply_to_biome={"mountain_hall",}, --does_not_apply_to_biome={"snowcave","snowcastle",},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "reaction_unfreeze_chance", 80 )
			BiomeVegetationSetValue( biome_filename, "grass", "tree_material", "grass_dry" )
			BiomeVegetationSetValue( biome_filename, "fungus_loose", "tree_probability", 0.0 ) -- no mushrooms in dry biome
			BiomeSetValue( biome_filename, "color_grading_r", 1.00 )
			BiomeSetValue( biome_filename, "color_grading_g", 0.95 )
			BiomeSetValue( biome_filename, "color_grading_b", 0.9 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.075 )
		end,
		inject_spawns_action = function()
			inject_spawn( g_props, 1.6, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/props/physics_barrel_water.xml",
			})
			inject_spawn( g_props, 0.4, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 2,
				offset_y 	= -8,
				entity 	= "data/entities/props/physics_seamine.xml"
			})
			inject_spawn( g_props2, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 3,
				offset_y 	= -8,
				entity 	= "data/entities/props/physics_seamine.xml"
			})
		end,
	},
	-- gold vein - more gold spawns inside ground
	{
		id = "GOLD_VEIN",
		ui_description="$biomemodifierdesc_gold_vein",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/gold.png",
		probability=0.1,
		-- does_not_apply_to_biome={"snowcastle",},
		action = function( biome_name, biome_filename )
			BiomeMaterialSetValue( biome_filename, "gold", "material_max", 20 ) 
			BiomeMaterialSetValue( biome_filename, "gold", "material_min", 0.1 )
		end,
	},
	-- gold vein super - tons of gold spawns inside ground
	{
		id = "GOLD_VEIN_SUPER",
		ui_description="$biomemodifierdesc_gold_vein_super",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/gold.png",
		probability=0.04,
		does_not_apply_to_biome={"snowcastle","snowcave"},
		-- apply_only_to_biome={"coalmine","coalmine_alt","excavationsite","snowcave",},
		action = function( biome_name, biome_filename )
			BiomeMaterialSetValue( biome_filename, "gold", "material_max", 80 ) 
			BiomeMaterialSetValue( biome_filename, "gold", "material_min", 0.9 )

			BiomeMaterialSetValue( biome_filename, "gold", "is_rare", false )
		end,
	},
	-- root growers, swamp & soil materials
	{
		id = "PLANT_INFESTED",
		ui_description="$biomemodifierdesc_plant_infested",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/plant_infested.png",
		probability=0.6,
		does_not_apply_to_biome={"rainforest","rainforest_open","robobase"},
		action = function( biome_name, biome_filename ) end,
		inject_spawns_action = function()
			-- plants
			inject_spawn( g_props, 0.9, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/root_grower.xml",
			})
			inject_spawn( g_props2, 0.9, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/root_grower.xml",
			})
			inject_spawn( g_lamp, 2.0, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/root_grower.xml",
			})
			inject_spawn( g_lamp, 1.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/verlet_chains/root/hanging_root_random.xml",
			})
			-- enemies
			inject_spawn( g_small_enemies, 0.03, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,
				entity 	=  "data/entities/animals/rainforest/shooterflower.xml",
			})
			inject_spawn( g_small_enemies, 0.03, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,
				entity 	=  "data/entities/animals/rainforest/bloom.xml",
			})
			-- material pixel scenes
			inject_spawn( g_props, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_swamp_ball.xml",
			})
			inject_spawn( g_props2, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_swamp_ball.xml",
			})
			inject_spawn( g_props, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_grass_ball.xml",
			})
			inject_spawn( g_props2, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_grass_ball.xml",
			})
		end,
	},
	-- random furniture
	{
		id = "FURNISHED",
		ui_description="$biomemodifierdesc_furnished",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/furnished.png",
		probability=0.5,
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			local function add_prop(name, mult)
				mult = mult or 0.2
				inject_spawn( g_props, mult, {
					prob   		= 0,
					min_count	= 1,
					max_count	= 1,
					offset_y 	= 0,    
					entity 	=  "data/entities/props/"..name..".xml",
				})
				inject_spawn( g_props2, mult, {
					prob   		= 0,
					min_count	= 1,
					max_count	= 1,
					offset_y 	= 0,    
					entity 	=  "data/entities/props/"..name..".xml",
				})
			end
			add_prop("furniture_bed")
			add_prop("furniture_wood_chair", 0.3)
			add_prop("furniture_dresser")
			add_prop("furniture_rocking_chair", 0.2)
			add_prop("furniture_wood_table")
			add_prop("furniture_wardrobe", 0.1)
			
			add_prop("furniture_castle_chair", 0.2)
			add_prop("furniture_castle_divan", 0.1)
			add_prop("furniture_castle_statue", 0.1)
			add_prop("furniture_castle_table", 0.1)
			add_prop("furniture_castle_wardrobe", 0.1)

			add_prop("furniture_locker", 0.1)
			add_prop("furniture_footlocker", 0.1)
			add_prop("furniture_bunk", 0.1)
			add_prop("furniture_cryopod", 0.1)
			add_prop("furniture_table", 0.1)
			add_prop("furniture_stool", 0.2)

			inject_spawn( g_lamp, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/lasergun_spawner.xml",
			})
			inject_spawn( g_lamp, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_lantern.xml",
			})
			-- mimic
			inject_spawn( g_big_enemies, 0.05, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/chest_mimic.xml",
			})
			inject_spawn( g_big_enemies, 0.05, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/dark_alchemist.xml",
			})
			inject_spawn( g_big_enemies, 0.05, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/illusions/shaman_wind.xml",
			})
		end,
	},
	-- mines
	{
		id = "BOOBY_TRAPPED",
		ui_description="$biomemodifierdesc_booby_trapped",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/booby_trapped.png",
		probability=0.6,
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_lamp, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/lasergun_spawner.xml",
			})
			inject_spawn( g_lamp, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_lantern.xml",
			})
			inject_spawn( g_props, 0.75, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/projectiles/mine.xml",
			})
			inject_spawn( g_props2, 0.75, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/projectiles/mine.xml",
			})
			inject_spawn( g_small_enemies, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/projectiles/mine.xml",
			})
		end,
	},
	-- tunnels and worms
	{
		id = "PERFORATED",
		ui_description="$biomemodifierdesc_perforated",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/perforated.png",
		probability=0.5,
		does_not_apply_to_biome={"vault","vault_frozen","crypt","snowcave"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_01.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_02.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_02.xml",
			})
			inject_spawn( g_lamp, 0.9, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_01.xml",
			})
			inject_spawn( g_lamp, 0.9, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_02.xml",
			})
			inject_spawn( g_lamp, 0.9, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_02.xml",
			})
			inject_spawn( g_small_enemies, 0.15, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm_tiny.xml",
			})
			inject_spawn( g_big_enemies, 0.15, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm.xml",
			})
			inject_spawn( g_big_enemies, 0.075, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm_big.xml",
			})
		end,
	},
	-- ghosts and tombstones
	{
		id = "SPOOKY",
		ui_description="$biomemodifierdesc_spooky",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/spooky.png",
		probability=0.4,
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_props, 1.0, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 2,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/tiny_ghost_spawner.xml",
			})
			inject_spawn( g_props2, 1.0, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 2,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/tiny_ghost_spawner.xml",
			})
			inject_spawn( g_lamp, 0.25, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 2,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/tiny_ghost_spawner.xml",
			})
			inject_spawn( g_props, 0.75, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/furniture_tombstone_01.xml",
			})
			inject_spawn( g_props, 0.75, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/furniture_tombstone_02.xml",
			})
			inject_spawn( g_props, 0.75, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/furniture_tombstone_03.xml",
			})
			inject_spawn( g_props, 0.75, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/banner.xml",
			})
			inject_spawn( g_small_enemies, 0.05, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/confusespirit.xml",
			})
			inject_spawn( g_small_enemies, 0.05, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/berserkspirit.xml",
			})
			inject_spawn( g_small_enemies, 0.01, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/weakspirit.xml",
				ngpluslevel = 1,
			})
			inject_spawn( g_small_enemies, 0.05, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/slimespirit.xml",
			})
		end,
	},
	-- gravity/repulsion fields
	{
		id = "GRAVITY_FIELDS",
		ui_description="$biomemodifierdesc_gravity_fields",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/gravity_fields.png",
		probability=0.3,
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )
			--BiomeObjectSetValue( biome_filename, "modifiers", "projectile_drag_coeff", 1.1 )
		end,
		inject_spawns_action = function()
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field.xml",
			})
			inject_spawn( g_lamp, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field.xml",
			})

			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field_reverse.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field_reverse.xml",
			})
			inject_spawn( g_lamp, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field_reverse.xml",
			})
		end,
	},
	-- fungus props
	{
		id = "FUNGAL",
		ui_description="$biomemodifierdesc_fungal",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/fungal.png",
		probability=0.5,
		does_not_apply_to_biome={"fungiforest","fungicave"},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.6 )
			BiomeSetValue( biome_filename, "color_grading_r", 0.90 )
			BiomeSetValue( biome_filename, "color_grading_g", 1.10 )
			BiomeSetValue( biome_filename, "color_grading_b", 0.95 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.12 )
		end,
		inject_spawns_action = function()
			local physics_fungus_mult = 0.9
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus.xml",
			})
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_big.xml",
			})
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_small.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_big.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_small.xml",
			})
			-- enemies
			inject_spawn( g_small_enemies, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 5,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/fungus.xml",
			})
			inject_spawn( g_small_enemies, 0.2, {
				prob   		= 0,
				min_count	= 2,
				max_count	= 5,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/blob.xml",
			})
			inject_spawn( g_big_enemies, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 4,
				offset_y 	= 0,    
				entity 	= "data/entities/animals/fungus_big.xml",
			})
		end,
	},
	{
		id = "OVER_FUNGAL",
		ui_description="$biomemodifierdesc_OVER_FUNGAL",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/fungal.png",
		probability=0.2,
		does_not_apply_to_biome={"fungicave","fungiforest"},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.6 )
			BiomeSetValue( biome_filename, "color_grading_r", 0.60 )
			BiomeSetValue( biome_filename, "color_grading_g", 1.50 )
			BiomeSetValue( biome_filename, "color_grading_b", 0.7 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.18 )
		end,
		inject_spawns_action = function()
			local physics_fungus_mult = 0.97
			inject_spawn( g_lamp, 1.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/fungal_pipe_spawner.xml",
			})
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 2,
				max_count	= 4,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus.xml",
			})
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 3,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_big.xml",
			})
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 2,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_hugeish.xml",
			})
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 2,
				max_count	= 4,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_acid.xml",
			})
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 3,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_acid_big.xml",
			})
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_acid_hugeish.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 2,
				max_count	= 4,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 3,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_big.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 2,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_hugeish.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 2,
				max_count	= 4,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_acid.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 3,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_acid_big.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_acid_hugeish.xml",
			})
			-- enemies
			inject_spawn( g_small_enemies, 0.15, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 5,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/fungus.xml",
			})
			inject_spawn( g_big_enemies, 0.75, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 4,
				offset_y 	= 0,    
				entity 	= "data/entities/animals/fungus_big.xml",
			})
		end,
	},
	-- leaky pipes and water material blobs
	{
		id = "FLOODED",
		ui_description="$biomemodifierdesc_flooded",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/moist.png",
		probability=0.7,
		does_not_apply_to_biome={"robobase","vault"},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.3 )
			BiomeSetValue( biome_filename, "color_grading_r", 0.90 )
			BiomeSetValue( biome_filename, "color_grading_g", 0.95 )
			BiomeSetValue( biome_filename, "color_grading_b", 1.05 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.12 )
		end,
		inject_spawns_action = function()
			-- leaky pipes
			inject_spawn( g_lamp, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/drain_pipe_spawner.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/drain_pipe_spawner.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/drain_pipe_spawner.xml",
			})
			inject_spawn( g_props, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/polar_pipe_spawner.xml",
			})
			inject_spawn( g_props2, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/polar_pipe_spawner.xml",
			})
			-- materials
			inject_spawn( g_lamp, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_water_ball.xml",
			})
			inject_spawn( g_small_enemies, 0.4, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/shaman.xml",
			})
		end,
	},
	-- acid gas pipes
	{
		id = "GAS_FLOODED",
		ui_description="$biomemodifierdesc_gas_glooded",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/gas.png",
		probability=0.5,
		does_not_apply_to_biome={"mountain_hall","vault"},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.5 )
			BiomeSetValue( biome_filename, "color_grading_r", 0.9 )
			BiomeSetValue( biome_filename, "color_grading_g", 1.05 )
			BiomeSetValue( biome_filename, "color_grading_b", 0.9 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.1 )
		end,
		inject_spawns_action = function()
			-- leaky pipes
			inject_spawn( g_lamp, 0.6, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/gas_pipe_spawner.xml",
			})
			inject_spawn( g_lamp, 0.6, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/fart_pipe_spawner.xml",
			})
			inject_spawn( g_lamp, 0.6, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/sewer_pipe_spawner.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/gas_pipe_spawner_floor.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/gas_pipe_spawner_floor.xml",
			})
			-- enemies
			inject_spawn( g_small_enemies, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/acidshooter.xml",
			})
			inject_spawn( g_big_enemies, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/giantshooter.xml",
			})
		end,
	},
	-- energy shields and forcefield generators
	{
		id = "SHIELDED",
		ui_description="$biomemodifierdesc_shielded",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/shielded.png",
		probability=0.1,
		does_not_apply_to_biome={"mountain_hall","excavationsite","snowcastle"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/energy_shield_sector_spawner.xml",
			})
			inject_spawn( g_props2, 0.55, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/energy_shield_sector_spawner.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/forcefield_generator.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/forcefield_generator.xml",
			})
			inject_spawn( g_small_enemies, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 3,
				offset_y 	= 0,    
				entity 	=  "data/entities/misc/homunculus.xml",
			})
			inject_spawn( g_big_enemies, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 3,
				offset_y 	= 0,    
				entity 	=  "data/entities/misc/homunculus.xml",
			})
		end,
	},
	-- Creates fields that grant temporary invulnerability to enemies
	{
		id = "PROTECTION_FIELDS",
		ui_description="$biomemodifierdesc_sunlight",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/sunlight.png",
		probability = 0.2,
		-- requires_flag = "moon_is_sun",
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )
			--BiomeObjectSetValue( biome_filename, "modifiers", "projectile_drag_coeff", 1.1 )
		end,
		inject_spawns_action = function()
			inject_spawn( g_props, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/protection_field.xml",
			})
			inject_spawn( g_props2, 0.7, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/protection_field.xml",
			})
			inject_spawn( g_lamp, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/protection_field.xml",
			})
		end,
	},
	{
		id = "OMINOUS",
		ui_description="$biomemodifierdesc_sundark",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/ominous.png",
		probability = 0.3,
		-- requires_flag = "darkmoon_is_darksun",
		does_not_apply_to_biome={"mountain_hall","coalmine","excavationsite"},
		action = function( biome_name, biome_filename )
			--BiomeObjectSetValue( biome_filename, "modifiers", "projectile_drag_coeff", 1.1 )
		end,
		inject_spawns_action = function()
			inject_spawn( g_props, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/ominous_orb.xml",
			})
			inject_spawn( g_props2, 0.4, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/ominous_orb.xml",
			})
			inject_spawn( g_lamp, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/ominous_orb.xml",
			})
		end,
	},
	{
		id = "INVISIBILITY",
		ui_description="$biomemodifierdesc_invisibility",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/invisible.png",
		probability=0.1,
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_small_enemies, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/invisibility_machine.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/invisibility_machine.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/invisibility_machine.xml",
			})
		end,
	},
	{
		id = "WORMY",
		ui_description="$biomemodifierdesc_wormy",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/wormy.png",
		probability=0.03,
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_small_enemies, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 2,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm_tiny.xml",
			})
			inject_spawn( g_small_enemies, 0.08, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm.xml",
			})
			inject_spawn( g_big_enemies, 0.08, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm_big.xml",
			})
		end,
	},
	{
		id = "HOLY_MOUNT_HYPERGRAVITY",
		ui_description="$dholy_mount_biome_modifiers",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/low_gravity.png",
		probability=0.0,
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "entity_gravity_y_multiplier", 13.0 )
			BiomeSetValue( biome_filename, "color_grading_r", 1.00 )
			BiomeSetValue( biome_filename, "color_grading_g", 1.00 )
			BiomeSetValue( biome_filename, "color_grading_b", 1.00 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.0 )
		end,
	},
	{
		id = "HOLY_MOUNT_ZERO_GRAVITY",
		ui_description="$dholy_mount_biome_modifiers",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/low_gravity.png",
		probability=0.0,
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "entity_gravity_y_multiplier", 0.005 )
			BiomeSetValue( biome_filename, "color_grading_r", 1.00 )
			BiomeSetValue( biome_filename, "color_grading_g", 1.00 )
			BiomeSetValue( biome_filename, "color_grading_b", 1.00 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.0 )
		end,
	},
	--[[-- dry - fire spreads faster than usually, fire demons spawn
	-- bouncy - projectiles and physics bodies bounce from surfaces
	-- corrupted - corruption grows everywhere. corruption = some sort of easily destructible static material
	-- toxic - pools of toxic sludge, toxic rock everywhere
	-- vulcanous - lava, lava rock everywhere
	-- haunted - ghost crystals spawn
	-- rat infested - rats spawn everywhere
	-- worm infested - more worm spawn than usually
	-- alchemic - humanoid enemies drop random potions on death
	-- peaceful - enemies don't attack unless projectile spells are used
	-- portal upwards - a box can be found that spawns a portal when kicked
	-- portal downwards - a box can be found that spawns a portal when kicked
	-- more based on various perks?
	]]--
}
