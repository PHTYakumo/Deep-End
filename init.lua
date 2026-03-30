dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")
dofile_once("mods/deep_end/files/lol_translations.lua")

local year, month, day, hour, minute, second = GameGetDateAndTimeLocal()

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< translations >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local translater = "mods/deep_end/translations.csv"
local main = "data/translations/common.csv"
local translations = ModTextFileGetContent( translater )
local main_content = ModTextFileGetContent( main )
ModTextFileSetContent( main, main_content .. translations )

if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then
	translater = "mods/deep_end/files/map/map_text_mania.csv"
else
	local chosen = tonumber(ModSettingGet( "DEEP_END.MAP_TYPE" ))

	if chosen == 0 then translater = "mods/deep_end/files/map/map_text_classic.csv"
	elseif chosen == 1 then translater = "mods/deep_end/files/map/map_text_wasteland.csv"
	elseif chosen == 2 then translater = "mods/deep_end/files/map/map_text_thorny.csv"
	elseif chosen == 3 then translater = "mods/deep_end/files/map/map_text_neddle.csv"
	elseif chosen == 4 then translater = "mods/deep_end/files/map/map_text_doomsday.csv"
	end
end

translations = ModTextFileGetContent( translater )
main_content = ModTextFileGetContent( main )
ModTextFileSetContent( main, main_content .. translations )

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< pixel scenes >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local scenes_base = "data/biome/_pixel_scenes.xml"
local scb = ModTextFileGetContent( scenes_base )
ModTextFileSetContent( scenes_base, scb:gsub( [===[<BackgroundImages>]===], [===[<BackgroundImages> <Image filename="data/biome_impl/hidden/boss_arena.png" x="3425" y="40298" ></Image> <Image filename="data/biome_impl/hidden/boss_arena_under.png" x="2976" y="41340" ></Image> <Image filename="data/biome_impl/hidden/boss_arena_under_right.png" x="4238" y="42703" ></Image>]===], 1 ) )

scenes_base = "data/biome/_pixel_scenes_newgame_plus.xml"
scb = ModTextFileGetContent( scenes_base )
ModTextFileSetContent( scenes_base, scb:gsub( [===[<BackgroundImages>]===], [===[<BackgroundImages> <Image filename="data/biome_impl/hidden/boss_arena.png" x="3425" y="40298" ></Image> <Image filename="data/biome_impl/hidden/boss_arena_under.png" x="2976" y="41340" ></Image> <Image filename="data/biome_impl/hidden/boss_arena_under_right.png" x="4238" y="42703" ></Image>]===], 1 ) )

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< biome scripts >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local biome_base = "data/biome/the_sky.xml" -- have not done yet.
local ibs = ModTextFileGetContent( biome_base )
ModTextFileSetContent( biome_base, ibs:gsub( [===[data/scripts/biomes/the_end.lua]===], [===[data/scripts/biomes/the_sky.lua]===], 1 ) )

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< base card >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local card_base = "data/entities/base_custom_card.xml"
local icb = ModTextFileGetContent( card_base )
ModTextFileSetContent( card_base, icb:gsub( [===[<VelocityComponent]===], [===[<VelocityComponent liquid_drag="0" gravity_y="8"]===], 1 ) )

card_base = "data/entities/misc/custom_cards/action.xml"
icb = ModTextFileGetContent( card_base )
ModTextFileSetContent( card_base, icb:gsub( [===[<VelocityComponent]===], [===[<VelocityComponent liquid_drag="0" gravity_y="8"]===], 1 ) )

card_base = "data/entities/misc/custom_cards/energy_shield.xml"
icb = ModTextFileGetContent( card_base )
ModTextFileSetContent( card_base, icb:gsub( [===[<VelocityComponent]===], [===[<VelocityComponent liquid_drag="0" gravity_y="8"]===], 1 ) )

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< base wand >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local wand_base = "data/entities/base_wand_pickup.xml"
local wdb = ModTextFileGetContent( wand_base )
ModTextFileSetContent( wand_base, wdb:gsub( [===[</LuaComponent>]===], [===[</LuaComponent> <LuaComponent _enabled="1" _tags="enabled_in_world" execute_every_n_frame="1" script_source_file="data/scripts/gun/procedural/wand_spin_by_speed.lua" ></LuaComponent>]===], 1 ) )

wdb = ModTextFileGetContent( wand_base )
ModTextFileSetContent( wand_base, wdb:gsub( [===[area_aabb.max_y="0"]===], [===[area_aabb.max_y="4" count_min="4" always_check_fullness="1"]===], 1 ) )

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< player status >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local player_start = "data/entities/player.xml"
local pls = ModTextFileGetContent( player_start )

