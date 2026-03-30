dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/perks/perk.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local player = EntityGetClosestWithTag(x, y, "player_unit")

SetRandomSeed( GameGetFrameNum()+entity_id, x*y )
local count = Random( 1, 5 )

local world_entity_id = GameGetWorldStateEntity()
if( world_entity_id ~= nil ) then
	local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
	if( comp_worldstate ~= nil ) then
		local global_genome_relations_modifier = ComponentGetValue2( comp_worldstate, "global_genome_relations_modifier" )
		global_genome_relations_modifier = global_genome_relations_modifier + Random( 5, 25 ) - 5 * count
		ComponentSetValue2( comp_worldstate, "global_genome_relations_modifier", global_genome_relations_modifier )
	end
end

while count > 0 do
	local pid = perk_spawn_random(x,y)
	-- rerandomize if picked perk is gamble
	component_read( get_variable_storage_component(pid, "perk_id"), { value_string = "" }, function(comp)
		print(comp.value_string)
		if comp.value_string ~= "GAMBLE" then
			perk_pickup(pid, player, "", false, false )
			count = count - 1
		else
			--print("Gamble perk spawned another Gamble. Rerandomizing...")
			EntityKill(pid)
		end
	end)
end

EntityKill(entity_id)
