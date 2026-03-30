dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

edit_component( entity_id, "VelocityComponent", function(vcomp,vars)
	ComponentSetValueVector2( vcomp, "mVelocity", 0, 0 )
end)

local enemies = EntityGetInRadiusWithTag( x, y, 36, "homing_target")
if not enemies then return end

for i=1,#enemies do
	local eid = enemies[i]

	if ( eid ~= NULL_ENTITY ) and ( eid ~= player_id ) then
		local px,py = EntityGetTransform( eid )
		
		px = ( x - px ) * 2
		py = ( y - py ) * 2
	
		edit_component( eid, "VelocityComponent", function(vcomp,vars)
			local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity")
			ComponentSetValueVector2( vcomp, "mVelocity", px, py )
		end)
	
		edit_component( eid, "CharacterDataComponent", function(ccomp,vars)
			local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity")
			ComponentSetValueVector2( ccomp, "mVelocity", px, py )
		end)
	end
end