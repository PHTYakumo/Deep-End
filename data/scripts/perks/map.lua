dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( entity_id )
y = y - 4 -- offset to middle of character

local is_moving, timer, timercomp = false, 0
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

if comps ~= nil then for i,comp in ipairs( comps ) do
	local n = ComponentGetValue2( comp, "name" )

	if n == "map_timer" then
		timer = ComponentGetValue2( comp, "value_int" )
		timercomp = comp
		break
	end
end end

if timercomp ~= nil and entity_id ~= player_id then
	component_read( EntityGetFirstComponent( player_id, "ControlsComponent" ),
	{ mButtonDownDown = false, mButtonDownUp = false, mButtonDownLeft = false, mButtonDownRight = false, mButtonDownJump = false, mButtonDownFire = false },
	function(controls_comp)
		is_moving = controls_comp.mButtonDownDown or controls_comp.mButtonDownUp or controls_comp.mButtonDownLeft or controls_comp.mButtonDownRight or controls_comp.mButtonDownJump or controls_comp.mButtonDownFire or false
	end )
	
	if is_moving == false then
		local roll_interval, trigger_time, total_lyrics = 150, 180, 14
		local total_loop = roll_interval * total_lyrics + trigger_time
		local maxtime = total_loop + roll_interval
		timer = math.min( timer + 1, maxtime + 1 )
		
		if timer > trigger_time and timer < total_loop then
			local alan_walker = math.floor( ( timer - trigger_time) / roll_interval  ) + 1 -- figure out the corresponding lyrics
			local faded = tostring( alan_walker )
			local where_r_u_now = 30 * (-1) ^ alan_walker -- figure ou where it should be displayed

			GameCreateSpriteForXFrames( "data/items_gfx/deep_end_map/lyrics_" .. alan_walker .. ".png", x, y + where_r_u_now, true, 0, 0, 1, true )
		end

		if timer == total_loop then
			PhysicsApplyTorque( EntityLoad( "data/entities/items/pickup/golden_hamis.xml", x, y - 24 ), 666 )

			local ui_comp = EntityGetFirstComponent( entity_id, "UIIconComponent" )
			if ui_comp ~= nil and ui_comp ~= 0 then EntitySetComponentIsEnabled( entity_id, ui_comp, false ) end

			EntityRemoveFromParent( entity_id )
			EntityKill( entity_id ) -- won't remove the icon
		end

		-- if timer > maxtime then timer = trigger_time end -- loop
	else
		timer = 0
	end
	
	ComponentSetValue2( timercomp, "value_int", timer )
end

--[[

EntityAddComponent2( id, "SpriteComponent",
{
	image_file="data/fonts/font_pixel_white.xml",
	is_text_sprite=true,
	offset_x=sprite_offset_x,
	offset_y=sprite_offset_y,
	text = "", 
	update_transform=true,
	update_transform_rotation=false,
	has_special_scale=true,
	special_scale_x=sprite_scale_x,
	special_scale_y=sprite_scale_y,
	alpha=sprite_alpha,
})

]]--