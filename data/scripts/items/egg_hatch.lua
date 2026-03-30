dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
local entity_list_name = "monsters"

if ( components ~= nil ) then
	for key,comp_id in pairs(components) do
		local var_name = ComponentGetValue2( comp_id, "name" )
		if ( var_name == "entity_list" ) then
			entity_list_name = ComponentGetValue2( comp_id, "value_string" )
		end
	end
end

local entity_lists = 
{
monsters = { {"fox", 3}, {"super_fish"}, {"ultimate_killer"}, {"ultimate_ultra_killer"} },
slimes = { {"longleg", 4}, {"ant"}, {"necromancer_shop"} },
fire = { {"assassin"}, {"spearbot"}, {"drone_physics_hell"} },
red = { {"scavenger_glue", 3}, {"statue", 2}, {"bigzombie"} },
chilly = { {"goblin_bomb", 2}, {"tank_rocket"}, {"fungus_big"} },
purple = { {"miner_santa", 2}, {"miner_chef"}, {"scavenger_heal"} },
worms = { {"worm_end"}, {"worm_big"}, {"meatmaggot", 3} },
}

SetRandomSeed( GameGetFrameNum() + entity_id, x + y )

local options = entity_lists[entity_list_name]
local opts = #options
local rnd = 1

for i=1,opts do
	rnd = math.min(rnd + math.min(math.max(Random(1, 8) - 7, 0), 1), opts)
end

local entity_to_spawn = options[rnd][1] or "zombie"
local entity_count = options[rnd][2] or 1

local option = "data/entities/animals/" .. entity_to_spawn .. ".xml"

GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/egg/hatch", x, y )

for j=1,entity_count do
	local eid = EntityLoad( option, x, y )

	if not EntityHasTag( eid, "holy_mountain_creature" ) then EntityAddTag( eid, "holy_mountain_creature" ) end
	
	local herd_id
	local players = EntityGetWithTag( "player_unit" )

	if ( #players > 0 ) then
		local p = players[1]
		
		edit_component( p, "GenomeDataComponent", function(comp,vars)
			herd_id = ComponentGetValue2( comp, "herd_id" )
		end)
	end
	
	if ( entity_list_name ~= "worms" ) then
		local charm_component = GetGameEffectLoadTo( eid, "CHARM", true )
		if( charm_component ~= nil ) then
			ComponentSetValue( charm_component, "frames", -1 )
		end

		-- so that hatched enemies don't drop gold
		local lua_components = EntityGetComponent( eid, "LuaComponent")
		if( lua_components ~= nil ) then
			for i,lua_comp in ipairs(lua_components) do
				if( ComponentGetValue2( lua_comp, "script_death") == "data/scripts/items/drop_money.lua" ) then
					-- this crashes the game, so let's just set this to NULL
					-- EntityRemoveComponent( eid, lua_comp )
					ComponentSetValue( lua_comp, "script_death", "" )
				end
			end
		end

		local damagemodels = EntityGetComponent( eid, "DamageModelComponent" )
		if( damagemodels ~= nil ) then
			for i,damagemodel in ipairs(damagemodels) do
				local max_hp = ComponentGetValue2( damagemodel, "max_hp" )

				max_hp = max_hp * 2.0
				
				ComponentSetValue( damagemodel, "max_hp", max_hp )
				ComponentSetValue( damagemodel, "hp", max_hp )
			end
		end
		
		if ( herd_id ~= nil ) then
			edit_component( eid, "GenomeDataComponent", function(comp,vars)
				ComponentSetValue2( comp, "herd_id", herd_id )
			end)
		end
	end
end