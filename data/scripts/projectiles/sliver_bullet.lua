dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)

if EntityHasTag( root_id, "sliver_bullet_weakened" ) then
	EntityKill(entity_id)
	return
end

if EntityHasTag( root_id, "boss" ) or EntityHasTag( root_id, "touchmagic_immunity" )
	or EntityHasTag( root_id, "polymorphable_NOT" ) or EntityHasTag( root_id, "teleportable_NOT" )
	or EntityHasTag( root_id, "necrobot_NOT" ) or EntityHasTag( root_id, "curse_NOT" )
	or EntityHasTag( root_id, "lukki" ) or EntityHasTag( root_id, "worm" )
	or EntityHasTag( root_id, "thundermage" ) or EntityHasTag( root_id, "robot" )
	or EntityHasTag( root_id, "music_energy_000" ) or EntityHasTag( root_id, "music_energy_000_near" )
	or EntityHasTag( root_id, "music_energy_050" ) or EntityHasTag( root_id, "music_energy_050_near" )
	or EntityHasTag( root_id, "music_energy_100" ) or EntityHasTag( root_id, "music_energy_100_near" ) then 

	EntityAddChild( root_id, EntityLoad( "data/entities/misc/effect_weakness_sliver.xml" ) )

	if ( not EntityHasTag( root_id, "boss" ) ) and ( not EntityHasTag( root_id, "miniboss" ) ) and ( not EntityHasTag( root_id, "boss_centipede" ) ) then
		EntityAddChild( root_id, EntityLoad( "data/entities/misc/effect_weaken_sliver.xml" ) )
	end
end

EntityAddTag( root_id, "sliver_bullet_weakened" )
EntityKill(entity_id)
