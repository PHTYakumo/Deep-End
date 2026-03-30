dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

-- fix "most" of the errors in the repetitive parts above and below the world ( the_sky & the_end )

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff808000, "spawn_statues" )
RegisterSpawnFunction( 0xff00AC64, "load_pixel_scene4" )
RegisterSpawnFunction( 0xffC8C800, "spawn_lamp2" )
RegisterSpawnFunction( 0xff400080, "spawn_large_enemies" )
RegisterSpawnFunction( 0xffC8001A, "spawn_ghost_crystal" )
RegisterSpawnFunction( 0xff82FF5A, "spawn_crawlers" )
RegisterSpawnFunction( 0xff647D7D, "spawn_pressureplates" )
RegisterSpawnFunction( 0xff649B7D, "spawn_doors" )
RegisterSpawnFunction( 0xffA07864, "spawn_scavengers" )
RegisterSpawnFunction( 0xff00AC33, "load_pixel_scene3" )
RegisterSpawnFunction( 0xffFFCD2A, "spawn_scorpions" )
RegisterSpawnFunction( 0xff905ecb, "spawn_reward_wands" )
RegisterSpawnFunction( 0xff905ecc, "spawn_boss_limbs_trigger" )

RegisterSpawnFunction( 0xff0000ff, "spawn_nest" )
RegisterSpawnFunction( 0xffB40000, "spawn_fungi" )
RegisterSpawnFunction( 0xff969678, "load_structures" )
RegisterSpawnFunction( 0xff967878, "load_large_structures" )
RegisterSpawnFunction( 0xff967896, "load_i_structures" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )
RegisterSpawnFunction( 0xffC35700, "load_oiltank" )
RegisterSpawnFunction( 0xff55AF4B, "load_altar" )
RegisterSpawnFunction( 0xff23B9C3, "spawn_altar_torch" )
RegisterSpawnFunction( 0xff55AF8C, "spawn_skulls" )
RegisterSpawnFunction( 0xff55FF8C, "spawn_chest" )
RegisterSpawnFunction( 0xff4e175e, "load_oiltank_alt" )
RegisterSpawnFunction( 0xff50fafa, "spawn_trapwand" )
RegisterSpawnFunction( 0xfff12ab5, "spawn_bbqbox" )
RegisterSpawnFunction( 0xff005cfd, "spawn_swing_puzzle_box" )
RegisterSpawnFunction( 0xff00b5fc, "spawn_swing_puzzle_target" )
RegisterSpawnFunction( 0xff93ca00, "spawn_oiltank_puzzle" )
RegisterSpawnFunction( 0xffb97300, "spawn_receptacle_oil" )


RegisterSpawnFunction( 0xffFF50FF, "spawn_hanger" )
RegisterSpawnFunction( 0xff00ac6e, "load_pixel_scene4_alt" )
RegisterSpawnFunction( 0xff0050FF, "spawn_wheel" )
RegisterSpawnFunction( 0xff0150FF, "spawn_wheel_small" )
RegisterSpawnFunction( 0xff0250FF, "spawn_wheel_tiny" )
RegisterSpawnFunction( 0xff2d2eac, "spawn_rock" )
RegisterSpawnFunction( 0xff0A50FF, "spawn_physicsstructure" )
RegisterSpawnFunction( 0xffc999ff, "spawn_hanging_prop" )
RegisterSpawnFunction( 0xff7868ff, "load_puzzleroom" )
RegisterSpawnFunction( 0xff70d79e, "load_gunpowderpool_01" )
RegisterSpawnFunction( 0xff70d79f, "load_gunpowderpool_02" )
RegisterSpawnFunction( 0xff70d7a0, "load_gunpowderpool_03" )
RegisterSpawnFunction( 0xff70d7a1, "load_gunpowderpool_04" )
RegisterSpawnFunction( 0xffb09016, "spawn_meditation_cube" )
RegisterSpawnFunction( 0xff00855c, "spawn_receptacle" )


RegisterSpawnFunction( 0xffb1ff99, "spawn_tower_short" )
RegisterSpawnFunction( 0xff5c8550, "spawn_tower_tall" )
RegisterSpawnFunction( 0xff227fff, "spawn_beam_low" )
RegisterSpawnFunction( 0xff8228ff, "spawn_beam_low_flipped" )
RegisterSpawnFunction( 0xff0098ba, "spawn_beam_steep" )
RegisterSpawnFunction( 0xff7600a9, "spawn_beam_steep_flipped" )


