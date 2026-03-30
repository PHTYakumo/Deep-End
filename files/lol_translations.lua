dofile_once("data/scripts/lib/utilities.lua")

--[[

******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******											******
******							******											******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******
**************************************					******					******
**************************************					******					******
**************************************					******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******
******							******					******
******							******					******					******
******							******					******					******
******							******					******					******
******							******					******					******

]]--

-- if you use SPACE in the name of the translation key, the swapper below may cause these translation keys to fail to work properly

function DEEP_END_LOL_TRANSLATIONS( monolingual )
	local main = "data/translations/common.csv"

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[秒]===], [===[六十分之一分钟]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[音乐]===], [===[缪贼客]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[贪婪]===], [===[来财]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[失败]===], [===[坠机]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[诅咒]===], [===[坠机]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[疯狂]===], [===[坠机]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[癫狂]===], [===[坠机]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[疯癫]===], [===[坠机]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[海]===], [===[壶]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[射弹]===], [===[头哦蛇舞]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[子弹]===], [===[头哦蛇舞]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[飞弹]===], [===[头哦蛇舞]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[投射物]===], [===[头哦蛇舞]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[投射]===], [===[头哦蛇]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[闪电]===], [===[抢救]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[雷电]===], [===[抢救]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[雷霆]===], [===[抢救]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[寒冰]===], [===[灼热]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[冰冻]===], [===[灼热]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[冰冷]===], [===[灼热]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[火焰]===], [===[红温]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[燃烧]===], [===[红温]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[烈焰]===], [===[红温]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[神圣]===], [===[天哪]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[神]===], [===[神经]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[静态]===], [===[区]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[修正]===], [===[拐]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[生命值]===], [===[时髦值]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[生命]===], [===[时髦]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[传送]===], [===[迷路]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[生气]===], [===[不爽]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[愤怒]===], [===[不爽]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[你]===], [===[恁]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[购买]===], [===[抢夺]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[买]===], [===[抢夺]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[黄金]===], [===[粪土]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[金块]===], [===[粪土]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[水]===], [===[一氧化二氢]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[天赋]===], [===[客户端]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[法杖]===], [===[应用程序]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[魔杖]===], [===[应用程序]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[杖子]===], [===[应用程序]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[伤害]===], [===[抛瓦]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[力量]===], [===[抛瓦]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[能量]===], [===[抛瓦]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[速度]===], [===[斯必得]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[法力]===], [===[网速]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[魔力]===], [===[网速]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[乱序]===], [===[猴子打字机]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[法术]===], [===[快捷方式]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[容量]===], [===[注册表]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[施放]===], [===[分配角色]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[释放]===], [===[分配角色]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[充能]===], [===[斟满]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[散射]===], [===[播撒]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[拾取]===], [===[搭载]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[装满]===], [===[综合运算]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[眼药水]===], [===[莎普爱思]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[基质]===], [===[压缩包]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[魔药]===], [===[压缩包]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[药水]===], [===[压缩包]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[烧瓶]===], [===[压缩包]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[瓶子]===], [===[压缩包]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[罐子]===], [===[压缩包]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[隐形]===], [===[掩耳盗铃]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[隐身]===], [===[掩耳盗铃]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[虚幻]===], [===[掩耳盗铃]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[潮湿]===], [===[优柔寡断]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[着火]===], [===[在兴头上]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[开启]===], [===[畅谈]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[宝箱]===], [===[切斯特]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[云]===], [===[克劳德]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[进入]===], [===[困在]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[格挡]===], [===[拆特]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[瞄准]===], [===[锁]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[追踪]===], [===[锁]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[跟踪]===], [===[锁]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[浮空]===], [===[放屁]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[触发]===], [===[扳机]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[定时]===], [===[闹钟]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[失效]===], [===[遗嘱]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[死亡]===], [===[嗝屁]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[大型]===], [===[不小的]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[巨型]===], [===[超不小的]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[提高]===], [===[蒸蒸日上]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[提升]===], [===[蒸蒸日上]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[增强]===], [===[蒸蒸日上]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[几率]===], [===[大概]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[概率]===], [===[大概]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[穿凿]===], [===[全知之眼]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[切割]===], [===[终极锯片]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[近战]===], [===[肘击]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[恐怖]===], [===[故障机器人]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[怪异]===], [===[涩涩]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[电浆]===], [===[深绿玉髓]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[拉帕]===], [===[咪啪]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[屏障]===], [===[防火墙]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[伟大之作]===], [===[白头山]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[太阳]===], [===[将军]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[蠕虫]===], [===[蛆]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[ perk]===], [===[ ppeerrkk]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[ Perk]===], [===[ Ppeerrkk]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[ curse]===], [===[ perk]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[ Curse]===], [===[ Perk]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[ ppeerrkk]===], [===[ curse]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[ Ppeerrkk]===], [===[ Curse]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[ second]===], [===[ one sixtieth minute]===] ) )

	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content:gsub( [===[ Second]===], [===[ One sixtieth minute]===] ) )

	translations = ModTextFileGetContent( "mods/deep_end/files/translations_ex.csv" )
	main_content = ModTextFileGetContent( main )
	ModTextFileSetContent( main, main_content .. translations )

	if monolingual then
		main_content = ModTextFileGetContent( main ) -- everything is in English, this effectively reduces the probability of crash, but...
		ModTextFileSetContent( main, main_content:gsub( [===[,,,,,,,,]===], [===[,,,,,,,,,,,,,,,,,,,,,,,,]===] ) )
	end
end