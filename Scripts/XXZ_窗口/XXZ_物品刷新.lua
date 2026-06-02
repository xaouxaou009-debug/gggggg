local Windows = GameMain:GetMod("Windows");--先注册一个新的MOD模块
local tbWindow = Windows:CreateWindow("XXZ_JiaoYi");
local WuPinSeve = GameMain:GetMod("XXZ_WuPinTable_SEVE");
local tbEvent = GameMain:GetMod("_Event");
local selflist = selflist or {}


function tbWindow:OnInit()
	self.window.contentPane =  UIPackage.CreateObject("XXZUI", "XXZJiaoYi");--载入UI包里的窗口
	self.window.closeButton = self:GetChild("frame"):GetChild("n5");
	self:GetChild("frame").title = "物品购买"
	--GameMain:GetMod("Windows"):CreateWindow("XXZ_JiaoYi"):Show()
	
	
	self.label1 = self:GetChild("label_1");
	
	self.bnt1 = self:GetChild("bnt_1");	
	self.bnt2 = self:GetChild("bnt_2");
	self.bnt3 = self:GetChild("bnt_3");
	self.bnt4 = self:GetChild("bnt_4");
	self.bnt4.tooltips = "[size=12][color=#00688B]移除范围内选中的所有物品，并每个友情奖励0.03~0.3的点数[/color][/size]"
	self.bnt1.onClick:Add(tbWindow.OnClick);
	self.bnt2.onClick:Add(tbWindow.OnClick);
	self.bnt3.onClick:Add(tbWindow.OnClick);
	self.bnt4.onClick:Add(tbWindow.OnClick);
	self.bntrw = self:GetChild("bnt_rw");
	self.bntrw.tooltips = "[size=12][color=#00688B]点击此处开启任务面板，接取任务赚取修炼点，用以购买物品\n多个窗口开启时消耗点数不会实时更新当前点数，可以再次打开刷新数据[/color][/size]"
	self.bntrw.onClick:Add(tbWindow.OnClick);
	self.bntzz = self:GetChild("bnt_zz");
	self.bntzz.tooltips = "[size=12][color=#00688B]扫码赞助支持作者，赞助支持作者购买更多素材，自己掏钱买不动了，是否赞助随意，MOD永远免费[/color][/size]"
	self.bntzz.onClick:Add(tbWindow.OnClick);
	
	self.TextInput1 = self:GetChild("TextInput1");
	self.TextInput1.title = 1
	self.TextInput1.tooltips = "[size=12][color=#00688B]可以在此处输入数量来购买指定数量物品[/color][/size]"
	self.TextInput2 = self:GetChild("TextInput2");
	
	self.window:Center();
	local a = self.window.position;
	self.window:SetPosition(a.x,100,a.x);
end


function tbWindow.ClickSelectItem(context)
	local name = context.data.name
	local dianshu = GameMain:GetMod("ZH_zhanghu"):AddLingNum()
	for i=1,5 do
		if context.sender.name == "list"..i then
			local items = WuPinSeve:GetTable(i)
			for k,v in pairs(items) do
				if name == v[1] then
					local item = ThingMgr:GetDef(g_emThingType.Item,name)
					local count = tonumber(tbWindow:GetChild("TextInput1").title)
					if count then
						count = math.floor(math.abs(count))
						if count == 0 then
							count = 1
						end
					else
						count = 1
					end
					
					local jieshao = "\n[size=15][color=#FF0000]请确定当前订单，确定后将直接发放物品到仓库里[/color][/size]"
					
					if v[2]*count > dianshu then
						count = math.floor(dianshu/v[2])
						if count == 0 then
							world:ShowMsgBox(item.ThingName.."的价格为"..v[2].."点，超出了你拥有的修炼点，无法购买", "购买失败")
							return false
						end
					end
					
					local shuoming  = string.format("[size=15][color=#EE7600]购买物品：%s\n购买数量：%s\n当前点数：%s\n需求点数：%s[/color][/size]"..jieshao,item.ThingName,count,dianshu,count*v[2])
					
								
					CS.Wnd_Message.Show(nil, 2,
					function (s)
						if s == "1" then	
							GameMain:GetMod("XXZ_JianYiCangKu_SEVE"):CunChuCaiLiao(name,count)
							GameMain:GetMod("ZH_zhanghu"):AddLingNum(-(count*v[2]))
							tbWindow:OnShowUpdate()
							if Windows:CreateWindow("XXZ_JianYiCangKu").IsShowing then
								Windows:CreateWindow("XXZ_JianYiCangKu"):OnShowUpdate()
							end
						end
					end, true, item.ThingName, 0, 0,shuoming)
				end
			end
		end
	end
end

function tbWindow.OnClick(context)

	local shuaxinxiaohao = {math.floor(5+world.DayCount/12),math.floor(10+world.DayCount/8),math.floor(20+world.DayCount/5)}
	for i=1,3 do
		if context.sender.name == "bnt_"..i then
			local dianshu = GameMain:GetMod("ZH_zhanghu"):AddLingNum()
			if dianshu >= shuaxinxiaohao[i] then
				GameMain:GetMod("ZH_zhanghu"):AddLingNum(-shuaxinxiaohao[i])
				WuPinSeve:WuPinTable(i+2)
			else
				world:ShowMsgBox("刷新失败，本次刷新需要消耗点数"..shuaxinxiaohao[i].."点，剩余点数为"..dianshu, "刷新失败")
			end
			tbWindow:OnShowUpdate()
			return false
		end
	end
	if context.sender.name == "bnt_4" then
		world:CastMagic(nil,'Magic_wupin_yichu')
	end
	if context.sender.name == "bnt_rw" then
		tbWindow:Hide()
		GameMain:GetMod("Windows"):CreateWindow("XXZ_RenWu"):Show()
	end
	if context.sender.name == "bnt_zz" then
		local ZZUI = Windows:CreateWindow("XXZ_XXZUIZZ")
		if ZZUI.IsShowing then
			ZZUI:Hide()
		else
			ZZUI:Show()
		end
	end
end

