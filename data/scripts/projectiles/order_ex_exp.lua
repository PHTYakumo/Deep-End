dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, r, sx, sy = EntityGetTransform( entity_id )

local off_effect = EntityHasTag( entity_id, "spells_to_power_target" )
local exp_rad, exp_dmg = 20, 0.6

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )

if comps ~= nil then for i,comp in ipairs( comps ) do
	if ComponentGetValue2( comp, "name" ) == "exp_data" then
		exp_rad = ComponentGetValue2( comp, "value_int" ) or 20
		exp_dmg = ComponentGetValue2( comp, "value_float" ) or 0.6
	end
end end

if comp == nil then return end
local eid = EntityLoad( "data/entities/misc/order_ex_fade.xml", x, y )

local vx, vy = ComponentGetValueVector2( comp, "mVelocity" )
r = math.pi * 1.5 - math.atan2( vx, vy )

EntitySetTransform( eid, x, y, r )
EntityApplyTransform( eid, x, y, r )

if not off_effect then
    EntityAddComponent( eid, "VariableStorageComponent", 
	{ 
		name = "exp_data",
		value_int = tostring(exp_rad),
        value_float = tostring(exp_dmg),
	} )
end

EntityAddComponent( eid, "LightComponent", 
{ 
    fade_out_time = "1",
    radius = tostring( exp_rad * 2 + 10 ),
    r = "255",
    g = "55",
    b = "255",
} )

local enemies = EntityGetInRadiusWithTag( x, y, exp_rad + 20, "hittable" )

if enemies ~= nil then for i,pid in ipairs( enemies ) do
    if not EntityHasTag( pid, "player_unit" ) and EntityGetFirstComponent( pid, "DamageModelComponent" ) ~= nil then
        EntityInflictDamage( pid, exp_dmg, "DAMAGE_ICE", "$ORDER", "FROZEN", 0, 0, entity_id )
        local fid = EntityLoad( "data/entities/misc/effect_order_stun.xml", x, y )

        if off_effect then
            EntityInflictDamage( pid, exp_dmg, "DAMAGE_ELECTRICITY", "$ORDER", "FROZEN", 0, 0, entity_id )
            EntityRemoveTag( fid, "effect_protection" )
        end

        EntityAddChild( pid, fid )
    end
end end
