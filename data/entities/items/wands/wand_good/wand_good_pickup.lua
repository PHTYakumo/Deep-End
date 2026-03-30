dofile( "data/scripts/game_helpers.lua" )
dofile( "data/scripts/lib/utilities.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
	local x,y = EntityGetTransform( entity_item )
	local good_wands = EntityGetWithTag( "wand_good" )
	
	if #good_wands > 0 and y < 512 then for i,entity_id in ipairs(good_wands) do
		if entity_id ~= entity_item and EntityGetComponent( entity_id, "VelocityComponent" ) ~= nil then
			local px,py = EntityGetTransform( entity_id )
			EntityLoad( "data/entities/particles/poof_pink.xml", px, py )
			EntityKill( entity_id )
		end
	end end
	
	if EntityHasTag( entity_item, "wand_good" ) then EntityRemoveTag( entity_item, "wand_good" ) end
	EntityLoad( "data/entities/particles/image_emitters/wand_effect.xml", x, y )
end
