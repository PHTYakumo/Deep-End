dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()

if entity_id == NULL_ENTITY or entity_id == nil then return end

if not EntityHasTag( entity_id, "projectile_heal" ) then EntityAddTag( entity_id, "projectile_heal" ) end

local comps = EntityGetComponent( entity_id, "ProjectileComponent" )

if comps ~= nil then
    for i,v in ipairs( comps ) do
        ComponentObjectSetValue2( v, "damage_by_type", "healing", -0.0004 )
    end
end