dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
if not EntityHasTag( entity_id, "effect_protection" ) then return end

local executed_times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
local comp = EntityGetFirstComponentIncludingDisabled( entity_id, "SpriteComponent" )
if comp ~= nil then  ComponentSetValue2( comp, "alpha", clamp( ( 59.99 - executed_times ) * 0.0667, 0, 1 ) ) end

local pl_id = EntityGetParent( entity_id )
local px, py, r, psx, psy = EntityGetTransform( pl_id )

if pl_id ~= NULL_ENTITY and px ~= nil and psy ~= nil then
    local vcomp = EntityGetFirstComponentIncludingDisabled( pl_id, "VelocityComponent" )
    if vcomp ~= nil then ComponentSetValueVector2( vcomp, "mVelocity", 0, -sign(psy) * 5 ) end

    local ccomp = EntityGetFirstComponentIncludingDisabled( pl_id, "CharacterDataComponent" )
    if ccomp ~= nil then ComponentSetValueVector2( ccomp, "mVelocity", 0, -sign(psy) * 5 ) end
end

