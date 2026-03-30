dofile_once("data/scripts/lib/utilities.lua")

local entity_id = EntityGetRootEntity( GetUpdatedEntityID() )
local x, y = EntityGetTransform( entity_id )

local scomp = get_variable_storage_component( entity_id, "projectile_file" )
if not scomp then return end

local projectile_file = ComponentGetValue2( scomp, "value_string" )
local comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )

local vx, vy = ComponentGetValueVector2( comp, "mVelocity" )
local friction = ComponentGetValue2( comp, "air_friction" ) * 0.33
local gravity = ComponentGetValue2( comp, "gravity_y" ) * 0.33

vx, vy = vx * 0.67, vy * 0.67
ComponentSetValueVector2( comp, "mVelocity", vx, vy )
ComponentSetValue2( comp, "air_friction", friction )
ComponentSetValue2( comp, "gravity_y", gravity )

x, y = x - vx * 0.1, y - vy * 0.1
EntitySetTransform( entity_id, x - vx * 0.01, y - vy * 0.01 )

-- left copy

local left_id = shoot_projectile_from_projectile( entity_id, projectile_file, x - vy * 0.0125, y + vx * 0.0125, vx, vy )
EntityAddTag( left_id, "quantum_red" ) -- for death fx

EntityLoadToEntity( "data/entities/misc/quantum_split_fx_red.xml", left_id )
EntityAddComponent( left_id, "SineWaveComponent", { sinewave_freq=0.99, sinewave_m=0.75, lifetime=-1, } ) -- entanglement

comp = EntityGetFirstComponent( left_id, "VelocityComponent" )

if comp ~= nil then
	ComponentSetValue2( comp, "air_friction", friction )
	ComponentSetValue2( comp, "gravity_y", gravity )
end

comp = EntityGetFirstComponent( left_id, "ProjectileComponent" )

if comp ~= nil then
	ComponentSetValue2( comp, "penetrate_world", false )
	ComponentSetValue2( comp, "penetrate_entities", false )
end

-- right copy

local right_id = shoot_projectile_from_projectile( entity_id, projectile_file, x + vy * 0.0125, y - vx * 0.0125, vx, vy )
EntityAddTag( right_id, "quantum_blue" ) -- for death fx

EntityLoadToEntity( "data/entities/misc/quantum_split_fx_blue.xml", right_id )
EntityAddComponent( right_id, "SineWaveComponent", { sinewave_freq=0.99, sinewave_m=-0.75, lifetime=-1, } ) -- entanglement

comp = EntityGetFirstComponent( right_id, "VelocityComponent" )

if comp ~= nil then
	ComponentSetValue2( comp, "air_friction", friction )
	ComponentSetValue2( comp, "gravity_y", gravity )
end

comp = EntityGetFirstComponent( right_id, "ProjectileComponent" )

if comp ~= nil then
	ComponentSetValue2( comp, "penetrate_world", false )
	ComponentSetValue2( comp, "penetrate_entities", false )
end

-- quantum entanglement
-- chaos will occur after any redistribution of id, but only projectiles with tag "projectile_cloned" will be deleted

local qt_name, qt_file = "next_quantum_entity", "data/scripts/projectiles/quantum_split_kill.lua"

EntityAddTag( entity_id, "projectile_cloned" )
EntityAddTag( left_id, "projectile_cloned" )
EntityAddTag( right_id, "projectile_cloned" )

EntityAddComponent( entity_id, "VariableStorageComponent", { name=qt_name, value_string=tostring(left_id), value_int=right_id, } )
EntityAddComponent( left_id, "VariableStorageComponent", { name=qt_name, value_string=tostring(left_id), value_int=right_id, } )
EntityAddComponent( right_id, "VariableStorageComponent", { name=qt_name, value_string=tostring(left_id), value_int=right_id, } )

EntityAddComponent( entity_id, "LuaComponent", { script_source_file=qt_file, execute_on_removed=1, execute_every_n_frame=-1, } )
EntityAddComponent( left_id, "LuaComponent", { script_source_file=qt_file, execute_on_removed=1, execute_every_n_frame=-1, } )
EntityAddComponent( right_id, "LuaComponent", { script_source_file=qt_file, execute_on_removed=1, execute_every_n_frame=-1, } )




