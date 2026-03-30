spawnlists =
{
	potion_spawnlist =
	{
		rnd_min = 1,
		rnd_max = 100,
		spawns = 
		{
			{
				value_min = 1,
				value_max = 18,
				load_entity_func = 
					function( data, x, y )
						local ox = data.offset_x or 0
						local oy = data.offset_y or 0

						SetRandomSeed( x * 13 - GameGetFrameNum(), y )
						
						if ( y < 512 * 27 ) or ( math.abs(x) > 512 * 27 ) then
							if Random( 1, 100 ) >= 88 then
								local entity_id = EntityLoad( "data/entities/items/pickup/summon_portal_broken.xml", x + ox, y + oy )
							elseif Random( 1, 100 ) <= 20 then
								local entity_id = EntityLoad( "data/entities/items/pickup/broken_wand.xml", x + ox, y + oy )
							else
								local entity_id = EntityLoad( "data/entities/items/pickup/broken_wand_big.xml", x + ox, y + oy )
							end
						else
							local opts = { "brimstone", "stonestone", "thunderstone", "waterstone", "poopstone", "evil_eye" }
							local entity_id = EntityLoad( "data/entities/items/pickup/" .. opts[Random( 1, #opts )] .. ".xml", x + ox, y + oy + 9 )
						end
					end,
				offset_y = -13,
			},
			{
				value_min = 19,
				value_max = 19,
				load_entity_func = 
					function( data, x, y )
						local ox = data.offset_x or 0
						local oy = data.offset_y or 0

						SetRandomSeed( x * 13 - GameGetFrameNum(), y )
						
						if GameHasFlagRun( "greed_curse" ) and ( GameHasFlagRun( "greed_curse_gone" ) == false ) then
							local opts = { "gold_orb", "gold_orb_greed", "greed_die", "die" }
							local entity_id = EntityLoad( "data/entities/items/pickup/physics_" .. opts[Random( 1, #opts )] .. ".xml", x + ox, y + oy )
						else
							local opts = { "laser", "fireball", "lava", "slow", "null", "disc", "metal" }
							local entity_id = EntityLoad( "data/entities/items/pickup/runestones/runestone_" .. opts[Random( 1, #opts )] .. ".xml", x + ox, y + oy )

							if ( Random( 1, 100 ) < 70 ) then
								runestone_activate( entity_id )
							end
						end
					end,
				offset_y = -13,
			},
			{
				value_min = 20,
				value_max = 20,
				load_entity_func = 
					function( data, x, y )
						local ox = data.offset_x or 0
						local oy = data.offset_y or 0

						SetRandomSeed( x * 13 - GameGetFrameNum(), y )

						if ( Random( 1, 100 ) < 66 ) then
							local entity_id = EntityLoad( "data/entities/items/pickup/safe_haven.xml", x + ox, y + oy )
						else
							local opts = { "fire", "monster", "purple", "red", "slime", "spiders", "worm" }
							local entity_id = EntityLoad( "data/entities/items/pickup/egg_" .. opts[Random( 1, #opts )] .. ".xml", x + ox, y + oy + 2 )
						end
					end,
				offset_y = -4,
			},
			{
				value_min = 21,
				value_max = 100,
				load_entity_func = 
					function( data, x, y )
						local ox = data.offset_x or 0
						local oy = data.offset_y or 0

						SetRandomSeed( x * 13 - GameGetFrameNum(), y )

						if ( Random( 1, 100 ) <= 6 ) then
							local entity_id = EntityLoad( "data/entities/items/pickup/jar_super.xml", x + ox, y + oy )
						elseif ( Random( 1, 100 ) >= 77 ) then
							local entity_id = EntityLoad( "data/entities/items/pickup/jar.xml", x + ox, y + oy )
						else
							local entity_id = EntityLoad( "data/entities/items/pickup/potion.xml", x + ox, y + oy )
						end
					end,
				offset_y = -5,
			},
		},
	},
	potion_spawnlist_liquidcave =
	{
		rnd_min = 1,
		rnd_max = 100,
		spawns = 
		{
			{
				value_min = 1,
				value_max = 10,
				load_entity = "data/entities/items/pickup/moon.xml",
				offset_y = -4,
			},
			{
				value_min = 11,
				value_max = 100,
				load_entity = "data/entities/items/pickup/jar_super.xml",
				offset_y = -4,
			},
		},
	},
}

function spawn_from_list( listname, x, y )
	local year, month, day = GameGetDateAndTimeLocal()

	SetRandomSeed( x+day, y-month ) -- it can be harder to replay the exactly same seed?
	local spawnlist
	
	if ( type( listname ) == "string" ) then
		spawnlist = spawnlists[listname]
	elseif ( type( listname ) == "table" ) then
		spawnlist = listname
	end
	
	if ( spawnlist == nil ) then
		print( "Couldn't find a spawn list with name: " .. tostring( listname ) )
		return
	end
	
	local rndmin = spawnlist.rnd_min or 0
	local rndmax = spawnlist.rnd_max or 100
	
	local rnd = Random( rndmin, rndmax )
	
	if ( spawnlist.spawns ~= nil ) then
		for i,data in ipairs( spawnlist.spawns ) do
			local vmin = data.value_min or rndmin
			local vmax = data.value_max or rndmax
			
			if ( rnd >= vmin ) and ( rnd <= vmax ) then
				if ( data.spawn_requires_flag ~= nil ) and ( HasFlagPersistent( data.spawn_requires_flag ) == false ) then
					return
				end
				
				local ox = data.offset_x or 0
				local oy = data.offset_y or 0
				
				if ( data.load_entity_func ~= nil ) then
					data.load_entity_func( data, x, y )
					return
				elseif ( data.load_entity_from_list ~= nil ) then
					spawn_from_list( data.load_entity_from_list, x, y )
					return
				elseif ( data.load_entity ~= nil ) then
					EntityLoad( data.load_entity, x + ox, y + oy )
					return
				end
			end
		end
	end
end