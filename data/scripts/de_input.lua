dofile_once("data/scripts/lib/utilities.lua")

function de_key_judge( all_input, init )
    local judge_result, key_input = false, init

    if string.len(all_input) > 0 then key_input = string.byte( all_input, 1, 1 ) end -- if key_input == 32 then key_input = init end

    if key_input == 0 then
        judge_result = InputIsMouseButtonDown(2)
    elseif key_input == 9999 then -- default true
        return true
    elseif key_input == -9999 then -- default false
        return false
    else
        local key_result, use_mouse, find = 41, false, false

        if key_input <= 122 and key_input >= 97 then key_result = key_input - 93
        elseif key_input <= 90 and key_input >= 65 then key_result = key_input - 61
        elseif key_input <= 57 and key_input >= 49 then key_result = key_input - 19
        elseif key_input == 48 then key_result = 39 end

        local key_strs = 
        { 
            "tab", "Tab", "TAB", 
            "cap", "Cap", "CAP", 
            "shif", "Shif", "SHIF", 
            "ctr", "Ctr", "CTR", "cont", "Cont", "CONT", 
            "alt", "Alt", "ALT", 
            "spa", "Spa", "SPA" 
        }

        local mouse_strs = 
        { 
            "left", "Left", "LEFT", 
            "right", "Right", "RIGHT", 
            "mid", "Mid", "MID"
        }

        local wheel_strs = 
        {
            "up", "Up", "UP", 
            "down", "Down", "DOWN" 
        }

        local key_str_results = 
        { 
            43, 43, 43, 
            57, 57, 57,
            225, 225, 225, 
            224, 224, 224, 224, 224, 224, 
            226, 226, 226, 
            44, 44, 44 
        }

        local mouse_str_results = 
        { 
            1, 1, 1,
            2, 2, 2,
            3, 3, 3
        }

        local wheel_strs_results = 
        { 
            4, 4, 4, 4, 4, 4, 4,
            4, 4, 4, 4, 4, 4, 4,
            5, 5, 5, 5, 5, 5, 5,
            5, 5, 5, 5, 5, 5, 5
        }

        for i=1,#key_strs do if string.find( all_input, key_strs[i] ) then 
            key_result = key_str_results[i] 
            find = true
            break
        end end

        if ( string.find( all_input, "mouse" ) or string.find( all_input, "Mouse" ) or string.find( all_input, "MOUSE" ) ) 
            and ( not find ) then
            for i=1,#mouse_strs do if string.find( all_input, mouse_strs[i] ) then 
                key_result = mouse_str_results[i] 
                use_mouse = true
                find = true
                break
            end end
        end

        if ( string.find( all_input, "wheel" ) or string.find( all_input, "Wheel" ) or string.find( all_input, "WHEEL" ) ) 
            and ( not find ) then
            for i=1,#wheel_strs do if string.find( all_input, wheel_strs[i] ) then 
                key_result = wheel_strs_results[i] 
                use_mouse = true
                break
            end end
        end

        if key_result == 41 then judge_result = InputIsMouseButtonDown(2)
        elseif use_mouse then judge_result = InputIsMouseButtonDown(key_result)
        else judge_result = InputIsKeyDown(key_result) end
    end

    return judge_result
end