RegisterSpawnFunction( 0xff4691c7, "load_puzzle_capsule" )
RegisterSpawnFunction( 0xff3691d7, "load_puzzle_capsule_b" )
RegisterSpawnFunction( 0xffF516E3, "spawn_scavenger_party" )
RegisterSpawnFunction( 0xffFFC84E, "spawn_acid" )
RegisterSpawnFunction( 0xff7285c4, "load_acidtank_right" )
RegisterSpawnFunction( 0xff9472c4, "load_acidtank_left" )
RegisterSpawnFunction( 0xff504600, "spawn_stones" )
RegisterSpawnFunction( 0xffc800ff, "load_pixel_scene_alt" )
RegisterSpawnFunction( 0xff434040, "spawn_burning_barrel" )
RegisterSpawnFunction( 0xffb4a00a, "spawn_fish" )
RegisterSpawnFunction( 0xffaa42ff, "spawn_electricity_trap" )
RegisterSpawnFunction( 0xff366178, "spawn_buried_eye_teleporter" )
RegisterSpawnFunction( 0xff876543, "spawn_statue_hand" )


RegisterSpawnFunction( 0xffc78f20, "spawn_barricade" )
RegisterSpawnFunction( 0xffc022f5, "spawn_forcefield_generator" )
RegisterSpawnFunction( 0xffa3d900, "spawn_brimstone" )
RegisterSpawnFunction( 0xff00d982, "spawn_vasta_or_vihta" )
RegisterSpawnFunction( 0xff932020, "spawn_cook" )

RegisterSpawnFunction( 0xff614630, "load_panel_01" )
RegisterSpawnFunction( 0xff614635, "load_panel_02" )
RegisterSpawnFunction( 0xff61463e, "load_panel_03" )
RegisterSpawnFunction( 0xff614638, "load_panel_04" )
RegisterSpawnFunction( 0xff614646, "load_panel_07" )
RegisterSpawnFunction( 0xff614650, "load_panel_08" )
RegisterSpawnFunction( 0xff614658, "load_panel_09" )

RegisterSpawnFunction( 0xffc133ff, "load_chamfer_top_r" )
RegisterSpawnFunction( 0xff8b33ff, "load_chamfer_top_l" )
RegisterSpawnFunction( 0xff8824b3, "load_chamfer_bottom_r" )
RegisterSpawnFunction( 0xff5f23ad, "load_chamfer_bottom_l" )
RegisterSpawnFunction( 0xff73ffa7, "load_chamfer_inner_top_r" )
RegisterSpawnFunction( 0xffd5ff7f, "load_chamfer_inner_top_l" )
RegisterSpawnFunction( 0xff387d51, "load_chamfer_inner_bottom_r" )
RegisterSpawnFunction( 0xff97b55b, "load_chamfer_inner_bottom_l" )

RegisterSpawnFunction( 0xff44609c, "load_pillar_filler" )
RegisterSpawnFunction( 0xff44449c, "load_pillar_filler_tall" )
RegisterSpawnFunction( 0xff01a1fa, "spawn_turret" )
RegisterSpawnFunction( 0xffb03058, "load_pod_large" )
RegisterSpawnFunction( 0xffb05830, "load_pod_small_l" )
RegisterSpawnFunction( 0xffb09030, "load_pod_small_r" )
RegisterSpawnFunction( 0xffffa659, "load_furniture" )
RegisterSpawnFunction( 0xfffec390, "load_furniture_bunk" )
RegisterSpawnFunction( 0xff4c63e0, "spawn_root_grower" )
RegisterSpawnFunction( 0xff4cacab, "spawn_forge_check" )
RegisterSpawnFunction( 0xff2a78ff, "spawn_drill_laser" )

RegisterSpawnFunction( 0xff806326, "spawn_tree" )

-- RegisterSpawnFunction( 0xff967878, "spawn_lasergun" )

