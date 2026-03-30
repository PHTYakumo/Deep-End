dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")
dofile_once( "data/scripts/perks/perk_list.lua" )

--[[
	remove every single perk (including the invalidated ones), but keep part of the effect.
]]--

function DEEP_END_remove_all( player_id )
	if ( player_id ~= nil ) then
		for i,perk_data in ipairs( perk_list ) do
			local perk_id = perk_data.id
			
			local flag_name = get_perk_picked_flag_name( perk_id )
			local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) )
			
			if ( GameHasFlagRun( flag_name ) or ( pickup_count > 0 ) ) then
				print( "Removing " .. perk_id )
				GameRemoveFlagRun( flag_name )
				pickup_count = 0
				GlobalsSetValue( flag_name .. "_PICKUP_COUNT", tostring( pickup_count ) )
				
				if ( perk_data.game_effect ~= nil ) then
					local comp = GameGetGameEffect( player_id, perk_data.game_effect )
					
					if ( comp ~= NULL_ENTITY ) then
						ComponentSetValue2( comp, "frames", 1 )
					end
				end
				
				if ( perk_data.game_effect2 ~= nil ) then
					local comp = GameGetGameEffect( player_id, perk_data.game_effect2 )
					
					if ( comp ~= NULL_ENTITY ) then
						ComponentSetValue2( comp, "frames", 1 )
					end
				end
				
				if ( perk_data.func_remove ~= nil ) then
					perk_data.func_remove( player_id )
				end
				
				local c = EntityGetAllChildren( player_id )
				if ( c ~= nil ) then
					for a,child in ipairs( c ) do
						if EntityHasTag( child, "perk_entity" ) then
							local ikcomp = EntityGetFirstComponent( child, "IKLimbWalkerComponent" )
							if ( ikcomp ~= nil ) then
								ComponentSetValue2( ikcomp, "affect_flying", false )
							end
							
							EntityKill( child )
						end
					end
				end
				
				if ( perk_data.remove_other_perks ~= nil ) then
					for a,b in ipairs( perk_data.remove_other_perks ) do
						local f = get_perk_picked_flag_name( b )
						GameRemoveFlagRun( f )
					end
				end
			end
		end
		
		local comps = EntityGetAllComponents( player_id )
		for i,v in ipairs( comps ) do
			if ComponentHasTag( v, "perk_component" ) then
				EntityRemoveComponent( player_id, v )
			end
		end
		
		EntitySetComponentsWithTagEnabled( player_id, "lukki_enable", false )
		EntitySetComponentsWithTagEnabled( player_id, "player_hat", false )
		
		local hat2 = EntityGetComponent( player_id, "SpriteComponent", "player_hat2" )
		
		if ( hat2 ~= nil ) then
			EntitySetComponentsWithTagEnabled( player_id, "player_hat2_shadow", true )
		end
		
		local minions = EntityGetWithTag( "perk_entity" )
		for i,v in ipairs( minions ) do
			EntityKill( v )
		end

		local icons = EntityGetAllChildren( player_id )
		-- This eliminates a lot of things, but you can ignore the impact when using this function, for you're going to die...
		for i=1,#icons do
			EntityKill( icons[i] )
		end
	end
end

--[[
	x2 then /2
]]--

function deep_end_create_all_player_perks_fission( player_entity )
	local x,y = EntityGetTransform( player_entity )
	local perks_to_sp, perks_to_spawn, perk_to_pickup, perk_ewe = {}, {}, {}, 0
	
	for i,perk_data in ipairs(perk_list) do
		local perk_id = perk_data.id
		
		if perk_id == "EDIT_WANDS_EVERYWHERE" then
			local flag_name = get_perk_picked_flag_name( perk_id )
			local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) )
			
			if GameHasFlagRun( flag_name ) or pickup_count > 0 then
				perk_ewe = math.max( perk_ewe, pickup_count )
			end
		elseif perk_data.one_off_effect == nil or perk_data.one_off_effect == false then
			local flag_name = get_perk_picked_flag_name( perk_id )
			local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) )
			
			if GameHasFlagRun( flag_name ) or pickup_count > 0 then
				for i=1,pickup_count do
					table.insert( perks_to_sp, perk_id )
					table.insert( perks_to_spawn, perk_id )
				end
			end
		end
	end

	if perk_ewe > 0 then for i=1,perk_ewe do
		local sp_perk = perk_spawn( x, y, "EDIT_WANDS_EVERYWHERE", true )
		table.insert( perk_to_pickup, sp_perk )
		-- perk_pickup( sp_perk, player_entity, EntityGetName(sp_perk), false, false )
	end end

	if #perks_to_sp > 0 then
		SetRandomSeed( GameGetFrameNum(), #perks_to_sp )

		for key,pid in ipairs( perks_to_sp ) do table.insert( perks_to_spawn, pid ) end
		for i = 1,#perks_to_sp do table.remove( perks_to_spawn, Random( 1, #perks_to_spawn ) ) end

		local full_arc = math.pi
		local count = 8
		local row_size_inc = 4

		local currcount = 0
		local angle = 0

		local inc = full_arc / count
		local initlen = 24
		local length = 24
		local len_inc = 16
		
		for key,pid in ipairs( perks_to_spawn ) do
			local px = x + math.cos( angle ) * length
			local py = y - math.sin( angle ) * length
			
			local sp_perk = perk_spawn( px, py, pid, true )
			table.insert( perk_to_pickup, sp_perk )
			-- perk_pickup( sp_perk, player_entity, EntityGetName(sp_perk), false, false )
			
			angle = angle + inc
			currcount = currcount + 1
			
			if currcount > count then
				currcount = 0
				angle = 0

				count = count + row_size_inc
				length = length + len_inc
				
				inc = full_arc / count
			end
		end
	end

	GamePrint( tostring( #perk_to_pickup ) .. "/" .. tostring( #perks_to_sp + perk_ewe ) )
	return perk_to_pickup
end