if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then
	ModTextFileSetContent( player_start, pls:gsub( [===[<Entity><Base file="data/entities/items/starting_wand_rng.xml" /></Entity>]===], [===[<Entity><Base file="data/entities/items/wand_level_03_better.xml" /></Entity> <Entity><Base file="data/entities/items/wand_level_03_better.xml" /></Entity>]===], 1 ) )
	pls = ModTextFileGetContent( player_start )
	ModTextFileSetContent( player_start, pls:gsub( [===[<Entity><Base file="data/entities/items/starting_bomb_wand_rng.xml" /></Entity>]===], [===[<Entity><Base file="data/entities/items/wand_level_03_better.xml" /></Entity> <Entity><Base file="data/entities/items/wand_level_03_better.xml" /></Entity>]===], 1 ) )
	pls = ModTextFileGetContent( player_start )
	ModTextFileSetContent( player_start, pls:gsub( [===[<Entity><Base file="data/entities/items/pickup/potion_starting.xml" /></Entity>]===], [===[<Entity><Base file="data/entities/items/pickup/potion_water.xml" /></Entity> <Entity><Base file="data/entities/items/pickup/potion_water.xml" /></Entity>]===], 1 ) )
else
	ModTextFileSetContent( player_start, pls:gsub( [===[<Entity><Base file="data/entities/items/pickup/potion_starting.xml" /></Entity>]===], [===[<Entity><Base file="data/entities/items/wands/level_01/wand_007.xml" /></Entity> <Entity><Base file="data/entities/items/wands/level_01/wand_017.xml" /></Entity> <Entity><Base file="data/entities/items/pickup/potion_starting.xml" /></Entity> <Entity><Base file="data/entities/items/pickup/gourd.xml" /></Entity>]===], 1 ) )
end

local player_base = "data/entities/player_base.xml"
local pl = ModTextFileGetContent( player_base )
ModTextFileSetContent( player_base, pl:gsub( [===[full_inventory_slots_x="16"]===], [===[full_inventory_slots_x="18"]===], 1 ) )

pl = ModTextFileGetContent( player_base )
ModTextFileSetContent( player_base, pl:gsub( [===[air_in_lungs_max="7"]===], [===[air_in_lungs_max="10"]===], 1 ) )

pl = ModTextFileGetContent( player_base )
ModTextFileSetContent( player_base, pl:gsub( [===[suck_health="1"]===], [===[suck_health="0"]===], 1 ) )

pl = ModTextFileGetContent( player_base )
ModTextFileSetContent( player_base, pl:gsub( [===[materials_how_much_damage="0.004,0.002,0.0006,0.0008,0.0012,0.0012,0.0012,0.0012,0.0012,0.0012,0.0012,0.0012,0.0012,0.016,-0.002,0.0002,0.0002,0.004,0.0004,0.000012"]===], [===[materials_how_much_damage="0.002,0.0012,0.00024,0.00036,0.0004,0.0004,0.0004,0.0004,0.0004,0.0004,0.0004,0.0004,0.0004,0.002,-0.01,0.06,0.06,0.0016,0.0002,0.000004"]===], 1 ) )

pl = ModTextFileGetContent( player_base )
if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then
	ModTextFileSetContent( player_base, pl:gsub( [===[hp="4"]===], [===[hp="10"]===], 1 ) )
else
	local chosen = tonumber(ModSettingGet( "DEEP_END.MAP_TYPE" ))
	local hp_init = 8

	if chosen == 1 then
        hp_init = 10
    elseif chosen == 2 then
        hp_init = 12
    elseif chosen == 3 then
        hp_init = 16
    elseif chosen == 4 then
        hp_init = 20
    end

	if ModSettingGet( "DEEP_END.ORIGINAL_SPELLS" ) then hp_init = hp_init * 0.8 end
	ModTextFileSetContent( player_base, pl:gsub( [===[hp="4"]===], [===[hp="]===] .. tostring(hp_init) .. [===["]===], 1 ) )
end

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< enemy initialization >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local ex_hp_mult = math.floor( ModSettingGet( "DEEP_END.HELL_AND_HELL_HP" ) + 0.5 )
local hah_amount = math.max( math.floor( ModSettingGet( "DEEP_END.HELL_AND_HELL_AMOUNT" ) + 0.5 ), 1 )
local enemy_list = { "basic", "flying", "robot" }

for i=1,#enemy_list do
	local enemy_base = "data/entities/base_enemy_" .. enemy_list[i] .. ".xml"
	local enm = ModTextFileGetContent( enemy_base )
	local perk_loader = [===[<LuaComponent script_source_file="data/entities/misc/what_is_this/de_enemy_init.lua" execute_every_n_frame="-1" execute_on_added="1" ></LuaComponent>]===] -- ModTextFileGetContent( "data/entities/misc/what_is_this/de_enemy_perk_spawn.xml" )
	ModTextFileSetContent( enemy_base, enm:gsub( [===[</Entity>]===], perk_loader .. [===[</Entity>]===], 1 ) )
end

if ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) then
	for i=1,#enemy_list do
		local enemy_base = "data/entities/base_enemy_" .. enemy_list[i] .. ".xml"
		local enm = ModTextFileGetContent( enemy_base )
		local perk_loader = [===[<LuaComponent script_source_file="data/entities/misc/what_is_this/de_enemy_perk_spawn.lua" execute_every_n_frame="-1" execute_on_added="1" ></LuaComponent>]===] -- ModTextFileGetContent( "data/entities/misc/what_is_this/de_enemy_perk_spawn.xml" )
		ModTextFileSetContent( enemy_base, enm:gsub( [===[</Entity>]===], perk_loader .. [===[</Entity>]===], 1 ) )
	end
