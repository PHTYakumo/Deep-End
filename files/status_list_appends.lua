
local de_status_list = {
    {
        id="DEEP_END_GRAVITY_EFFECT",
        ui_name="$dde_gravity_potion",
        ui_description="$ddde_gravity_potion",
        ui_icon="data/ui_gfx/status_indicators/de_gravity.png",
        is_harmful=true,
        effect_entity="data/entities/misc/effect_de_gravity.xml",
        -- effect_permanent=true,
    },
    {
        id="DEEP_END_LASER_EYE_EFFECT",
        ui_name="$dde_laser_eye",
        ui_description="$ddde_laser_eye",
        ui_icon="data/ui_gfx/status_indicators/de_laser_eye.png",
        is_harmful=true,
        effect_entity="data/entities/misc/effect_de_personal_laser.xml",
        -- effect_permanent=true,
    },
    {
        id="DEEP_END_HARDEN_EFFECT",
        ui_name="$dde_hardener",
        ui_description="$ddde_hardener",
        ui_icon="data/ui_gfx/status_indicators/de_hardener.png",
        protects_from_fire=true,
        -- is_harmful=true,
        effect_entity="data/entities/misc/effect_de_harden.xml",
        -- effect_permanent=true,
    },
    {
        id="DEEP_END_NO_EDIT_EFFECT",
        ui_name="$status_de_no_edit",
        ui_description="$dstatus_de_no_edit",
        ui_icon="data/ui_gfx/status_indicators/de_no_edit.png",
        is_harmful=true,
        effect_entity="data/entities/misc/effect_de_woolgather.xml",
        -- effect_permanent=true,
    },
    {
        id="DEEP_END_NO_HEAL_EFFECT",
        ui_name="$status_de_no_heal",
        ui_description="$dstatus_de_no_heal",
        ui_icon="data/ui_gfx/status_indicators/de_no_heal.png",
        is_harmful=true,
        effect_entity="data/entities/misc/effect_no_heal_de.xml",
        -- effect_permanent=true,
    },
    {
        id="DEEP_END_DIZZY_EFFECT",
        ui_name="$status_de_dizzy",
        ui_description="$dstatus_de_dizzy",
        ui_icon="data/ui_gfx/status_indicators/de_dizzy.png",
        is_harmful=true,
        effect_entity="data/entities/misc/effect_de_light_headedness.xml",
        -- effect_permanent=true,
    },

    {
        id="DEEP_END_HP_UP",
        ui_name="$status_de_hp_up",
        ui_description="$dstatus_de_hp_up",
        ui_icon="data/ui_gfx/status_indicators/de_hp_up.png",
        -- is_harmful=true,
        effect_entity="data/entities/misc/effect_de_hp_up.xml",
        -- effect_permanent=true,
    },
}

local list_len = #status_effects

for i=1,#de_status_list do
    status_effects[list_len+i] = de_status_list[i]
end
