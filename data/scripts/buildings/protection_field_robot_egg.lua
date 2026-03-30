dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local entities = EntityGetInRadiusWithTag( x, y, 256, "enemy" )
if #entities == 0 then return end

for i=1,#entities do if not EntityHasTag( entities[i], "robot_egg_boosted" ) then
	if not EntityHasTag( entities[i], "teleportable_NOT" ) then EntityAddTag( entities[i], "teleportable_NOT" ) end
	if not EntityHasTag( entities[i], "touchmagic_immunity" ) then EntityAddTag( entities[i], "touchmagic_immunity" ) end
	if not EntityHasTag( entities[i], "polymorphable_NOT" ) then EntityAddTag( entities[i], "polymorphable_NOT" ) end

	local acomp = EntityGetFirstComponent( entities[i], "AnimalAIComponent" )
	if acomp ~= nil then ComponentSetValue2( acomp, "dont_counter_attack_own_herd", true ) end

	local dcomp = EntityGetFirstComponent( entities[i], "DamageModelComponent" )
	if dcomp ~= nil then ComponentSetValue2( dcomp, "blood_multiplier", 0.0001 ) end

	EntityAddTag( entities[i], "robot_egg_boosted" )
	
	EntityAddComponent( entities[i], "LuaComponent", {
		script_shot = "data/scripts/projectiles/smart_shot.lua" ,
		execute_every_n_frame = "-1",
	} )

	EntityAddComponent( entities[i], "LuaComponent", {
		script_damage_about_to_be_received = "data/entities/animals/boss_wizard/orbit/dmg_cap.lua",
		execute_every_n_frame = "-1",
	} )
end end