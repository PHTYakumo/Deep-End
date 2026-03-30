dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pl = EntityGetParent( entity_id )

if not EntityHasTag( pl, "player_unit" ) then return end

edit_component( pl, "VelocityComponent", function(vcomp,vars)
	ComponentSetValueVector2( vcomp, "mVelocity", 0, 0 )
end)

edit_component( pl, "CharacterDataComponent", function(ccomp,vars)
	ComponentSetValueVector2( ccomp, "mVelocity", 0, 0 )
end)