dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetParent( entity_id )

local x, y = EntityGetTransform( entity_id )
local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )

if ( player_id ~= NULL_ENTITY ) and ( entity_id ~= player_id ) then
	local comp = EntityGetFirstComponent( player_id, "DamageModelComponent" )
	local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
	
	local resists = { "drill", "electricity", "explosion", "fire", "ice", "melee", "projectile", "radioactive", "slice" }
	local result = ""
	
	if ( comp ~= nil ) and ( comps ~= nil ) then
		for a,b in ipairs( resists ) do
			local r = ComponentObjectGetValue( comp, "damage_multipliers", b )
			local wither_r = r

			if EntityHasTag( player_id, "player_unit" ) then
				wither_r = clamp( wither_r*1.2, 2.0, 2^newgame_n + 3 )
				
				result = result .. tostring(r)
				
				if ( a < #resists ) then
					result = result .. " "
				end

				if ( b == "melee" ) then
					wither_r = clamp( r*1.2, 3.0, 2^newgame_n + 4 )
				elseif ( b == "explosion" ) then
					wither_r = clamp( r*2.0, 1.2, 2^newgame_n + 3.2 )
				end
			else
				wither_r = clamp( r+0.1, 0, 16 ) -- in NG+?
			end
			
			ComponentObjectSetValue( comp, "damage_multipliers", b, tostring(wither_r) )
		end
	
		if ( #result > 0 ) then
			for i,v in ipairs( comps ) do
				local n = ComponentGetValue2( v, "name" )
				
				if ( n == "wither_data" ) then
					ComponentSetValue2( v, "value_string", result )
					break
				end
			end
		end
	end
	
	local c = EntityGetAllChildren( player_id )
	
	if ( c ~= nil ) then
		for i,v in ipairs( c ) do
			if EntityHasTag( v, "effect_resistance" ) then
				EntitySetComponentsWithTagEnabled( v, "effect_resistance", false )
			end
		end
	end
end