dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/newgame_plus.lua")

-------------------------------------------------------------------------------

function make_random_card( x, y )
	--
end

-------------------------------------------------------------------------------

function drop_random_reward( x, y, entity_id, rand_x, rand_y, set_rnd_  )
	local good_item_dropped = true
	--
	return good_item_dropped
end

function drop_money( entity_item )
	-- 
end

function on_open( entity_item )
	local x, y = EntityGetTransform( entity_item )
	local players = EntityGetInRadiusWithTag( x, y, 66, "player_unit" )

	if players[1] ~= nil then
		do_newgame_plus()
		for i=1,3 do GamePrint("$chest_bad_msg_2") end
	end
end

function item_pickup( entity_item, entity_who_picked, name )
	-- GamePrintImportant( "$log_chest", "", "data/ui_gfx/decorations/peace_temple_break.png" )
	-- GameTriggerMusicCue( "item" )

	--if (remove_entity == false) then
	--	EntityLoad( "data/entities/misc/chest_random_dummy.xml", x, y )
	--end

	on_open( entity_item )
	
	EntityKill( entity_item )
end

function physics_body_modified( is_destroyed )
	-- GamePrint( "A chest was broken open" )
	-- GameTriggerMusicCue( "item" )
	local entity_item = GetUpdatedEntityID()
	
	on_open( entity_item )

	edit_component( entity_item, "ItemComponent", function(comp,vars)
		EntitySetComponentIsEnabled( entity_item, comp, false )
	end)
	
	EntityKill( entity_item )
end