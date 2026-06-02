local Windows = GameMain:GetMod("Windows");--先注册一个新的MOD模块
local tbWindow = Windows:CreateWindow("XXZ_RenWu")

local WuPinSeve = GameMain:GetMod("XXZ_WuPinTable_SEVE")
local RenWuSeve = GameMain:GetMod("XXZ_RenWuTable_SEVE");
local tbEvent = GameMain:GetMod("_Event");
local selflist = selflist or {}


function tbWindow:OnInit()
	self.window.contentPane =  UIPackage.CreateObject("XXZUI", "XXZRenWu");--载入UI包里的窗口
	self.window.closeButton = self:GetChild("frame"):GetChild("n5");
	self:GetChild("frame").tooltips = "[size=12][color=#00688B]任务系统还未接入，当前点数只能通过提交底下收购的物品获取[/color][/size]"
	--GameMain:GetMod("Windows"):CreateWindow("XXZ_RenWu"):Show()
	self.list = self:GetChild("list")
	self.list.onClickItem:Add(tbWindow.ClickSelectItem)
	
	self.list1 = self:GetChild("list1")
	self.list1.onClickItem:Add(tbWindow.ClickSelectItem)
	
	self.bntvs = self:GetChild("bnt_vs");	
	self.bntvs.onClick:Add(tbWindow.OnClick);
	
	self.TextInput1 = self:GetChild("TextInput1");
	self.TextInput1.title = 1
	self.TextInput1.tooltips = "[size=12][color=#00688B]在此处设置每次提交物品的最大值，当提交的物品小于此数值将全部提交[/color][/size]"
	
	self.window:Center();
	local a = self.window.position;
	self.window:SetPosition(a.x,100,a.x);
end


function tbWindow.ClickSelectItem(context)
	if context.sender.name == "list" then
		local num = tonumber(context.data.apexIndex)
		local count = tonumber(tbWindow:GetChild("TextInput1").title)
		local items = selflist["changzhulist"][num]
		local jiage = items[2]
		local tname = ThingMgr:GetDef(g_emThingType.Item,items[1])
		if items[3] <= 0 then
			world:ShowMsgBox(tname.ThingName.."提交到了上限无法继续提交，请等待刷新", "提交失败")
			return false
		end
		if count then
			count = math.floor(math.abs(count))
			if count == 0 then
				count = 1
			end
			if count >= items[3] then
				count = items[3]
			end
		else
			count = 1
		end
		local CaiLiaoList = GameMain:GetMod("XXZ_JianYiCangKu_SEVE"):GetCangKuCaiLiao()
		if CaiLiaoList ~= nil then
			for i=1,#CaiLiaoList do 
				local item = CaiLiaoList[i]
				if items[1] == item[1] then
					local shuoming =  "当前提交物品："..tname.ThingName.."\n当前提交数量："..count.."个\n仓库中已存在"..item[2].."个，是否直接提交，取消将需要自己选择地图上的对应物品"
					CS.Wnd_Message.Show(nil, 2,
					function (s)
						if s == "1" then
							if count >= item[2] then
								count = item[2]
							end
							GameMain:GetMod("ZH_zhanghu"):AddLingNum(jiage*count)
							GameMain:GetMod("XXZ_JianYiCangKu_SEVE"):CunChuCaiLiao(item[1],-count)
							local sycount = GameMain:GetMod("XXZ_RenWuTable_SEVE"):SetChangZhuCount(num,count)
							world:ShowMsgBox(tname.ThingName.."提交成功，本次共提交"..count.."个\n共获得点数"..jiage*count.."点\n剩余可提交数量"..sycount, "提交成功")
						else
							world:EnterUILuaMode("LUA_XXZ_wupin_tijiao",items[1],jiage,count,num)
						end
					end, true, "物品提交", 0, 0,shuoming)
					return false
				end
			end
		end
		world:EnterUILuaMode("LUA_XXZ_wupin_tijiao",items[1],jiage,count,num)
		return false
	end
end

function tbWindow.OnClick(context)
	if context.sender.name == "bnt_vs" then
		tbWindow:Hide()
		Windows:CreateWindow("XXZ_TiaoZhan"):Show()
	end
end
--GameMain:GetMod("XXZ_RenWuTable_SEVE"):ChangZhuInit()
--GameMain:GetMod("Windows"):CreateWindow("XXZ_RenWu"):OnShowUpdate()
function tbWindow:OnShowUpdate()
	self.list:RemoveChildrenToPool()
	for i=1,#selflist["changzhulist"] do
		local items = selflist["changzhulist"][i]
		if items[1] ~= nil then
			local item = self.list:AddItemFromPool()
			local tname = ThingMgr:GetDef(g_emThingType.Item,items[1])
			item.icon = tname.TexPath
			item.apexIndex = i
			item.title = tname.ThingName
			item.tooltips = string.format("[size=15][color=#1C86EE]%s[/color][/size]\n[size=12][color=#00688B]物品价格：%s\n收购数量：%s\n价格浮动：%s\n刷新时间：每天\n每天物品提交到达上限时，请等待第二天刷新再进行提交[/color][/size]",tname.ThingName,items[2],items[3],items[4])
		end
	end
