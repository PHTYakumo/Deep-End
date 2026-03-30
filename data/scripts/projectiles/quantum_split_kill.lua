dofile_once("data/scripts/lib/utilities.lua")

local entity_id = EntityGetRootEntity( GetUpdatedEntityID() )
local x, y = EntityGetTransform( entity_id )

-- reversed death fx
if EntityHasTag( entity_id, "quantum_blue" ) then EntityLoad( "data/entities/misc/quantum_split_fx_red_die.xml", x, y )
elseif EntityHasTag( entity_id, "quantum_red" ) then EntityLoad( "data/entities/misc/quantum_split_fx_blue_die.xml", x, y ) end

local storage_comp = get_variable_storage_component( entity_id, "next_quantum_entity" )
if not storage_comp then return end

local function modify_projectile( next_id )
	local projectile_comp = EntityGetFirstComponent( next_id, "ProjectileComponent" )

	if projectile_comp ~= nil then
		ComponentSetValue2( projectile_comp, "on_lifetime_out_explode", false )
		ComponentSetValue2( projectile_comp, "on_death_explode", false )

		EntityKill( next_id )
	end
end

local init_id = tonumber( ComponentGetValue2( storage_comp, "value_string" ) )
local qt_id = ComponentGetValue2( storage_comp, "value_int" )

-- make sure that non-entanglement entities won't be mistakenly deleted after any redistribution of id
-- the entangled projectile-copy will forcibly vanish if the initial projectile or another entangled copy have vanished

if EntityHasTag( init_id, "projectile_cloned" ) then modify_projectile( init_id ) end
if EntityHasTag( qt_id, "projectile_cloned" ) then modify_projectile( qt_id ) end
