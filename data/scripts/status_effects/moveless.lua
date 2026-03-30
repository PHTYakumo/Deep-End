dofile_once("data/scripts/lib/utilities.lua")

local pl_id = EntityGetParent( GetUpdatedEntityID() )
local px, py, pr, psx, psy = EntityGetTransform( pl_id )

if pl_id ~= NULL_ENTITY and px ~= nil and psy ~= nil then
    px, py = math.sin(pr) * psy * 1000, math.cos(pr) * psy * 1000

    local vcomp = EntityGetFirstComponentIncludingDisabled( pl_id, "VelocityComponent" )
    if vcomp ~= nil then ComponentSetValueVector2( vcomp, "mVelocity", px, py ) end

    local ccomp = EntityGetFirstComponentIncludingDisabled( pl_id, "CharacterDataComponent" )
    if ccomp ~= nil then ComponentSetValueVector2( ccomp, "mVelocity", px, py ) end
end

