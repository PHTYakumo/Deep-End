dofile_once( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/perk_list.lua" )
dofile_once( "data/scripts/perks/abyss_func.lua" )

-- This implementation causes the game to be slower

local entity_id = GetUpdatedEntityID()
local px, py = EntityGetTransform( entity_id )

local depthcomp
local depth = 1

local depthcomps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if ( depthcomps ~= nil ) then
	for i,comp in ipairs( depthcomps ) do
		local n = ComponentGetValue2( comp, "name" )
		if ( n == "deepth_state" ) then
			depth = ComponentGetValue2( comp, "value_int" )
			depthcomp = comp
			break
		end
	end
end

--[[
local moneycomp = EntityGetFirstComponent( entity_id, "WalletComponent" )
ComponentSetValue2( moneycomp, "money", 0 )
]]--

local level = 1
depth = math.max( depth, py )
ComponentSetValue2( depthcomp, "value_int", depth )

-- what level wand to give
if( depth > 2000 ) then level = level + 1 end
if( depth > 5000 ) then level = level + 1 end
if( depth > 9000 ) then level = level + 1 end
if( depth > 14000 ) then level = level + 1 end
if( depth > 20000 ) then level = level + 1 end
if( depth > 26000 ) then level = 10 end
if( depth > 32000 ) then level = 100 end
if( py < -500 ) then level = 10 end
if( py < -1500 ) then level = 100 end

local world_entity_id = GameGetWorldStateEntity()
if( world_entity_id ~= nil ) then
	local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
	if( comp_worldstate ~= nil ) then
		ComponentSetValue( comp_worldstate, "global_genome_relations_modifier", tostring( -2 ) )
	end
end

GlobalsSetValue( "TEMPLE_PERK_COUNT", "2" )							-- so extra_perk and perks_lottery are useless

-- strengthen your enemies

local radius = 512
local enemies = EntityGetInRadiusWithTag( px, py, radius, "enemy" )
local wands = EntityGetInRadiusWithTag( px, py, radius, "wand" )

for i,enemy in ipairs( enemies ) do
	if ( not EntityHasTag( enemy, "boosted" ) ) and ( not EntityHasTag( enemy, "holy_mountain_creature" ) ) and ( not EntityHasTag( enemy, "small_friend" ) ) then
		EntityAddTag( enemy, "boosted" )

		if not EntityHasTag( enemy, "curse_NOT" ) then EntityAddTag( enemy, "curse_NOT") end
		if not EntityHasTag( enemy, "polymorphable_NOT" ) then EntityAddTag( enemy, "polymorphable_NOT") end

		SetRandomSeed( enemy + px, GameGetFrameNum() + py )

		EntityAddRandomStains( enemy, CellFactory_GetType("blood_fading"), Random( 13, 66 )^2 )

		EntityAddComponent( enemy, "VariableStorageComponent", 
		{
			_tags="no_gold_drop",
		} )

		local wp = math.max( math.floor( level^0.7 ), 10 )
		local wrnd = Random( 1, wp + 6 )

		if ( wrnd < 7 ) then
			de_enemy_give_wand( enemy, level ) 					-- 0.857 0.857 0.75 0.75 0.667 0.667 0.545 0.375
		end

		de_enemy_give_perk( enemy )
	end
end

-- destroy wands your dropped
for i,wand in ipairs( wands ) do 								
	local icomp = EntityGetFirstComponent( wand, "ItemComponent" )

	if ( icomp ~= nil ) then
		if ( EntityHasTag( wand, "abyss_frozen_wand" ) ) then
			local used = ComponentGetValue2( icomp, "has_been_picked_by_player" )

			if ( used ) then
				local wx, wy = EntityGetTransform( wand )
				EntityLoad( "data/entities/particles/image_emitters/chest_effect_bad.xml", wx, wy )
				EntityKill( wand ) 
			end
		end

		if ( EntityHasTag( wand, "abyss_wand" ) ) then 
			-- EntityKill( wand ) 
			ComponentSetValue( icomp, "is_frozen", "true" )
			EntityAddTag( wand, "abyss_frozen_wand" )
			-- GamePrint( "$mAbyss" )
		elseif ( not EntityHasTag( wand, "abyss_cursed" ) ) then
			EntityAddTag( wand, "abyss_cursed" )

			SetRandomSeed( wand + px, GameGetFrameNum() + py )
			local crnd = Random( 1, 10 )

			if ( crnd < 7 ) then
				ComponentSetValue( icomp, "is_frozen", "true" )
				EntityAddTag( wand, "abyss_frozen_wand" )
			end
		end
	end
end

--[[

if ( #enemies > 0 ) then
	SetRandomSeed( #enemies + px, GameGetFrameNum() + py )
	local ernd = Random( 1, #enemies )

	EntityRemoveStainStatusEffect( enemies[ernd], "RADIOACTIVE", 5 )
	EntityRemoveStainStatusEffect( enemies[ernd], "POISONED", 5 )
	EntityRemoveStainStatusEffect( enemies[ernd], "WEAKNESS", 5 )
	EntityRemoveStainStatusEffect( enemies[ernd], "CHARM", 5 )
end

]]--

-- remove stains

SetRandomSeed( GameGetFrameNum(), px + py )
local stain_rng = Random( 1, 3 )

if ( stain_rng == 1 ) then
	EntityRemoveStainStatusEffect( entity_id, "WET", 1 )
	EntityRemoveStainStatusEffect( entity_id, "HP_REGENERATION", 1 )
elseif ( stain_rng == 2 ) then
	EntityRemoveStainStatusEffect( entity_id, "BLOODY", 1 )
	EntityRemoveStainStatusEffect( entity_id, "PROTECTION_ALL", 1 )
elseif ( stain_rng == 3 ) then
	EntityRemoveStainStatusEffect( entity_id, "JARATE", 1 )
	EntityRemoveStainStatusEffect( entity_id, "DEEP_END_HARDEN_EFFECT", 1 )
end

-- GameEmitRainParticles( num_particles:int, width_outside_camera:number, material_name:string, velocity_min:number, velocity_max:number, gravity:number, droplets_bounce:bool, draw_as_long:bool )




