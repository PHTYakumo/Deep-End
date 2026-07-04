dofile_once("data/scripts/lib/utilities.lua")
local entity_id, e = GetUpdatedEntityID(), nil
local pos_x, pos_y = EntityGetTransform( entity_id )

if ProceduralRandomf(pos_x, pos_y) < 0.5 then
	-- fruit
	e = EntityLoad( "data/entities/props/root_grower_fruit.xml", pos_x, pos_y)
	EntitySetTransform(e, pos_x, pos_y, ProceduralRandomf(pos_x, pos_y, -math.pi * 0.5, math.pi * 0.5))
else
	-- leaf
	e = EntityLoad( "data/entities/props/root_grower_leaf.xml", pos_x, pos_y)
	EntitySetTransform(e, pos_x, pos_y, ProceduralRandomf(pos_x, pos_y, math.pi * 2))
end

EntityAddComponent(e, "LifetimeComponent", { lifetime="2000", })