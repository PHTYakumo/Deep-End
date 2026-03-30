dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local player_id = EntityGetRootEntity( entity_id )
if player_id == entity_id then return end

local mcomps = EntityGetComponent( player_id, "VariableStorageComponent" )
if mcomps == nil then return end

for i,comp in ipairs( mcomps ) do
	local name = ComponentGetValue2( comp, "name" )

	if ( name == "deep_end_map_timer" ) then
		if ComponentGetValue2( comp, "value_int" ) < 30 then return end
		break
	end
end

local ng_now = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
local ng = ng_now

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if comps == nil then return end

for i,comp in ipairs( comps ) do
	local name = ComponentGetValue2( comp, "name" )

	if ( name == "x" ) then
		x = ComponentGetValue2( comp, "value_float" )
	elseif ( name == "y" ) then
		y = ComponentGetValue2( comp, "value_float" )
	elseif ( name == "ng" ) then
		ng = ComponentGetValue2( comp, "value_int" )
	end
end

if sign(ng) == sign(ng_now) then -- replenishment
	local eid = EntityLoad( "data/entities/items/pickup/temple_travel_mark.xml", x, y )
	local price = math.ceil( y^0.6 * 0.02 ) + math.abs( check_parallel_pos(x) ) - math.abs( ng_now )
	price = clamp( price * 500, 1000, 8000 )

	EntityAddTag( eid, "item_shop" )
	EntityAddComponent( eid, "ItemCostComponent", { cost=tostring(price), } )
	EntityAddComponent( eid, "SpriteComponent", 
		{ 
			_tags="shop_cost,enabled_in_world",
			image_file="data/fonts/font_pixel_white.xml",
			is_text_sprite="1",
			offset_x="11",
			offset_y="18",
			update_transform="1",
			update_transform_rotation="1",
			text=tostring(price),
			z_index="-1",
		}
	)
end

-- particles % audio
EntityLoad( "data/entities/particles/image_emitters/scroll_effect.xml", x, y )
GamePlaySound( "data/audio/Desktop/animals.bank", "animals/wizard/voc_attack", x, y )
GamePlaySound( "data/audio/Desktop/animals.bank", "animals/ghost/death", x, y )

-- tele
GamePrint("$chest_bad_msg_2")
EntitySetTransform( player_id, x, y )
EntityApplyTransform( player_id, x, y )
EntityKill(entity_id)