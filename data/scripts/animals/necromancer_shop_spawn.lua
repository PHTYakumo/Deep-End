dofile_once("data/scripts/lib/utilities.lua")

local entity_id, eid = GetUpdatedEntityID(), nil
local pos_x, pos_y = EntityGetTransform(entity_id)

if tonumber(GlobalsGetValue("STEVARI_DEATHS", 0)) < 3 then
	eid = EntityLoad("data/entities/animals/necromancer_shop.xml", pos_x, pos_y)
else
	eid = EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
end

local hpcomp = EntityGetFirstComponent( eid, "DamageModelComponent" )

if hpcomp ~= nil then
	local max_hp = ComponentGetValue2( hpcomp, "max_hp" ) * ( 0.5 + math.abs(pos_y) * 0.0002 )
	local hp = ComponentGetValue2( hpcomp, "hp" ) * ( 0.5 + math.abs(pos_y) * 0.0002 )

	ComponentSetValue2( hpcomp, "max_hp", max_hp )
	ComponentSetValue2( hpcomp, "hp", hp )
end

EntityKill(entity_id)