RegisterSpawnFunction( 0xff692e94, "load_pixel_scene_wide" )
RegisterSpawnFunction( 0xff822e5b, "load_pixel_scene_tall" )
-- RegisterSpawnFunction( 0xff00AC64, "load_warning_strip" )
RegisterSpawnFunction( 0xff504B64, "spawn_machines" )
RegisterSpawnFunction( 0xffBE8246, "spawn_pipes_hor" )
RegisterSpawnFunction( 0xffBE8264, "spawn_pipes_turn_right" )
RegisterSpawnFunction( 0xffBE8282, "spawn_pipes_turn_left" )
RegisterSpawnFunction( 0xffBE82A0, "spawn_pipes_ver" )
RegisterSpawnFunction( 0xffBE82BE, "spawn_pipes_cross" )
RegisterSpawnFunction( 0xff2E8246, "spawn_pipes_big_hor" )
RegisterSpawnFunction( 0xff2E8264, "spawn_pipes_big_turn_right" )
RegisterSpawnFunction( 0xff2E8282, "spawn_pipes_big_turn_left" )
RegisterSpawnFunction( 0xff2E82A0, "spawn_pipes_big_ver" )
RegisterSpawnFunction( 0xff5c73da, "spawn_stains" )
RegisterSpawnFunction( 0xff5c73db, "spawn_stains_ceiling" )
RegisterSpawnFunction( 0xff4a107d, "load_pillar" )
RegisterSpawnFunction( 0xff7b59ab, "load_pillar_base" )
RegisterSpawnFunction( 0xff40ffce, "load_catwalk" )
RegisterSpawnFunction( 0xffbf4c86, "spawn_apparatus" )

RegisterSpawnFunction( 0xffacf14b, "spawn_laser_trap" )
RegisterSpawnFunction( 0xffa45aff, "spawn_lab_puzzle" )

RegisterSpawnFunction( 0xff400000, "spawn_robots" )
RegisterSpawnFunction( 0xff30b3b0, "spawn_physics_fungus" )

RegisterSpawnFunction( 0xff30b3f0, "spawn_physics_acid_fungus" )
RegisterSpawnFunction( 0xff6a8d79, "spawn_fungitrap" )

RegisterSpawnFunction( 0xff2D1E5A, "spawn_bones" )
RegisterSpawnFunction( 0xff782060, "load_beam" )
RegisterSpawnFunction( 0xff783060, "load_background_scene" )
RegisterSpawnFunction( 0xff378ec4, "load_small_background_scene" )
RegisterSpawnFunction( 0xff786460, "load_cavein" )
RegisterSpawnFunction( 0xff535988, "spawn_statue_back" )

RegisterSpawnFunction( 0xff805000, "spawn_cloud_trap" )
RegisterSpawnFunction( 0xff397780, "load_floor_rubble" )
RegisterSpawnFunction( 0xff00ffa0, "load_floor_rubble_l" )
RegisterSpawnFunction( 0xff1ca7ff, "load_floor_rubble_r" )

RegisterSpawnFunction( 0xff39a760, "spawn_lasergate_ver" )

RegisterSpawnFunction( 0xff30D14E, "spawn_secret_checker" )
RegisterSpawnFunction( 0xff616602, "spawn_huussi_checker" )

RegisterSpawnFunction( 0xff4c63e1, "spawn_cyst" )
RegisterSpawnFunction( 0xffd97f7f, "spawn_mouth" )

-- actual functions that get called from the wang generator

function safe( x, y )
	return true
end

function spawn_statues(x, y)
end

function spawn_chest(x, y)
end

function spawn_save(x, y)
end

function spawn_stash(x,y)
end

function spawn_lamp(x, y)
end

function spawn_lamp2(x, y)
end

function spawn_props(x, y)
end

function spawn_ghost_crystal(x, y)
end

function spawn_crawlers(x, y)
end

function spawn_pressureplates(x, y)
end

function spawn_doors(x, y)
end

function spawn_scavengers(x, y)
end

function spawn_scorpions(x, y)
end

function init( x, y, w, h )
	-- print( "init called: " .. x .. ", " .. y )
end

function spawn_reward_wands( x, y )
end

function spawn_boss_limbs_trigger( x, y )
end

function spawn_lamp(x, y)
end

function spawn_ghostlamp(x, y)
end

function spawn_props(x, y)
end

function spawn_props2(x, y)
end

function spawn_props3(x, y)
end

function spawn_fungi(x, y)
end

function load_oiltank( x, y )
end

function load_oiltank_alt( x, y )
end

function load_structures( x, y )
end

function load_large_structures( x, y )
end

function load_i_structures( x, y )
end

function spawn_stash(x,y)
end

function spawn_nest(x, y)
end

function spawn_vines(x, y)
end

