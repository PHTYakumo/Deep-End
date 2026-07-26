dofile_once("data/scripts/lib/utilities.lua")

function shot( eid )
	if eid ~= nil and eid ~= NULL_ENTITY then
		local c = EntityGetFirstComponent( eid, "ProjectileComponent" )
		local x, y = EntityGetTransform( eid )
		
		if c ~= nil and not EntityHasTag( eid, "projectile_heal" ) then
			local extra_damage = clamp( math.abs(y) * 0.0001, 0.01, 100 )
			ComponentSetValue2( c, "damage", ComponentGetValue2( c, "damage" ) + extra_damage )
		end
	end
end