end

function tbWindow:OnShown()
	tbWindow.IsShowing = true

end


function tbWindow:OnHide()
	tbWindow.IsShowing = false

end














function RenWuSeve:OnInit()
	tbEvent:RegisterEvent(g_emEvent.DayChange, RenWuSeve.OnDayChange, "XXZ_RenWuTable_SEVE")
end


function RenWuSeve:OnSave()
	return selflist
end


function RenWuSeve:OnLoad(t)
	selflist = t or {}
end

function RenWuSeve.OnDayChange()
	RenWuSeve:ChangZhuInit()
end


function RenWuSeve:OnStep(dt)
	if selflist["changzhulist"] == nil then
		selflist["changzhulist"] = {}
		RenWuSeve:ChangZhuInit()
	end
end 

--GameMain:GetMod("XXZ_RenWuTable_SEVE"):ChangZhuInit()
function RenWuSeve:ChangZhuInit()

	
	local WuPinJiaZhiList = WuPinSeve:Table()
	local daycount = world.DayCount
	local cailiao = {}
	cailiao[1] = {"Item_LingStone",7+math.floor(daycount/4)}
	cailiao[2] = {"Item_LingCrystal",2+math.floor(daycount/10)}
	local list1 = {
	{100,"Item_Wood",1},{100,"Item_Cotton",1},{100,"Item_BrownRock",1},{100,"Item_GrayRock",1},{85,"Item_Marble",0.85},{30,"Item_StoneEssence",0.3},{30,"Item_JadeEssence",0.3},
	{65,"Item_IronRock",0.65},{50,"Item_CopperRock",0.5},{50,"Item_SilverRock",0.5},{30,"Item_Jade",0.3},{30,"Item_LingWood",0.3},{30,"Item_Cinnabar",0.3},
	{20,"Item_HardWood",0.15},{10,"Item_DarksteelRock",0.1},{5,"Item_SkyStone",0.02},{5,"Item_ExtremeJade",0.02},{5,"Item_ParasolWood",0.02},{5,"Item_StarEssence",0.02}
	}
	
	local getlist1 = Lib:CountRateTable(list1, 1)
	local wupiname1 = list1[getlist1][2]
	local shuliang1 = list1[getlist1][1]
	local jiacheng1 = list1[getlist1][3]
	cailiao[3] = {wupiname1,shuliang1+math.floor(jiacheng1*daycount)};
	
	local lsjin,lsmu,lsshui,lshuo,lstu,lsyuan,lshun = "Item_lingshi_jin","Item_lingshi_mu","Item_lingshi_shui","Item_lingshi_huo","Item_lingshi_tu","Item_lingshi_yuan","Item_lingshi_hun"
	local list2 = {{50,"Item_lingshi_canpian",1},
	{10,lsjin.."1",0.4},{10,lsmu.."1",0.4},{10,lsshui.."1",0.4},{10,lshuo.."1",0.4},{10,lstu.."1",0.4},{10,lsyuan.."1",0.4},{10,lshun.."1",0.4},
	{7,lsjin.."2",0.2},{7,lsmu.."2",0.2},{7,lsshui.."2",0.2},{7,lshuo.."2",0.2},{7,lstu.."2",0.2},{7,lsyuan.."2",0.2},{7,lshun.."2",0.2},
	{5,lsjin.."3",0.1},{5,lsmu.."3",0.1},{5,lsshui.."3",0.1},{5,lshuo.."3",0.1},{5,lstu.."3",0.1},{5,lsyuan.."3",0.1},{5,lshun.."3",0.1},
	{3,lsjin.."4",0.05},{3,lsmu.."4",0.05},{3,lsshui.."4",0.05},{3,lshuo.."4",0.05},{3,lstu.."4",0.05},{3,lsyuan.."4",0.05},{3,lshun.."4",0.05},
	{3,lsjin.."5",0.03},{3,lsmu.."5",0.03},{3,lsshui.."5",0.03},{3,lshuo.."5",0.03},{3,lstu.."5",0.03},{3,lsyuan.."5",0.03},{3,lshun.."5",0.03},
	{2,lsjin.."6",0.02},{2,lsmu.."6",0.02},{2,lsshui.."6",0.02},{2,lshuo.."6",0.02},{2,lstu.."6",0.02},{2,lsyuan.."6",0.02},{2,lshun.."6",0.02},
	{2,lsjin.."7",0.01},{2,lsmu.."7",0.01},{2,lsshui.."7",0.01},{2,lshuo.."7",0.01},{2,lstu.."7",0.01},{2,lsyuan.."7",0.01},{2,lshun.."7",0.01},
	{1,lsjin.."8",0.01},{1,lsmu.."8",0.01},{1,lsshui.."8",0.01},{1,lshuo.."8",0.01},{1,lstu.."8",0.01},{1,lsyuan.."8",0.01},{1,lshun.."8",0.01},
	--{1,lsjin.."9",0.01},{1,lsmu.."9",0.01},{1,lsshui.."9",0.01},{1,lshuo.."9",0.01},{1,lstu.."9",0.01},{1,lsyuan.."9",0.01},{1,lshun.."9",0.01},
	}
	local getlist2 = Lib:CountRateTable(list2, 1);
	local wupiname2 = list2[getlist1][2]
	local shuliang2 = list2[getlist1][1]
	local jiacheng2 = list2[getlist1][3]
	cailiao[4] = {wupiname2,shuliang2+math.floor(jiacheng2*daycount)}
	
	local list3 = {
	{100,"Item_Ginkgo",1},{100,"Item_Healroot",1},{100,"Item_Pear",1},{100,"Item_Lotusroot",1},{100,"Item_Wheat",1},{100,"Item_Mushroom",1},
	{50,"Item_Fruit",0.5},{50,"Item_SnakeGallbladder",0.5},{50,"Item_BearGallbladder",0.5},{50,"Item_Mint",0.5},{50,"Item_MagicHerb",0.5},{50,"Item_Ginseng",0.5},{50,"Item_GanodermaLucidum",0.5},
	{10,"Item_LingWater",0.1},{10,"Item_PurpleGanodermaLucidum",0.1},{10,"Item_RedGinseng",0.1},{10,"Item_MonsterBlood",0.1},{10,"Item_LingMuXueJie",0.1},
	{2,"Item_LifeStream",0.05},{2,"Item_EarthEssence",0.05},{2,"Item_EarthEssence1",0.05},{2,"Item_EarthEssence_1",0.05},{2,"Item_EarthEssence1_1",0.05},{2,"Item_XieHunLu",0.05},{2,"Item_YuanHunLu",0.05},
	{1,"Item_BenYuan_None",0.05},{1,"Item_JinEssence",0.02},{1,"Item_MuEssence",0.02},{1,"Item_ShuiEssence",0.02},{1,"Item_HuoEssence",0.02},{1,"Item_TuEssence",0.02},
	}
	local getlist3 = Lib:CountRateTable(list3, 1);
	local wupiname3 = list3[getlist3][2]
	local shuliang3 = list3[getlist3][1]
	local jiacheng3 = list3[getlist3][3]
	cailiao[5] = {wupiname3,shuliang3+math.floor(jiacheng3*daycount)}
	
	
	local list4 = WuPinJiaZhiList[WorldLua:RandomInt(1,#WuPinJiaZhiList+1)]
	local wupiname4 = list4[1]
	local jiacheng4 = (300*daycount)/list4[2]
	local shuliang4 = math.max(1,jiacheng4)
	cailiao[6] = {wupiname4,shuliang4}
	
	for i=1,6 do
		local item = cailiao[i][1]
		local count = cailiao[i][2]
		for k,v in pairs(WuPinJiaZhiList) do
			if item == v[1] then
				local random1 = WorldLua:RandomFloat(0.5,1.7)
				local random2 = WorldLua:RandomFloat(0.6,1.8)
				local jiage = math.floor(v[2]*random1*100)/100
				local count = math.max(1,math.floor(count*random2))
				local shuoming = "价格平常"
				local num = random1-1
				if num > 0.1 then
					local list = {"价格略高","价格稍高","价格较高","价格极高","价格特高","价格超高","价格最高","价格最大化"}
					local num = math.ceil(num*10)
					shuoming = list[num]
				elseif num < -0.1 then
					local list = {"价格略高","价格稍低","价格较低","价格极低","价格特低","价格超低","价格最低","价格最小化"}
					local num = math.ceil(math.abs(num*10))
					shuoming = list[num]
				end
				selflist["changzhulist"][i] = {v[1],jiage,count,shuoming}
			end
		end
	end
	if tbWindow.IsShowing then
		tbWindow:OnShowUpdate()
	end
end



function RenWuSeve:SetChangZhuCount(num,count)
	if num ~= nil then
		selflist["changzhulist"][num][3] = selflist["changzhulist"][num][3]-count
		if tbWindow.IsShowing then
			tbWindow:OnShowUpdate()
		end
	end
	return selflist["changzhulist"][num][3] 
end

