function spawn_altar_torch(x, y)
	EntityLoad( "data/entities/props/altar_torch.xml", x-7, y-38 )
end

function spawn_trapwand(x, y)
end

function spawn_bbqbox( x, y )
end

function spawn_swing_puzzle_box( x, y )
	EntityLoad( "data/entities/props/physics/trap_electricity_suspended.xml", x, y)
end

function spawn_swing_puzzle_target( x, y )
	EntityLoad( "data/entities/buildings/swing_puzzle_target.xml", x, y)
end

function spawn_oiltank_puzzle( x, y )
	EntityLoad( "data/entities/buildings/oiltank_puzzle.xml", x, y)
end

function spawn_receptacle_oil( x, y )
	EntityLoad( "data/entities/buildings/receptacle_oil.xml", x, y )
	EntityLoad( "data/entities/items/pickup/potion_empty.xml", x+72, y-17 )
end

function load_pixel_scene4_alt( x, y )
end

function load_puzzleroom( x, y )
end

function load_gunpowderpool_01( x, y )
end

function load_gunpowderpool_02( x, y )
end

function load_gunpowderpool_03( x, y )
end

function load_gunpowderpool_04( x, y )
end

function spawn_physicsstructure(x, y)
end

function spawn_wheel(x, y)
	EntityLoad( "data/entities/props/physics_wheel.xml", x, y )
end

function spawn_wheel_small(x, y)
	EntityLoad( "data/entities/props/physics_wheel_small.xml", x, y )
end

function spawn_wheel_tiny(x, y)
	EntityLoad( "data/entities/props/physics_wheel_tiny.xml", x, y )
end

function spawn_hanger(x, y)
end

function spawn_rock(x, y)
end

function spawn_hanging_prop(x, y)
end

function spawn_nest(x, y)
end

function spawn_ladder(x, y)
	--spawn(g_ladder,x,y-80,0,0)
end

function spawn_meditation_cube( x, y )
end

function spawn_receptacle( x, y )
	EntityLoad( "data/entities/buildings/receptacle_steam.xml", x, y )
end

function spawn_tower_short(x,y)
	generate_tower(x,y,ProceduralRandomi(x-4,y+3,0,2))
end

function spawn_tower_tall(x,y)
	generate_tower(x,y,ProceduralRandomi(x+7,y-1,2,3))
end

function generate_tower( x, y, height )
end

function spawn_beam_low(x,y)
	LoadBackgroundSprite("data/biome_impl/excavationsite/beam_low.png", x-60, y-35, 60, true )
end

function spawn_beam_low_flipped(x,y)
	LoadBackgroundSprite("data/biome_impl/excavationsite/beam_low_flipped.png", x-60, y-35, 60, true)
end

function spawn_beam_steep(x,y)
	LoadBackgroundSprite("data/biome_impl/excavationsite/beam_steep.png", x-35, y-60, 60, true)
end

function spawn_beam_steep_flipped(x,y)
	LoadBackgroundSprite("data/biome_impl/excavationsite/beam_steep_flipped.png", x-35, y-60, 60, true)
end


function spawn_scavenger_party(x,y)
end

function spawn_props(x, y)
end

function spawn_skulls(x, y)
end

function spawn_stones(x, y)
end

function load_pixel_scene( x, y )
end

function load_pixel_scene_alt( x, y )
end

function load_pixel_scene2( x, y )
end

function load_pixel_scene3( x, y )
end

function load_pixel_scene4( x, y )
end

function load_puzzle_capsule( x, y )
end

function load_puzzle_capsule_b( x, y )
end

function spawn_acid(x, y)
	if safe( x, y ) then
		EntityLoad( "data/entities/props/dripping_acid_gas.xml", x, y )
	end
end

function load_altar( x, y )
	-- LoadPixelScene( "data/biome_impl/altar.png", "data/biome_impl/altar_visual.png", x-92, y-96, "", true )
	-- EntityLoad( "data/entities/buildings/altar.xml", x, y-32 )
end

function load_acidtank_right( x, y )
end

function load_acidtank_left( x, y )
end

function spawn_electricity_trap(x, y)
	EntityLoad("data/entities/props/physics_trap_electricity_enabled.xml", x, y)
end

function spawn_burning_barrel(x, y)
end

function spawn_fish(x, y)
end

