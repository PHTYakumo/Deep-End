dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("data/scripts/gun/gun_enums.lua")

local entity_id = GetUpdatedEntityID()
EntityKill(entity_id)									-- one-off

local player_id = EntityGetParent( entity_id )
if player_id == NULL_ENTITY or player_id == nil then return end
local x, y = EntityGetTransform( player_id )

local key = EntityGetInRadiusWithTag( x, y, 16, "de_wand_stone" )
if #key > 0 then return end								-- immune

local wand = find_the_wand_held( player_id )
if wand == NULL_ENTITY or wand == nil then return end

local comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
local c = EntityGetAllChildren( wand )
if comp == nil or c == nil then return end

local deck_capacity = ComponentObjectGetValue( comp, "gun_config", "deck_capacity" )
local deck_capacity2 = EntityGetWandCapacity( wand )

if deck_capacity == nil or deck_capacity2 == nil then return end
local always_casts = deck_capacity - deck_capacity2		-- how many always_casts -- better to be encapsulated into one function?

if #c > always_casts then
	for i=always_casts+1,#c do
		local comp2 = EntityGetFirstComponentIncludingDisabled( c[i], "ItemActionComponent" )
		
		if comp2 ~= nil then
			local inventory_full
			local plchilds = EntityGetAllChildren( player_id )

			if plchilds then for i,plchild in ipairs( plchilds ) do if EntityGetName( plchild ) == "inventory_full" then
				inventory_full = plchild
				break
			end end end									-- get player's spell inventory

			EntityRemoveFromParent( c[i] )				-- remove spells from the wand

			if inventory_full then
				EntitySetComponentsWithTagEnabled( c[i], "enabled_in_world", false )
				EntitySetComponentsWithTagEnabled( c[i], "enabled_in_hand", false )
				EntitySetComponentsWithTagEnabled( c[i], "enabled_in_inventory", true )
				EntitySetComponentsWithTagEnabled( c[i], "item_unidentified", false )
				EntityAddChild( inventory_full, c[i] )	-- move to the inventory
			else
				EntitySetComponentsWithTagEnabled( c[i], "enabled_in_hand", false )
				EntitySetComponentsWithTagEnabled( c[i], "enabled_in_inventory", false )
				EntitySetComponentsWithTagEnabled( c[i], "enabled_in_world", true )
				EntitySetComponentsWithTagEnabled( c[i], "item_unidentified", false )
				EntitySetTransform( c[i], x, y )		-- failed to getting inventory, discard spells in the world
			end
		end
	end

	GamePrint("$text_status_de_expelliarmus")
	EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y )
end