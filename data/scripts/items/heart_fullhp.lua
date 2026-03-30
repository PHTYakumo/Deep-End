dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )

	local max_hp = 0
	local max_hp_addition = 0
	local healing = 0
	
	local x, y = EntityGetTransform( entity_item )

	local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
	if( damagemodels ~= nil ) then
		for i,damagemodel in ipairs(damagemodels) do
			max_hp = ComponentGetValue2( damagemodel, "max_hp" ) 
			local max_hp_cap = ComponentGetValue2( damagemodel, "max_hp_cap" ) 
			local hp = ComponentGetValue2( damagemodel, "hp" ) 
			
			max_hp = max_hp + max_hp_addition
			
			if ( max_hp_cap > 0 ) then
				max_hp_cap = math.max( max_hp, max_hp_cap )
			end

			if EntityHasTag( entity_who_picked, "abyss_player" ) then
				healing = -2^31
				hp = math.max( hp , max_hp * 0.8 )

				GamePrintImportant( "$log_heart_fullhp_temple", GameTextGet( "$logdesc_heart_fullhp_temple", tostring(math.floor(-max_hp * 25)), "80%?", "##%^^*!!#^" ) )
			else
				healing = max_hp - hp
				hp = max_hp

				EntityAddChild( entity_who_picked, EntityLoad( "data/entities/misc/effect_regeneration_once.xml" ) )
				EntityAddChild( entity_who_picked, EntityLoad( "data/entities/misc/effect_protection_all_once_no_ui.xml" ) )

				if EntityHasTag( entity_who_picked, "player_unit" ) then
					GamePrintImportant( "$log_heart_fullhp_temple", GameTextGet( "$logdesc_heart_fullhp_temple", tostring(math.floor(max_hp_addition * 25)), tostring(math.floor(max_hp * 25)), tostring(math.floor(healing * 25)) ) )
				
					-- remove the item from the game
					EntityKill( entity_item )
				end
			end
			
			-- if( hp > max_hp ) then hp = max_hp end
			ComponentSetValue( damagemodel, "max_hp_cap", max_hp_cap)
			ComponentSetValue( damagemodel, "max_hp", max_hp)
			ComponentSetValue( damagemodel, "hp", hp)
		end
	end

	EntityLoad("data/entities/particles/image_emitters/heart_fullhp_effect.xml", x, y-12)
	EntityLoad("data/entities/particles/heart_out.xml", x, y-8)
	--GameTriggerMusicEvent( "music/temple/enter", true, x, y )
end
