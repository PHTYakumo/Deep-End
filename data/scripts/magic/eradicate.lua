dofile_once("data/scripts/lib/utilities.lua")

local targets = EntityGetWithTag( "mortal" )

for i,v in ipairs( targets ) do
	if EntityHasTag( v, "player_unit" ) or EntityHasTag( v, "boss" ) then
		EntityInflictDamage( v, 2.64, "NONE", "$damage_supernova", "NONE", 0, 0, v )
	else
		if EntityGetFirstComponent( v, "DamageModelComponent" ) ~= nil then EntityKill( v ) end
	end
end