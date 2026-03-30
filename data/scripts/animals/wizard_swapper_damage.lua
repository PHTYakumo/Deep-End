dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_a = GetUpdatedEntityID()
	local xa,ya = EntityGetTransform( entity_a )

	if EntityHasTag( entity_who_caused, "no_swap" ) or EntityHasTag( entity_who_caused, "boss" ) then return  end
	if script_wait_frames( entity_a, 6 ) or not EntityGetIsAlive( entity_who_caused ) then return end
	
	local entity_b = entity_who_caused
	local xb,yb = EntityGetTransform( entity_b )

	local dist = math.abs( xa - xb ) + math.abs( ya - yb )
	if dist > 256 then return end

	dist = math.min( math.abs( xa ) + math.abs( ya ), math.abs( xb ) + math.abs( yb ) )
	if dist < 16 then return end

	EntitySetTransform( entity_a, xb, yb )
	EntitySetTransform( entity_b, xa, ya )

	GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/swapper/swap", xa, ya );
end
