dofile_once("data/scripts/lib/utilities.lua")

local entity_id, rad = GetUpdatedEntityID(), 1.9
local x, y = EntityGetTransform( entity_id )

local sampos = EntityGetInRadiusWithTag( x, y, 6, "this_is_sampo" )

if #sampos > 0 then for i=1,#sampos do if EntityGetRootEntity( sampos[i] ) == sampos[i] then
    dofile_once("data/scripts/newgame_plus.lua")
    local pls = EntityGetInRadiusWithTag( x, y, 66, "player_unit" )

    if #pls > 0 then
        local newgame_n = tonumber( SessionNumbersGetValue( "NEW_GAME_PLUS_COUNT" ) )
        DEEP_END_do_newgame_any_dimension( newgame_n - 1 )

        EntityKill( sampos[i] )
        EntityKill( entity_id )

        GamePrint( "$chest_bad_msg_13" )
        break
    end
end end end

local enemies = EntityGetInRadiusWithTag( x, y, 66, "mortal" )

if #enemies > 0 then for i=1,#enemies do if not EntityHasTag( enemies[i], "projectile" ) then
    local px, py, vel = EntityGetTransform( enemies[i] )
    px, py = px - x, py - y

    vel = ( ( px^2 + py^2 )^0.5 + 0.01 ) * 0.02
    px, py = px / vel, py / vel

    local rx = math.cos( rad ) * px - math.sin( rad ) * py
	local ry = math.sin( rad ) * px + math.cos( rad ) * py

    local vcomp = EntityGetFirstComponent( enemies[i], "VelocityComponent" )
    local ccomp = EntityGetFirstComponent( enemies[i], "CharacterDataComponent" )

    if vcomp ~= nil then
        local vx, vy = ComponentGetValue2( vcomp, "mVelocity" )
        ComponentSetValue2( vcomp, "mVelocity", vx * 0.8 + rx, vy * 0.8 + ry )
    end

    if ccomp ~= nil then
        local vx, vy = ComponentGetValue2( ccomp, "mVelocity" )
        ComponentSetValue2( ccomp, "mVelocity", vx * 0.8 + rx, vy * 0.8 + ry )
    end
end end end

enemies = EntityGetInRadiusWithTag( x, y, 66, "projectile" )

if #enemies > 0 then for i=1,#enemies do if not EntityHasTag( enemies[i], "resist_repulsion" ) then
    local px, py, vel = EntityGetTransform( enemies[i] )
    px, py = px - x, py - y

    vel = ( ( px^2 + py^2 )^0.5 + 0.01 ) * 0.007
    px, py = px / vel, py / vel

    local rx = math.cos( rad ) * px - math.sin( rad ) * py
	local ry = math.sin( rad ) * px + math.cos( rad ) * py

    local vcomp = EntityGetFirstComponent( enemies[i], "VelocityComponent" )
    local ccomp = EntityGetFirstComponent( enemies[i], "CharacterDataComponent" )

    if vcomp ~= nil then
        local vx, vy = ComponentGetValue2( vcomp, "mVelocity" )
        ComponentSetValue2( vcomp, "mVelocity", vx * 0.3 + rx, vy * 0.3 + ry )
    end

    if ccomp ~= nil then
        local vx, vy = ComponentGetValue2( ccomp, "mVelocity" )
        ComponentSetValue2( ccomp, "mVelocity", vx * 0.3 + rx, vy * 0.3 + ry )
    end
end end end

local executed_times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
if executed_times % 8 ~= 7 then return end

SetRandomSeed( GameGetFrameNum(), entity_id )

local length = Random( 0, 10 ) * 50 + 250
local angle = GameGetFrameNum() * 0.5

vx = math.cos( angle ) * length
vy = -math.sin( angle ) * length

shoot_projectile( entity_id, "data/entities/projectiles/deck/tentacle.xml", x, y, vx, vy )