function tbWindow:OnShowUpdate()

	local shuaxinxiaohao = {math.floor(5+world.DayCount/12),math.floor(10+world.DayCount/8),math.floor(20+world.DayCount/5)}
	self.bnt1.tooltips = "刷新物品需要消耗点数："..shuaxinxiaohao[1]
	self.bnt2.tooltips = "刷新物品需要消耗点数："..shuaxinxiaohao[2]
	self.bnt3.tooltips = "刷新物品需要消耗点数："..shuaxinxiaohao[3]

	local dianshu = GameMain:GetMod("ZH_zhanghu"):AddLingNum()
	self.TextInput2.title = "当前点数:"..dianshu
	self.TextInput2.tooltips = "[color=#FF0000]修炼点数通过出售正在收购的物品或者做任务获得，点数可以购买物品等[/color]"
	
	for i=1,5 do
		local list = self:GetChild("list"..i)
		list:RemoveChildrenToPool()
		local items = WuPinSeve:GetTable(i)
		local daycount = WuPinSeve:GetDay(i)
		for i=1,#items do
			local item = list:AddItemFromPool()
			local tname = ThingMgr:GetDef(g_emThingType.Item,items[i][1])
			local JuLing = ""
			if tname.Ling ~= nil then 
				JuLing = string.format("[size=12][color=#CD950C]聚灵：%s\n范围：%s[/color][/size]", tname.Ling.AddionLing, tname.Ling.AddionRadius)
			end
			item.icon = tname.TexPath
			item.name = tname.Name
			item.title = tname.ThingName
			local thingname = "[size=15][color=#1C86EE]"..tname.ThingName.."[/color][/size]"
			local desc1 = string.format("[size=12][color=#CD950C]%s\n美观：%s\n品阶：%s[/color][/size]", JuLing, tname.Beauty, tname.Rate)
			local desc1 = desc1.."\n[size=12][color=#20B2AA]"..tname.Desc.."[/color][/size]"
			local desc2 = "[size=12][color=#00688B]物品售价："..items[i][2].."[/color][/size]\n"
			local desc2 = desc2.."[size=12][color=#00688B]最大购买："..math.floor(dianshu/items[i][2]).."[/color][/size]\n"
			local desc2 = desc2.."[size=12][color=#00688B]刷新计时："..daycount.."[/color][/size]\n"
			item.tooltips = string.format("%s\n%s\n%s", thingname, desc1, desc2)
		end
		list.onClickItem:Add(tbWindow.ClickSelectItem)
	end
end

function tbWindow:OnShown()
	tbWindow.IsShowing = true

end

function tbWindow:OnUpdate(dt)
end

function tbWindow:OnHide()
	tbWindow.IsShowing = false
end

function WuPinSeve:OnInit()
	tbEvent:RegisterEvent(g_emEvent.DayChange, WuPinSeve.OnDayChange, "XXZ_WuPinTable_SEVE")
end
function WuPinSeve:OnSave()
	return selflist
end


function WuPinSeve:OnLoad(t)
	selflist = t or {}
end

function WuPinSeve.OnDayChange()
	local day = {1,3,5,7,9}
	for i=1,5 do
		if selflist["daycount"..i] ~= nil then
			selflist["daycount"..i] = selflist["daycount"..i]-1
			if selflist["daycount"..i] == 0 then
				WuPinSeve:WuPinTable(i)
			selflist["daycount"..i] = day[i]
			end
		end
	end
end
function WuPinSeve:OnStep(dt)
	for i=1,5 do
		if selflist["wupinlist_"..i] == nil then
			WuPinSeve:WuPinTable(i)
		end
	end
	local day = {1,3,5,7,9}
	for i=1,5 do
		if selflist["daycount"..i] == nil then
			selflist["daycount"..i] = day[i]
		end
	end
end 


