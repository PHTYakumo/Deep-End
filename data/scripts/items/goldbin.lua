dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")

function damage_received( damage, msg, source )
	if not EntityHasTag( source, "player_unit" ) then return end
	local x, y = EntityGetTransform( source )

	local dmg = math.floor( math.abs(damage)^0.4 + 0.08 )
	local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") ) 

	if dmg >= 1 then
		if math.abs( newgame_n ) > 9999 then
			DEEP_END_do_newgame_any_dimension( -579 )
			-- EntityLoad( "data/entities/items/pickup/goldbin.xml", x, y-256 )
		else
			if newgame_n < 55 then newgame_n = math.min( dmg + newgame_n, 55 )
			else newgame_n = math.min( dmg, 9999 ) + newgame_n end

			DEEP_END_do_newgame_any_dimension( newgame_n )
			EntityLoad( "data/entities/items/pickup/goldbin.xml", x, y-256 )
		end
	end
end