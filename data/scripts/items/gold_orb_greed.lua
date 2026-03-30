dofile_once("data/scripts/lib/utilities.lua")

function drop()
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "kick_count" )
	
	SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	
	if ( comp ~= nil ) then
		local count = ComponentGetValue2( comp, "value_int" )
		count = count + 1
		ComponentSetValue2( comp, "value_int", count )
		
		SetRandomSeed( x + entity_id, y - GameGetFrameNum() )
		
		local outcome = Random( 1, 24 )
		
		if ( count <= 1 ) then
			outcome = Random( 3, 7 )
		else
			outcome = math.max( 1, outcome - ( count - 5 ) )
		end

		local jackpot = Random( 1, 13 ) - outcome
		
		-- print( tostring( outcome ) )
		
		if ( outcome == 1 ) then
			EntityLoad( "data/entities/projectiles/deck/explosion_giga.xml", x, y )
			EntityKill( entity_id )
			return
		elseif ( jackpot > count ) then
			for i=1,outcome do
				shoot_projectile( entity_id, "data/entities/items/pickup/bloodmoney_1000.xml", x, y, Random(-50,50), Random(-50,50) )
			end
		else
			for i=1,outcome do
				shoot_projectile( entity_id, "data/entities/items/pickup/bloodmoney_200.xml", x, y, Random(-50,50), Random(-50,50) )
			end
		end
	end
end

function kick()
	drop()
end