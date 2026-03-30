dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/perk.lua" )
dofile_once( "data/scripts/perks/perk_list.lua" )
dofile_once( "data/scripts/perks/deep_end_perk_utilities.lua" )

local entity_to_kill = GetUpdatedEntityID()
local entity_id = EntityGetRootEntity( entity_to_kill )

if not EntityHasTag( entity_id, "player_unit" ) then
	EntityKill( entity_to_kill )
	return
end

local perk_to_pickup = deep_end_create_all_player_perks_fission( entity_id )

IMPL_remove_all_perks( entity_id )

if #perk_to_pickup > 0 then for key,pid in ipairs( perk_to_pickup ) do
	perk_pickup( pid, entity_id, EntityGetName(pid), false, false )
end end

local opts = { "REMOVE_FOG_OF_WAR", "UNLIMITED_SPELLS", "NO_MORE_SHUFFLE" }
local x, y = EntityGetTransform( entity_id )
SetRandomSeed( x, y )

for i=1,3 do
	rnd = Random( 1, #opts )

	local starting_perk = perk_spawn( x + 20 * ( i - 2 ), y - 25, opts[rnd], true )
	EntityAddComponent( starting_perk, "LuaComponent", { script_item_picked_up = "data/scripts/perks/perk_choose_one.lua", } )
	EntityAddTag( starting_perk, "perk_choose_one")

	table.remove( opts, rnd )
end

EntityKill( entity_to_kill )