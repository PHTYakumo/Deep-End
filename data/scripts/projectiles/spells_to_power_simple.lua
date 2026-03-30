dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( entity_id )

local who_shot
local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

if ( comp ~= nil ) then
	who_shot = ComponentGetValue2( comp, "mWhoShot" )
end

if ( who_shot ~= nil ) and ( comp ~= nil ) then
	local damage = ComponentGetValue2( comp, "damage" ) * 1.6
	local expdamage = ComponentObjectGetValue2( comp, "config_explosion", "damage" ) * 1.2
	
	ComponentSetValue2( comp, "damage", damage ) 
	ComponentObjectSetValue2( comp, "config_explosion", "damage", expdamage )

	-- GamePrint(tostring(entity_id))
end