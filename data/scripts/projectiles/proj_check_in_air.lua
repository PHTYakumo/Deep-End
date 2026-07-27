dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local vscomp = EntityGetFirstComponent( entity_id, "VariableStorageComponent" )

if ComponentGetValue2( vscomp, "name" ) ~= "substantialize" then return end
local check = ComponentGetValue2( vscomp, "value_int" )

if check <= 0 then EntitySetComponentIsEnabled( entity_id, EntityGetFirstComponentIncludingDisabled( entity_id, "LuaComponent" ), true ) end
local x, y = EntityGetTransform( entity_id )

local velcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
local vx, vy, fr = 0, 0, 0

if velcomp ~= nil then
	vx, vy = ComponentGetValue2( velcomp, "mVelocity" )
	fr = ComponentGetValue2( velcomp, "air_friction" )
end

vx = x + vx * (1.1)^(-fr) -- fit v(t+6) = v(t) * ( 1 - fr/60 )^6
vy = y + vy * (1.1)^(-fr)

local success = RaytracePlatforms( x, y, vx, vy )
if not success then ComponentSetValue2( vscomp, "value_int", check - 1 ) end

