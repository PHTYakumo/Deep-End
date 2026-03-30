dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

for i=1,3 do
	local eid
	
	eid = EntityLoad( "data/entities/animals/boss_wizard/orbit/wizard_orb_death.xml", x, y )
	
	if ( eid ~= nil ) then
		EntityAddChild( entity_id, eid )
		
		local comp = EntityGetFirstComponent( eid, "VariableStorageComponent", "wizard_orb_id" )
		if ( comp ~= nil ) then
			ComponentSetValue2( comp, "value_int", i-1 )
		end
	end
end

for i=1,21 do
	local eid
	
	eid = EntityLoad( "data/entities/animals/boss_wizard/orbit/wizard_orb_blood.xml", x, y )
	
	if ( eid ~= nil ) then
		EntityAddChild( entity_id, eid )
		
		local comp = EntityGetFirstComponent( eid, "VariableStorageComponent", "wizard_orb_id" )
		if ( comp ~= nil ) then
			ComponentSetValue2( comp, "value_int", i-1 )
		end
	end
end

for i=1,3 do
	local eid
	
	eid = EntityLoad( "data/entities/animals/boss_wizard/orbit/wizard_orb_blood_ex.xml", x, y )
	
	if ( eid ~= nil ) then
		EntityAddChild( entity_id, eid )
		
		local comp = EntityGetFirstComponent( eid, "VariableStorageComponent", "wizard_orb_id" )
		if ( comp ~= nil ) then
			ComponentSetValue2( comp, "value_int", i-1 )
		end
	end
end
