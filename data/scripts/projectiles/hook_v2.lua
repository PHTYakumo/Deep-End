dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local owner_id = 0

local x, y = EntityGetTransform( entity_id )
local px, py = x, y

local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if pcomp ~= nil then owner_id = ComponentGetValue2( pcomp, "mWhoShot" ) end

if owner_id ~= nil and owner_id ~= NULL_ENTITY then
	px, py = EntityGetTransform( owner_id )
	-- py = py - 4

	local dist = get_magnitude( y - py, x - px )
	if dist < 10 then EntityKill( entity_id ) end 

	local dir = -math.atan2( y - py, x - px )
	dist = clamp( dist * 5, 375, 750 )

	local vcomp = EntityGetFirstComponent( owner_id, "VelocityComponent" )
	local ccomp = EntityGetFirstComponent( owner_id, "CharacterDataComponent" )

	if vcomp ~= nil and ccomp ~= nil then
		px, py = ComponentGetValueVector2( vcomp, "mVelocity" )
		px, py = math.cos( dir ) * dist, -math.sin( dir ) * dist

		ComponentSetValueVector2( vcomp, "mVelocity", px, py )
		ComponentSetValueVector2( ccomp, "mVelocity", px, py )
	end
end
