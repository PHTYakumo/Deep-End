dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local x, y = EntityGetTransform( entity_item )
	local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )

	if damagemodels ~= nil then
		for i,damagemodel in ipairs(damagemodels) do
			local max_hp = ComponentGetValue2( damagemodel, "max_hp" )

			ComponentSetValue2( damagemodel, "max_hp_old", max_hp )
			ComponentSetValue2( damagemodel, "hp", max_hp )
			ComponentSetValue2( damagemodel, "mLastMaxHpChangeFrame", GameGetFrameNum() )
		end
	end

	GameRegenItemActionsInPlayer( entity_who_picked )

	local heart = EntityLoad( "data/entities/items/pickup/heart_fullhp_inf.xml", x, y )
	local item_comp = EntityGetFirstComponent( heart, "ItemComponent" )

	if item_comp ~= nil then ComponentSetValue2( item_comp, "next_frame_pickable", GameGetFrameNum() + 15 ) end

	EntityLoad( "data/entities/particles/image_emitters/speed_run_effect.xml", x, y )
	EntityKill( entity_item )
end
 