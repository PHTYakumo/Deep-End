dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 400

local eyes = EntityGetInRadiusWithTag( x, y, radius, "evil_eye" )
local found = 0

if ( #eyes >= 3 ) then
	for i,v in ipairs( eyes ) do
		local t = EntityGetFirstComponent( v, "LightComponent", "magic_eye_check" )
		
		if ( t ~= nil ) then found = found + 1 end
	end
end

local t = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
local ultra_light = EntityGetInRadiusWithTag( x, y, radius, "ultra_light" )

if ( found >= 3 ) or ( #ultra_light >= 18 ) then
	if ( t == nil ) then
		EntitySetComponentsWithTagEnabled( entity_id, "magic_eye", true )
		EntityLoad( "data/entities/particles/poof_blue.xml", x, y )
	end
else
	if ( t ~= nil ) then
		EntitySetComponentsWithTagEnabled( entity_id, "magic_eye", false )
		EntityLoad( "data/entities/particles/poof_blue.xml", x, y )
	end
end