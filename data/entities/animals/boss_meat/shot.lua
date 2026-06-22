dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
if not EntityHasTag( entity_id, "touchmagic_immunity" ) then EntityAddTag( entity_id, "touchmagic_immunity" ) end

local x,y = EntityGetTransform( entity_id )
SetRandomSeed( x + GameGetFrameNum(), y )

local angle = Random( 0, 99 ) * 0.01
angle = math.pi * 2 * angle

local vx = math.cos( angle ) * 90
local vy = -math.sin( angle ) * 90

shoot_projectile( entity_id, "data/entities/animals/boss_meat/acidshot_slow.xml", x, y, vx, vy )
ComponentSetValue2( GetUpdatedComponentID(), "execute_every_n_frame", Random( 2, 6 ) )