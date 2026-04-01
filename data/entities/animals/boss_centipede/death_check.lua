dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/perks/perk.lua")

function death()
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform( entity_id )

	local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	local radius = 540

	EntityLoad( "data/entities/props/physics_pata.xml", 2855, 40330)
	EntityLoad( "data/entities/props/physics_pata.xml", 2865, 40310)
	EntityLoad( "data/entities/props/physics_pata.xml", 2875, 40330)

	EntityLoad( "data/entities/animals/boss_centipede/clear_materials_ex.xml", 3546, 40143)

	perk_spawn_with_name( 3546, 40143, "RESPAWN", true )

	if ( newgame_n == 0 ) then
		CreateItemActionEntity( "TELEPORT_PROJECTILE_SHORT", 3393, 40143 )
		CreateItemActionEntity( "SUPER_TELEPORT_CAST", 3414, 40143 )
		CreateItemActionEntity( "ANTIHEAL", 3681, 40143 )
		CreateItemActionEntity( "WHITE_HOLE", 3702, 40143 )

		EntityLoad( "data/entities/buildings/teleport_teleroom.xml", 3546, 40469 )

		-- If you exit the game without loading the corresponding chunks, these entities will not be saved!
		EntityLoad( "data/entities/buildings/mystery_teleport_back.xml", 3835, 12192 )
		EntityLoad( "data/entities/buildings/teleport_ending_victory.xml", 3838, 11950 )
		
		EntityLoad( "data/entities/buildings/teleport_teleroom_extele.xml", 780, -900 )
		EntityLoad( "data/entities/buildings/teleport_teleroom.xml", 9985, -1280 )

		EntityLoad( "data/entities/items/pickup/heart_fullhp_inf.xml", 3835, 12140 )
		EntityLoad( "data/entities/items/pickup/temple_travel_mark.xml", 350, -120 )
		EntityLoad( "data/entities/misc/what_is_this/clues.xml", 145, 145 )

		-- ConvertMaterialEverywhere( CellFactory_GetType( "templebrick_thick_static_noedge" ), CellFactory_GetType( "Rock_Magic_Deep_End" ) )
		ConvertMaterialEverywhere( CellFactory_GetType( "templebrick_static_ruined" ), CellFactory_GetType( "Rock_Magic_Deep_End" ) ) -- making a table is not as intuitive as this?
		ConvertMaterialEverywhere( CellFactory_GetType( "templebrick_static" ), CellFactory_GetType( "Rock_Magic_Deep_End" ) )
		ConvertMaterialEverywhere( CellFactory_GetType( "templebrick_static_soft" ), CellFactory_GetType( "Rock_Magic_Deep_End" ) )
		ConvertMaterialEverywhere( CellFactory_GetType( "templebrick_noedge_static" ), CellFactory_GetType( "Rock_Magic_Deep_End" ) )
		ConvertMaterialEverywhere( CellFactory_GetType( "templebrick_thick_static" ), CellFactory_GetType( "Rock_Magic_Deep_End" ) )
		ConvertMaterialEverywhere( CellFactory_GetType( "templebrick_static_broken" ), CellFactory_GetType( "Rock_Magic_Deep_End" ) )
		ConvertMaterialEverywhere( CellFactory_GetType( "rock_hard" ), CellFactory_GetType( "cheese_static" ) )
		ConvertMaterialEverywhere( CellFactory_GetType( "rock_hard_border" ), CellFactory_GetType( "cheese_static" ) )
		ConvertMaterialEverywhere( CellFactory_GetType( "rock_eroding" ), CellFactory_GetType( "cheese_static" ) )
		ConvertMaterialEverywhere( CellFactory_GetType( "sand_static" ), CellFactory_GetType( "cheese_static" ) )
		ConvertMaterialEverywhere( CellFactory_GetType( "sand_static_bright" ), CellFactory_GetType( "cheese_static" ) )
		ConvertMaterialEverywhere( CellFactory_GetType( "sand_static_red" ), CellFactory_GetType( "cheese_static" ) )

		GamePrintImportant( "$defeat_boss_centipede_1", "$defeat_boss_centipede_2", "data/ui_gfx/decorations/boss_defeat.png" )
	else
		GamePrintImportant( "$defeat_boss_centipede_1", "$defeat_boss_centipede_3", "data/ui_gfx/decorations/boss_defeat.png" )
	end

	local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )

	if comp_worldstate ~= nil and newgame_n == 0 and ( not ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then
		local ed2_happened = ComponentGetValue2( comp_worldstate, "ENDING_HAPPINESS" )
		if ed2_happened then EntityLoad( "data/entities/animals/boss_fish/fish_giga.xml",  3842, 42620 ) end
	end

	local p = EntityGetWithTag( "player_unit" )
	local p2 = EntityGetWithTag( "boss_centipede_minion" )
	local bullet = EntityGetInRadiusWithTag( x, y, radius, "projectile_centipede" )
	local bullet2 = EntityGetInRadiusWithTag( x, y, radius, "projectile_converted" )
	local sun = EntityGetInRadiusWithTag( x, y, radius, "seed_e" )
	local sun2 = EntityGetInRadiusWithTag( x, y, radius, "seed_f" )

	if #p > 0 then for i=1,#p do
		if not EntityHasTag( p[i], "deep_end_map_plus" ) then EntityAddTag( p[i], "deep_end_map_plus" ) end
	end end

	if #p2 > 0 then for i=1,#p2 do
		EntityKill(p2[i])
	end end

	if #bullet > 0 then for i=1,#bullet do
		EntityKill(bullet[i])
	end end

	if #bullet2 > 0 then for i=1,#bullet2 do
		EntityKill(bullet[i])
	end end
	
	if #sun > 0 or #sun2 > 0 then
		print( "SUN DETECTED" )
		GameAddFlagRun( "sun_kill" )
	end
	
	GameAddFlagRun( "miniboss_fish" )
	AddFlagPersistent( "miniboss_fish" )
end