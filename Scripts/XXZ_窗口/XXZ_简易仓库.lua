local Windows = GameMain:GetMod("Windows");--先注册一个新的MOD模块
local tbWindow = Windows:CreateWindow("XXZ_JianYiCangKu");

local CangKuSeve = GameMain:GetMod("XXZ_JianYiCangKu_SEVE")
local tbEvent = GameMain:GetMod("_Event");

local selflist = selflist or {}


function tbWindow:OnInit()
	self.window.contentPane =  UIPackage.CreateObject("XXZUI", "XXZCangKu");--载入UI包里的窗口
	self.window.closeButton = self:GetChild("frame"):GetChild("n5");
	self:GetChild("frame").tooltips = "[size=12][color=#00688B]可以在此仓库中存取物品，此仓库存取物品仅为数量交换，指定一件物品直接移除，在仓库中直接获得物品数量，取出时消耗剩余数量生成新的物品，请注意，不能叠加的不可存，有特殊属性的不建议存[/color][/size]"
	
	self.hua_1 = self:GetChild("hua_1");
	self.num = self.hua_1.value
	self.hua_1.tooltips = "[size=12][color=#00688B]拖动光标取出物品的百分比\n物品百分比低于1，会取出一个[/color][/size]"
	
	self.TextInput1 = self:GetChild("TextInput2");
	self.TextInput1.title = "查询"
	self.TextInput1.tooltips = "[size=12][color=#00688B]可以在此处输入文字来查询仓库中的物品[/color][/size]"
	
	self.list1 = self:GetChild("list1")
	self.list1.onClickItem:Add(tbWindow.ClickSelectItem)
	self.list1.onRightClickItem:Add(tbWindow.RightClickSelectItem)
	self.list2 = self:GetChild("list2")
	self.list2.onClickItem:Add(tbWindow.ClickSelectItem)
	
	self.bnt1 = self:GetChild("bnt_1");	
	self.bnt1.onClick:Add(tbWindow.OnClick);
	self.bnt1.title = "存储"
	self.bnt1.tooltips = "[size=12][color=#00688B]可以选择物品将其数据化并存入此仓库，有特殊属性的不建议存入[/color][/size]"
	self.bnt2 = self:GetChild("bnt_2");	
	self.bnt2.onClick:Add(tbWindow.OnClick);
	self.bntdw = self:GetChild("bnt_dw");	
	self.bntdw.onClick:Add(tbWindow.OnClick);
	self.bntdw.onRightClick:Add(tbWindow.onRightClick);
	self.bntdw.tooltips = "[size=12][color=#00688B]选择一处地点作为投放物品的坐标，不选择随机投放,右键查看当前坐标点[/color][/size]"
	
	
	self.window:Center();
	local a = self.window.position;
	self.window:SetPosition(a.x,100,a.x);
end
function tbWindow.RightClickSelectItem(context)
	local name = context.data.name
	if context.sender.name == "list1" then
		local cplist = World.map.Things:FindItems(nil, 50, 9999, name, 0, nil, 0, 9999, nil, false, false)
		if cplist ~= nil then
			for i=0,math.min(20,cplist.Count-1) do
				world:FlyLineEffect(cplist[i].Key, cplist[i].Key, 0.5)
				CangKuSeve:CunChuCaiLiao(name,cplist[i].Count)
				ThingMgr:RemoveThing(cplist[i])
			end
		end
	end
	if tbWindow.IsShowing then
		tbWindow:OnShowUpdate()
	end
end

