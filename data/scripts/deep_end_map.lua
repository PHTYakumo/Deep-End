dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/de_input.lua")

local entity_id = GetUpdatedEntityID()
local x, y, pr, psx, psy = EntityGetTransform( entity_id )

x = math.floor( x * 100 ) * 0.01
y = math.floor( y * 100 ) * 0.01 - 4.00

--[[

stage	depth	x
2		1910	-256
3		4982
4		9078
5		14198
6		19830
7		25974
8		32630

<< starting point >>
227		-80

<< under ground sun >>
260		37775

<< forge >>
1540	9640

<< boss >>
3546	40242

<< pyramid >>
9985	-1280

<< dragon >>
2348	12080

<< teleroom >>
3835	12080
(3)	(6)
(2)	(5)
(1)	(4)

<< pit >>
4158	818

<< bosses >>
-12230	13100	(1)
14080	10960	(2)
12740	15155	(3)
-14075	180		(4)
6920	13580	(5)
-4660	815		(6)

// 72:1 //

]]---

function DE_map_locate( x, y, lx, ly, stage, type )
	local dx, dy = ( lx - x ) * 0.01388889, ( ly - y ) * 0.01388889
	local sprite_file = "data/items_gfx/deep_end_map/" .. type .. "_" .. tostring(stage) .. ".png"

	if math.abs( dy ) < 400 then GameCreateSpriteForXFrames( sprite_file, x+dx, y+dy, true, 0, 0, 1, true ) end
end

local timer, timercomp = 0
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

if comps ~= nil then for i,comp in ipairs( comps ) do
	local n = ComponentGetValue2( comp, "name" )

	if n == "deep_end_map_timer" then
		timer = ComponentGetValue2( comp, "value_int" )
		timercomp = comp
		break
	end
end end

local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
local show_de_map = true

if newgame_n ~= 0 or y < -18000 or y > 54000 then show_de_map = false end