end

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< lukkis' heads >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local lukki_list = { "lukki", "lukki_longleg", "lukki_creepy", "lukki_creepy_long", "lukki_tiny" }

for i=1,#lukki_list do
	local lukki_base = "data/entities/animals/lukki/" .. lukki_list[i] .. ".xml"
	local lkb = ModTextFileGetContent( lukki_base )
	ModTextFileSetContent( lukki_base, lkb:gsub( [===[fixed_rotation="1"]===], [===[fixed_rotation="0"]===], 1 ) )
end

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< ghosty enemies >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local ghost_list = { "acidshooter", "enlightened_alchemist", "shaman", "wizard_swapper" }

for i=1,#ghost_list do
	local ghost_base = "data/entities/animals/illusions/" .. ghost_list[i] .. ".xml"
	local gst = ModTextFileGetContent( ghost_base )
	ModTextFileSetContent( ghost_base, gst:gsub( [===[tags="]===], [===[tags="de_ghosty_enemy,]===], 1 ) )

	gst = ModTextFileGetContent( ghost_base )
	ModTextFileSetContent( ghost_base, gst:gsub( [===[lifetime="600"]===], [===[lifetime="360"]===], 1 ) )
end

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< field spells >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local spell_base = "data/entities/projectiles/deck/base_field.xml"
local isb = ModTextFileGetContent( spell_base )
ModTextFileSetContent( spell_base, isb:gsub( [===[<VelocityComponent]===], [===[<VelocityComponent terminal_velocity="128"]===], 1 ) )

spell_base = "data/entities/projectiles/deck/summon_portal.xml"
isb = ModTextFileGetContent( spell_base )
ModTextFileSetContent( spell_base, isb:gsub( [===[name="$projectile_default" ]===], [===[name="$projectile_default" tags="de_summon_portal"]===], 1 ) )

local spell_list = { "shield_field", "freeze_field", "chaos_polymorph_field", "polymorph_field", "berserk_field", "charm_field" }

for i=1,#spell_list do
	spell_base = "data/entities/projectiles/deck/" .. spell_list[i] .. ".xml"
	isb = ModTextFileGetContent( spell_base )
	ModTextFileSetContent( spell_base, isb:gsub( [===[name="$projectile_default" ]===], [===[name="$projectile_default" tags="de_]===] .. spell_list[i] .. [===["]===], 1 ) )
end

if not ( ModSettingGet( "DEEP_END.ORIGINAL_SPELLS" ) ) then
	local prj_base = "data/entities/projectiles/deck/lance_holy.xml"
	local prjb = ModTextFileGetContent( prj_base )
	ModTextFileSetContent( prj_base, prjb:gsub( [===[on_collision_die="1"]===], [===[on_collision_die="0"]===], 1 ) )
end

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< fungal shift >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local fungal_trip = "data/entities/misc/effect_trip_03.xml"
local ift = ModTextFileGetContent( fungal_trip )
ModTextFileSetContent( fungal_trip, ift:gsub( [===[execute_every_n_frame="600"]===], [===[execute_every_n_frame="60"]===], 1 ) )

ift = ModTextFileGetContent( fungal_trip )
ModTextFileSetContent( fungal_trip, ift:gsub( [===[distortion_amount="0.2"]===], [===[distortion_amount="6000000"]===], 1 ) )

ift = ModTextFileGetContent( fungal_trip )
ModTextFileSetContent( fungal_trip, ift:gsub( [===[color_amount="1.5"]===], [===[color_amount="6000000"]===], 1 ) )

ift = ModTextFileGetContent( fungal_trip )
ModTextFileSetContent( fungal_trip, ift:gsub( [===[fractals_amount="1.5"]===], [===[fractals_amount="6000000"]===], 1 ) )

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< sturdy flasks >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local potion_base = "data/entities/items/pickup/potion.xml"
local ipb = ModTextFileGetContent( potion_base )
ModTextFileSetContent( potion_base, ipb:gsub( [===[hp="0.5"]===], [===[hp="11.76"]===], 1 ) )

ipb = ModTextFileGetContent( potion_base )
ModTextFileSetContent( potion_base, ipb:gsub( [===[material="potion_glass_box2d"]===], [===[material="potion_toughened_glass_box2d"]===], 1 ) )

potion_base = "data/entities/items/pickup/jar.xml"
ipb = ModTextFileGetContent( potion_base )
ModTextFileSetContent( potion_base, ipb:gsub( [===[material="potion_glass_box2d"]===], [===[material="potion_toughened_glass_box2d"]===], 1 ) )

ipb = ModTextFileGetContent( potion_base )
ModTextFileSetContent( potion_base, ipb:gsub( [===[></PhysicsImageShapeComponent>]===], [===[></PhysicsImageShapeComponent> <MaterialSuckerComponent material_type="1" randomized_position.min_x="-3" randomized_position.max_x="3" randomized_position.min_y="-4" randomized_position.max_y="6"></MaterialSuckerComponent>]===], 1 ) )

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< auto pick up >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