function spawn_buried_eye_teleporter(x, y)
	EntityLoad("data/entities/buildings/teleport_snowcave_buried_eye.xml", x, y)
end

function spawn_statue_hand(x, y)
	EntityLoad("data/entities/buildings/statue_hand_1.xml", x, y)
end

function spawn_receptacle( x, y )
	EntityLoad( "data/entities/buildings/receptacle_water.xml", x, y )
end

function spawn_turret(x, y)
end

function spawn_items(x, y)
	local r = ProceduralRandom( x-11.631, y+10.2257 )
	
	if (r > 0.2) then
		LoadPixelScene( "data/biome_impl/wand_altar_vault.png", "data/biome_impl/wand_altar_vault_visual.png", x-5, y-9, "", true )
	end
end

function spawn_lamp(x, y)
end

function spawn_lamp2(x, y)
end

function spawn_props(x, y)
end

function spawn_props2(x, y)
end

function spawn_props3(x, y)
end

function spawn_props4(x, y)
end

function load_paneling(x,y,id)
	LoadPixelScene( "data/biome_impl/snowcastle/paneling_wall.png", "", x, y, "data/biome_impl/snowcastle/paneling_" .. id .. ".png", true, false, {}, 60 )
end

function load_panel_01(x, y)
	load_paneling(x-15,y-30,"01")
end

function load_panel_02(x, y)
	load_paneling(x-10,y-20,"02")
end

function load_panel_03(x, y)
	load_paneling(x-60,y-20,"03")
end

function load_panel_04(x, y)
	load_paneling(x-20,y-20,"04")
end

function load_panel_05(x, y)
	load_paneling(x-60,y-60,"05")
end

function load_panel_06(x, y)
	load_paneling(x-20,y-60,"06")
end

function load_panel_07(x, y)
	load_paneling(x-40,y-40,"07")
end

function load_panel_08(x, y)
	load_paneling(x-40,y-20,"08")
end

function load_panel_09(x, y)
	load_paneling(x-20,y-20,"09")
end

function spawn_potion_altar(x, y)
	local r = ProceduralRandom( x, y )
	
	if (r > 0.65) then
		LoadPixelScene( "data/biome_impl/potion_altar_vault.png", "data/biome_impl/potion_altar_vault_visual.png", x-3, y-9, "", true )
	end
end

function spawn_barricade(x, y)
end

function spawn_forcefield_generator(x, y)
end

function spawn_brimstone(x, y)
	EntityLoad("data/entities/items/pickup/brimstone.xml", x, y)
	EntityLoad("data/entities/buildings/sauna_stove_heat.xml", x, y+10)
end

function spawn_vasta_or_vihta(x, y)
	if x > 190 then
		EntityLoad("data/entities/items/wand_vasta.xml", x, y)
	else
		EntityLoad("data/entities/items/wand_vihta.xml", x, y)
	end
end


-- Chamfer corner pieces. 4 outer corners + 4 inner corners
-- /\ /\
-- \/ \/

