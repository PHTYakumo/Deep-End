dofile_once("data/scripts/lib/utilities.lua")
-- dofile_once("data/scripts/gun/gun_actions.lua")
-- dofile_once("data/scripts/perks/perk_list.lua")

function collision_trigger()
	local entity_id = EntityGetClosestWithTag( 671, -112, "controls_f" )
	local x, y = EntityGetTransform( entity_id )

	local components = EntityGetAllComponents( entity_id )
	for i,comp in ipairs( components ) do EntitySetComponentIsEnabled( entity_id, comp, true ) end
	
	if math.abs(x) > 50000 then return end

	local new_entity_id = EntityLoad( "data/entities/particles/image_emitters/de_welcome.xml", 600, -100 )
	local new_components = EntityGetAllComponents( new_entity_id )

	for i,comp in ipairs( new_components ) do EntitySetComponentIsEnabled( new_entity_id, comp, true ) end

	if ( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then
		GamePrintImportant( "$menu_paused", " ", "data/ui_gfx/decorations/angered_the_gods.png" )
	else
		local chosen, m_tip = tonumber(ModSettingGet( "DEEP_END.MAP_TYPE" )), " "

		if chosen == 0 then m_tip = GameTextGetTranslatedOrNot("$tip_text_classic")
		elseif chosen == 1 then m_tip = GameTextGetTranslatedOrNot("$tip_text_wasteland")
		elseif chosen == 2 then m_tip = GameTextGetTranslatedOrNot("$tip_text_thorny")
		elseif chosen == 3 then m_tip = GameTextGetTranslatedOrNot("$tip_text_neddle")
		elseif chosen == 4 then m_tip = GameTextGetTranslatedOrNot("$tip_text_doomsday")
		end

		GamePrintImportant( "$menu_paused", m_tip, "data/ui_gfx/decorations/peace_temple_break.png" )
		GamePrint("$map_text")
	end

	LoadPixelScene( "data/biome_impl/empty.png", "data/biome_impl/empty.png", 512, -512, "data/biome_impl/mountain/hall_background_append.png", true )

	-- GamePrint(tostring(#actions))
	-- GamePrint(tostring(#perk_list))
end