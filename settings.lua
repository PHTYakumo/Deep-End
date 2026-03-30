dofile_once("data/scripts/lib/mod_settings.lua")

local mod_id = "DEEP_END"
local language = GameTextGet( "$current_language" )
mod_settings_version = 1


function mod_setting_warning(mod_id, gui, in_main_menu, im_id, setting)
    GuiColorSetForNextWidget(gui, 1.0, 0.4, 0.4, 1.0)
    GuiText(gui, mod_setting_group_x_offset, 0, setting.ui_name .. ": " .. setting.ui_description)
end

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id )
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end

if ( string.find( language, "中文" ) ) or ( string.find( language, "汉化" ) ) then
	mod_settings = 
	{
		{
			id = "FESTIVAL_EVENTS",
			ui_name = "开启节日事件",
			ui_description = 
			"\n   大部分是正面效果, 大部分..",
			value_default = true,
			scope = MOD_SETTING_SCOPE_NEW_GAME,
		},
		{
			id = "NIGHTMARE_END",
			ui_name = "简易结局演出",
			ui_description =
			"\n   仅作为死亡效果, 关掉可以大幅减少卡顿",
			value_default = true,
			scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
		},
		{
			id = "NOT_AUTO_PICK_UP",
			ui_name = "不再自动拾取完全回复和法术刷新",
			ui_description = 
			"\n   我只提一句: 别忘了捡!",
			value_default = true,
			scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
		},
		{
			id = "MEAT_HEAL",
			ui_name = "温和的肉界",
			ui_description =
			"\n   取消肉界的禁疗诅咒!?",
			value_default = true,
			scope = MOD_SETTING_SCOPE_NEW_GAME,
		},
		{
			category_id = "WARNING",
			ui_name = "!!!",
			foldable = true,
			_folded = false,
			settings = {
				{
					ui_fn = mod_setting_warning,
					ui_name = "警告",
					ui_description =
					"\n   如果语言选项不使用官中 部分文本可能会没有中文翻译" ..
					"\n   推荐将设置里的装饰粒子数量和画面震动强度分别设置为20%和小于15" ..
					"\n   (不然卡了不怪我)",
					not_setting = true,
				}
			},
		},
		{
			category_id = "MAP_SETTING",
			ui_name = "QOL设置",
			foldable = true,
			_folded = false,
			settings = {
				{
					id = "QOL_KEY_1",
					ui_name = "快速清空法杖快捷键:",
					ui_description = 
						"\n   请输入数字,字母或按键名" ..
						"\n   按下后,将手持法杖的所有法术直接丢弃",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "QOL_KEY_2",
					ui_name = "快速存放法术快捷键:",
					ui_description = 
						"\n   请输入数字,字母或按键名" ..
						"\n   按下后,将手持法杖的所有法术收至背包",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "MAP_KEY",
					ui_name = "呼出地图按键:",
					ui_description = 
						"\n   请输入数字,字母或按键名" ..
						"\n   留空将设置为:" ..
						"\n   同时长按左+右 / 只长按下(吃)",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "LOCATE_MOUNT",
					ui_name = "简易地图显示圣山",
					ui_description = 
						"\n   否则呼出地图将只告知方位!",
					value_default = true,
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
			},
		},
		{
			category_id = "POWER_SETTING",
			ui_name = "能力与玩法设置",
			foldable = true,
			_folded = false,
			settings = {
				{
					id = "MAP_TYPE",
					ui_name = "地图选择",
					ui_description = "选择你想要游玩的地图",
					value_default = "0",
					values = {{"0","经典"}, {"1","废土"},{"2","荆棘"}, {"3","夹缝"}, {"4","末日"}},
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "EDIT",
					ui_name = "获得随编",
					ui_description = 
					"\n   同时根据伤害类型增加受伤伤害!",
					value_default = true,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "EVERYONE_IS_POWERFUL",
					ui_name = "强化后的世界",
					ui_description = 
					"\n   包括敌人和你的初始奖励!",
					value_default = true,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "ORIGINAL_SPELLS",
					ui_name = "取消对大部分原版法术的改动",
					ui_description =
					"\n   但你的初始血量将只有80%!",
					value_default = false,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "HEAVEN_OR_HELL",
					ui_name = "<<<<<<狂热模式>>>>>>",
					ui_description = 
					"\n   你和敌人都将获得超乎想象的力量!!!" ..
					"\n   (开启本模式将禁用上述四个设置)",
					value_default = false,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "HEAVEN_OR_HELL_FACTOR",
					ui_name = "狂热因子",
					ui_description = 
					"\n   调整敌人的强化倍率." ..
					"\n   (因子>40时可能需要强劲的电脑)",
					value_default = 4,
					value_min = 0,
					value_max = 41,
					value_display_multiplier = 1,
					value_display_formatting = " $0/40 ",
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "HELL_AND_HELL_HP",
					ui_name = "敌人额外血量倍率",
					ui_description = 
					"\n   同时额外增加金钱掉落量" ..
					"\n   警告: 此数值将直接乘以强化后的敌人血量!",
					value_default = 1,
					value_min = 1,
					value_max = 16,
					value_display_multiplier = 1,
					value_display_formatting = " $0/16 ",
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "HELL_AND_HELL_AMOUNT",
					ui_name = "敌人数量倍率",
					ui_description = 
					"\n   同时有概率翻倍野生法杖的生成" ..
					"\n   警告: 这些敌人都将获得原本的强化!" ..
					"\n   (倍率>2时可能需要强劲的电脑)",
					value_default = 1,
					value_min = 1,
					value_max = 8,
					value_display_multiplier = 1,
					value_display_formatting = " $0/8 ",
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "HELL_AND_HELL_PERK",
					ui_name = "敌人获得随机天赋",
					ui_description = 
					"\n   同时天赋重掷价格永远从50开始" ..
					"\n   警告: 后果自行承担!" ..
					"\n   (可能需要强劲的电脑)",
					value_default = false,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
			},
		},
		{
			category_id = "LOL_SETTING",
			ui_name = "其他设置",
			foldable = true,
			_folded = false,
			settings = {
				{
					id = "BIOME_MODIFIER",
					ui_name = "环境修正概率",
					ui_description = 
					"\n   调整各群系被施加环境修正的概率.",
					value_default = 2,
					value_min = 1,
					value_max = 10,
					value_display_multiplier = 1,
					value_display_formatting = " $0/10 ",
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "TIME",
					ui_name = "背景时间流逝速率",
					ui_description = 
					"\n   原版是1, 调不调影响不大.",
					value_default = "240",
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "LOL_TRANS",
					ui_name = "害人汉化?",
					ui_description = 
					"\n   字面意思.",
					value_default = false,
					scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				},
			},
		},
		{
			category_id = "DASH_SETTING",
			ui_name = "冲刺天赋设置",
			foldable = true,
			_folded = false,
			settings = {
				{
					id = "ALWAYS_CAN_DASH",
					ui_name = "直接获取冲刺天赋",
					ui_description = 
					"\n   不用去拿了, 嘿嘿.",
					value_default = false,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "PERK_DASH_HOOK_PRIMARY",
					ui_name = "发射钩爪按键(首选):",
					ui_description =
					"\n   请输入数字,字母或按键名" ..
					"\n   留空将设置为鼠标右键.",
					value_default = "leftctrl/control",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "PERK_DASH_HOOK_SECONDARY",
					ui_name = "发射钩爪按键(次要):",
					ui_description =
					"\n   请输入数字,字母或按键名" ..
					"\n   留空将不设置.",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "PERK_DASH_HOOK_COMBINED",
					ui_name = "发射钩爪组合键:",
					ui_description =
					"\n   必须同时按下此键+任一上面设置的按键来发射钩爪" ..
					"\n   留空将不启用组合键.",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "PERK_DASH_SKY_GLIDE",
					ui_name = "滑翔键:",
					ui_description =
					"\n   即使不设置 浮空能量耗尽后按飞行+下也能滑翔",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "DOUBLE_TAPPING",
					ui_name = "双击间隔(帧)",
					ui_description = 
					"\n   10~20是比较舒适的区间.",
					value_default = "13",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
			},
		},
	}
else
	mod_settings = 
	{
		{
			id = "FESTIVAL_EVENTS",
			ui_name = "Enable seasonal events",
			ui_description = 
			"\n   Mostly positive, mostly..",
			value_default = true,
			scope = MOD_SETTING_SCOPE_NEW_GAME,
		},
		{
			id = "NIGHTMARE_END",
			ui_name = "Simple ending performance",
			ui_description =
			"\n   As a death effect only, disable it can greatly reduce stuttering",
			value_default = true,
			scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
		},
		{
			id = "NOT_AUTO_PICK_UP",
			ui_name = "Pick up Full-Hp and Spell-Refresh manually",
			ui_description = 
			"\n   Don't forget to pick them up if you set this to True!",
			value_default = true,
			scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
		},
		{
			id = "MEAT_HEAL",
			ui_name = "Milder Meat Realm",
			ui_description = 
			"\n   Healable in Meat Realm even without defeating the boss there!?",
			value_default = true,
			scope = MOD_SETTING_SCOPE_NEW_GAME,
		},
		{
			category_id = "WARNING",
			ui_name = "!!!",
			foldable = true,
			_folded = false,
			settings = {
				{
					ui_fn = mod_setting_warning,
					ui_name = "Attention",
					ui_description = 
					"\n   Setting Cosmetic-particle-amount below 20% and Screen-shake-intensity" ..
					"\n   below 15 is recommended. (to avoid the game stuck)",
					not_setting = true,
				}
			},
		},
		{
			category_id = "MAP_SETTING",
			ui_name = "QOL settings",
			foldable = true,
			_folded = false,
			settings = {
				{
					id = "QOL_KEY_1",
					ui_name = "Quick Wand-Emptying:",
					ui_description = 
						"\n   Throw out all the spells from the wand you held directly" ..
						"\n   Please enter a number, letter or key name",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "QOL_KEY_2",
					ui_name = "Quick Spell-Collecting:",
					ui_description = 
						"\n   Move all the spells from the wand you held to your inventory" ..
						"\n   Please enter a number, letter or key name",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "MAP_KEY",
					ui_name = "Map-Key Setting :",
					ui_description = 
						"\n   Displaying map by tapping this key" ..
						"\n   Please enter a number, letter or key name" ..
						"\n   If empty. You can call map by pressing" ..
						"\n   LEFT & RIGHT / nothing but DOWN.",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "LOCATE_MOUNT",
					ui_name = "Displaying the position of Holy Mount",
					ui_description = 
						"\n   If false, map will only give coordinatess.",
					value_default = true,
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
			},
		},
		{
			category_id = "POWER_SETTING",
			ui_name = "Ability settings",
			foldable = true,
			_folded = false,
			settings = {
				{
					id = "MAP_TYPE",
					ui_name = "Map Type Selection",
					ui_description = "Choose the map you want to play",
					value_default = "0",
					values = {{"0","Classic"}, {"1","Wasteland"},{"2","Thorny"}, {"3","Neddle"}, {"4","Doomsday"}},
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "EDIT",
					ui_name = "Tinker-with-Wands-Everywhere",
					ui_description = 
					"\n   You will receive 1.25 times damage. ( avergae )",
					value_default = true,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "EVERYONE_IS_POWERFUL",
					ui_name = "Enhance everyone",
					ui_description = 
					"\n   Include starting perks and wands.",
					value_default = true,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "ORIGINAL_SPELLS",
					ui_name = "Spells from vanilla game won't be changed",
					ui_description = 
					"\n   But your initial HP will only be 80%.",
					value_default = false,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "HEAVEN_OR_HELL",
					ui_name = "<<<<<< Mania Mode >>>>>>",
					ui_description = 
					"\n   Both you and your enemy will gain power beyond your imagination!!!" ..
					"\n   ( Enabling this mode will disable the ABOVE four Settings )",
					value_default = false,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "HEAVEN_OR_HELL_FACTOR",
					ui_name = "Intensifying factor in Mania Mode",
					ui_description = 
					"\n   Adjust enemies' HP & AS rate in Mania Mode," ..
					"\n   ( If it's > 40, you probably need a powerful CPU )",
					value_default = 4,
					value_min = 0,
					value_max = 41,
					value_display_multiplier = 1,
					value_display_formatting = " $0/40 ",
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "HELL_AND_HELL_HP",
					ui_name = "Enemy HP multiplier",
					ui_description = 
					"\n   Also increases the amount of money dropped." ..
					"\n   Warning: " ..
					"\n   Enemy HP will be multiplied directly by this number," ..
					"\n   on an enhanced basis! ( thus, just 1 is preferable )",
					value_default = 1,
					value_min = 1,
					value_max = 16,
					value_display_multiplier = 1,
					value_display_formatting = " $0/16 ",
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "HELL_AND_HELL_AMOUNT",
					ui_name = "Enemy number multiplier",
					ui_description = 
					"\n   Also there is probability to generate double wands in the world." ..
					"\n   Warning: " ..
					"\n   The number will directly affect the amount of enemies generated," ..
					"\n   on an enhanced basis! ( thus, just 1 is preferable )",
					value_default = 1,
					value_min = 1,
					value_max = 8,
					value_display_multiplier = 1,
					value_display_formatting = " $0/8 ",
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "HELL_AND_HELL_PERK",
					ui_name = "Enemies gain perks",
					ui_description = 
					"\n   Up for the challenge, the perk reroll price will always start at 50!" ..
					"\n               #########                    ########              ###  " ..
					"\n           ###              ###            ###            ###          ###  " ..
					"\n       ###                                ###                    ###      ###  " ..
					"\n   ###                                  ###                        ###    ###  " ..
					"\n   ###                                  ###                        ###    ###  " ..
					"\n   ###                ######      ###                        ###    ###  " ..
					"\n   ###                        ###    ###                        ###    ###  " ..
					"\n   ###                        ###      ###                    ###              " ..
					"\n       ###                    ###          ###            ###          ###  " ..
					"\n           ############                  ########              ###  ",
					value_default = false,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
			},
		},
		{
			category_id = "LOL_SETTING",
			ui_name = "Scene settings",
			foldable = true,
			_folded = false,
			settings = {
				{
					id = "BIOME_MODIFIER",
					ui_name = "Biome modifier chance",
					ui_description = 
					"\n   The probability that some biomes are modified.",
					value_default = 2,
					value_min = 1,
					value_max = 10,
					value_display_multiplier = 1,
					value_display_formatting = " $0/10 ",
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "TIME",
					ui_name = "Time passing velocity in the background",
					ui_description = 
					"\n   In the normal game is 1.",
					value_default = "240",
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "LOL_TRANS",
					ui_name = "Chaotic translations",
					ui_description = 
					"\n   Add some FUNNY translations?",
					value_default = false,
					scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				},
			},
		},
		{
			category_id = "DASH_SETTING",
			ui_name = "How-to-dash perk settings",
			foldable = true,
			_folded = false,
			settings = {
				{
					id = "ALWAYS_CAN_DASH",
					ui_name = "Get HOW-TO-DASH immediately",
					ui_description = 
					"\n   Instead of picking at starting point.",
					value_default = false,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "PERK_DASH_HOOK_PRIMARY",
					ui_name = "Key Seting 1:",
					ui_description = 
					"\n   Shoot extra hook by tapping this key (Primary)" ..
					"\n   Please enter a number, letter or key name" ..
					"\n   If empty, mouse-right is set.",
					value_default = "leftctrl/control",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "PERK_DASH_HOOK_SECONDARY",
					ui_name = "Key Seting 2:",
					ui_description = 
					"\n   Shoot extra hook by tapping this key (Secondary)" ..
					"\n   Please enter a number, letter or key name" ..
					"\n   If empty, nothing is set.",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "PERK_DASH_HOOK_COMBINED",
					ui_name = "Key Seting 3:",
					ui_description = 
					"\n   Combined key for shooting extra hook" ..
					"\n   This key must be pressed at the same time" ..
					"\n   If empty, key combinations are not enabled.",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "PERK_DASH_SKY_GLIDE",
					ui_name = "Gliding key:",
					ui_description =
					"\n   Slowing down flight and descent vertically" ..
					"\n   by pressing this key.",
					value_default = "",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "DOUBLE_TAPPING",
					ui_name = "Interval to judge whether you double-tap",
					ui_description = 
					"\n   Frames, 10 to 20 may be comfortable.",
					value_default = "13",
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
			},
		},
	}
end