function WuPinSeve:WuPinTable(num)

	local WuPinJiaZhiList = WuPinSeve:Table()
	selflist["wupinlist_"..num] = {}
	
	local wupinlist = {}
	wupinlist[1] = {"Item_LingStone","Item_LingCrystal","Item_jinghua_jiejing1"}
	
	local shi1 = {"Item_Ginkgo","Item_Healroot","Item_Pear","Item_Lotusroot","Item_Wheat","Item_Mushroom","Item_Cotton","Item_Fruit","Item_Yao_BoarMeat","Item_BossZhuLong_Meat","Item_BossLong_Meat","Item_BossFeng_Meat",}
	local shi2 = {"Item_Mint","Item_MagicHerb","Item_Ginseng","Item_GanodermaLucidum","Item_SnakeGallbladder","Item_BearGallbladder","Item_Cinnabar","Item_LingWater","Item_RedGinseng","Item_PurpleGanodermaLucidum"}
	local shi3 = {"Item_Dan_Thin","Item_Dan_Fat","Item_Dan_NoHunger2","Item_Dan_NoHunger1","Item_Dan_LostSoul","Item_Dan_Happiness"}
	wupinlist[2] = {shi1[WorldLua:RandomInt(1,#shi1+1)],shi2[WorldLua:RandomInt(1,#shi2+1)],shi3[WorldLua:RandomInt(1,#shi3+1)]}
	
	local jin1 = "Item_cailiao_jinkuang"..WorldLua:RandomInt(1,8)
	local w3_1 = {"Item_cailiao_jinkuang0",jin1,"Item_IronRock","Item_CopperRock","Item_SilverRock","Item_DarksteelRock","Item_StarEssence"}
	local w3_1 = w3_1[WorldLua:RandomInt(1,#w3_1+1)]
	local shi1 = "Item_cailiao_shikuang"..WorldLua:RandomInt(1,8)
	local w3_2 = {"Item_cailiao_shikuang0",shi1,"Item_BrownRock","Item_GrayRock","Item_Marble","Item_Jade","Item_StoneEssence","Item_JadeEssence","Item_SkyStone","Item_ExtremeJade"}
	local w3_2 = w3_2[WorldLua:RandomInt(1,#w3_2+1)]
	local mu1 = "Item_cailiao_mucai"..WorldLua:RandomInt(1,8)
	local w3_3 = {"Item_cailiao_mucai0",mu1,"Item_Wood","Item_LingWood","Item_HardWood","Item_ParasolWood"}
	local w3_3 = w3_3[WorldLua:RandomInt(1,#w3_3+1)]
	local pimao = {"Item_shoupi"..WorldLua:RandomInt(1,6),"Item_yumao"..WorldLua:RandomInt(1,6)}
	local w3_4 = {"Item_RabbitLeather","Item_WolfLeather","Item_BearLeather","Item_YaoLeather1","Item_FeiLeather","Item_LuShuLeather",pimao[WorldLua:RandomInt(1,#pimao+1)]}
	local w3_4 = w3_4[WorldLua:RandomInt(1,#w3_4+1)]
	
	local lingguo = {"Item_lingguo_jin","Item_lingguo_mu","Item_lingguo_shui","Item_lingguo_huo","Item_lingguo_tu"}
	local w3_5 = lingguo[WorldLua:RandomInt(1,#lingguo+1)]..WorldLua:RandomInt(1,12)
	wupinlist[3] = {w3_1,w3_2,w3_3,w3_4,w3_5}
	
	local w4_1 = "Item_qianghua_suipian"..WorldLua:RandomInt(1,11)
	local w4_2 = "Item_fumo_suipian"..WorldLua:RandomInt(1,11)
	local w4_3 = "Item_fumo_fuwen_"..WorldLua:RandomInt(1,65)
	
	local ql = "Item_fumo_qiling"..WorldLua:RandomInt(1,5)
	local cz = "Item_fumo_chongzhu"..WorldLua:RandomInt(1,6)
	local pz = "Item_fumo_fuwen_pinzhi"..WorldLua:RandomInt(1,6)
	local lj = "Item_fumo_fuwen_leijie"..WorldLua:RandomInt(1,6)
	local w4_4 = {ql,cz,pz,lj,"Item_fumo_fuwen_pinjie1","Item_fumo_fuwen_meiguan1"}
	local w4_4 = w4_4[WorldLua:RandomInt(1,#w4_4+1)]
	local xingxiu = {"Item_fumo_fuwen_dong","Item_fumo_fuwen_xi","Item_fumo_fuwen_nan","Item_fumo_fuwen_bei"}
	local w4_5 = xingxiu[WorldLua:RandomInt(1,#xingxiu+1)]..WorldLua:RandomInt(1,8)
	wupinlist[4] = {w4_1,w4_2,w4_3,w4_4,w4_5}
	
	local w5_1 = {"Item_MonsterBlood","Item_SoulPearl","Item_EarthEssence1_1","Item_EarthEssence_1","Item_EarthEssence1","Item_EarthEssence","Item_LifeStream","Item_LingMuXueJie","Item_ZaoHuaYuLu","Item_XianDaoXieNian","Item_XianDaoShenNian","Item_QieDaoGuo","Item_YuanHunLu","Item_XieHunLu","Item_YanDaoGuo","Item_Dan_JingYuan","Item_Dan_JingYuan2","Item_Dan_JingYuan3","Item_Dan_Ling","Item_BasePracticeDrug","Item_Dan_FiveBaseFromLife","Item_Dan_CureFiveElementDamage","Item_Dan_CureJinDamage","Item_Dan_CureMuDamage","Item_Dan_CureShuiDamage","Item_Dan_CureHuoDamage","Item_Dan_CureTuDamage","Item_Dan_IncreaseLife2","Item_Dan_ReBorn","Item_Dan_IncreaseLife1","Item_Dan_IncreaseLife4","Item_Dan_HundredRefine","Item_Dan_IncreaseLife5","Item_Dan_IncreaseLife3","Item_Dan_ExtremeLofty","Item_Dan_TreeEXP","Item_Dan_LongDan1","Item_Dan_FengDan1","Item_Dan_ZhuLongDan1","Item_lingguo_wuxing1"}
	local w5_1 = w5_1[WorldLua:RandomInt(1,#w5_1+1)]
	local lingshi = {"Item_lingshi_jin","Item_lingshi_mu","Item_lingshi_shui","Item_lingshi_huo","Item_lingshi_tu","Item_lingshi_yuan","Item_lingshi_hun"}
	local w5_2 = lingshi[WorldLua:RandomInt(1,#lingshi+1)]..WorldLua:RandomInt(4,11)
	local w5_3 = {"Item_BossFeng_HuoYu","Item_DragonScale","Item_BossFeng_GangYu","Item_BossLong_Lin","Item_BossZhuLong_BaiLin","Item_BossZhuLong_HeiLin","Item_BossFeng_Gu","Item_BossLong_Zhua","Item_BossFeng_WeiYu","Item_BossLong_Jing","Item_BossZhuLong_Eye","Item_BossFeng_TouYu","Item_BossLong_Jiao","Item_BossZhuLong_TianLin","Item_BossZhuLong_LongYu","Item_BossLong_NiLin","Item_BossFeng_HongYu","Item_ThunderAir","Item_JinEssence","Item_MuEssence","Item_ShuiEssence","Item_HuoEssence","Item_TuEssence","Item_ZaoHuaYuZi","Item_BenYuan_Jin","Item_BenYuan_Mu","Item_BenYuan_Shui","Item_BenYuan_Huo","Item_BenYuan_Tu","Item_BenYuan_None"}
	local w5_3 = w5_3[WorldLua:RandomInt(1,#w5_3+1)]
	
	local w5_4 = {"Item_MiBao_WuYueZhenTu","Item_MiBao_ShenMuZhenTu","Item_MiBao_BaMenZhenTu","Item_MiBao_SanYinZhenTu","Item_MiBao_YinYangZhenTu","Item_MiBao_FengHunZhenTu","Item_MiBao_LongXingZhenTu","Item_MiBao_LiuYuZhenTu","Item_MiBao_TianDiWuFangZhenTu","Item_MiBao_QiXingZhenTu","Item_MiBao_ZhuXianZhenTu","Item_MiBao_KuiHuaShenJian","Item_MiBao_YaoGuang","Item_MiBao_KaiYang","Item_MiBao_YuHeng","Item_MiBao_TianXuan","Item_MiBao_TianJi","Item_MiBao_TianQuan","Item_MiBao_TianShu","Item_MiBao_TianLangDing","Item_MiBao_JueXianJian","Item_MiBao_XianXianJian","Item_MiBao_LuXianJian","Item_MiBao_ZhuXianJian","Item_MiBao_YuanShenXinJian","Item_MiBao_QingNingFeiYu","Item_MiBao_ShenNongDing","Item_MiBao_TunLingShenJian","Item_MiBao_JinLianShenZuo","Item_MiBao_TuFabao","Item_MiBao_HuoFabao","Item_MiBao_ShuiFabao","Item_MiBao_MuFabao","Item_MiBao_JinFabao","Item_MiBao_WuqiLeiFu","Item_MiBao_TaiYiFenGuangJian","Item_MiBao_XiXingShenSuo","Item_MiBao_QiJueShenZhen","Item_MiBao_WuDuZhuXianSword","Item_MiBao_BaiLingZhanXianSword","Item_MiBao_ShiErShaShenMoLingSha","Item_MiBao_TianMoHuaXueShenDao","Item_MiBao_YinHunZhu","Item_MiBao_JiuTianYuanYangChi","Item_MiBao_LongXinYinYangGui","Item_MiBao_DaiShenZhu"}
	local w5_4 = w5_4[WorldLua:RandomInt(1,#w5_4+1)]
	
	local w5_5 = {"Item_zhuanshu_lingpai_zixia","Item_zhuanshu_lingpai_diaochan","Item_zhuanshu_lingpai_yuji","Item_zhuanshu_lingpai_guanyu","Item_zhuanshu_lingpai_libai","Item_zhuanshu_lingpai_lvbu","Item_zhuanshu_lingpai_sunwukong","Item_zhuanshu_lingpai_biyao","Item_zhuanshu_lingpai_luxueqi"}
	local w5_5 = w5_5[WorldLua:RandomInt(1,#w5_5+1)]
	wupinlist[5] = {w5_1,w5_2,w5_3,w5_4,w5_5}
	local list = wupinlist[num]
	for i=1,#list do
		local name = list[i]
		for k,v in pairs(WuPinJiaZhiList) do
			if name == v[1] then
				local Random = WuPinJiaZhiList[k]
				Random[2] = math.floor(WorldLua:RandomFloat(Random[2]*2.6,Random[2]*5.5)*100*(1+world.DayCount/1000))/100
				table.insert(selflist["wupinlist_"..num],Random)
			end
		end
	end
end


function WuPinSeve:GetTable(num)
	return selflist["wupinlist_"..num]
end


function WuPinSeve:GetDay(num)
	return selflist["daycount"..num]
end



--[[
function WuPinSeve:OnSetHotKey()
	local HotKey = {
	{ID = "XXZ_JiaoYi" , Name = "刷新物品" , Type = "Mod", InitialKey1 = "LeftAlt+C" },
	{ID = "XXZ_JianYiCangKu" , Name = "打开仓库" , Type = "Mod", InitialKey1 = "LeftAlt+F" },
	{ID = "XXZCunChu" , Name = "打开仓库" , Type = "Mod", InitialKey1 = "LeftAlt+G" },
	};
	return HotKey;
end
function WuPinSeve:OnHotKey(ID,state)
	if ID == "XXZCunChu" and state == "down" then
		world:EnterUILuaMode("LUA_cunchu_cailiao")
		return false
	end
	if state == "down" then
		GameMain:GetMod("Windows"):CreateWindow(ID):Show()
	end
end
]]--



function WuPinSeve:Table()

local WuPinJiaZhiList = 
{
{"Item_Dan_Thin",188  }, --  塑身丹
{"Item_Dan_Fat",188  }, --  壮体丹
{"Item_Dan_NoHunger2",188  }, --  辟谷丹
{"Item_Dan_NoHunger1",188  }, --  兵粮丸
{"Item_Dan_LostSoul",188  }, --  摄神丹
{"Item_Dan_Happiness",588  }, --  极乐丹
{"Item_Dan_JingYuan",1088  }, --  精元丹
{"Item_Dan_JingYuan2",1888  }, --  参芝九窍丸
{"Item_Dan_JingYuan3",5888  }, --  血竭散
{"Item_Dan_Ling",588  }, --  聚灵丹
{"Item_Dan_NoHunger",588  }, --  饮气丹
{"Item_Dan_Restore",588  }, -- 归源散
{"Item_Dan_DredgeQi1",588  }, --  通脉散
{"Item_Dan_DredgeQi",788  }, --  理气丹
{"Item_Dan_WuLingSan",788  }, --  五灵散
{"Item_Dan_PracticeRate",8888  }, --  黄庭丹
{"Item_Dan_PracticeSpeed",8888  }, --  黄芽丹
{"Item_Dan_Ling2",4888  }, --  紫阳丹
{"Item_BasePracticeDrug",48888  }, --  筑基丹
{"Item_Dan_Defense",588  }, -- 真罡丹
{"Item_Dan_FiveBase1",588  }, -- 通天丸
{"Item_Dan_FiveBase2",888  }, -- 纳地丸
{"Item_Dan_FiveBase3",588  }, --  逸仙丸
{"Item_Dan_FiveBase4",588  }, -- 明通丸 
{"Item_Dan_FiveBase5",588  }, --  神佑丸
{"Item_Dan_FiveBaseFromLife",5888  }, --  五毒五炁元神丹
{"Item_Dan_Soul1",1888  }, -- 神泣丹
{"Item_Dan_Soul2",1888  }, -- 通玄丹
{"Item_Dan_Soul3",1888  }, -- 凝珀丹
{"Item_Dan_Soul4",1888  }, -- 燃魂丹
{"Item_Dan_Ling3",1888  }, -- 万灵散
{"Item_Dan_CureFiveElementDamage",2888  }, --  五方化伤丹
{"Item_Dan_CureJinDamage",6888  }, --  庚金万化丸
{"Item_Dan_CureMuDamage",6888  }, --  碧春丹
{"Item_Dan_CureShuiDamage",6888  }, --  天一承气散
{"Item_Dan_CureHuoDamage",6888  }, --  火真丹
{"Item_Dan_CureTuDamage",6888  }, --  定坤丹
{"Item_Dan_SwordBall",4888  }, -- 剑丸
{"Item_Dan_IncreaseNeckCountdown2",4888  }, -- 碧血丹青
{"Item_Dan_IncreaseLife2",5888  }, -- 玄牝续命散
{"Item_Dan_ReBorn",10888  }, --  玄牝重生丹
{"Item_Dan_IncreaseLife1",10888  }, --长生丹 
{"Item_Dan_IncreaseLife4",19888  }, -- 再造金丹
{"Item_Dan_IncreaseNeckCountdown1",22888 }, -- 乾元避劫丹
{"Item_Dan_HundredRefine",38888  }, -- 九转金丹
{"Item_Dan_IncreaseLife5",48888  }, -- 未来星宿化劫丹
{"Item_Dan_IncreaseLife3",58888  }, -- 五极灵丹
{"Item_Dan_ExtremeLofty",68888  }, -- 造化神丹
{"Item_Dan_TreeEXP",88888  }, --  天道神丹
{"Item_Dan_LingYuanZhong",158888  }, --  灵源种
{"Item_Dan_LongDan1",588888  }, --  龙魂真灵丹
{"Item_Dan_FengDan1",588888  }, --  凤魂真灵丹
{"Item_Dan_ZhuLongDan1",588888  }, --  阴阳真灵丹
{"Item_Ginkgo",0.5  }, --  银杏果
{"Item_Healroot",0.5  }, --药草
{"Item_Pear",0.5  }, --  梨
{"Item_Lotusroot",0.5  }, --  莲藕
{"Item_Wheat",0.6  }, --  小麦
{"Item_Mushroom",0.6  }, --  香菇
{"Item_Wood",1  }, --  原木
{"Item_Cotton",1  }, --  棉花
{"Item_BrownRock",1.2  }, --棕石
{"Item_GrayRock",1.5  }, --灰石
{"Item_Fruit",12  }, --  龙涎果
{"Item_RabbitLeather",2  }, --兔皮
{"Item_WolfLeather",4  }, --狼皮
{"Item_BoarLeather",6  }, --野猪皮
{"Item_BearLeather",8  }, --熊皮
{"Item_SnakeGallbladder",15  }, --蛇胆
{"Item_BearGallbladder",20  }, --熊胆
{"Item_Marble",4  }, --大理石
{"Item_IronRock",6  }, --铁矿
{"Item_Mint",10  }, --清心草
{"Item_MagicHerb",10  }, --灵仙草
{"Item_Ginseng",10  }, --人参
{"Item_GanodermaLucidum",10  }, --芝草
{"Item_Cinnabar",20  }, --  朱砂
{"Item_CopperRock",50  }, --火铜矿石
{"Item_SilverRock",50  }, --寒晶矿石
{"Item_LingStone",66  }, --灵石
{"Item_Jade",88 }, --玉石
{"Item_HardWood",88  }, --金丝灵木
{"Item_StoneEssence",120  }, --石髓
{"Item_JadeEssence",120  }, --玉髓
{"Item_LingWood",180  }, --灵木
{"Item_YaoLeather",240  }, --妖化的兽皮
{"Item_SoulCrystalNing",188  }, -- 宁珀
{"Item_SoulCrystalYou",244  }, -- 幽珀
{"Item_SoulCrystalLing",288  }, -- 灵珀
{"Item_DarksteelRock",580  }, --玄铁
{"Item_LingWater",360  }, -- 灵初露
{"Item_PurpleGanodermaLucidum",480  }, --紫芝
{"Item_RedGinseng",480  }, --赤参
{"Item_FeiLeather",360  }, --蜚之皮
{"Item_LuShuLeather",360  }, --鹿蜀之皮
{"Item_YaoLeather1",360  }, --  妖兽的韧皮
{"Item_MonsterBlood",360  }, --妖灵血
{"Item_LingMuXueJie",488  }, --灵木血竭
{"Item_LifeStream",2888  }, --长生泉
{"Item_EarthEssence",2888  }, --地母灵液
{"Item_EarthEssence1",2888  }, --邪脉血泉
{"Item_EarthEssence_1",2888  }, --灵髓脂
{"Item_EarthEssence1_1",2888  }, --血髓脂
{"Item_DragonShit",733  }, --天龙砂
{"Item_SkyStone",2888  }, --天柱石
{"Item_ExtremeJade",2888  }, --千棱神玉
{"Item_ParasolWood",2888  }, --梧桐神木
{"Item_StarEssence",2888  }, --星髓
{"Item_SoulPearl",3666  }, --玄牝珠
{"Item_BenYuan_Jin",10888  }, --  天道本源-金
{"Item_BenYuan_Mu",10888  }, -- 天道本源-木 
{"Item_BenYuan_Shui",10888  }, --  天道本源-水
{"Item_BenYuan_Huo",10888  }, --  天道本源-火
{"Item_BenYuan_Tu",10888  }, --  天道本源-土
{"Item_BenYuan_None",10888  }, --  天道本源-无
{"Item_ZaoHuaYuLu",8888  }, --造化玉露 
{"Item_LingCrystal",3333  },--灵晶
{"Item_ThunderAir",12800  }, --天劫之息
{"Item_JinEssence",38888  }, --琅琊果
{"Item_MuEssence",38888  }, --木枯藤
{"Item_ShuiEssence",38888  }, --五色金莲
{"Item_HuoEssence",38888  }, --朱果
{"Item_TuEssence",38888  }, --赭黄精
{"Item_ZaoHuaYuZi",18888  }, --造化玉籽

{"Item_XieHunLu",3888  }, --  邪魂露
{"Item_YuanHunLu",3888  }, --  元魂露
{"Item_QieDaoGuo",24444  }, --  窃道果
{"Item_XianDaoShenNian",18888  }, --  仙识神念
{"Item_XianDaoXieNian",18888  }, --  仙识邪念
{"Item_YanDaoGuo",38888  }, --  演道果

{"Item_Yao_BoarMeat",1888  },--猪妖的精肉
{"Item_BossFeng_Meat",6888  },--凶凤的血肉
{"Item_BossLong_Meat",6888  },--蛟龙的血肉
{"Item_BossZhuLong_Meat",6888  },--原初血肉

{"Item_BossFeng_HuoYu",9888  },--炽烈的火羽35
{"Item_DragonScale",9888  }, --脱落的龙鳞35
{"Item_BossFeng_GangYu",9888  },--凶凤的刚羽35
{"Item_BossLong_Lin",9888  },--蛟龙的玄鳞
{"Item_BossZhuLong_BaiLin",9888  },--洁白的大鳞
{"Item_BossZhuLong_HeiLin",9888  },--漆黑的大鳞

{"Item_BossFeng_Gu",20888  },--凶凤的坚空骨50
{"Item_BossLong_Zhua",20888  },--蛟龙的罗刹爪

{"Item_BossFeng_WeiYu",48888  },--凶凤的蔽天羽75
{"Item_BossLong_Jing",48888  },--蛟龙的崩天筋
{"Item_BossZhuLong_Eye",48888  },--阴阳之结晶

{"Item_BossFeng_TouYu",188888  },--凶凤的烬灭羽150
{"Item_BossLong_Jiao",188888  },--蛟龙的天角150
{"Item_BossZhuLong_TianLin",188888  },--烛龙的天鳞

{"Item_BossFeng_HongYu",288888  },--凶凤的真焱玉200
{"Item_BossLong_NiLin",288888  },--蛟龙的逆鳞
{"Item_BossZhuLong_LongYu",288888  },--混沌的龙玉

{"Item_SpellPaper",48  },--神珀符
{"Item_SpellPaperLv2",158  },--神珀符
{"Item_SpellPaperLv3",388  },--神珀符

{"Item_MiBao_WuDuZhuXianSword",488888  },--五毒诛仙剑
{"Item_MiBao_BaiLingZhanXianSword",488888  },--百灵斩仙剑
{"Item_MiBao_ShiErShaShenMoLingSha",488888  },--十二煞神魔灵砂
{"Item_MiBao_TianMoHuaXueShenDao",488888  },--天魔化血神刀
{"Item_MiBao_YinHunZhu",488888  },--饮魂珠
{"Item_MiBao_JiuTianYuanYangChi",488888  },--九天元阳尺
{"Item_MiBao_LongXinYinYangGui",488888  },--龙心阴阳圭
{"Item_MiBao_DaiShenZhu",488888  },--代身珠
{"Item_MiBao_QiJueShenZhen",488888  },--偷天七绝针
{"Item_MiBao_XiXingShenSuo",488888  },--吸星神梭
{"Item_MiBao_TaiYiFenGuangJian",488888  },--太乙分光剑
{"Item_MiBao_WuqiLeiFu",488888  },--五气雷符
{"Item_MiBao_JinFabao",488888  },--素色云界旗
{"Item_MiBao_MuFabao",488888  },--青莲宝色旗
{"Item_MiBao_ShuiFabao",488888  },--真武皂雕旗
{"Item_MiBao_HuoFabao",488888  },--离地焰光旗
{"Item_MiBao_TuFabao",488888  },--戊己杏黄旗
{"Item_MiBao_JinLianShenZuo",488888  },--金莲神座
{"Item_MiBao_TunLingShenJian",488888  },--吞灵神剪
{"Item_MiBao_ShenNongDing",488888  },--神农鼎
{"Item_MiBao_QingNingFeiYu",488888  },--清宁飞羽
{"Item_MiBao_YuanShenXinJian",488888  },--元神心剑
{"Item_MiBao_ZhuXianJian",488888  },--诛仙剑
{"Item_MiBao_LuXianJian",488888  },--戮仙剑
{"Item_MiBao_XianXianJian",488888  },--陷仙剑
{"Item_MiBao_JueXianJian",488888  },--绝仙剑
{"Item_MiBao_TianLangDing",488888  },--天狼蚊须钉
{"Item_MiBao_TianShu",488888  },--天枢剑
{"Item_MiBao_TianQuan",488888  },--天权剑
{"Item_MiBao_TianJi",488888  },--天玑剑
{"Item_MiBao_TianXuan",488888  },--天璇剑
{"Item_MiBao_YuHeng",488888  },--玉衡剑
{"Item_MiBao_KaiYang",488888  },--开阳剑
{"Item_MiBao_YaoGuang",488888  },--摇光剑
{"Item_MiBao_KuiHuaShenJian",488888  },--一剑
{"Item_MiBao_ZhuXianZhenTu",288888  },--诛仙阵图
{"Item_MiBao_QiXingZhenTu",288888  },--北斗真武戮魔阵图
{"Item_MiBao_TianDiWuFangZhenTu",288888  },--天地五方不灭阵图
{"Item_MiBao_LiuYuZhenTu",288888  },--诸天六御仪轨总图
{"Item_MiBao_LongXingZhenTu",288888  },--九御赋龙形阵图
{"Item_MiBao_FengHunZhenTu",288888  },--真凰羽剑阵图
{"Item_MiBao_YinYangZhenTu",288888  },--阴阳二行阵图
{"Item_MiBao_SanYinZhenTu",288888  },--三阴三绝阵图
{"Item_MiBao_BaMenZhenTu",288888  },--八门天劫剑阵图
{"Item_MiBao_ShenMuZhenTu",288888  },--先天甲乙木神阵图
{"Item_MiBao_WuYueZhenTu",288888  },--五峰镇归墟阵图

{"Item_Wonder_BaBaoGongDe",188888  },--八宝功德之心
{"Item_Wonder_WanDaoZunFaZuo",188888  },--万道尊法之心
{"Item_Wonder_QiQingQingTongShu",188888  },--七情之心
{"Item_Wonder_ZhouTianXingDouPan",188888  },--周天星斗之心
{"Item_Wonder_WuLongXuanJinTa",188888  },--玄阳之心
{"Item_Wonder_ShuShanJianChi",188888  },--剑之心
{"Item_Wonder_LingYuFeng",188888  },--灵玉之心
{"Item_Wonder_WanGuXieFaTan",188888  },--万骨之心
{"Item_Wonder_XuanCiTianKeng",188888  },--玄磁之心
{"Item_Wonder_QiShaShenBei",188888  },--七杀之心
{"Item_Wonder_XuanYinShengQuan",188888  },--玄阴之心

{"Item_shoupi1",1888},
{"Item_shoupi2",5888  },
{"Item_shoupi3",38888  },
{"Item_shoupi4",188888  },
{"Item_shoupi5",888888  },
{"Item_yumao1",1888 },
{"Item_yumao2",5888  },
{"Item_yumao3",38888  },
{"Item_yumao4",188888  },
{"Item_yumao5",888888  },
{"Item_cailiao_mucai0",5},
{"Item_cailiao_shikuang0",5},
{"Item_cailiao_jinkuang0",5},
{"Item_cailiao_mucai1",688},
{"Item_cailiao_mucai2",688},
{"Item_cailiao_mucai3",688},
{"Item_cailiao_mucai4",688},
{"Item_cailiao_mucai5",688},
{"Item_cailiao_mucai6",688},
{"Item_cailiao_mucai7",688},
{"Item_cailiao_shikuang1",688},
{"Item_cailiao_shikuang2",688},
{"Item_cailiao_shikuang3",688},
{"Item_cailiao_shikuang4",688},
{"Item_cailiao_shikuang5",688},
{"Item_cailiao_shikuang6",688},
{"Item_cailiao_shikuang7",688},
{"Item_cailiao_jinkuang1",688},
{"Item_cailiao_jinkuang2",688},
{"Item_cailiao_jinkuang3",688},
{"Item_cailiao_jinkuang4",688},
{"Item_cailiao_jinkuang5",688},
{"Item_cailiao_jinkuang6",688},
{"Item_cailiao_jinkuang7",688},
{"Item_cailiao_muliao1",1888},
{"Item_cailiao_muliao2",1888},
{"Item_cailiao_muliao3",1888},
{"Item_cailiao_muliao4",1888},
{"Item_cailiao_muliao5",1888},
{"Item_cailiao_muliao6",1888},
{"Item_cailiao_muliao7",1888},
{"Item_cailiao_shizhuan1",1888},
{"Item_cailiao_shizhuan2",1888},
{"Item_cailiao_shizhuan3",1888},
{"Item_cailiao_shizhuan4",1888},
{"Item_cailiao_shizhuan5",1888},
{"Item_cailiao_shizhuan6",1888},
{"Item_cailiao_shizhuan7",1888},
{"Item_cailiao_jinshu1",1888},
{"Item_cailiao_jinshu2",1888},
{"Item_cailiao_jinshu3",1888},
{"Item_cailiao_jinshu4",1888},
{"Item_cailiao_jinshu5",1888},
{"Item_cailiao_jinshu6",1888},
{"Item_cailiao_jinshu7",1888},
{"Item_qianghua_suipian1",188},
{"Item_qianghua_suipian2",188},
{"Item_qianghua_suipian3",188},
{"Item_qianghua_suipian4",188},
{"Item_qianghua_suipian5",188},
{"Item_qianghua_suipian6",188},
{"Item_qianghua_suipian7",188},
{"Item_qianghua_suipian8",188},
{"Item_qianghua_suipian9",188},
{"Item_qianghua_suipian10",188},
{"Item_fumo_fuwen_dong1",188888},
{"Item_fumo_fuwen_dong2",188888},
{"Item_fumo_fuwen_dong3",188888},
{"Item_fumo_fuwen_dong4",188888},
{"Item_fumo_fuwen_dong5",188888},
{"Item_fumo_fuwen_dong6",188888},
{"Item_fumo_fuwen_dong7",188888},
{"Item_fumo_fuwen_nan1",188888},
{"Item_fumo_fuwen_nan2",188888},
{"Item_fumo_fuwen_nan3",188888},
{"Item_fumo_fuwen_nan4",188888},
{"Item_fumo_fuwen_nan5",188888},
{"Item_fumo_fuwen_nan6",188888},
{"Item_fumo_fuwen_nan7",188888},
{"Item_fumo_fuwen_xi1",188888},
{"Item_fumo_fuwen_xi2",188888},
{"Item_fumo_fuwen_xi3",188888},
{"Item_fumo_fuwen_xi4",188888},
{"Item_fumo_fuwen_xi5",188888},
{"Item_fumo_fuwen_xi6",188888},
{"Item_fumo_fuwen_xi7",188888},
{"Item_fumo_fuwen_bei1",188888},
{"Item_fumo_fuwen_bei2",188888},
{"Item_fumo_fuwen_bei3",188888},
{"Item_fumo_fuwen_bei4",188888},
{"Item_fumo_fuwen_bei5",188888},
{"Item_fumo_fuwen_bei6",188888},
{"Item_fumo_fuwen_bei7",188888},
{"Item_fumo_suipian1",188},
{"Item_fumo_suipian2",388},
{"Item_fumo_suipian3",588},
{"Item_fumo_suipian4",1288},
{"Item_fumo_suipian5",2488},
{"Item_fumo_suipian6",4688},
{"Item_fumo_suipian7",7888},
{"Item_fumo_suipian8",12888},
{"Item_fumo_suipian9",18888},
{"Item_fumo_suipian10",28888},
{"Item_fumo_qiling1",5888},
{"Item_fumo_qiling2",18888},
{"Item_fumo_qiling3",58888},
{"Item_fumo_qiling4",188888},
{"Item_fumo_chongzhu1",1888},
{"Item_fumo_chongzhu2",2888},
{"Item_fumo_chongzhu3",3888},
{"Item_fumo_chongzhu4",3888},
{"Item_fumo_chongzhu5",3888},
{"Item_fumo_fuwen_pinzhi1",1888},
{"Item_fumo_fuwen_pinzhi2",3888},
{"Item_fumo_fuwen_pinzhi3",6888},
{"Item_fumo_fuwen_pinzhi4",12888},
{"Item_fumo_fuwen_pinzhi5",38888},
{"Item_fumo_fuwen_leijie1",3888},
{"Item_fumo_fuwen_leijie2",8888},
{"Item_fumo_fuwen_leijie3",18888},
{"Item_fumo_fuwen_leijie4",38888},
{"Item_fumo_fuwen_leijie5",88888},
{"Item_fumo_fuwen_pinjie1",12888},
{"Item_fumo_fuwen_meiguan1",8888},
{"Item_fumo_fuwen1",888},
{"Item_fumo_fuwen2",1888},
{"Item_fumo_fuwen3",3888},
{"Item_fumo_fuwen4",8888},
{"Item_fumo_fuwen5",18888},
{"Item_fumo_fuwen_1",3888},
{"Item_fumo_fuwen_2",3888},
{"Item_fumo_fuwen_3",3888},
{"Item_fumo_fuwen_4",3888},
{"Item_fumo_fuwen_5",3888},
{"Item_fumo_fuwen_6",3888},
{"Item_fumo_fuwen_7",3888},
{"Item_fumo_fuwen_8",3888},
{"Item_fumo_fuwen_9",3888},
{"Item_fumo_fuwen_10",3888},
{"Item_fumo_fuwen_11",3888},
{"Item_fumo_fuwen_12",3888},
{"Item_fumo_fuwen_13",3888},
{"Item_fumo_fuwen_14",3888},
{"Item_fumo_fuwen_15",3888},
{"Item_fumo_fuwen_16",3888},
{"Item_fumo_fuwen_17",3888},
{"Item_fumo_fuwen_18",3888},
{"Item_fumo_fuwen_19",3888},
{"Item_fumo_fuwen_20",3888},
{"Item_fumo_fuwen_21",3888},
{"Item_fumo_fuwen_22",3888},
{"Item_fumo_fuwen_23",3888},
{"Item_fumo_fuwen_24",3888},
{"Item_fumo_fuwen_25",3888},
{"Item_fumo_fuwen_26",3888},
{"Item_fumo_fuwen_27",3888},
{"Item_fumo_fuwen_28",3888},
{"Item_fumo_fuwen_29",3888},
{"Item_fumo_fuwen_30",3888},
{"Item_fumo_fuwen_31",3888},
{"Item_fumo_fuwen_32",3888},
{"Item_fumo_fuwen_33",3888},
{"Item_fumo_fuwen_34",3888},
{"Item_fumo_fuwen_35",3888},
{"Item_fumo_fuwen_36",3888},
{"Item_fumo_fuwen_37",3888},
{"Item_fumo_fuwen_38",3888},
{"Item_fumo_fuwen_39",3888},
{"Item_fumo_fuwen_40",3888},
{"Item_fumo_fuwen_41",3888},
{"Item_fumo_fuwen_42",3888},
{"Item_fumo_fuwen_43",3888},
{"Item_fumo_fuwen_44",3888},
{"Item_fumo_fuwen_45",3888},
{"Item_fumo_fuwen_46",3888},
{"Item_fumo_fuwen_47",3888},
{"Item_fumo_fuwen_48",3888},
{"Item_fumo_fuwen_49",3888},
{"Item_fumo_fuwen_50",3888},
{"Item_fumo_fuwen_51",3888},
{"Item_fumo_fuwen_52",3888},
{"Item_fumo_fuwen_53",3888},
{"Item_fumo_fuwen_54",3888},
{"Item_fumo_fuwen_55",3888},
{"Item_fumo_fuwen_56",3888},
{"Item_fumo_fuwen_57",3888},
{"Item_fumo_fuwen_58",3888},
{"Item_fumo_fuwen_59",3888},
{"Item_fumo_fuwen_60",3888},
{"Item_fumo_fuwen_61",3888},
{"Item_fumo_fuwen_62",3888},
{"Item_fumo_fuwen_63",3888},
{"Item_fumo_fuwen_64",3888},

{"Item_lingshi_canpian",88},
{"Item_lingshi_jin1",588},
{"Item_lingshi_jin2",1088},
{"Item_lingshi_jin3",2088},
{"Item_lingshi_jin4",5888},
{"Item_lingshi_jin5",10888},
{"Item_lingshi_jin6",28888},
{"Item_lingshi_jin7",58888},
{"Item_lingshi_jin8",98888},
{"Item_lingshi_jin9",288888},
{"Item_lingshi_jin10",688888},
{"Item_lingshi_jin11",1888888},
{"Item_lingshi_mu1",588},
{"Item_lingshi_mu2",1088},
{"Item_lingshi_mu3",2088},
{"Item_lingshi_mu4",5888},
{"Item_lingshi_mu5",10888},
{"Item_lingshi_mu6",28888},
{"Item_lingshi_mu7",58888},
{"Item_lingshi_mu8",98888},
{"Item_lingshi_mu9",288888},
{"Item_lingshi_mu10",688888},
{"Item_lingshi_mu11",1888888},
{"Item_lingshi_shui1",588},
{"Item_lingshi_shui2",1088},
{"Item_lingshi_shui3",2088},
{"Item_lingshi_shui4",5888},
{"Item_lingshi_shui5",18888},
{"Item_lingshi_shui6",28888},
{"Item_lingshi_shui7",58888},
{"Item_lingshi_shui8",98888},
{"Item_lingshi_shui9",288888},
{"Item_lingshi_shui10",688888},
{"Item_lingshi_shui11",1888888},
{"Item_lingshi_huo1",588},
{"Item_lingshi_huo2",1088},
{"Item_lingshi_huo3",2088},
{"Item_lingshi_huo4",5888},
{"Item_lingshi_huo5",10888},
{"Item_lingshi_huo6",28888},
{"Item_lingshi_huo7",58888},
{"Item_lingshi_huo8",98888},
{"Item_lingshi_huo9",688888},
{"Item_lingshi_huo10",1888888},
{"Item_lingshi_huo11",1888888},
{"Item_lingshi_tu1",588},
{"Item_lingshi_tu2",1088},
{"Item_lingshi_tu3",2088},
{"Item_lingshi_tu4",5888},
{"Item_lingshi_tu5",10888},
{"Item_lingshi_tu6",28888},
{"Item_lingshi_tu7",58888},
{"Item_lingshi_tu8",98888},
{"Item_lingshi_tu9",288888},
{"Item_lingshi_tu10",688888},
{"Item_lingshi_tu11",1888888},
{"Item_lingshi_yuan1",588},
{"Item_lingshi_yuan2",1088},
{"Item_lingshi_yuan3",2088},
{"Item_lingshi_yuan4",5888},
{"Item_lingshi_yuan5",10888},
{"Item_lingshi_yuan6",28888},
{"Item_lingshi_yuan7",58888},
{"Item_lingshi_yuan8",98888},
{"Item_lingshi_yuan9",288888},
{"Item_lingshi_yuan10",688888},
{"Item_lingshi_yuan11",1888888},
{"Item_lingshi_hun1",588},
{"Item_lingshi_hun2",1088},
{"Item_lingshi_hun3",2088},
{"Item_lingshi_hun4",5888},
{"Item_lingshi_hun5",28888},
{"Item_lingshi_hun6",58888},
{"Item_lingshi_hun7",58888},
{"Item_lingshi_hun8",98888},
{"Item_lingshi_hun9",288888},
{"Item_lingshi_hun10",688888},
{"Item_lingshi_hun11",1888888},
{"Item_zaohua_tu_1",58888},
{"Item_zaohua_tu_2",58888},
{"Item_zaohua_tu_3",58888},
{"Item_zaohua_tu_4",58888},
{"Item_zaohua_tu_5",58888},
{"Item_zaohua_tu_6",58888},
{"Item_zaohua_tu_7",58888},
{"Item_zaohua_shui_1",38888},
{"Item_zaohua_shui_2",38888},
{"Item_zaohua_shui_3",38888},
{"Item_zaohua_shui_4",38888},
{"Item_zaohua_shui_5",38888},
{"Item_zaohua_shui_6",38888},
{"Item_zaohua_shui_7",38888},

{"Item_lingguo_jin1",1800},
{"Item_lingguo_jin2",3600},
{"Item_lingguo_jin3",7200},
{"Item_lingguo_jin4",12800},
{"Item_lingguo_jin5",18800},
{"Item_lingguo_jin6",26800},
{"Item_lingguo_jin7",36800},
{"Item_lingguo_jin8",48800},
{"Item_lingguo_jin9",68800},
{"Item_lingguo_jin10",98800},
{"Item_lingguo_jin11",128000},
{"Item_lingguo_mu1",1800},
{"Item_lingguo_mu2",3600},
{"Item_lingguo_mu3",7200},
{"Item_lingguo_mu4",12800},
{"Item_lingguo_mu5",18800},
{"Item_lingguo_mu6",26800},
{"Item_lingguo_mu7",36800},
{"Item_lingguo_mu8",48800},
{"Item_lingguo_mu9",68800},
{"Item_lingguo_mu10",98800},
{"Item_lingguo_mu11",128000},
{"Item_lingguo_shui1",1800},
{"Item_lingguo_shui2",1800},
{"Item_lingguo_shui3",7200},
{"Item_lingguo_shui4",12800},
{"Item_lingguo_shui5",18800},
{"Item_lingguo_shui6",26800},
{"Item_lingguo_shui7",36800},
{"Item_lingguo_shui8",48800},
{"Item_lingguo_shui9",68800},
{"Item_lingguo_shui10",98800},
{"Item_lingguo_shui11",128000},
{"Item_lingguo_huo1",1800},
{"Item_lingguo_huo2",3600},
{"Item_lingguo_huo3",7200},
{"Item_lingguo_huo4",12800},
{"Item_lingguo_huo5",18800},
{"Item_lingguo_huo6",26800},
{"Item_lingguo_huo7",36800},
{"Item_lingguo_huo8",48800},
{"Item_lingguo_huo9",68800},
{"Item_lingguo_huo10",98800},
{"Item_lingguo_huo11",128000},
{"Item_lingguo_tu1",1800},
{"Item_lingguo_tu2",3600},
{"Item_lingguo_tu3",7200},
{"Item_lingguo_tu4",12800},
{"Item_lingguo_tu5",18800},
{"Item_lingguo_tu6",26800},
{"Item_lingguo_tu7",36800},
{"Item_lingguo_tu8",48800},
{"Item_lingguo_tu9",68800},
{"Item_lingguo_tu10",98800},
{"Item_lingguo_tu11",128000},

{"Item_jinghua_jiejing1",38888},


{"Item_lingguo_wuxing1",38800},
{"Item_zhuanshu_lingpai_luxueqi",888888},
{"Item_zhuanshu_lingpai_biyao",888888},
{"Item_zhuanshu_lingpai_sunwukong",888888},
{"Item_zhuanshu_lingpai_lvbu",888888},
{"Item_zhuanshu_lingpai_libai",888888},
{"Item_zhuanshu_lingpai_guanyu",888888},
{"Item_zhuanshu_lingpai_yuji",888888},
{"Item_zhuanshu_lingpai_diaochan",888888},
{"Item_zhuanshu_lingpai_zixia",888888},

}

	return WuPinJiaZhiList
	
end







