dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( entity_id )
local wand_id = find_the_wand_held( player_id )

if wand_id ~= nil and wand_id ~= NULL_ENTITY and EntityHasTag( player_id, "player_unit" ) then
	local comp = EntityGetFirstComponentIncludingDisabled( entity_id, "LaserEmitterComponent" )
	if comp == nil then return end
	
	local x, y, dir = EntityGetTransform( wand_id )
	local ox, oy = x + math.cos( -dir ) * 6, y - math.sin( -dir ) * 6 - 0.1
	
	EntitySetTransform( entity_id, ox, oy + 0.5, dir )
	ComponentSetValue2( comp, "is_emitting", true )

	local acomp = EntityGetFirstComponentIncludingDisabled( wand_id, "AbilityComponent" )
	if acomp == nil then return end

	dir = ComponentGetValue2( acomp, "mana" ) / math.max( ComponentGetValue2( acomp, "mana_max" ), 0.1 )
	dir = math.ceil( clamp( dir, 0.1, 1 ) * 6 )

	local laser_types = { "spark_red_bright", "spark_yellow", "spark_green", "spark_teal", "spark_electric", "spark_purple_bright", "material_rainbow" }
	ComponentObjectSetValue2( comp, "laser", "beam_particle_type", CellFactory_GetType( laser_types[dir] ) )
else
	local comp = EntityGetFirstComponentIncludingDisabled( entity_id, "LaserEmitterComponent" )
	if comp ~= nil then ComponentSetValue2( comp, "is_emitting", false ) end
end