dofile_once("data/scripts/lib/utilities.lua")

if not ModSettingGet( "DEEP_END.BOSS_GUIDE" ) then return end

local entity_id, icon_path = GetUpdatedEntityID(), "mods/deep_end/files/weak_point_icon/"
local x, y = EntityGetTransform( entity_id )

local icon_list = {
	"vulnerable/electricity",
	"vulnerable/curse_wither_electricity",
	"vulnerable/curse_wither_melee",
	"curable/explosion",
	"curable/ice",
	"curable/fire",
	"curable/radioactive",
	"curable/poison"
}

for i=1,#icon_list do
	local eid = EntityLoad( icon_path .. "weak_point_icon.xml", x, y )
	EntityAddChild( entity_id, eid )

	local comp = EntityGetFirstComponent( eid, "UIIconComponent" )
	if comp ~= nil then ComponentSetValue2( comp, "icon_sprite_file", icon_path .. icon_list[i] .. ".png" ) end

	if i < #icon_list then EntityAddChild( entity_id, EntityLoad( icon_path .. "weak_point_icon.xml", x, y ) ) end
end
