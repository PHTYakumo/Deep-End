dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")

function item_pickup( entity_item, entity_who_picked, name )
	local x,y = EntityGetTransform( entity_item )
	local choose_ones = EntityGetInRadiusWithTag( x, y, 250, "perk_choose_one" )

	for i,choose_one in ipairs(choose_ones) do
		if EntityHasTag( choose_one, "perk" ) and ( choose_one ~= entity_item ) then EntityKill( choose_one ) end
	end
end