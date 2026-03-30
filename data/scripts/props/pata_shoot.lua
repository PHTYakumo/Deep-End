dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, r = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() - y, entity_id - x )
r = -r + math.pi * 0.5 + Random( -10, 10 ) * 0.05

local tiems = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" ) + entity_id * 2
tiems = tiems % 6 + 1

if Random( 1, 10 ) > 7 then tiems = Random( 1, 6 ) end
r = r + 0.4 - 0.4 * ( ( tiems - 1 ) % 3 )

local vx = math.cos( r ) * 120
local vy = -math.sin( r ) * 120

x = x - vx * 0.07
y = y + vy * 0.01

local pfile = "data/entities/projectiles/deck/pata_rocket_" .. tostring( tiems ) .. ".xml"
local vcomp = EntityGetFirstComponent( shoot_projectile( entity_id, pfile, x, y, vx, vy ), "ProjectileComponent" )

if vcomp == nil then return end
ComponentSetValue2( vcomp, "collide_with_world", false )
ComponentSetValue2( vcomp, "damage", 0 )
ComponentSetValue2( vcomp, "lifetime", 88 )

ComponentObjectSetValue2( vcomp, "config_explosion", "damage", 0 )
ComponentObjectSetValue2( vcomp, "config_explosion", "create_cell_probability", 0 )

local vx, vy = ComponentGetValueVector2( vcomp, "mVelocity" )
ComponentSetValueVector2( vcomp, "mVelocity", -vx, -vy )

local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "pata_times_shot" )
if comp == nil then return end

local timer = ComponentGetValue2( comp, "value_int" )
timer = timer + 1

if timer > 88 then
	EntitySetComponentsWithTagEnabled( entity_id, "pata_active", false )
	EntitySetComponentsWithTagEnabled( entity_id, "pata_inactive", true )

	timer = 0
end

ComponentSetValue( GetUpdatedComponentID(), "execute_every_n_frame", math.max( 39 - timer * 2, 9 ) )
ComponentSetValue2( comp, "value_int", timer )