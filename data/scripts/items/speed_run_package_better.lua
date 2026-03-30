dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local x, y = EntityGetTransform( entity_who_picked )
	local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )

	local max_hp_old = 0
	local max_hp = 0
	local hp_ratio = 1
	local multiplier = tonumber( GlobalsGetValue( "HEARTS_MORE_EXTRA_HP_MULTIPLIER", "1" ) )

	if not EntityHasTag( entity_item, "item_shop" ) then hp_ratio = 0.5 end

	if damagemodels ~= nil then
		for i,damagemodel in ipairs(damagemodels) do
			hp = ComponentGetValue2( damagemodel, "hp" )
			max_hp = ComponentGetValue2( damagemodel, "max_hp" )
			max_hp_old = max_hp
			max_hp = max_hp + multiplier * 0.8 + 2.4 -- 80,100,120,etc

			local max_hp_cap = ComponentGetValue2( damagemodel, "max_hp_cap" )
			if max_hp_cap > 0 then
				max_hp = math.min( max_hp, max_hp_cap )
			end

			hp = math.min( hp + hp_ratio * max_hp, max_hp )

			ComponentSetValue( damagemodel, "max_hp_old", max_hp_old )
			ComponentSetValue( damagemodel, "max_hp", max_hp )
			ComponentSetValue( damagemodel, "hp", hp )
			ComponentSetValue( damagemodel, "mLastMaxHpChangeFrame", GameGetFrameNum() )
		end
	end

	-- the less effect, the better
	EntityLoad( "data/entities/particles/image_emitters/speed_run_effect.xml", x, y )

	if EntityHasTag( entity_who_picked, "player_unit" ) then
		if EntityHasTag( entity_item, "give_potion" ) then
			EntityLoad( "data/entities/items/pickup/potion_polymorph_protection.xml", x+16, y-2 )
		end

		if not EntityHasTag( entity_item, "item_shop" ) then
			GamePrintImportant( "$log_heart_better", "" )
		end
		
		GameRegenItemActionsInPlayer( entity_who_picked )

		-- remove the item from the game
		EntityKill( entity_item )
	end
end
 