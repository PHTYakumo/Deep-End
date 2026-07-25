dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/abyss_func.lua" )

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y, rot = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local status, rstorage = 0, 0
local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )

if variablestorages ~= nil then
	for j,storage_id in ipairs(variablestorages) do if ComponentGetValue2( storage_id, "name" ) == "rolling" then
		status = ComponentGetValue2( storage_id, "value_int" )
		rstorage = storage_id
	end end
	
	if status > 0 then
		status = status + 1
		
		if status >= 20 then
			local players = EntityGetInRadiusWithTag( pos_x, pos_y, 200, "player_unit" )
			if #players <= 0 then return end
			
			local result = Random( 1, 6 )
			status = 0
			
			local textprint = "$item_die_"
			local anim = "default"
			
			if #players > 0 then GamePrint( textprint .. tostring( result ) ) end
			anim = "rolled_" .. tostring( result )
			
			local player_id = EntityGetClosestWithTag( pos_x, pos_y, "player_unit" )
			if not EntityGetIsAlive( player_id ) then return end

			if result == 1 then
				de_shuffle_pl_perk( player_id )
			elseif result == 2 then
				de_shuffle_pl_inventory( player_id )
			elseif result == 3 then
				de_enemy_give_perk( EntityLoad("data/entities/animals/longerleg.xml", pos_x, pos_y - 16 ) )
			elseif result == 4 then
				de_enemy_give_wand( EntityLoad("data/entities/animals/drunk/sniper.xml", pos_x, pos_y - 16 ), Random( 1, 6 ) )
			elseif result == 5 then
				EntityLoad("data/entities/misc/greed_curse/greed_rain.xml", pos_x, pos_y - 16 )
			elseif result == 6 then
				EntityLoad( "data/entities/items/pickup/chest_random_harder_" .. tostring(Random(1,7)) .. ".xml", pos_x, pos_y - 16 )
			end
			
			edit_component2( entity_id, "SpriteComponent", function(comp,vars)
				ComponentSetValue2( comp, "rect_animation", anim )
			end)
		end
	end
	
	ComponentSetValue2( rstorage, "value_int", status )
end