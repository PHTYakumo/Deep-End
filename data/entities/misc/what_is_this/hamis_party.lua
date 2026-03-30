dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("data/scripts/gun/gun_enums.lua")

local player_id, dude = EntityGetParent( GetUpdatedEntityID() ), 0
if player_id == NULL_ENTITY or player_id == nil then return end

local x, y, r, sx, sy = EntityGetTransform( player_id )
-- EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y )

local plchilds = EntityGetAllChildren( player_id )
local inventory_quick, inventory_full

if plchilds then for i,plchild in ipairs( plchilds ) do
	if EntityGetName( plchild ) == "inventory_quick" then inventory_quick = EntityGetAllChildren( plchild )
	elseif EntityGetName( plchild ) == "inventory_full" then inventory_full = EntityGetAllChildren( plchild ) end
end end

if inventory_quick ~= nil and #inventory_quick > 0 then for i,wand in ipairs( inventory_quick ) do
	if EntityHasTag( wand, "wand" ) and EntityGetFirstComponentIncludingDisabled( wand, "ItemComponent") ~= nil then
		local comp, c, deck_capacity, deck_capacity2
		local always_casts = -999
		
		local comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
		local c = EntityGetAllChildren( wand )

		if comp ~= nil and c ~= nil then
			deck_capacity = ComponentObjectGetValue( comp, "gun_config", "deck_capacity" )
			deck_capacity2 = EntityGetWandCapacity( wand )
		end

		if deck_capacity ~= nil and deck_capacity2 ~= nil then always_casts = deck_capacity - deck_capacity2 end

		if always_casts ~= -999 and #c > always_casts then for i=always_casts+1,#c do
			if EntityGetFirstComponentIncludingDisabled( c[i], "ItemActionComponent" ) ~= nil then
				EntityRemoveFromParent( c[i] )
				EntitySetTransform( c[i], x, y, r, sx, sy )

				EntitySetComponentsWithTagEnabled( c[i], "enabled_in_hand", false )
				EntitySetComponentsWithTagEnabled( c[i], "enabled_in_inventory", false )
				EntitySetComponentsWithTagEnabled( c[i], "enabled_in_world", true )
				EntitySetComponentsWithTagEnabled( c[i], "item_unidentified", false )

				dude = dude + 1
			end
		end end
	end
end end

if inventory_full ~= nil and #inventory_full > 0 then for i=1,#inventory_full do
	if EntityGetFirstComponentIncludingDisabled( inventory_full[i], "ItemActionComponent" ) ~= nil then
		EntityRemoveFromParent( inventory_full[i] )
		EntitySetTransform( inventory_full[i], x, y, r, sx, sy )

		EntitySetComponentsWithTagEnabled( inventory_full[i], "enabled_in_hand", false )
		EntitySetComponentsWithTagEnabled( inventory_full[i], "enabled_in_inventory", false )
		EntitySetComponentsWithTagEnabled( inventory_full[i], "enabled_in_world", true )
		EntitySetComponentsWithTagEnabled( inventory_full[i], "item_unidentified", false )

		dude = dude + 1
	end
end end

dude = clamp( dude, 1, 149 )
for i=1,dude do EntityLoad("data/entities/animals/longleg.xml", x, y ) end

-- cards at inventory_quick ( ABILITY_ACTIONS_MATERIALIZED ) are not under consideration