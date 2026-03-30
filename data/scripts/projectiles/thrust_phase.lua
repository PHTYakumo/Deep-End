dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, angle, sx, sy = EntityGetTransform( entity_id )

local times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
SetRandomSeed( GameGetFrameNum() - entity_id, x + y )

if times == 1 then
	local velcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
	if velcomp == nil then return end

	sx, sy = ComponentGetValueVector2( velcomp, "mVelocity" )

	local projcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
	if projcomp == nil then return end

	ComponentSetValue2( projcomp, "damage", ComponentGetValue2( projcomp, "damage" ) * 0.1 )
elseif times == 4 then
	local comps = EntityGetComponent( entity_id, "ParticleEmitterComponent" )

	if comps ~= nil then for i,comp in ipairs( comps ) do
		EntitySetComponentIsEnabled( entity_id, comp, false )
	end end
end

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

if comps ~= nil then for i,comp in ipairs( comps ) do
	local n = ComponentGetValue2( comp, "name" )

	if n == "sx" then
		if times == 1 then ComponentSetValue2( comp, "value_float", x )
		else sx = ComponentGetValue2( comp, "value_float" ) end
	elseif n == "sy" then
		if times == 1 then ComponentSetValue2( comp, "value_float", y )
		else sy = ComponentGetValue2( comp, "value_float" ) end
	elseif n == "angle" then
		if times == 1 then ComponentSetValue2( comp, "value_float", -math.atan2(sx,sy) )
		else angle = ComponentGetValue2( comp, "value_float" ) + 0.025 * ( Random(-6,6) + Random(-6,6) ) end
	end
end end

if times <= 1 then return end
if times == 9 then EntitySetComponentIsEnabled( entity_id, EntityGetFirstComponentIncludingDisabled( entity_id, "SpriteParticleEmitterComponent" ), true ) end

-- local targets = EntityGetInRadiusWithTag( sx, sy, 33, "enemy" )
-- if targets[1] ~= nil then sx,sy = EntityGetTransform( targets[Random(1,#targets)] ) end

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local px, py = ComponentGetValueVector2( comp, "mVelocity" )
	local speed = get_magnitude(px,py)

	px = -math.sin(angle) * speed
	py = math.cos(angle) * speed

	ComponentSetValueVector2( comp, "mVelocity", px, py )

	sx = sx - px * 0.005
	sy = sy - py * 0.005

	EntitySetTransform( entity_id, sx, sy )
	EntityApplyTransform( entity_id, sx, sy )
end)