dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/biomes/temple_shared.lua" )

function collision_trigger()
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	local workshop = EntityGetClosestWithTag( x, y, "workshop" )
	EntityKill( workshop );
	
	workshop = EntityGetClosestWithTag( x, y, "workshop" )
	EntityKill( workshop );
	
	workshop = EntityGetClosestWithTag( x, y, "workshop" )
	EntityKill( workshop );

	workshop = EntityGetClosestWithTag( x, y, "workshop_show_hint" )
	EntityKill( workshop );

	local temple_areacheckers = EntityGetInRadiusWithTag( x, y, 2048, "temple_areachecker" )
	for k,areachecker in pairs(temple_areacheckers) do
		local ax, ay = EntityGetTransform( areachecker )
		if math.abs( y - ay ) < 512 then EntityKill( areachecker ) end
	end

	temple_set_active_flag( x, y, "0" )
	GlobalsSetValue( "FINAL_BOSS_ARENA_ENTERED", "1" )

	GameTriggerMusicFadeOutAndDequeueAll( 2.0 )
	GamePlaySound( "data/audio/Desktop/misc.bank", "misc/temple_collapse", x-100, y-50 )

	StatsBiomeReset()
	EntityKill( entity_id )

	PhysicsSetStatic( EntityLoad( "data/entities/projectiles/bomb_holy_lol.xml", x-6, y-2 ), true )
end