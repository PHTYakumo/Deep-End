dofile_once("data/scripts/lib/utilities.lua")

local et = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
if et > 32 then return end

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local exp_rad, exp_dmg, find = 20, 0.6, false

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local scomps = EntityGetComponent( entity_id, "SpriteComponent" )

if comps ~= nil then for i,comp in ipairs( comps ) do
	if ComponentGetValue2( comp, "name" ) == "exp_data" then
		exp_rad = ComponentGetValue2( comp, "value_int" ) or 20
		exp_dmg = ComponentGetValue2( comp, "value_float" ) or 0.6
        find = true
	end
end end

if scomps ~= nil then for i=1,#scomps do
    local scale = 1 + et * 0.0333 * ( exp_rad * 0.1 - 0.75 )
    if i > 1 then scale = scale * 0.7 end

    ComponentSetValue2( scomps[i], "special_scale_x", scale )
    ComponentSetValue2( scomps[i], "special_scale_y", scale )
    ComponentSetValue2( scomps[i], "alpha", clamp( 1 - et * 0.0333, 0, 1 ) )
end end

if not ( find and et % 5 == 1 ) then return end

function arc_proj_sp( px, py, et, exp_rad, exp_dmg )
    local dir = et % 10
    dir = sign( (-1)^dir )
    
    local pid1 = EntityLoad( "data/entities/projectiles/deck/order_ex_arc.xml", px, py - 180 * dir )
    local pid2 = EntityLoad( "data/entities/projectiles/deck/order_ex_arc.xml", px, py + 180 * dir )

    local comp1 = EntityGetFirstComponentIncludingDisabled( pid1, "VelocityComponent" )
    ComponentSetValue2( comp1, "mVelocity", 0, 500 * dir )

    local comp2 = EntityGetFirstComponentIncludingDisabled( pid2, "LuaComponent" )
    EntitySetComponentIsEnabled( pid2, comp2, false )

    comp1 = EntityGetFirstComponentIncludingDisabled( pid1, "ProjectileComponent" )
    comp2 = EntityGetFirstComponentIncludingDisabled( pid2, "ProjectileComponent" )

    ComponentObjectSetValue2( comp1, "damage_by_type", "electricity", exp_dmg )
    ComponentObjectSetValue2( comp2, "damage_by_type", "electricity", exp_dmg )

    ComponentObjectSetValue2( comp1, "config_explosion", "explosion_radius", exp_rad )
    ComponentObjectSetValue2( comp1, "config_explosion", "damage", exp_dmg )

    ComponentObjectSetValue2( comp2, "config_explosion", "explosion_radius", exp_rad )
    ComponentObjectSetValue2( comp2, "config_explosion", "damage", exp_dmg )

    comp1 = EntityGetFirstComponentIncludingDisabled( pid1, "LightningComponent" )
    comp2 = EntityGetFirstComponentIncludingDisabled( pid2, "LightningComponent" )

    ComponentObjectSetValue2( comp1, "config_explosion", "explosion_radius", exp_rad )
    ComponentObjectSetValue2( comp1, "config_explosion", "damage", exp_dmg )

    ComponentObjectSetValue2( comp2, "config_explosion", "explosion_radius", exp_rad )
    ComponentObjectSetValue2( comp2, "config_explosion", "damage", exp_dmg )

    comp1 = EntityGetFirstComponentIncludingDisabled( pid1, "ArcComponent" )
    comp2 = EntityGetFirstComponentIncludingDisabled( pid2, "ArcComponent" )

    ComponentSetValue2( comp1, "mArcTarget", pid2 )
    ComponentSetValue2( comp2, "mArcTarget", pid1 )
end

local enemies = EntityGetInRadiusWithTag( x, y, exp_rad + 5, "effect_order_stun" )

if enemies[1] ~= nil then
    SetRandomSeed( GameGetFrameNum(), entity_id + et )
    local ernd = Random( 1, #enemies )

    x, y = EntityGetTransform( enemies[ernd] )
    EntityRemoveTag( enemies[ernd], "effect_order_stun" )
end

GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/chain_bolt/create", x, y )
arc_proj_sp( x, y, et, exp_rad, exp_dmg * 0.5 )
