dofile_once( "data/scripts/lib/utilities.lua" )

CHANCE_OF_MODIFIER_PER_BIOME = ModSettingGet( "DEEP_END.BIOME_MODIFIER" ) * 0.1
CHANCE_OF_MODIFIER_COALMINE, CHANCE_OF_MODIFIER_EXCAVATIONSITE = 0, 0
CHANCE_OF_MOIST_FUNGICAVE, CHANCE_OF_MOIST_LAKE = 0, 0

-- NOTE: at the moment the modifiers aren't serialized. it is assumed the modifiers stay static throughout a single run.
-- this script re-applies the modifiers every time the game systems are initialized (through init_biome_modifiers() and biome_modifiers_inject_spawns()).
-- because of that the biomes shouldn't be modified outside those hooks, because the changes would be lost after the game is saved/loaded.

rnd = nil
biomes_with_modifier = {}

biomes = {}
biome_modifiers = {}

biome_modifier_cosmetic_freeze = {}
biome_modifier_fog_of_war_clear_at_player = {}

dofile_once("mods/deep_end/files/biome_modifiers_list.lua")

function table_clear(t)
    for k,_ in pairs(t) do
        t[k] = nil
    end
end

function inject_spawn(list, probability_mult, new_spawn)
	if list == nil then
		return
	end

	local existing_spawn = nil
	local max_prob = 0.0
	for _,it in ipairs(list) do
		max_prob = math.max(max_prob, it.prob)
		if it.entity == new_spawn.entity then
			existing_spawn = it
		end
	end
	max_prob = math.max( max_prob, 0.3 )

	if existing_spawn then
		existing_spawn.prob = max_prob * probability_mult
		existing_spawn.min_count = new_spawn.min_count
		existing_spawn.max_count = new_spawn.max_count
		existing_spawn.offset_y = new_spawn.offset_y
	else
		new_spawn.prob = max_prob * probability_mult
		table.insert(list, new_spawn)
	end
end

function biome_modifiers_inject_spawns( biome_name )
	local mappings = get_modifier_mappings()
	local modifier = mappings[biome_name]
	if modifier ~= nil and modifier.inject_spawns_action ~= nil then
		modifier.inject_spawns_action(biome_name)
	end
end

---

function biome_material_multiply_value( biome_filename, material_name, field_name, multiplier )
	local value = BiomeMaterialGetValue( biome_filename, material_name, field_name )
	if type(value) == "number" then
		BiomeMaterialSetValue( biome_filename, material_name, field_name, value*multiplier )
	end
end

function biome_modifier_applies_to_biome( modifier, biome_name )
	if modifier == nil then
		return false
	end

	local ok = true
	
	if modifier.requires_flag ~= nil then
		if ( HasFlagPersistent( modifier.requires_flag ) == false ) then
			return false
		end
	end

	if modifier.does_not_apply_to_biome ~= nil then
		for _,skip_biome in ipairs(modifier.does_not_apply_to_biome) do
			if skip_biome == biome_name then
				ok = false
				break
			end
		end
	end

	if modifier.apply_only_to_biome ~= nil then
		ok = false
		for _,required_biome in ipairs(modifier.apply_only_to_biome) do
			if required_biome == biome_name then
				ok = true
				break
			end
		end
	end

	return ok
end

function string_starts( str, start )
   return string.sub( str, 1, string.len(start) ) == start
end

function apply_modifier_from_data( biome_name, modifier )
	local biome_filename = biome_name
	if  string_starts( biome_filename, "data/" ) == false then
		biome_filename = "data/biome/" .. biome_name .. ".xml"
	 end

	if rnd == nil then
		rnd = random_create(347893,90734)
	end

	-- ignores?
	local ok = true
	if modifier.does_not_apply_to_biome ~= nil then
		for _,skip_biome in ipairs(modifier.does_not_apply_to_biome) do
			if skip_biome == biome_name then
				ok = false
				break
			end
		end
	end

	if modifier.apply_only_to_biome ~= nil then
		ok = false
		for _,required_biome in ipairs(modifier.apply_only_to_biome) do
			if required_biome == biome_name then
				ok = true
				break
			end
		end
	end
	
	if modifier.requires_flag ~= nil then
		if ( HasFlagPersistent( modifier.requires_flag ) == false ) then
			ok = false
		end
	end

	-- apply
	if ok then
		modifier.action( biome_name, biome_filename )
		BiomeSetValue( biome_filename, "mModifierUIDescription", modifier.ui_description )
		BiomeSetValue( biome_filename, "mModifierUIDecorationFile", modifier.ui_decoration_file or "" )
		table.insert( biomes_with_modifier, biome_name )
	end
