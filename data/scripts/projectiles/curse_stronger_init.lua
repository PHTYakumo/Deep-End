dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )
local x,y = EntityGetTransform( root_id )

if EntityHasTag( root_id, "curse_NOT" ) then
	EntityKill( entity_id )
	return
end

if EntityHasTag( root_id, "effect_CURSE" ) then
	local c = EntityGetAllChildren( root_id )
	if c ~= nil then
		for i,v in ipairs( c ) do
			if EntityHasTag( v, "effect_CURSE" ) then
				local comp = EntityGetFirstComponent( v, "LifetimeComponent", "effect_curse_lifetime" )
				
				if comp ~= nil then
					ComponentSetValue2( comp, "creation_frame", GameGetFrameNum() )
					ComponentSetValue2( comp, "kill_frame", GameGetFrameNum() + 240 )
					
					comp = EntityGetFirstComponent( v, "VariableStorageComponent", "effect_curse_damage" )
					
					if comp ~= nil then
						local damage = ComponentGetValue2( comp, "value_float" )
						damage = damage + 0.16
						ComponentSetValue2( comp, "value_float", damage )
					end
				end
				
				break
			end
		end
	end
else
	EntityAddChild( root_id, EntityLoad( "data/entities/misc/curse_stronger.xml", x, y ) )
	EntityAddTag( root_id, "effect_CURSE" )
end

EntityKill( entity_id )