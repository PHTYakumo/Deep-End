dofile_once("data/scripts/lib/utilities.lua")

local entity_id, do_tp = GetUpdatedEntityID(), false
if EntityGetFirstComponent( entity_id, "SpriteComponent", "shop_cost" ) ~= nil then return end

local x, y = EntityGetTransform( entity_id )
local players = EntityGetInRadiusWithTag( x, y, 15, "player_unit" )

if #players == 0 then return end
local ng_now, ng = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") ), 0

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if comps == nil then return end

for i,comp in ipairs( comps ) do
	local name = ComponentGetValue2( comp, "name" )

	if name == "x" then x = ComponentGetValue2( comp, "value_float" )
	elseif name == "y" then y = ComponentGetValue2( comp, "value_float" )
	elseif name == "ng" then ng = ComponentGetValue2( comp, "value_int" ) end
end

for i=1,#players do
	local mcomps = EntityGetComponent( players[i], "VariableStorageComponent" )
	local tp_me = false

	if mcomps ~= nil then for i,comp in ipairs( mcomps ) do if ComponentGetValue2( comp, "name" ) == "deep_end_map_timer" then
		if ComponentGetValue2( comp, "value_int" ) > 30 then tp_me = true end
		break
	end end end

	if tp_me then
		do_tp = true

		-- tele
		GamePrint("$chest_bad_msg_2")
		EntitySetTransform( players[i], x, y )
		EntityApplyTransform( players[i], x, y )

		-- particles % audio
		EntityLoad( "data/entities/particles/image_emitters/scroll_effect.xml", x, y )
		GamePlaySound( "data/audio/Desktop/animals.bank", "animals/wizard/voc_attack", x, y )
		GamePlaySound( "data/audio/Desktop/animals.bank", "animals/ghost/death", x, y )
	end
end

if not ( do_tp and EntityHasTag( entity_id, "teleportable_NOT" ) ) then return end
EntityRemoveTag( entity_id, "teleportable_NOT" )

-- delayed kill
EntityAddComponent( entity_id, "LuaComponent", 
{
	script_source_file = "data/scripts/items/item_fade_and_delete.lua",
	execute_every_n_frame = "3",
} )

-- replenishment
if sign(ng) == sign(ng_now) then
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