function tbWindow.ClickSelectItem(context)
	local name = context.data.name
	if context.sender.name == "list1" then
		for k,v in pairs(selflist["cunchulist"]) do
			if name == v[1] then
				local num = tbWindow:GetChild("hua_1").value/100
				local count = tonumber(math.floor(num*v[2]))
				if count <= 1 then
					count = 1
				end
				tbWindow:DropItem(name,count)
				tbWindow:OnShowUpdate()
			end
		end
	end
	if context.sender.name == "list2" and name ~= nil then
		if context.data.apexIndex == 1 then
			if name == "Building_cangku" then
				CangKuSeve:SetJianZhu(name)
				local cangku = world:GetBuildingCount("Building_cangku")
				local dianshu = GameMain:GetMod("ZH_zhanghu"):AddLingNum()
				local xiaohao = cangku*48888
				local shuoming = "建造新仓库消耗点数"..xiaohao.."点\n建造后可以在新的仓库存放物品\n选择位置时取消将不会返还点数"
				if dianshu < xiaohao then
					world:ShowMsgBox("建造一个仓库需要消耗点数"..xiaohao.."点，你的点数不足，无法建造", "无法建造")
					return false
				end
				CS.Wnd_Message.Show(nil, 2,
				function (s)
					if s == "1" then	
						world:EnterUILuaMode("LUA_JianZhu_shengcheng",name,nil,false)
						GameMain:GetMod("ZH_zhanghu"):AddLingNum(-xiaohao)
					end
				end, true, "特殊仓库", 0, 0,shuoming)
				return false
			end
			world:EnterUILuaMode("LUA_JianZhu_shengcheng",name,nil,false)
		elseif context.data.apexIndex == 2 then
			CangKuSeve:CunChuCaiLiao(name,1)
			CangKuSeve:SetJianZhu(name)
		elseif context.data.apexIndex == 3 then
			GameMain:GetMod("ZH_zhanghu"):AddLingNum(name)
			CangKuSeve:SetJianZhu(name)
		elseif context.data.apexIndex == 4 then
			CangKuSeve:SetJianZhu(name)
			local plant = ItemRandomMachine.RandomItem("Item_lingshi_canpian",nil,1,12,1,1)
			world:EnterUILuaMode("LingZhi", plant, name, false)
		end
	end
end

function tbWindow.OnClick(context)
	if context.sender.name == "bnt_1" then
		local countmax = selflist["countmax"]+18
		if countmax <= #selflist["cunchulist"] then
			world:ShowMsgBox("你当前拥有仓库位"..countmax.."个，已经全部存满，请开辟新的仓库位后再继续存储", "开启失败")
			return false
		end
		world:EnterUILuaMode("LUA_cunchu_cailiao")
	end
	if context.sender.name == "bnt_2" then
		local countmax = selflist["countmax"]
		local xiaohao = 2888+countmax*2888
		local shuoming = "当前为开启第"..(countmax+1).."个格子，需要消耗点数"..xiaohao.."点"
		local dianshu = GameMain:GetMod("ZH_zhanghu"):AddLingNum()
		if dianshu < xiaohao then
			world:ShowMsgBox(shuoming.."\n超出了你拥有的修炼点，无法购买", "开启失败")
			return false
		end
		CS.Wnd_Message.Show(nil, 2,
		function (s)
			if s == "1" then	
				CangKuSeve:SetCountMax(1)
				GameMain:GetMod("ZH_zhanghu"):AddLingNum(-xiaohao)
				if WorldLua:CheckRate(0.05+(0.3/selflist["countmax"])) then
					CangKuSeve:SetCountMax(1)
					world:ShowMsgBox("你在开启仓库位的时候获得了神的祝福，额外开启了一个位置", "开启失败")
				end
				tbWindow:OnShowUpdate()
			end
		end, true, "仓库扩展", 0, 0,shuoming.."\n是否确定开启新的仓储位")
	end
	if context.sender.name == "bnt_dw" then
		world:EnterUILuaMode("XXZ_CangKu_DingWei")
	end
	
end
function tbWindow.onRightClick(context)
	if context.sender.name == "bnt_dw" then
		if selflist["dropkey"] ~= nil then
			CS.MapCamera.Instance:LookKey(selflist["dropkey"])
		else
			world:ShowMsgBox("你还没有设置坐标，快去设置一个吧", "坐标丢失")
		end
	end
end


