dofile_once("data/scripts/lib/utilities.lua")

--[[
    0~10f           reveal
    11~75f          aim
    76~100~300f     beam
    301~345f        fade
]]--

local entity_id = GetUpdatedEntityID()
local frame_count = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )

local acomp = EntityGetFirstComponentIncludingDisabled( entity_id, "AreaDamageComponent", "enable_when_player_seen" )
if acomp == nil then return end
local dmg = ComponentGetValue2( acomp, "damage_per_frame" )

if frame_count <= 10 then
    local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
    local scomp = EntityGetFirstComponent( entity_id, "SpriteComponent" )
    if vcomp == nil or scomp == nil then return end

    local x, y, dir = EntityGetTransform( entity_id )
    local cx, cy = DEBUG_GetMouseWorld()

    cx, cy = cx - x, cy - y
    cx, cy = math.cos( 0.25 ) * cx - math.sin( 0.25 ) * cy, math.sin( 0.25 ) * cx + math.cos( 0.25 ) * cy

    ComponentSetValue2( vcomp, "mVelocity", -cx, -cy )
    ComponentSetValue2( scomp, "alpha", math.min( ComponentGetValue2( scomp, "alpha" ) + 0.11, 1 ) )
elseif frame_count <= 75 then
    local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
    if vcomp == nil then return end

    local x, y, dir = EntityGetTransform( entity_id )
    local cx, cy = DEBUG_GetMouseWorld()

    local vx, vy = ComponentGetValue2( vcomp, "mVelocity" )
    cx, cy = cx - x, cy - y

    local vel, ddir = math.ceil( ( cx^2 + cy^2 )^0.5 + 0.01 ), 0.002 * ( frame_count + 25 )^1.5
    cx, cy = cx * ddir / vel, cy * ddir / vel

    vx, vy = vx * 0.99 + cx * 0.01, vy * 0.99 + cy * 0.01

    ComponentSetValue2( vcomp, "mVelocity", vx, vy )
elseif frame_count <= 100 then
    local scomp = EntityGetFirstComponentIncludingDisabled( entity_id, "SpriteComponent", "enable_when_player_seen" )
    if scomp == nil then return end

    ComponentSetValue2( scomp, "alpha", math.min( ComponentGetValue2( scomp, "alpha" ) + 0.03, 1 ) )
    ComponentSetValue2( scomp, "special_scale_y", math.min( ComponentGetValue2( scomp, "special_scale_y" ) + 0.02, 0.625 ) )

    if dmg < 2 then ComponentSetValue2( acomp, "damage_per_frame", math.min( dmg + 0.05, 1 ) ) end
elseif frame_count > 300 then
    local scomp = EntityGetFirstComponentIncludingDisabled( entity_id, "SpriteComponent", "enable_when_player_seen" )
    if scomp ~= nil then ComponentSetValue2( scomp, "alpha", math.max( ComponentGetValue2( scomp, "alpha" ) - 0.022, 0.01 ) ) end

    if dmg < 2 then ComponentSetValue2( acomp, "damage_per_frame", math.max( dmg - 0.025, 0 ) ) end
    scomp = EntityGetFirstComponent( entity_id, "SpriteComponent" )

    if scomp ~= nil and frame_count > 325 then
        ComponentSetValue2( scomp, "alpha", math.max( ComponentGetValue2( scomp, "alpha" ) - 0.03, 0.4 ) )
        ComponentSetValue2( scomp, "special_scale_x", math.min( ComponentGetValue2( scomp, "special_scale_x" ) + 0.03, 1.6 ) )
        ComponentSetValue2( scomp, "special_scale_y", math.min( ComponentGetValue2( scomp, "special_scale_y" ) + 0.03, 1.6 ) )
    end
end

if frame_count == 10 then
    local x, y = EntityGetTransform( entity_id )
    GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/blindness/creat", x, y )

    local scomp = EntityGetFirstComponentIncludingDisabled( entity_id, "SpriteComponent", "enable_when_player_seen" )
    if scomp ~= nil then EntitySetComponentIsEnabled( entity_id, scomp, true ) end
elseif frame_count == 75 then
    EntitySetComponentIsEnabled( entity_id, acomp, true )
    
    --[[
    local x, y, dir = EntityGetTransform( entity_id )
    local pls = EntityGetInRadiusWithTag( x, y, 66, "boss_centipede" )
    if #pls == 0 then return end

    dmg = ComponentGetValue2( EntityGetFirstComponentIncludingDisabled( pls[1], "DamageModelComponent" ), "max_hp" ) or 100
    dmg = math.max( dmg * 0.02, 2 )

    ComponentSetValue2( acomp, "damage_per_frame", dmg )
    GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/barren_puzzle_completed/create", x, y )

    -- GamePrint( tostring( dmg * 25) )
    ]]--
elseif frame_count == 345 then
    EntityConvertToMaterial( entity_id, "spark_blue_dark" )
elseif frame_count > 345 then
    EntityKill( entity_id )
elseif frame_count > 75 and frame_count % 10 == 7 then
    local x, y, dir = EntityGetTransform( entity_id )
    GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/rune/create", x, y )

    if dmg > 0.004 then
        local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
        if vcomp == nil then return end

        dmg = dmg * 0.5

        local vx, vy = ComponentGetValue2( vcomp, "mVelocity" )
        local pid = EntityLoad( "data/entities/projectiles/deck/orb_shine_reversed_beam.xml", x - vy * 1.5, y + vx * 1.5 )

		local comp = EntityGetFirstComponent( pid, "ProjectileComponent" )
        if comp ~= nil then ComponentObjectSetValue2( comp, "damage_by_type", "holy", dmg ) end

        comp = EntityGetFirstComponent( pid, "VelocityComponent" )
		if comp ~= nil then ComponentSetValueVector2( comp, "mVelocity", vx * 20000, vy * 20000 ) end

        pid = EntityLoad( "data/entities/projectiles/deck/orb_shine_reversed_beam.xml", x + vy * 1.5, y - vx * 1.5 )

		comp = EntityGetFirstComponent( pid, "ProjectileComponent" )
        if comp ~= nil then ComponentObjectSetValue2( comp, "damage_by_type", "holy", dmg ) end

        comp = EntityGetFirstComponent( pid, "VelocityComponent" )
		if comp ~= nil then ComponentSetValueVector2( comp, "mVelocity", vx * 20000, vy * 20000 ) end
    end
end