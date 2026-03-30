dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
local vx, vy = ComponentGetValueVector2( comp, "mVelocity" )

local pl = get_players()[1]
if pl == nil then return end

local cx, cy = ComponentGetValueVector2( EntityGetFirstComponent( pl, "ControlsComponent" ), "mMousePosition" )
cx, cy = cx - x, cy - y

local dist = math.max( get_magnitude( cx, cy ), 1 )
local vel = get_magnitude( vx, vy )

vx = cx / dist * vel + vx 
vy = cy / dist * vel + vy

local coeff = get_magnitude( vx, vy )
if coeff < 0.1 then vx, vy, coeff = cx, cy, dist end

vx = vx / coeff * vel
vy = vy / coeff * vel

ComponentSetValueVector2( comp, "mVelocity", vx, vy )