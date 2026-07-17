dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
if not EntityHasTag( entity_id, "effect_protection" ) then return end

local et = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
local pl_id = EntityGetParent( entity_id )

local comp = EntityGetFirstComponentIncludingDisabled( entity_id, "SpriteComponent" )
if comp ~= nil then  ComponentSetValue2( comp, "alpha", clamp( ( 59.99 - et ) * 0.0667, 0, 1 ) ) end

if et < 1 then
    local cids = EntityGetAllChildren( pl_id, "effect_order_stun" )
    if cids ~= nil and #cids > 1 then EntityKill( cids[#cids] ) end
end

local px, py, r, psx, psy = EntityGetTransform( pl_id )

if pl_id ~= NULL_ENTITY and px ~= nil and psy ~= nil then
    local vcomp = EntityGetFirstComponentIncludingDisabled( pl_id, "VelocityComponent" )
    if vcomp ~= nil then ComponentSetValueVector2( vcomp, "mVelocity", 0, -sign(psy) * 5 ) end

    local ccomp = EntityGetFirstComponentIncludingDisabled( pl_id, "CharacterDataComponent" )
    if ccomp ~= nil then ComponentSetValueVector2( ccomp, "mVelocity", 0, -sign(psy) * 5 ) end
end

