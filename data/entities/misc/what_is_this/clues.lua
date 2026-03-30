dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local clues = {
	"Reforge The Bin",
	"Reactivate The Portal",
	"Remove The God",
	"Rewind The Regression",
	"Reach The Bound",
	"Reveal The ■"
}

for i=1,#clues do
	EntityAddComponent2( entity_id, "SpriteComponent",
	{
		_tags="enabled_in_world",
		image_file="data/fonts/font_pixel_runes.xml", 
		is_text_sprite=true, 
		offset_x=0, 
		offset_y=-15*i, 
		update_transform=true, 
		update_transform_rotation=true,
		text=clues[i], 
		has_special_scale=true,
		special_scale_x=1.2,
		special_scale_y=1.2,
		z_index=0,
	})
end