function tbWindow:OnShowUpdate()
	local countmax = selflist["countmax"]+18  
	self.bnt2.tooltips = "[size=12][color=#00688B]当前仓库可存储物品上限"..countmax.."种\n点击扩展消耗点数拓展仓库格数\n格数越多消耗点数越多[/color][/size]"
	
	local items = selflist["cunchulist"]
	self.list1:RemoveChildrenToPool()
	if self.text == nil or self.text == "查询" or string.len(self.text) == 0 then
		for i=1,#items do
			local item = self.list1:AddItemFromPool()
			local tname = ThingMgr:GetDef(g_emThingType.Item,items[i][1])
			local JuLing = ""
			if tname.Ling ~= nil then 
				JuLing = string.format("[size=12][color=#CD950C]聚灵：%s\n范围：%s[/color][/size]", tname.Ling.AddionLing, tname.Ling.AddionRadius)
			end
			item.icon = tname.TexPath
			item.title = tname.ThingName
			item.name = tname.Name
			local thingname = "[size=15][color=#1C86EE]"..tname.ThingName.."[/color][/size]"
			local desc1 = string.format("[size=12][color=#CD950C]%s\n美观：%s\n品阶：%s[/color][/size]", JuLing, tname.Beauty, tname.Rate)
			local desc1 = desc1.."\n[size=12][color=#20B2AA]"..tname.Desc.."[/color][/size]"
			local desc2 = "[size=12][color=#00688B]物品数量："..items[i][2].."[/color][/size]\n右键点击可以一键存储地图上的此物品，为了防止卡顿，每次最大抽取20个单位"
			item.tooltips = string.format("%s\n%s\n%s", thingname, desc1, desc2)
		end
	else
		for i=1,#items do
			local tname = ThingMgr:GetDef(g_emThingType.Item,items[i][1])
			if string.find(tname.ThingName,self.text) then
				local item = self.list1:AddItemFromPool()
				local JuLing = ""
				if tname.Ling ~= nil then 
					JuLing = string.format("[size=12][color=#CD950C]聚灵：%s\n范围：%s[/color][/size]", tname.Ling.AddionLing, tname.Ling.AddionRadius)
				end
				item.icon = tname.TexPath
				item.title = tname.ThingName
				item.name = tname.Name
				local thingname = "[size=15][color=#1C86EE]"..tname.ThingName.."[/color][/size]"
				local desc1 = string.format("[size=12][color=#CD950C]%s\n美观：%s\n品阶：%s[/color][/size]", JuLing, tname.Beauty, tname.Rate)
				local desc1 = desc1.."\n[size=12][color=#20B2AA]"..tname.Desc.."[/color][/size]"
				local desc2 = "[size=12][color=#00688B]物品数量："..items[i][2].."[/color][/size]\n右键点击可以一键存储地图上的此物品，为了防止卡顿，每次最大抽取20个单位"
				item.tooltips = string.format("%s\n%s\n%s", thingname, desc1, desc2)
			end
		end
	end
	local items = selflist["jianzhulist"]
	self.list2:RemoveChildrenToPool()
	for i=1,#items do
		if items[i][1] == "building" then
			local item = self.list2:AddItemFromPool()
			local tname = ThingMgr:GetDef(g_emThingType.Building,items[i][2])
			item.icon = tname.TexPath
			item.title = tname.ThingName
			item.name = tname.Name
			item.apexIndex = 1
			local thingname = "[size=15][color=#1C86EE]"..tname.ThingName.."[/color][/size]"
			local desc1 = "[size=12][color=#20B2AA]"..tname.Desc.."[/color][/size]"
			local desc1 = desc1.."[size=12][color=#20B2AA]\n点击建筑图标可以在地图上建造新的建筑[/color][/size]"
			item.tooltips = string.format("%s\n%s", thingname, desc1)
		end
		if items[i][1] == "wupin" then
			local item = self.list2:AddItemFromPool()
			local tname = ThingMgr:GetDef(g_emThingType.Item,items[i][2])
			item.icon = tname.TexPath
			item.title = tname.ThingName
			item.name = tname.Name
			item.apexIndex = 2
			local thingname = "[size=15][color=#1C86EE]"..tname.ThingName.."[/color][/size]"
			local desc1 = "[size=12][color=#20B2AA]"..tname.Desc.."[/color][/size]"
			local desc1 = desc1.."[size=12][color=#20B2AA]\n修仙传赠送的符文碎片，点击物品图标，获得赠送的物品奖励,物品直接发放仓库中[/color][/size]"
			item.tooltips = string.format("%s\n%s", thingname, desc1)
		end
		if items[i][1] == "dianshu" then
			local item = self.list2:AddItemFromPool()
			item.icon = "Spr/Qita/qian.png"
			item.title = "修炼点"
			item.name = items[i][2]
			item.apexIndex = 3
			item.tooltips = "[size=12][color=#20B2AA]\n你获得了修仙传赠送的修炼点数"..items[i][2].."点，点击图标，获得赠送的点数奖励,点数直接发放进账户中[/color][/size]"
		end
		if items[i][1] == "plant" then
			local tname = ThingMgr:GetDef(g_emThingType.Plant,items[i][2])
			local item = self.list2:AddItemFromPool()
			item.icon = tname.TexPath
			item.title = tname.ThingName
			item.name = tname.Name
			item.apexIndex = 4
			item.tooltips = "[size=12][color=#20B2AA]\n你获得了修仙传赠送的灵植："..item.title.."\n点击图标，在地图上种植灵植[/color][/size]"
		end
	end