if ModSettingGet( "DEEP_END.NOT_AUTO_PICK_UP" ) then
	local item_data = "data/entities/items/pickup/heart_fullhp.xml"
	local itemd = ModTextFileGetContent( item_data )
	ModTextFileSetContent( item_data, itemd:gsub( [===[auto_pickup="1"]===], [===[auto_pickup="0"]===], 1 ) )

	item_data = "data/entities/items/pickup/spell_refresh.xml"
	itemd = ModTextFileGetContent( item_data )
	ModTextFileSetContent( item_data, itemd:gsub( [===[auto_pickup="1"]===], [===[auto_pickup="0"]===], 1 ) )
end

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< pickup items >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local pickup_list = { "brimstone", "broken_wand", "poopstone", "waterstone", "moon", "summon_portal_broken", "sun/sunstone", "musicstone" }

local pickup_base = "data/entities/items/pickup/chest_random.xml"
local pkb = ModTextFileGetContent( pickup_base )
ModTextFileSetContent( pickup_base, pkb:gsub( [===[material="wood_prop"]===], [===[material="wood_prop_durable"]===], 1 ) )

pickup_base = "data/entities/items/pickup/sun/sunstone.xml"
pkb = ModTextFileGetContent( pickup_base )
ModTextFileSetContent( pickup_base, pkb:gsub( [===[mortal]===], [===[enemy]===], 1 ) )

pickup_base = "data/entities/items/pickup/beamstone.xml"
pkb = ModTextFileGetContent( pickup_base )
ModTextFileSetContent( pickup_base, pkb:gsub( [===[material="gem_box2d_opal"]===], [===[material="Box2d_Deep_End"]===], 1 ) )

pickup_base = "data/entities/items/pickup/musicstone.xml"
pkb = ModTextFileGetContent( pickup_base )
ModTextFileSetContent( pickup_base, pkb:gsub( [===[material="gem_box2d_turquoise"]===], [===[material="Box2d_Deep_End"]===], 1 ) )

pickup_base = "data/entities/animals/boss_alchemist/key.xml"
pkb = ModTextFileGetContent( pickup_base )
ModTextFileSetContent( pickup_base, pkb:gsub( [===[material="item_box2d_glass"]===], [===[material="Box2d_Deep_End"]===], 1 ) )

pickup_base = "data/entities/buildings/chest_steel.xml"
pkb = ModTextFileGetContent( pickup_base )
ModTextFileSetContent( pickup_base, pkb:gsub( [===[material="steel"]===], [===[material="Box2d_Deep_End"]===], 1 ) )

for i=1,#pickup_list do
	local pi_manager = [===[<LuaComponent _tags="enabled_in_hand" _enabled="0" script_source_file="data/scripts/items/preferred_inventory_manager_quick.lua" execute_every_n_frame="1"></LuaComponent><LuaComponent _tags="enabled_in_inventory" _enabled="0" script_source_file="data/scripts/items/preferred_inventory_manager_full.lua" execute_every_n_frame="6"></LuaComponent>]===]
	pickup_base = "data/entities/items/pickup/" .. pickup_list[i] .. ".xml"

	pkb = ModTextFileGetContent( pickup_base )
	ModTextFileSetContent( pickup_base, pkb:gsub( [===[<PhysicsBodyComponent]===], pi_manager .. [===[<PhysicsBodyComponent]===], 1 ) )

	pkb = ModTextFileGetContent( pickup_base )
	ModTextFileSetContent( pickup_base, pkb:gsub( [===[throw_as_item="1"]===], [===[throw_as_item="0"]===], 1 ) )

	pkb = ModTextFileGetContent( pickup_base )
	ModTextFileSetContent( pickup_base, pkb:gsub( [===[preferred_inventory="QUICK"]===], [===[preferred_inventory="FULL"]===], 1 ) )
end

pickup_base = "data/entities/items/pickup/perk.xml"
pkb = ModTextFileGetContent( pickup_base )
ModTextFileSetContent( pickup_base, pkb:gsub( [===[">]===], [===["> <ItemCostComponent cost="0"></ItemCostComponent>]===], 1 ) )

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< gold nuggets >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local nugget_list = { "10", "50", "200", "1000", "10000", "200000" }

for i=1,#nugget_list do
	local nugget_base = "data/entities/items/pickup/goldnugget_" .. nugget_list[i] .. ".xml"
	local ngb = ModTextFileGetContent( nugget_base )
	ModTextFileSetContent( nugget_base, ngb:gsub( [===[item_name="$item_goldnugget_]===] .. nugget_list[i] .. [===["]===], [===[item_name="$item_goldnugget"]===], 1 ) )
end

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< polymorph table >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

