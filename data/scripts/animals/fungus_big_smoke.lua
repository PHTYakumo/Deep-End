dofile_once("data/scripts/lib/utilities.lua")

function collision_trigger()
	local entity_id = GetUpdatedEntityID()
	GameEntityPlaySound( entity_id, "death_buildup" )

	local ccomp = EntityGetFirstComponent( entity_id, "CharacterDataComponent" )
	if ccomp ~= nil then ComponentSetValue2( ccomp, "dont_update_velocity_and_xform", true ) end

	EntityAddComponent2( entity_id, "ParticleEmitterComponent", 
	{ 
		emitted_material_name="plasma_fading_pink",
		x_pos_offset_min=-6,
		y_pos_offset_min=-6,
		x_pos_offset_max=6,
		y_pos_offset_max=6,
		x_vel_min=-75,
		x_vel_max=75,
		y_vel_min=-150,
		y_vel_max=-60,
		count_min=10,
		count_max=18,
		lifetime_min=0.9,
		lifetime_max=3.8,
		create_real_particles=false,
		emit_cosmetic_particles=true,
		emission_interval_min_frames=1,
		emission_interval_max_frames=2,
		airflow_force=4,
		airflow_scale=1.0,
	} )
end