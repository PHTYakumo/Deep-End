dofile_once("data/scripts/lib/utilities.lua")

local entity_id, buff_root_id, buff_total = GetUpdatedEntityID(), nil, 0
local root_id = EntityGetRootEntity( entity_id )

if root_id ~= nil and root_id ~= NULL_ENTITY and root_id ~= entity_id and EntityHasTag( root_id, "de_effect_charge" ) then
	local px, py = EntityGetTransform( entity_id )
	local c = EntityGetAllChildren( root_id )

	if c ~= nil then for i,child in ipairs( c ) do
		if EntityHasTag( child, "de_effect_charge" ) then
			buff_total = buff_total + 1

			local comp = EntityGetFirstComponent( child, "GameEffectComponent" )
			if comp ~= nil then ComponentSetValue2( comp, "frames", 90 ) end

			buff_root_id = child
		elseif EntityHasTag( child, "de_effect_charge_side" ) then
			buff_total = buff_total + 1

			local comp = EntityGetFirstComponent( child, "GameEffectComponent" )
			if comp ~= nil then ComponentSetValue2( comp, "frames", 90 ) end
		end

		--[[
		if buff_root_id ~= nil and buff_total >= 64 then
			EntityKill( entity_id )
			break
			return
		end
		]]--
	end end
end

if buff_root_id ~= nil and buff_total < 64 then
	local comp = EntityGetFirstComponent( buff_root_id, "UIIconComponent" )

	if comp ~= nil then
		local name = GameTextGetTranslatedOrNot("$status_mana_regeneration")
		ComponentSetValue2( comp, "name", name .. " x" .. tostring( buff_total + 1 ) )
	end

	EntityAddChild( root_id, EntityLoad( "data/entities/misc/mana_from_spell_side.xml", px, py ) )
end

EntityKill( entity_id )