if timercomp ~= nil then
	local year, month, day = GameGetDateAndTimeLocal()
	local cx, cy = EntityGetTransform( entity_id )
	local key = ModSettingGet( "DEEP_END.MAP_KEY" )

	local call_map, close, map_speed = false, 50, 1
	local is_moving, is_down ,is_up, is_hover = false, false, false, false

	component_read( 
		EntityGetFirstComponent( entity_id, "ControlsComponent" ), 
		{ 
			mButtonDownDown = false, mButtonDownUp = false, mButtonDownLeft = false, mButtonDownRight = false, 
			mButtonDownJump = false, mButtonDownFire = false 
		}, 
		function(controls_comp)
			is_moving = controls_comp.mButtonDownUp or controls_comp.mButtonDownLeft or controls_comp.mButtonDownRight 
			or controls_comp.mButtonDownJump or controls_comp.mButtonDownFire or false

			is_down = controls_comp.mButtonDownDown or false

			is_up = controls_comp.mButtonDownUp or controls_comp.mButtonDownJump or false

			is_hover = controls_comp.mButtonDownLeft and controls_comp.mButtonDownRight or false
		end 
	)

	if is_hover then
		edit_component( entity_id, "VelocityComponent", function(vcomp,vars)
			local fx,fy = ComponentGetValue2( vcomp, "mVelocity" )
			ComponentSetValueVector2( vcomp, "mVelocity", 0, fy )
		end )

		edit_component( entity_id, "CharacterDataComponent", function(ccomp,vars)
			local fx,fy = ComponentGetValue2( ccomp, "mVelocity" )
			ComponentSetValueVector2( ccomp, "mVelocity", 0, fy )
		end )
	end

	edit_component( entity_id, "ControlsComponent", function(mcomp,vars)
        cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
    end )

	if cx ~= nil and cy ~= nil then close = math.abs( x - cx ) + math.abs( y - cy ) end

	if string.len(key) > 0 then
		map_speed = 10
		call_map = de_key_judge( key, 0 )
	else
		call_map = ( ( not is_moving ) and ( is_down ) ) or ( is_hover )
		if is_hover then map_speed = 4 end
	end
	
	if call_map then 
		local ttm = timer / map_speed
		timer = timer + map_speed
		if timer >= 9999 then timer = 300 end

		if timer > 30 and ModSettingGet( "DEEP_END.LOCATE_MOUNT" ) then
			if show_de_map then
				local mount_depth = { -80, 1910, 4982, 9078, 14198, 19830, 25974, 32630, 37775, 40242, 9640 }
				local mount_x = { 227, -256, -256, -256, -256, -256, -256, -256, 260, 3546, 1540 }

				local dx = math.floor( - ( 256 + x ) / 72 )

				if dx < -264 then
					GameCreateSpriteForXFrames( "data/items_gfx/deep_end_map/too_right.png", x, y-36, true, 0, 0, 1, true )
				elseif dx > 264 then
					GameCreateSpriteForXFrames( "data/items_gfx/deep_end_map/too_left.png", x, y-36, true, 0, 0, 1, true )
				else
					for i=1,#mount_depth do DE_map_locate( x, y, mount_x[i], mount_depth[i], i, "mount" ) end

					if EntityHasTag( entity_id, "deep_end_map_plus" ) then
						mount_depth = { -1280, 12080, 12080, 818, 13100, 10960, 15155, 180, 13500, 815 }
						mount_x = { 9985, 2348, 3835, 4158, -12230, 14080, 12740, -14275, 6920, -4660 }

						for i=1,#mount_depth do DE_map_locate( x, y, mount_x[i], mount_depth[i], i, "boss" ) end
					end

					if close > 20 then GameCreateSpriteForXFrames( "data/items_gfx/deep_end_map/cross.png", cx, cy, true, 0, 0, 1, true )
					else GameCreateSpriteForXFrames( "data/items_gfx/deep_end_map/cross_.png", x, y, true, 0, 0, 1, true ) end
				end
			else
				if close > 20 then GameCreateSpriteForXFrames( "data/items_gfx/deep_end_map/cross.png", cx, cy, true, 0, 0, 1, true )
				else GameCreateSpriteForXFrames( "data/items_gfx/deep_end_map/cross_.png", x, y, true, 0, 0, 1, true ) end
			end
		end

		if timer > 15 and ttm < 60 and close >= 20 then
			local sprite_me = ""

			if ( month == 4 and day == 1 ) or ( month == 9 and  day == 9 ) then sprite_me = "_fool" end
			GameCreateSpriteForXFrames( "data/items_gfx/deep_end_map/pog" .. sprite_me .. ".png", x, y, true, 0, 0, 1, true )

			if ( month == 4 and day == 1 ) or ( month == 9 and day == 9 ) then sprite_me = "fool_" end
			GameCreateSpriteForXFrames( "data/items_gfx/deep_end_map/pog_" .. sprite_me .. ".png", x, y, true, 0, 0, 1, true )
		else
			GameCreateSpriteForXFrames( "data/items_gfx/deep_end_map/_pog.png", x, y, true, 0, 0, 1, true )
		end

		if timer == 30 then
			local text = GameTextGetTranslatedOrNot("$deep_end_pos_broadcast_1")
			text = text .. tostring(x) .. ", " .. tostring(y)

			GamePrint( text )

			-- reset gravitation
			local gcomp = EntityGetFirstComponent( entity_id, "CharacterPlatformingComponent" )
			if gcomp ~= nil then ComponentSetValue2( gcomp, "pixel_gravity", math.abs( ComponentGetValue2( gcomp, "pixel_gravity" ) ) ) end

			x, y, pr, psx, psy = EntityGetTransform( entity_id )
			EntitySetTransform( entity_id, x, y, pr, psx, math.abs( psy ) )

			EntitySetComponentIsEnabled( entity_id, EntityGetFirstComponentIncludingDisabled( entity_id, "InventoryGuiComponent" ), false )
		end

		if timer >= 30 and ttm % 30 == 10 then
			local text = GameTextGetTranslatedOrNot("$deep_end_pos_broadcast_1")

			if close >= 20 then
				local cur_x, cur_y = ( cx - x ) * 72 + x, ( cy - y ) * 72 + y
				text = GameTextGetTranslatedOrNot("$deep_end_pos_broadcast_2") .. tostring(cur_x) .. ", " .. tostring(cur_y)
			else
				text = text .. tostring(x) .. ", " .. tostring(y)
			end

			GamePrint( text )
		end
	else
		timer = 0

		EntitySetComponentIsEnabled( entity_id, EntityGetFirstComponentIncludingDisabled( entity_id, "InventoryGuiComponent" ), true )
	end

	if InputIsKeyDown(58) then EntitySetComponentIsEnabled( entity_id, EntityGetFirstComponentIncludingDisabled( entity_id, "InventoryGuiComponent" ), false ) end

	local fcomp = EntityGetFirstComponent( entity_id, "CharacterDataComponent" )

	if fcomp ~= nil then
		local on_ground = ComponentGetValue2( fcomp, "is_on_ground" )
		local flight = ComponentGetValue2( fcomp, "mFlyingTimeLeft" )
		local on_ceiling = RaytracePlatforms( x, y, x, y-5 )

		if ( is_up or on_ground ) and psy <= 0 then
			local fmult = 33
			if on_ground then fmult = -33 end

			if flight > 0 or on_ground then
				edit_component( entity_id, "VelocityComponent", function(vcomp,vars)
					local fx,fy = ComponentGetValue2( vcomp, "mVelocity" )
					ComponentSetValueVector2( vcomp, "mVelocity", fx, fy * 23/31 + math.max(flight,3) * fmult )
				end )

				edit_component( entity_id, "CharacterDataComponent", function(ccomp,vars)
					local fx,fy = ComponentGetValue2( ccomp, "mVelocity" )
					ComponentSetValueVector2( ccomp, "mVelocity", fx, fy * 23/31 + math.max(flight,3) * fmult ) -- default drop speed: 350
				end )
			end
		end

		if is_down then ComponentSetValue2( fcomp, "effect_hit_ground", true )
		else ComponentSetValue2( fcomp, "effect_hit_ground", false ) end

		if on_ceiling and psy < 0 and ( not is_up ) then ComponentSetValue2( fcomp, "mFlyingTimeLeft", flight + 0.05 ) end
	end
	
	ComponentSetValue2( timercomp, "value_int", timer )
end