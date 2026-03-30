dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/perks/perk.lua" )

local entity_id = GetUpdatedEntityID()
local root_entity = EntityGetRootEntity( entity_id )
local x,y = EntityGetTransform( entity_id )

local effects = { "effect_confusion_ui_longer", "effect_drunk_ui", "effect_hearty", "effect_movement_slower_ui", "effect_weaken", "effect_homing_shooter" }
-- "effect_twitchy", "effect_frozen",

for i=1,#effects do
    EntityAddChild( root_entity, EntityLoad( "data/entities/misc/" .. effects[i] .. ".xml" ) )

    GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/megalaser/launch", x, y )
    GamePrint( "$boss_wizard_" .. tostring(i) )
end

-- remove all your perks AHAAAAAA!!!!!!!
local players = get_players()

if players == nil then return end

for i=1,#players do
    local pl = players[i]
        
    if ( pl ~= nil ) then
        if EntityHasTag( pl, "chaos_frankenstein" ) then
            GamePrintImportant( "$debuff_boss_wizard_1", "$debuff_boss_wizard_2" )
            
            EntityRemoveTag( pl, "forgeable" )
            EntityRemoveTag( pl, "chaos_frankenstein" )
        end

        create_all_player_perks( x, y - 32 )
        IMPL_remove_all_perks( pl )

        local gcomp = EntityGetFirstComponent( pl, "CharacterPlatformingComponent" )
        if ( gcomp ~= nil ) then ComponentSetValue2( gcomp, "pixel_gravity", math.abs(ComponentGetValue2( gcomp, "pixel_gravity" )) ) end

        local px,py,pr,psx,psy = EntityGetTransform( pl )
        EntitySetTransform( pl, px, py, pr, psx, math.abs(psy) )

        -- BossHealthBarComponent, full_inventory_slots_x, full_inventory_slots_y, run_velocity, blood_material, etc
        -- enjoy them!

        EntityRemoveIngestionStatusEffect( pl, "PROTECTION_ALL" )
        -- EntityRemoveIngestionStatusEffect( pl, "PROTECTION_POLYMORPH" )
        -- EntityRemoveIngestionStatusEffect( pl, "DEEP_END_HARDEN_EFFECT" )
    end
end

EntityKill( entity_id )