end

function tbWindow:OnShown()
	tbWindow.IsShowing = true
end

function tbWindow:OnUpdate(dt)
	if self.text ~= self.TextInput1.title then
		self.text = self.TextInput1.title
		tbWindow:OnShowUpdate()
	end
end

function tbWindow:OnHide()
	tbWindow.IsShowing = false

end

function tbWindow:DropItem(name,count)

	local wupin = ThingMgr:GetDef(g_emThingType.Item,name )
	local diejiashu = wupin.MaxStack
	local zhengshu = count/diejiashu
	local yushu = zhengshu-math.floor(zhengshu)
	local xunhuan = math.floor(zhengshu)
	CangKuSeve:CunChuCaiLiao(name,-count)
	local dropkey = selflist["dropkey"]
	if dropkey == nil then
		dropkey = Map:GetRandomInLifeArea(4)
	end
	if diejiashu >= count then
			local scwupin = ItemRandomMachine.RandomItem(name,nil,1,12,1,count)
			Map:DropItem(scwupin, dropkey, true, true, false, true, 0, false)
	else
		if zhengshu >= 1 then 
			for i = 1, xunhuan do
				local scwupin = ItemRandomMachine.RandomItem(name,nil,1,12,1,diejiashu)
				Map:DropItem(scwupin, dropkey, true, true, false, true, 0, false)
			end
		end
		if yushu ~= 0 then 
			local scwupin = ItemRandomMachine.RandomItem(name,nil,1,12,1,count-xunhuan*diejiashu)
			Map:DropItem(scwupin, dropkey, true, true, false, true, 0, false)
		end 	
	end 
end



function CangKuSeve:OnInit()
	tbEvent:RegisterEvent(g_emEvent.DayChange, CangKuSeve.OnDayChange, "XXZ_JianYiCangKu_SEVE")
end

function CangKuSeve:OnSave()
	return selflist
end


function CangKuSeve:OnLoad(t)
	selflist = t or {}
end

function CangKuSeve:OnStep(dt)
	if selflist["cunchulist"] == nil then
		selflist["cunchulist"] = {}
	end
	if selflist["jishi"] == nil then
		selflist["jishi"] = 0
		selflist["jianzhulist"] = {}
	end
	selflist["jishi"] = selflist["jishi"] + dt
	if selflist["jishi"] > 600 then
		selflist["jishi"] = 0
	end
	if selflist["countmax"] == nil then
		selflist["countmax"] = 0
	end
end 


function CangKuSeve:CunChuCaiLiao(name,count)
	if selflist["cunchulist"] == nil then
		selflist["cunchulist"] = {}
	end
	for i=1,#selflist["cunchulist"] do
		if name == selflist["cunchulist"][i][1] then
			selflist["cunchulist"][i][2] = selflist["cunchulist"][i][2]+count
			if selflist["cunchulist"][i][2] <= 0 then
				table.remove(selflist["cunchulist"],i)
				return false
			end
			return false
		end
	end
	table.insert(selflist["cunchulist"],{name,count})
