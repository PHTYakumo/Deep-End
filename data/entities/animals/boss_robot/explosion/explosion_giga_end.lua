dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")

local x, y = EntityGetTransform( GetUpdatedEntityID() )
SetRandomSeed( pw, 540 )

local opts_1 = { "HOMING_AREA", "HOMING_CURSOR", "HOMING_ROTATE", "AUTOAIM", "DE_METASTABLE_ARC" }
local opts_2 = { "HOMING_ACCELERATING", "HOMING", "HOMING_SHORT", "ANTI_HOMING", "HOMING_SHOOTER" }

for i=1,#opts_1 do
    local rnd = Random( 1, #opts_1 )
    CreateItemActionEntity( opts_1[rnd], x - (i-5.5) * 16 + 25, y + (i-5) * 16 + 6 )
    CreateItemActionEntity( opts_2[rnd], x - (i-0.5) * 16 - 25, y + (1-i) * 16 + 6 )

    table.remove( opts_1, rnd )
    table.remove( opts_2, rnd )
end

perk_spawn_with_name( x, y, "MAP", true )
EntityLoad( "data/entities/items/pickup/heart_fullhp.xml",  x, y-8 )

local ng_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
if ng_n == 0 then EntityLoad( "data/entities/buildings/teleport_teleroom.xml",  x, y-67 ) end

ConvertMaterialEverywhere( CellFactory_GetType( "steel" ), CellFactory_GetType( "fire_blue" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "steel_rust" ), CellFactory_GetType( "fire_blue" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "metal_rust_barrel" ), CellFactory_GetType( "fire_blue" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "metal_rust_rust" ), CellFactory_GetType( "fire_blue" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "metal_rust_barrel_rust" ), CellFactory_GetType( "fire_blue" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "metal_rust" ), CellFactory_GetType( "fire_blue" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "metal_wire_nohit" ), CellFactory_GetType( "fire_blue" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "metal_chain_nohit" ), CellFactory_GetType( "fire_blue" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "metal_nohit" ), CellFactory_GetType( "fire_blue" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "oil" ), CellFactory_GetType( "magic_liquid_mana_regeneration" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "liquid_fire" ), CellFactory_GetType( "magic_liquid_mana_regeneration" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "liquid_fire_weak" ), CellFactory_GetType( "magic_liquid_mana_regeneration" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "steel_static" ), CellFactory_GetType( "root" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "steelmoss_static" ), CellFactory_GetType( "root" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "steel_rusted_no_holes" ), CellFactory_GetType( "root" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "steel_grey_static" ), CellFactory_GetType( "root" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "steelfrost_static" ), CellFactory_GetType( "root" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "steelmoss_slanted" ), CellFactory_GetType( "root" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "steelsmoke_static" ), CellFactory_GetType( "root" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "steelpipe_static" ), CellFactory_GetType( "root" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "steel_static_strong" ), CellFactory_GetType( "root" ) )
ConvertMaterialEverywhere( CellFactory_GetType( "steel_static_unmeltable" ), CellFactory_GetType( "root" ) )

GamePrintImportant( "$defeat_boss_robot_1", "$defeat_boss_robot_2", "data/ui_gfx/decorations/boss_defeat.png" )

local world_entity_id = GameGetWorldStateEntity()
if world_entity_id ~= nil then
    local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
    if comp_worldstate ~= nil then
        local global_genome_relations_modifier = ComponentGetValue2( comp_worldstate, "global_genome_relations_modifier" )
        global_genome_relations_modifier = global_genome_relations_modifier - 10
        ComponentSetValue2( comp_worldstate, "global_genome_relations_modifier", global_genome_relations_modifier )
    end
end