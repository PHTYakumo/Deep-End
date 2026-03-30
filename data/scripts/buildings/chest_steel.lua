dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")

function on_open( entity_item )
	local x, y = EntityGetTransform( entity_item )
	AddFlagPersistent( "card_unlocked_everything" )

	GameTriggerMusicFadeOutAndDequeueAll( 3.0 )
	GameTriggerMusicEvent( "music/oneshot/dark_03", true, x, y )

	if not GameHasFlagRun( "DEEP_END_OPEN_CHEST_STEEL" ) then
		GamePrintImportant( "$deep_end_open_chest_steel_1", "$deep_end_open_chest_steel_2", "data/ui_gfx/decorations/angered_the_gods.png" )
		GameAddFlagRun( "DEEP_END_OPEN_CHEST_STEEL" )
	end

	local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
	local with_sampo = EntityGetInRadiusWithTag( x, y, 512, "this_is_sampo" )

	if comp_worldstate ~= nil and not ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then
		local ed2_happened = ComponentGetValue2( comp_worldstate, "ENDING_HAPPINESS" )
		local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )

		if newgame_n == -579 or newgame_n == 55 then
			CreateItemActionEntity( "DE_RESET_ALL", x, y )
		elseif newgame_n < 0 then
			CreateItemActionEntity( "SUMMON_WANDGHOST", x, y )
		elseif newgame_n > 0 then
			CreateItemActionEntity( "DE_SUICIDE_KING", x, y )
		elseif #with_sampo > 0 then
			CreateItemActionEntity( "DE_ULTIMATE", x, y )
		else
			EntityLoad( "data/entities/animals/boss_sky/apparition_spawn_fx.xml", x, y-4 )
		end
	end
end

function item_pickup( entity_item, entity_who_picked, name )
	on_open( entity_item )
	
	EntityKill( entity_item )
end

function physics_body_modified( is_destroyed )
	local entity_item = GetUpdatedEntityID()
	
	on_open( entity_item )

	edit_component( entity_item, "ItemComponent", function(comp,vars)
		EntitySetComponentIsEnabled( entity_item, comp, false )
	end)
	
	EntityKill( entity_item )
end