end

function apply_modifier( biome_name, modifier_id )
	local biome_filename = "data/biome/" .. biome_name .. ".xml"

	for _,modifier in ipairs(biome_modifiers) do
		if modifier.id == modifier_id then
			apply_modifier_from_data( biome_name, modifier )
			break
		end
	end
end

function get_modifier( modifier_id )
	for _,modifier in ipairs(biome_modifiers) do
		if modifier.id == modifier_id then
			return modifier
		end
	end
	return nil
end

function apply_modifier_if_has_none( biome_name, modifier_id )
	if biomes_with_modifier[biome_name] == nil then
		apply_modifier( biome_name, modifier_id )
	end
end

function has_modifiers(biome_name,ctx)
	if biome_name == "coalmine" and ctx.deaths < 1 and ctx.should_be_fully_deterministic == false then
		return false
	end

	return random_next(ctx.rnd, 0.0, 1.0) <= CHANCE_OF_MODIFIER_PER_BIOME
end


function get_modifier_mappings()
	-- returns a table mapping biome_names to active_modifiers.
	-- this function should be deterministic, and have no side effects.
	local result = {}

	local set_modifier_if_has_none = function( biome_name, modifier_id )
		if result[biome_name] == nil then
			result[biome_name] = get_modifier( modifier_id )
		end
	end

	rnd = random_create(347893,90734)
	local ctx = { }
	ctx.rnd = rnd
	ctx.deaths = tonumber(StatsGlobalGetValue( "death_count" ))
	ctx.should_be_fully_deterministic = GameIsModeFullyDeterministic()

	for _,biome_names in ipairs(biomes) do
		local modifier = nil
		if has_modifiers( biome_names[1], ctx ) then
			modifier = pick_random_from_table_weighted( rnd, biome_modifiers )
		end

		for _,biome_name in ipairs(biome_names) do
			if biome_modifier_applies_to_biome( modifier, biome_name ) then
				result[biome_name] = modifier
			end
		end
	end

	-- DEBUG - apply modifier to all biomes
	for _,biome_names in ipairs(biomes) do
		for _,biome_name in ipairs(biome_names) do
			--result[biome_name] = get_modifier( "GAS_FLOODED" )
		end
	end

	--[[
		apply_modifier_if_has_none( "hills", "FREEZING" )
		apply_modifier_if_has_none( "mountain_left_entrance", "FREEZING" )
		apply_modifier_if_has_none( "mountain_left_stub", "FREEZING" )
		apply_modifier_if_has_none( "mountain_right", "FREEZING" )
		apply_modifier_if_has_none( "mountain_right_stub", "FREEZING" )
		apply_modifier_if_has_none( "mountain_tree", "FREEZING" )
		apply_modifier_if_has_none( "mountain_tree", "FREEZING" )
		apply_modifier_from_data( "mountain_lake", biome_modifier_cosmetic_freeze )

		apply_modifier( "rainforest_dark", "FOG_OF_WAR_REAPPEARS" )
	]]--

	-- force custom fog of war in these biomes
	result["alchemist_secret"] = biome_modifier_fog_of_war_clear_at_player

	-- side biomes
	set_modifier_if_has_none( "mountain_hall", "HOLY_MOUNT_ZERO_GRAVITY" )
	set_modifier_if_has_none( "temple_altar_left", "HOLY_MOUNT_HYPERGRAVITY" )
	
	-- NOTE: Freezing tends to occasionally bug out physics bodies, only put it in overworld biomes
	set_modifier_if_has_none( "winter", "FREEZING" )
	result["winter_caves"] = biome_modifier_cosmetic_freeze

	set_modifier_if_has_none( "sandcave", "HOT" )
	set_modifier_if_has_none( "lavalake", "HOT" )
	set_modifier_if_has_none( "desert", "HOT" )
	set_modifier_if_has_none( "pyramid_entrance", "HOT" )
	set_modifier_if_has_none( "pyramid_top", "HOT" )

	set_modifier_if_has_none( "watercave", "MOIST" )
	set_modifier_if_has_none( "lake_statue", "MOIST" )

	return result
end

function init_biome_modifiers()
	local mappings = get_modifier_mappings()
	
	for biome_name,modifier in pairs(mappings) do
		if modifier ~= nil then
			apply_modifier_from_data( biome_name, modifier )
		end
	end
end

return init_biome_modifiers
