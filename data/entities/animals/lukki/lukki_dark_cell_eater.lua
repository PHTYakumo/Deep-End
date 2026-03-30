dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local executed_times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
executed_times = executed_times % 2

local ccomp = EntityGetFirstComponentIncludingDisabled( entity_id, "CellEaterComponent" )
local hcomp = EntityGetFirstComponent( entity_id, "HitboxComponent" )

if ccomp == nil or hcomp == nil then return end
PhysicsApplyTorque( entity_id, 666 * (-1)^executed_times )

EntitySetComponentIsEnabled( entity_id, ccomp, executed_times == 0 )
ComponentSetValue2( hcomp, "damage_multiplier", math.min( 1.2 - ComponentGetValue2( hcomp, "damage_multiplier" ), 1 ) )