dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local anger = tonumber( GlobalsGetValue( "HELPLESS_KILLS", "1" ) ) or 1
print( "DEAD HELPLESS ANIMALS: " .. tostring( anger ) )

local p = EntityGetInRadiusWithTag( x, y, 300, "player_unit" )

if ( #p > 0 ) and ( anger >= 15 ) and ( GlobalsGetValue( "ISLANDSPIRIT_SPAWNED", "0" ) == "0" ) then
	GlobalsSetValue( "ISLANDSPIRIT_SPAWNED", "1" )
	
	EntityLoad( "data/entities/animals/boss_spirit/spawn_portal.xml", x, y )
	EntityKill( entity_id )

	local helplesss = EntityGetInRadiusWithTag( x, y, 1024, "helpless_animal" )

	if ( #helplesss > 0 ) then
		x, y = EntityGetTransform( p[1] )

		for i=1,#helplesss do
			local ex, ey = EntityGetTransform( helplesss[i] )

			local vx = ( x-ex ) * 13
			local vy = ( y-ey ) * 13

			shoot_projectile( helplesss[i], "data/entities/animals/boss_spirit/orb_rnd/homing/orb_hearty.xml", ex, ey, vx, vy )
			shoot_projectile( helplesss[i], "data/entities/animals/boss_spirit/orb_rnd/homing/orb_poly.xml", ex, ey, vx, vy )
			shoot_projectile( helplesss[i], "data/entities/animals/boss_spirit/orb_rnd/homing/orb_weaken.xml", ex, ey, vx, vy )

			EntityKill( helplesss[i] )
		end
	end
end