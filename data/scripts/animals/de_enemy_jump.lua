dofile_once("data/scripts/lib/utilities.lua")

local entity_id = EntityGetParent(GetUpdatedEntityID())
if EntityHasTag( entity_id, "player_unit" ) and EntityHasTag( GetUpdatedEntityID(), "effect_protection" ) then return end

local x, y, r, sx, sy = EntityGetTransform( entity_id )
SetRandomSeed( GameGetFrameNum() - entity_id, GetUpdatedEntityID() )

ComponentSetValue2( GetUpdatedComponentID(), "execute_every_n_frame", Random( 1, 100 ) + 10 )
if Random( 1, 100 ) < 25 then sx = -sx end

local pcomp = EntityGetFirstComponent( entity_id, "PhysicsAIComponent" )
if pcomp ~= nil then PhysicsApplyForce( entity_id, Random( 1, 100 ) * sign( sx ) * 10, ( Random( 1, 100 ) - 50.5 ) * 10 ) end

local ccomp = EntityGetFirstComponent( entity_id, "ControlsComponent" )
if sx == nil or ccomp == nil then return end

x, y = sign( sx ) * 2 * Random( 1, 100 ), -2 * Random( 1, 100 )
ComponentSetValueVector2( ccomp, "mJumpVelocity", x, y )