PolymorphTableAddEntity( "data/entities/animals/fox.xml", false, true )
PolymorphTableAddEntity( "data/entities/animals/drone_physics_hell.xml", false, true )
-- PolymorphTableAddEntity( "data/entities/animals/boss_centipede/minion/berserkspirit.xml", true, true )
-- PolymorphTableAddEntity( "data/entities/animals/boss_centipede/minion/confusespirit.xml", true, true )
-- PolymorphTableAddEntity( "data/entities/animals/boss_centipede/minion/slimespirit.xml", true, true )
-- PolymorphTableAddEntity( "data/entities/animals/boss_centipede/minion/weakspirit.xml", true, true )

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< initialization >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

function deep_end_biome( biome_name, hp_scale, attack_speed )
	local biome_filename = "data/biome/" .. biome_name .. ".xml"
	BiomeSetValue( biome_filename, "game_enemy_hp_scale", hp_scale )
	BiomeSetValue( biome_filename, "game_enemy_attack_speed", attack_speed )
end

function OnWorldInitialized() 
	if ModSettingGet( "DEEP_END.EVERYONE_IS_POWERFUL" ) or ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then
		deep_end_biome( "coalmine", 0.5, 1 )
		deep_end_biome( "coalmine_alt", 0.6, 0.9 )
		deep_end_biome( "excavationsite", 0.75, 0.9 )
		deep_end_biome( "snowcastle", 1, 0.8 )
		deep_end_biome( "snowcave", 1, 0.8 )
		deep_end_biome( "rainforest_dark", 1.25, 0.7 )
		deep_end_biome( "snowcave_tunnel", 2, 0.7 )
		deep_end_biome( "liquidcave", 1.5, 0.75 )
		deep_end_biome( "vault", 2.5, 0.5 )
		deep_end_biome( "fungicave", 1.5, 0.7 )
		deep_end_biome( "pyramid", 3, 0.5 )
		deep_end_biome( "wandcave", 1.25, 0.6 )
		deep_end_biome( "rainforest", 2, 0.6 )
		deep_end_biome( "rainforest_open", 2, 0.6 )
		deep_end_biome( "robobase", 1.5, 0.75 )
		deep_end_biome( "crypt", 2.5, 0.5 )
		deep_end_biome( "desert", 3, 0.5 )
		deep_end_biome( "forest", 3, 0.5 )
		deep_end_biome( "winter_caves", 3, 0.4 )
		deep_end_biome( "vault_frozen", 4, 0.4 )
		deep_end_biome( "wizardcave", 4, 0.4 )
		deep_end_biome( "fungiforest", 2, 0.25 )
		deep_end_biome( "sandcave", 5, 0.6 )
		deep_end_biome( "clouds", 6, 0.3 )
		deep_end_biome( "the_end", 7, 0.3 )
		deep_end_biome( "the_sky", 7, 0.3 )
		deep_end_biome( "robot_egg", 10, 0.2 )

		if ModSettingGet( "DEEP_END.MEAT_HEAL" ) then
			deep_end_biome( "meat", 3.5, 1 )
		else
			deep_end_biome( "meat", 1.5, 1 )
		end

		deep_end_biome( "tower/solid_wall_tower", 8, 0.25 )
		for i=1,10 do deep_end_biome( "tower/solid_wall_tower_" .. tostring(i), 8, 0.25 ) end
	end

	if tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") ) == 0 then
		SessionNumbersSetValue( "DESIGN_SCALE_ENEMIES", "1" )

		if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then
			local mania_level = math.floor( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL_FACTOR" ) + 0.5 )

			deep_end_biome( "fungiforest", 5, 2 )

			if ModSettingGet( "DEEP_END.MEAT_HEAL" ) then
				deep_end_biome( "meat", 1, 4 )
			else
				deep_end_biome( "meat", 0.4, 4 )
			end

			if mania_level > 40 then
				SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MIN", tostring(20*ex_hp_mult) )
				SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MAX", tostring(20*ex_hp_mult) )
				SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_ATTACK_SPEED", "0.3" )
			else
				local hp_f = mania_level
				local rage_f = mania_level

				if hp_f <= 4 then hp_f = 0.2 * hp_f
				elseif hp_f <= 25 then hp_f = 0.4 * hp_f - 1
				elseif hp_f <= 25 then hp_f = 0.75 * hp_f - 10 end

				if rage_f > 4 then rage_f = math.ceil( 1000 / rage_f ) * 0.0032 + 0.22
				else rage_f = 1.8 - 0.2 * rage_f end

				SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MIN", tostring(hp_f*ex_hp_mult) )
				SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MAX", tostring(hp_f*ex_hp_mult) )
				SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_ATTACK_SPEED", tostring(rage_f) )
			end
		elseif ModSettingGet( "DEEP_END.EVERYONE_IS_POWERFUL" ) then
			SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MIN", tostring(2*ex_hp_mult) )
			SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MAX", tostring(2*ex_hp_mult) )
			SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_ATTACK_SPEED", "1" )
		else
			SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MIN", tostring(ex_hp_mult) )
			SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MAX", tostring(ex_hp_mult) )
			SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_ATTACK_SPEED", "1" )
		end
	end
end

function OnPlayerSpawned( player_entity ) 
	-- protect your hearing
	GlobalsSetValue( "DEEP_END_SOUND_DARK_SWORD_CURSE_LAST_PLAY_FRAME", "0" )
	GlobalsSetValue( "DEEP_END_SOUND_SNIPER_FIRE_LAST_PLAY_FRAME", "0" )
	GlobalsSetValue( "DEEP_END_SOUND_LIMBS_BOSS_SCREAM_PLAY_FRAME", "0" )

	-- reset the player's gravity
	local gcomp = EntityGetFirstComponent( player_entity, "CharacterPlatformingComponent" )
	if gcomp ~= nil then ComponentSetValue2( gcomp, "pixel_gravity", math.abs(ComponentGetValue2( gcomp, "pixel_gravity" )) )end

	local arm_r = EntityGetAllChildren( player_entity, "player_arm_r" )

	if arm_r ~= nil then
		local tscomps = EntityGetComponent( arm_r[1], "InheritTransformComponent" )

		if tscomps ~= nil then for i,comp in ipairs( tscomps ) do if ComponentGetValue2( comp, "parent_hotspot_tag" ) == "right_arm_root" then
			ComponentSetValue2( comp, "only_position", true )
			break
		end end end
	end

	local px,py,pr,psx,psy = EntityGetTransform( player_entity )
	EntitySetTransform( player_entity, px, py, pr, psx, math.abs(psy) )

	-- single use
	local key = "DEEP_END_MOD_INITIALIZED_ONLY_ONCE"
	local is_initialized = GlobalsGetValue( key ) 

	if is_initialized == "oh yeah" or is_initialized == "yes" then return end
	GlobalsSetValue( key, "oh yeah" )

	-- globals
	local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
	local set_dt = clamp( ModSettingGet( "DEEP_END.TIME" ), 1, 600 ) -- over 600 may disturb play

	ComponentSetValue( comp_worldstate, "time_dt", tostring( set_dt ) ) -- DESIGN_DAY_CYCLE_SPEED
	ComponentSetValue( comp_worldstate, "rain_target_extra", tostring( 0.1 ) )
	ComponentSetValue( comp_worldstate, "fog_target_extra", tostring( 0.1 ) )

	GlobalsSetValue( "STEVARI_DEATHS", "2" )
	GlobalsSetValue( "DEEP_END_REMOVE_FOG_OF_WAR", "f" )
	GlobalsSetValue( "DEEP_END_MAP_SPECIAL_MATERIAL_SPAWN", "null" )

	if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then
		ComponentSetValue2( comp_worldstate, "perk_hp_drop_chance", 20 )

		GlobalsSetValue( "TEMPLE_PERK_COUNT", 1 )
		GlobalsSetValue( "TEMPLE_PERK_REROLL_COUNT", -2 )
		GlobalsSetValue( "TEMPLE_SHOP_ITEM_COUNT", 6 )
	end

	if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) or ex_hp_mult * hah_amount >= 4 or hah_amount > 2 then
		GlobalsSetValue( "DEEP_END_GLOBAL_GORE", "t" )
		EntityAddChild( player_entity, EntityLoad( "data/entities/misc/effect_hoh_global_gore.xml", x, y ) )
	else
		GlobalsSetValue( "DEEP_END_GLOBAL_GORE", "f" )
	end

	-- player's status
	local itemcomp = EntityGetFirstComponent( player_entity, "ItemPickUpperComponent" )
	ComponentSetValue( itemcomp, "drop_items_on_death", "true" )

	local foodcomp = EntityGetFirstComponent( player_entity, "IngestionComponent" )

	if foodcomp ~= nil then
		local size = ComponentGetValue2( foodcomp, "ingestion_size" )
		local capacity = ComponentGetValue2( foodcomp, "ingestion_capacity" )
		
		component_write( foodcomp,
		{
			ingestion_cooldown_delay_frames = 400,
			ingestion_reduce_every_n_frame = 3,
			ingestion_size = math.max( size, capacity * 0.6 ),
		})

		if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then
			EntityAddComponent( player_entity, "LuaComponent", 
			{
				script_source_file = "data/scripts/perks/food_clock.lua",
				execute_every_n_frame = "75",
			} )
		end
	end

	local x, y = EntityGetTransform( player_entity )
	shoot_projectile( player_entity, "data/entities/projectiles/deck/xray.xml", x, y, 0, -100 )

	EntityAddChild( player_entity, EntityLoad( "data/entities/misc/effect_ability_actions_materialized_2.xml", x, y ) )

	-- player's scripts
	EntityAddComponent( player_entity, "LuaComponent", 
	{
		script_damage_about_to_be_received = "data/scripts/perks/no_instant_death.lua",
		execute_every_n_frame = "-1",
	} )

	EntityAddComponent( player_entity, "LuaComponent", 
	{ 
		script_source_file="data/scripts/deep_end_map.lua",
		execute_every_n_frame="1",
	} )

	EntityAddComponent( player_entity, "LuaComponent", 
	{ 
		script_source_file="data/scripts/deep_end_map.lua",
		execute_every_n_frame="1",
	} )

	EntityAddComponent( player_entity, "VariableStorageComponent", 
	{ 
		name="deep_end_map_timer",
		value_int="0",
	} )

	EntityAddComponent( player_entity, "VariableStorageComponent", 
	{ 
		name="gravity_if_tap",
		value_bool="1",
	} )

	EntityAddComponent( player_entity, "LuaComponent", 
	{ 
		-- _tags="deep_end_qol_script",
		script_source_file="data/scripts/deep_end_editor.lua",
		execute_every_n_frame="1",
	} )

	EntityAddComponent( player_entity, "LuaComponent", 
	{ 
		_tags="deep_end_qol_script",
		script_source_file="data/scripts/gun/deep_end_fast_wand_edit.lua",
		execute_every_n_frame="1",
	} )


	-- damage multipliers
	if ModSettingGet( "DEEP_END.EDIT" ) or ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then
		local init_perk = perk_spawn( x, y, "EDIT_WANDS_EVERYWHERE", true )

		perk_pickup(init_perk, player_entity, EntityGetName(init_perk), false, false)

		local damagemodels = EntityGetComponent( player_entity, "DamageModelComponent" )
		if damagemodels ~= nil then
			for i,damagemodel in ipairs(damagemodels) do
				
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

				melee = melee * 1.5
				projectile = projectile * 1.2
				explosion = explosion * 1.2
				electricity = electricity * 1.2
				fire = fire * 1.2
				drill = drill * 1.5
				slice = slice * 1.5
				ice = ice * 1.2
				physics_hit = physics_hit * 0.5
				radioactive = radioactive * 1.2
				poison = poison * 1.5
				curse = curse * 2.0
				-- healing = healing
				
				if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then
					projectile = projectile * 1.25 -- x1.5
					electricity = electricity * 1.2 -- x1.44
					fire = fire * 1.5 -- x1.8
					ice = ice * 1.2 -- x1.44
					radioactive = radioactive * 1.5 -- x1.8
					poison = poison * 1.5 -- x2.25
					curse = curse * 1.25 -- x2.5
				end

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
			end
		end

		-- EntityAddRandomStains( player_entity, CellFactory_GetType("magic_liquid_faster_levitation_and_movement"), 666 )
	else
		EntityAddRandomStains( player_entity, CellFactory_GetType("midas"), 666 )
	end

	if ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) then GlobalsSetValue( "TEMPLE_PERK_REROLL_COUNT", tostring(-1) ) end

	-- festal
	if ModSettingGet( "DEEP_END.FESTIVAL_EVENTS" ) then
		GamePrint( tostring(year) .. "." .. tostring(month) .. "." .. tostring(day) )

		if ( month == 4 ) and ( day == 1 ) then 
			GamePrintImportant( "$taprilfool", "", "data/ui_gfx/decorations/aprilfool.png" )
			EntityAddRandomStains( player_entity, CellFactory_GetType("magic_liquid_polymorph"), 666 ) 

			SetRandomSeed( year, player_entity )

			local bomb_lists = { "giga", "lol", "mini" }
			EntityLoad("data/entities/projectiles/bomb_holy_" .. bomb_lists[math.ceil(Random(1,15)^0.4-0.01)] .. ".xml", 100, -450 )
		elseif ( month == 12 ) and ( day >= 24 ) and ( day <= 26 ) then
			GamePrintImportant( "$txmas_1", "$txmas_2", "data/ui_gfx/decorations/xmas.png" )
			-- EntityAddRandomStains( player_entity, CellFactory_GetType("magic_liquid_hp_regeneration"), 777 ) 
			-- CreateItemActionEntity( "MELODY", x, y-16 )

			local global_genome_relations_modifier = tonumber( ComponentGetValue2( comp_worldstate, "global_genome_relations_modifier" ) )
			ComponentSetValue( comp_worldstate, "global_genome_relations_modifier", tostring( global_genome_relations_modifier  + 20 ) )
		elseif ( month == 10 ) and ( day == 31 ) then
			GamePrintImportant( "$thalloween_1", "$thalloween_2", "data/ui_gfx/decorations/halloween.png" )
			-- EntityAddRandomStains( player_entity, CellFactory_GetType("magic_liquid_hp_regeneration"), 888 ) 
		elseif ( month == 11 ) and ( day == 1 ) then
			GamePrintImportant( "$thallowmas_1", "$thallowmas_2", "data/ui_gfx/decorations/halloween.png" )
			-- EntityAddRandomStains( player_entity, CellFactory_GetType("magic_liquid_protection_all"), 777 ) 
		elseif ( month == 1 and day == 1 ) or ( month == 1 and day >= 21 ) or ( month == 2 and day <= 28 ) then 
			-- It's a little hard to judge if it's Chinese New Year, so I put in all the possible dates!
			if ( month == 1 and day == 1 ) then GamePrintImportant( "$tnewyear_1", "$tnewyear_2", "data/ui_gfx/decorations/newyear.png" )
			else GamePrintImportant( "$tnewyear_0", "$tnewyear_2", "data/ui_gfx/decorations/newyear.png" ) end
			-- EntityAddRandomStains( player_entity, CellFactory_GetType("magic_liquid_protection_all"), 888 ) 

			for i=1,16 do
				SetRandomSeed( x + i, y + player_entity )

				local prj = EntityLoad( "data/entities/projectiles/deck/new_year/ultimate_spark_new_year.xml", x + (-1)^Random( 1, 2 ) * Random( 30, 121 ), y + Random( -90, -31 ) )

				EntityAddComponent( prj, "LifetimeComponent", 
				{ 
					lifetime=tostring( 36 * i ),
				} )
			end

			CreateItemActionEntity( "FIREWORK", 388, -102 )

			local item_id = EntityLoad( "data/entities/items/pickup/bloodmoney_1000.xml", x, y - 108 )
			PhysicsApplyTorque( item_id, 999 )
		end
	end