end

function CangKuSeve:GetJianZhu()
end

function CangKuSeve:SetJianZhu(name)
	for i=1,#selflist["jianzhulist"] do
		if selflist["jianzhulist"][i][2]~= nil and string.find(name,selflist["jianzhulist"][i][2]) then
			table.remove(selflist["jianzhulist"],i)
			tbWindow:OnShowUpdate()
			return false
		end
	end
	if tbWindow.IsShowing == true then
			tbWindow:OnShowUpdate()
	end
end
function CangKuSeve:SetCountMax(num)
	if num ~= nil then
		selflist["countmax"] = selflist["countmax"]+num
	end
	return selflist["countmax"]
end
function CangKuSeve:SetDropKey(num)
	if num ~= nil then
		selflist["dropkey"] = num
	end
	return selflist["dropkey"]
end

function CangKuSeve:GetCangKu()
end

function CangKuSeve:GetCangKuCaiLiao()
	return selflist["cunchulist"]
end

function CangKuSeve.OnDayChange()

	local bdlist = {"Building_kuangshan","Building_shenjian","Building_cailiao","Building_cangku"}
	local maxcount = {1,1,1,1+(world.DayCount/112)}
	for i=1,#bdlist do
		local bd = bdlist[i]
		local bdcount = world:GetBuildingCount(bd)
		for i=1,#selflist["jianzhulist"] do
			if bd == selflist["jianzhulist"][i][2] then
				bdcount = bdcount+1
			end
		end
		if bdcount < maxcount[i] then
			local name = ThingMgr:GetDef(g_emThingType.Building,bd).ThingName
			MessageMgr:AddMessage(6290,nil, name, -1, 0, 0)
			table.insert(selflist["jianzhulist"],{"building",bdlist[i]})
		end
	end
	
	
	local name = {"dianshu","dianshu","wupin","dianshu","dianshu","wupin","dianshu","dianshu"}
	name = name[world:RandomInt(1,#name+1)]
	if name == "wupin" then
		local item = {"Item_fumo_fuwen_"..world:RandomInt(1,65),"Item_qianghua_suipian"..world:RandomInt(1,11),"Item_fumo_fuwen1","Item_fumo_suipian1","Item_zhuanshu_bianshen_1","Item_fumo_chongzhu1",
		"Item_lingguo_jin1","Item_lingguo_mu1","Item_lingguo_shui1","Item_lingguo_huo1","Item_lingguo_tu1","Item_lingguo_tu1","Item_cailiao_mucai"..world:RandomInt(1,8),"Item_cailiao_muliao"..world:RandomInt(1,8),
		"Item_cailiao_shikuang"..world:RandomInt(1,8),"Item_cailiao_jinkuang"..world:RandomInt(1,8),"Item_cailiao_shizhuan"..world:RandomInt(1,8),"Item_cailiao_jinshu"..world:RandomInt(1,8)
		}
		item = item[world:RandomInt(1,#item+1)]
		table.insert(selflist["jianzhulist"],{name,item})
	elseif name == "dianshu" then
		local count = world:RandomFloat(world.DayCount*1.8,world.DayCount*4.8)
		table.insert(selflist["jianzhulist"],{name,math.floor(count)})
	end
	MessageMgr:AddMessage(6291,nil, name, -1, 0, 0)
	
	local plants = {"Plant_lingshi_jin1","Plant_lingshi_mu1","Plant_lingshi_shui1","Plant_lingshi_huo1","Plant_lingshi_tu1"}
	for i=1,5 do
		local plant = plants[i]
		local plantcount = ThingMgr:FindLingPlantCount(plant)
		for i=1,#selflist["jianzhulist"] do
			if selflist["jianzhulist"][i][2] == plant then
				plantcount = plantcount+1
			end
		end
		if plantcount == 0 then
			table.insert(selflist["jianzhulist"],{"plant",plants[i]})
			MessageMgr:AddMessage(6291,nil, name, -1, 0, 0)
		end
	end
end























