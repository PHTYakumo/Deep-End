dofile_once( "data/scripts/perks/abyss_func.lua" )

function de_is_valid_file( file )
	local test = "data/entities/animals/"
	
	if ( string.sub( file, 1, #test ) == test ) then
		return true
	end
end

function de_is_valid_file2( file )
	local test = "data/entities/items/wand_"
	
	if ( string.sub( file, 1, #test ) == test ) then
		return true
	end
	
	return false
end

function entity_load_camera_bound(entity_data, x, y, rndx, rndy)
	local hah_amount = math.max( math.floor( ModSettingGet( "DEEP_END.HELL_AND_HELL_AMOUNT" ) + 0.5 ), 1 )

	local rand_x = 4
	local rand_y = 4

	if rndx ~= nil then rand_x = rndx end
	if rndy ~= nil then rand_y = rndy end

	if hah_amount >= 2 then
		rand_x = rand_x + 1
		rand_y = rand_y + 1
	elseif hah_amount >= 4 then
		rand_x = rand_x + 2
		rand_y = rand_y + 2
	elseif hah_amount >= 6 then
		rand_x = rand_x + 4
		rand_y = rand_y + 3
	elseif hah_amount >= 8 then
		rand_x = rand_x + 6
		rand_y = rand_y + 4
	end

	-- load groups
	if( entity_data.entities ~= nil ) then
		for j,ev in ipairs(entity_data.entities) do
			if( type( ev ) == 'table' ) then
				local count = 1
				if( ev.min_count ~= nil ) then
					count = ev.min_count
					if( ev.max_count ~= nil ) then
						if de_is_valid_file( ev.entity ) then
							count = ProceduralRandom( x+j, y, ev.min_count*hah_amount, ev.max_count*hah_amount )
						elseif de_is_valid_file2( ev.entity ) then
							count = math.min( ProceduralRandom( x+j, y, ev.min_count, ev.max_count*hah_amount ), 2 )
						else
							count = ProceduralRandom( x+j, y, ev.min_count, ev.max_count )
						end
					end
				end

				for i = 1,count do
					local pos_x = x + ProceduralRandom(x+j, y+i, -rand_x, rand_x)
					local pos_y = y + ProceduralRandom(x+j, y+i, -rand_y, rand_y)
					if( ev.offset_y ~= nil ) then pos_y = pos_y + ev.offset_y end
					if( ev.offset_x ~= nil ) then pos_x = pos_x + ev.offset_x end

					EntityLoadCameraBound( ev.entity, pos_x, pos_y )
				end

				--[[
				if de_is_valid_file( ev.entity ) and ( ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) ) then
					-- de_enemy_give_perk( eid )
					EntityLoad( "data/entities/misc/what_is_this/de_enemy_perk_spawn.xml", x, y )
				end
				]]--
			else
				if( ev ~= nil ) then
					local sp_amount = 1
					if de_is_valid_file( ev ) then
						sp_amount = hah_amount
					elseif de_is_valid_file2( ev ) then
						sp_amount = math.min( ProceduralRandomi( rand_x, rand_y, 1, hah_amount ), 2 )
					end

					for i = 1,sp_amount do
						local pos_x = x + ProceduralRandom(x+j, y+i, -rand_x, rand_x)
						local pos_y = y + ProceduralRandom(x+j, y+i, -rand_y, rand_y)
						if( ev.offset_y ~= nil ) then pos_y = pos_y + ev.offset_y end
						if( ev.offset_x ~= nil ) then pos_x = pos_x + ev.offset_x end

						EntityLoadCameraBound( ev, pos_x, pos_y )

						if not de_is_valid_file( ev ) then break end
					end

					--[[
					if de_is_valid_file( ev ) and ( ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) ) then
						-- de_enemy_give_perk( eid )
						EntityLoad( "data/entities/misc/what_is_this/de_enemy_perk_spawn.xml", x, y )
					end
					]]--
				end
			end
		end
	end

	if( entity_data.entity == nil or  entity_data.entity == '' ) then
		return 0
	end

	local how_many = ProceduralRandom(x,y,entity_data.min_count,entity_data.max_count)

	if de_is_valid_file( entity_data.entity ) then
		how_many = ProceduralRandom(x,y,entity_data.min_count*hah_amount,entity_data.max_count*hah_amount)
	elseif de_is_valid_file2( entity_data.entity ) then
		how_many = math.min( ProceduralRandom(x,y,entity_data.min_count,entity_data.max_count*hah_amount), 2 )
	end

	if( how_many <= 0 ) then
		return 0
	end

	local pos_x = x
	local pos_y = y

	for i = 1,how_many do
		pos_x = x + ProceduralRandom(x+i,y,-rand_x, rand_x)
		pos_y = y + ProceduralRandom(x+i,y,-rand_y, rand_y)
		if( entity_data.offset_y ~= nil ) then pos_y = pos_y + entity_data.offset_y end
		if( entity_data.offset_x ~= nil ) then pos_x = pos_x + entity_data.offset_x end

		EntityLoadCameraBound( entity_data.entity, pos_x, pos_y )
	end

	--[[
	if de_is_valid_file( entity_data.entity ) and ( ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) ) then
		-- de_enemy_give_perk( eid )
		EntityLoad( "data/entities/misc/what_is_this/de_enemy_perk_spawn.xml", x, y )
	end
	]]--

	return 1
end