function load_chamfer_top_r(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_top_r.png", "", x-10, y, "", true )
end

function load_chamfer_top_l(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_top_l.png", "", x-1, y, "", true )
end

function load_chamfer_bottom_r(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_bottom_r.png", "", x-10, y-20, "", true )
end

function load_chamfer_bottom_l(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_bottom_l.png", "", x-1, y-20, "", true )
end

function load_chamfer_inner_top_r(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_inner_top_r.png", "", x-10, y, "", true )
end

function load_chamfer_inner_top_l(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_inner_top_l.png", "", x, y, "", true )
end

function load_chamfer_inner_bottom_r(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_inner_bottom_r.png", "", x-10, y-20, "", true )
end

function load_chamfer_inner_bottom_l(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_inner_bottom_l.png", "", x, y-20, "", true )
end

function load_pillar_filler(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/pillar_filler_01.png", "", x, y, "", true )
end

function load_pillar_filler_tall(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/pillar_filler_tall_01.png", "", x, y, "", true )
end

function load_pod_large( x, y )
end

function load_pod_small_l( x, y )
end

function load_pod_small_r( x, y )
end

function load_furniture( x, y )
end

function load_bunk_with_surprise( x,y )
	EntityLoad("data/entities/props/furniture_bunk.xml", x, y+5)
	EntityLoad("data/entities/props/physics_propane_tank.xml", x, y)
end

function load_furniture_bunk( x, y )
	if ProceduralRandomf(x,y) < 0.02 then
		load_bunk_with_surprise(x,y)
	else
		EntityLoad("data/entities/props/furniture_bunk.xml", x, y+5)
	end
end

function spawn_root_grower(x, y)
	EntityLoad( "data/entities/props/root_grower.xml", x, y )
end

function spawn_forge_check(x, y)
	EntityLoad( "data/entities/buildings/forge_item_check.xml", x, y )
end

function spawn_drill_laser(x, y)
	EntityLoad( "data/entities/buildings/drill_laser.xml", x, y )
end

function spawn_cook(x, y)
	EntityLoad( "data/entities/animals/miner_chef.xml", x, y )
end

function spawn_tree(x, y)
end

function spawn_lasergun( x, y )
	EntityLoad( "data/entities/buildings/lasergun.xml", x + 5, y + 5 )
end

function spawn_potions(x, y)
	spawn_from_list( "potion_spawnlist_liquidcave", x, y )
end

function load_pixel_scene_wide( x,y )
end

function load_pixel_scene_tall( x,y )
end

function load_warning_strip( x, y )
	LoadBackgroundSprite("data/biome_impl/vault/warningstrip_background.png", x, y-4, 40)
end

function spawn_machines(x, y)
end

function spawn_stains( x, y )
end

function spawn_apparatus(x, y)
end

function spawn_stains_ceiling( x, y )
end

function spawn_potion_altar(x, y)
	local r = ProceduralRandom( x, y )
	
	if (r > 0.65) then
		LoadPixelScene( "data/biome_impl/potion_altar_vault.png", "data/biome_impl/potion_altar_vault_visual.png", x-3, y-10, "", true )
	end
end

function spawn_laser_trap(x, y)
	SetRandomSeed( x, y )
	
	LoadPixelScene( "data/biome_impl/vault/hole.png", "", x, y, "", true )
	
	if ( Random( 1, 3 ) == 2 ) then
		EntityLoad("data/entities/props/physics/trap_laser_toggling.xml", x + 5, y + 5)
	end
end

function spawn_lab_puzzle(x, y)
	SetRandomSeed(x, y)
	local type_a = random_from_array({
		"poly",
		"tele",
		"charm",
		"berserk",
	})
	local type_b = random_from_array({
		"protect",
		"worm",
		"invis",
		"speed",
	})
	EntityLoad("data/entities/buildings/vault_lab_puzzle_" .. type_a .. ".xml", x - 10, y)
	EntityLoad("data/entities/buildings/vault_lab_puzzle_" .. type_b .. ".xml", x + 11, y)
end


-----------------------------------------
-- PIPES
-----------------------------------------

function spawn_pipes_hor( x, y )
end

function spawn_pipes_ver( x, y )
end

function spawn_pipes_turn_right( x, y )
end

function spawn_pipes_turn_left( x, y )
end

function spawn_pipes_cross( x, y )
end

function spawn_pipes_big_hor( x, y )
end

function spawn_pipes_big_ver( x, y )
end

function spawn_pipes_big_turn_right( x, y )
end

function spawn_pipes_big_turn_left( x, y )
end

function load_catwalk( x, y )
end

function load_pillar( x, y )
end

function load_pillar_base( x, y )
end

function spawn_robots(x, y)
end

function spawn_physics_fungus(x, y)
end

function spawn_fungitrap(x, y)
end

function spawn_physics_acid_fungus(x, y)
end

function spawn_bones(x, y)
end

function load_beam( x, y )
end

function load_cavein( x, y )
end

function load_background_scene( x, y )
end

function load_small_background_scene( x, y )
end

function spawn_cloud_trap(x, y)
end

function load_floor_rubble( x, y )
end

function load_floor_rubble_l( x, y )
end

function load_floor_rubble_r( x, y )
end

function spawn_candles( x, y )
end

function spawn_lasergate_ver( x, y )
	EntityLoad( "data/entities/buildings/lasergate_down.xml", x + 5, y + 3 )
end

function spawn_secret_checker( x, y )
end

function spawn_huussi_checker( x, y )
	EntityLoad( "data/entities/buildings/huussi.xml", x, y )
end

function spawn_cyst(x, y)
	if ProceduralRandom(x, y) < 0.3 then return end
	EntityLoad( "data/entities/props/meat_cyst.xml", x+5, y+5 )
end

function spawn_mouth(x, y)
end