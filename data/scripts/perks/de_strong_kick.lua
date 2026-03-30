dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local ccomp = EntityGetFirstComponent( entity_id, "ControlsComponent" )
if x == nil or ccomp == nil then return end

local cx, cy = ComponentGetValueVector2( ccomp, "mMousePosition" )
cx, cy = cx - x, cy - y

local do_kick = ComponentGetValue2( ccomp, "mButtonDownKick" )
local kick_frame = ComponentGetValue2( ccomp, "mButtonFrameKick" )

kick_frame = GameGetFrameNum() - kick_frame - 5

if do_kick and kick_frame == -4 then
	EntityAddChild( entity_id, EntityLoad( "data/entities/misc/effect_protection_all_shorter.xml", x, y ) )
elseif do_kick and kick_frame % 20 == 15 then
	local vel = 225 / math.max( get_magnitude( cx, cy ), 1 )
	cx, cy = cx * vel, cy * vel

	shoot_projectile( entity_id, "data/entities/misc/perks/thermal_impact.xml", x, y, cx, cy )
end