dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
EntityInflictDamage( entity_id, 1.2, "NONE", "...", "NONE", 0, 0, entity_id )

SetRandomSeed( GameGetFrameNum(),entity_id )
if Random(0,100) > 67 then return end

local x, y = EntityGetTransform( entity_id )

x = x + Random(-4,4)
y = y + Random(-4,4)

local new_entity = EntityLoad( "data/entities/animals/longerleg.xml", x, y - 12 )

edit_component( new_entity, "LuaComponent", function(comp,vars)
	vars.script_death = ""
end)

