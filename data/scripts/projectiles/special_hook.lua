dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform( entity_id )
local owner_id = 0

local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if comp ~= nil then
	owner_id = ComponentGetValue2( comp, "mWhoShot" )

	edit_component( owner_id, "ControlsComponent", function(mcomp,vars)
		x,y = ComponentGetValueVector2( mcomp, "mMousePosition")
	end)
end

if owner_id ~= nil and owner_id ~= NULL_ENTITY then
	-- if not EntityHasTag( owner_id, "player_unit" ) then owner_id = EntityGetClosestWithTag( x, y, "player_unit") end
	if owner_id == nil or owner_id == NULL_ENTITY or EntityHasTag( owner_id, "wand_ghost" ) then return end

	local px,py = EntityGetTransform( owner_id )
	local dir = 0 - math.atan2( y - py, x - px )
	local vel_x = math.cos( dir ) * 660
	local vel_y = 0 - math.sin( dir ) * 660
	
	edit_component( owner_id, "VelocityComponent", function(vcomp,vars)
		ComponentSetValueVector2( vcomp, "mVelocity", vel_x, vel_y )
	end)
	
	edit_component( owner_id, "CharacterDataComponent", function(ccomp,vars)
		ComponentSetValueVector2( ccomp, "mVelocity", vel_x, vel_y )
	end)
end
