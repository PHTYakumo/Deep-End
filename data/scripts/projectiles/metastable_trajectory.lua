dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local velcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
if velcomp == nil then return end

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if comps == nil then return end

local sx, sy, angle, phasing = x, y, 314.159, false

for i,comp in ipairs( comps ) do
	local n = ComponentGetValue2( comp, "name" )

	if n == "sx" then
		sx = ComponentGetValue2( comp, "value_float" )
	elseif n == "sy" then
		sy = ComponentGetValue2( comp, "value_float" )
	elseif n == "angle" then
		angle = ComponentGetValue2( comp, "value_float" )
	elseif n == "phasing" then
		phasing = ComponentGetValue2( comp, "value_bool" )
	end
end

if ( sx == 0 and sy == 0 ) or angle > 314.159 then return end
if math.abs(angle) < 3.125 then angle = angle - sign(angle) * 0.08 end -- The shaking animation of the wand shooting also affects accuracy

local vx, vy = ComponentGetValueVector2( velcomp, "mVelocity" )
local speed = 55

if phasing then
	local projcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
	local phasing_f = 0.25

	if projcomp ~= nil then
		ComponentSetValue2( projcomp, "velocity_sets_scale", true )
    	ComponentSetValue2( projcomp, "velocity_sets_scale_coeff", 0.5 )
	end

	x = x + vx * phasing_f
	y = y + vy * phasing_f

	EntitySetTransform( entity_id, x, y, angle, 0.2, 1 )
	EntityApplyTransform( entity_id, x, y, angle, 0.2, 1 )
else
	local speed_f = 0.3 - math.abs( angle ) * 0.05
	speed = 325 * ProceduralRandomf( sx-y, sy-x, 1, 3 )

	speed_f = speed_f * speed * 0.001
	angle = angle + ProceduralRandomf( sx-y, sy-x, -speed_f, speed_f ) - 0.05
end

ComponentSetValueVector2( velcomp, "mVelocity", -math.sin( angle ) * speed, math.cos( angle ) * speed )