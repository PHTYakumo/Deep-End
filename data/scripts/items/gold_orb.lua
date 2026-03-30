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
		
		local outcome = Random( 1, 13 )
		
		if ( count <= 4 ) then
			outcome = Random( 2, 5 )
		else
			outcome = math.max( 1, outcome - ( count - 3 ) )
		end
		
		-- print( tostring( outcome ) )
		
		if ( outcome == 1 ) then
			EntityLoad( "data/entities/projectiles/deck/explosion.xml", x, y )
			EntityKill( entity_id )
			return
		else
			for i=1,outcome do
				shoot_projectile( entity_id, "data/entities/items/pickup/goldnugget_200.xml", x, y, Random(-50,50), Random(-50,50) )
			end
		end
	end
end

function kick()
	drop()
end