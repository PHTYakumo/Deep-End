dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local x, y = EntityGetTransform( entity_item )

    EntityAddChild( entity_who_picked, EntityLoad( "data/entities/misc/mana_from_spell.xml", x, y ) )
	EntityLoad("data/entities/particles/image_emitters/spell_refresh_effect.xml", x, y-12)

	if EntityHasTag( entity_who_picked, "player_unit" ) then
		GamePrintImportant( "$itemtitle_spell_refresh", "$itemdesc_spell_refresh" )
		GameRegenItemActionsInPlayer( entity_who_picked )
		EntityKill( entity_item )
	end
end
