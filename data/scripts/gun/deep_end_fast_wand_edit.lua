dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("data/scripts/gun/gun_enums.lua")
dofile_once("data/scripts/de_input.lua")

local entity_id, comp_id = GetUpdatedEntityID(), GetUpdatedComponentID()
if ComponentHasTag( comp_id, "deep_end_qol_script" ) then EntitySetComponentIsEnabled( entity_id, comp_id, false ) end

local frame_now, frame_cd = GameGetFrameNum(), 10
local last_execution = ComponentGetValueInt( comp_id,  "mLastExecutionFrame" )
	
if last_execution < 0 or ( GameGetFrameNum() - last_execution ) > frame_cd or not ComponentHasTag( comp_id, "deep_end_qol_script" ) then 
    local x, y = EntityGetTransform( entity_id )
    local wand = find_the_wand_held( entity_id )
    if x == nil or wand == nil then return end

    local comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
    local c = EntityGetAllChildren( wand, "card_action" )
    if comp == nil or c == nil then return end

    local deck_capacity = ComponentObjectGetValue( comp, "gun_config", "deck_capacity" )
    local deck_capacity2 = EntityGetWandCapacity( wand )
    if deck_capacity == nil or deck_capacity2 == nil then return end

    local always_casts = deck_capacity - deck_capacity2 -- how many always_casts
    local key_1 = ModSettingGet( "DEEP_END.QOL_KEY_1" ) -- wand -> world
    local key_2 = ModSettingGet( "DEEP_END.QOL_KEY_2" ) -- wand -> inventory

    if de_key_judge( key_1, -9999 ) then
        if #c > always_casts then
            local card_id = 0

            for i=always_casts+1,#c do if EntityGetFirstComponentIncludingDisabled( c[i], "ItemActionComponent" ) ~= nil then
                EntityRemoveFromParent( c[i] )
                EntitySetTransform( c[i], x, y, 0, 1, 1 )

                EntitySetComponentsWithTagEnabled( c[i], "enabled_in_hand", false )
                EntitySetComponentsWithTagEnabled( c[i], "enabled_in_inventory", false )
                EntitySetComponentsWithTagEnabled( c[i], "enabled_in_world", true )
                EntitySetComponentsWithTagEnabled( c[i], "item_unidentified", false )

                local spellc = EntityGetAllChildren( c[i] )

                if spellc ~= nil then for a,shield in ipairs( spellc ) do
                    local comps = EntityGetAllComponents( shield )
                    if comps ~= nil then for b,comp in ipairs( comps ) do EntitySetComponentIsEnabled( shield, comp, false ) end end
                end end

                local velocity_comp = EntityGetFirstComponentIncludingDisabled( c[i], "VelocityComponent" )
                card_id = card_id + 1

                if velocity_comp ~= nil then
                    local angle = card_id * (-1)^card_id
                    if angle > 0 then angle = angle - 1 end

                    ComponentSetValue2( velocity_comp, "mVelocity", angle * 5, -25 )
                end
            end end
        end
    elseif de_key_judge( key_2, -9999 ) then
        local inventory_cap, inventory_full = 18, nil
        local inventory_comp = EntityGetFirstComponent( entity_id, "Inventory2Component" )
        if inventory_comp == nil then return end

        inventory_cap = ComponentGetValue2( inventory_comp, "full_inventory_slots_y" )
        inventory_cap = inventory_cap * ComponentGetValue2( inventory_comp, "full_inventory_slots_x" ) -- inventory capacity
        
        local playerc = EntityGetAllChildren( entity_id )

        if playerc then for i,plchild in ipairs( playerc ) do if EntityGetName( plchild ) == "inventory_full" then
            inventory_full = plchild
            break
        end end end

        if inventory_full == nil then return end
        local inventoryc = EntityGetAllChildren( inventory_full )
        if inventoryc ~= nil then inventory_cap = inventory_cap - #inventoryc end

        if #c > always_casts then for i=always_casts+1,#c do
            if inventory_cap < 1 then break end -- inventory is full
            
            if EntityGetFirstComponentIncludingDisabled( c[i], "ItemActionComponent" ) ~= nil then
                EntityRemoveFromParent( c[i] )

                EntitySetComponentsWithTagEnabled( c[i], "enabled_in_world", false )
                EntitySetComponentsWithTagEnabled( c[i], "enabled_in_hand", false )
                EntitySetComponentsWithTagEnabled( c[i], "enabled_in_inventory", true )
                EntitySetComponentsWithTagEnabled( c[i], "item_unidentified", false )

                local spellc = EntityGetAllChildren( c[i] )

                if spellc ~= nil then for a,shield in ipairs( spellc ) do
                    local comps = EntityGetAllComponents( shield )
                    if comps ~= nil then for b,comp in ipairs( comps ) do EntitySetComponentIsEnabled( shield, comp, false ) end end
                end end

                EntityAddChild( inventory_full, c[i] )	-- move to the inventory
                inventory_cap = inventory_cap - 1
            end
        end end
    end
end