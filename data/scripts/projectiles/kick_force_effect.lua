dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local pl = get_players()[1]

local x, y = EntityGetTransform( pl )
local cx, cy = ComponentGetValueVector2( EntityGetFirstComponent( pl, "ControlsComponent" ), "mMousePosition" )

cx, cy = cx - x, cy - y
x, y = EntityGetTransform( entity_id )

local projs = EntityGetInRadiusWithTag( x, y, 12.5, "projectile" )

if #projs > 0 then for i=1,#projs do
    local vcomp = EntityGetFirstComponent( projs[i], "VelocityComponent" )

	if vcomp ~= nil and not EntityHasTag( projs[i], "resist_repulsion" ) then
		local vx, vy = ComponentGetValueVector2( vcomp, "mVelocity" )
        vel = get_magnitude( vx, vy ) / math.max( get_magnitude( cx, cy ), 1 )
        
        cx, cy = cx * vel, cy * vel
        ComponentSetValueVector2( vcomp, "mVelocity", cx, cy )
	end
end end
