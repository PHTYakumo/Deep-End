dofile_once("data/scripts/lib/utilities.lua")

function collision_trigger()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	local hah_amount = math.max( math.floor( ModSettingGet( "DEEP_END.HELL_AND_HELL_AMOUNT" ) + 0.5 ), 1 )
	local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	local eid = entity_id

	for i = 1,hah_amount do
		if ( newgame_n < 0 ) then
			eid = EntityLoad( "data/entities/animals/maggot_tiny/maggot_tiny.xml", pos_x, pos_y )
		else	
			eid = EntityLoad( "data/entities/animals/boss_dragon.xml", pos_x, pos_y )
			
			EntityAddComponent( eid, "LuaComponent", 
			{ 
				script_death = "data/scripts/animals/boss_dragon_death.lua",
				execute_every_n_frame = "-1",
			} )
		end

		EntityAddChild( eid, EntityLoad( "data/entities/misc/effect_protection_all_once_no_ui.xml", pos_x, pos_y ) )
	end

	local player = EntityGetClosestWithTag( pos_x, pos_y, "player_unit")

	if ( player ~= nil ) then EntityAddChild( player, EntityLoad( "data/entities/misc/effect_protection_all_once_no_ui.xml", pos_x, pos_y ) ) end
	
	EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", pos_x, pos_y )
	EntityKill( entity_id )
end