end

function OnPlayerDied(player_entity)
	local x, y = EntityGetTransform( player_entity )
	SetRandomSeed( x, y )

	GameSetCameraFree(true)
	ComponentSetValue2( EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" ), "open_fog_of_war_everywhere", true )

	if tonumber( StatsGetValue("projectiles_shot") ) <= 0 and tonumber( StatsGetValue("wands_edited" ) ) <= 0 then 
		EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_notinkeringofwands.xml", x+24, y-4 )
		EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_nowands.xml", x-24, y-4 )
	end

	if tonumber( StatsGetValue("damage_taken") ) <= 0 then EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_nohit.xml", x, y-52 ) end

	if EntityHasTag( player_entity, "speed_run_complete_in_deep_end" ) then EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_clock.xml", x, y-27 ) end

	EntityLoad( "data/entities/props/my_tombstone_0" .. tostring(Random( 1, 7 )) .. ".xml", x, y-4 )
	shoot_projectile( player_entity, "data/entities/projectiles/deck/my_soul.xml", x, y, 0, -40 )

	if tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") ) ~= 0 then
		if ModSettingGet( "DEEP_END.NIGHTMARE_END" ) then
			EntityLoad( "data/entities/projectiles/deck/circle_end.xml", x, y )
			EntityLoad( "data/entities/projectiles/deck/circle_end.xml", x+300, y+300 )
			EntityLoad( "data/entities/projectiles/deck/circle_end.xml", x+300, y-300 )
			EntityLoad( "data/entities/projectiles/deck/circle_end.xml", x-300, y+300 )
			EntityLoad( "data/entities/projectiles/deck/circle_end.xml", x-300, y-300 )
		end

		for i=1,9 do for j=1,9 do
			GameCreateSpriteForXFrames( "data/ui_gfx/game_over_menu/Pow.png", x + 60*(i-5) + Random(-25,25), y + 30*(j-5) + Random(-10,10), true, 0, 0, 16 - Random( 0, 8 ), true )
		end end
	else
		GameCreateSpriteForXFrames( "data/ui_gfx/game_over_menu/Pow.png", x, y-4, true, 0, 0, 12, true )
	end

	-- GameRemoveFlagRun( "ending_no_game_over_menu" )
end

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< append files >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

ModMagicNumbersFileAdd( "mods/deep_end/files/magic_numbers.xml" ) 
ModMaterialsFileAdd("mods/deep_end/files/materials.xml")
ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/deep_end/files/perk_list_updated.lua")
ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/deep_end/files/actions.lua" )
ModLuaFileAppend( "data/scripts/gun/gun_extra_modifiers.lua", "mods/deep_end/files/gun_extra_modifiers_updated.lua" )
ModLuaFileAppend( "data/scripts/gun/procedural/gun_procedural.lua", "mods/deep_end/files/gun_procedural_affix.lua" )
ModLuaFileAppend( "data/scripts/items/potion.lua", "mods/deep_end/files/potion_appends.lua" )
ModLuaFileAppend( "data/scripts/items/drop_money.lua", "mods/deep_end/files/drop_money_updated.lua")
ModLuaFileAppend( "data/scripts/status_effects/status_list.lua", "mods/deep_end/files/status_list_appends.lua" )
ModLuaFileAppend( "data/scripts/biomes/temple_altar_top_shared.lua", "mods/deep_end/files/temple_altar_top_shared.lua" )
if hah_amount > 1 then ModLuaFileAppend( "data/scripts/director_helpers.lua", "mods/deep_end/files/director_helpers_appends.lua" ) end

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< other >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

--[[

******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******											******
******							******											******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******
**************************************					******					******
**************************************					******					******
**************************************					******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******
******							******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******

]]--

-- steal from @Shug
local content = ModTextFileGetContent( "data/entities/buildings/workshop.xml" )
ModTextFileSetContent( "data/entities/buildings/workshop.xml", content:gsub( ",workshop_untouched", "" ) )

-- >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< crazy texts >>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<< --

local tmt = ModIsEnabled("noita.fairmod") or ModIsEnabled("evaisa.tmtrainer") -- the translation of perks will crash the game
if ModSettingGet( "DEEP_END.LOL_TRANS" ) or tmt then DEEP_END_LOL_TRANSLATIONS( tmt ) end -- so I have to do something
