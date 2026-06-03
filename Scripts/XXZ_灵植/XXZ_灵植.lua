local tbThing = GameMain:GetMod("ThingHelper"):GetThing("Plant_lingzhi_1");
local Windows = GameMain:GetMod("Windows");--先注册一个新的MOD模块
local tbWindow = Windows:CreateWindow("XXZ_LingZhi");
local LingZhiSeve = GameMain:GetMod("XXZ_LingZhi_SEVE")
local tbEvent = GameMain:GetMod("_Event");
local selflist = selflist or {}

function tbWindow:OnInit()
	self.window.contentPane =  UIPackage.CreateObject("XXZUI", "XXZLingZhi");--载入UI包里的窗口
	self.window.closeButton = self:GetChild("frame"):GetChild("n5");
	self:GetChild("frame").tooltips = "[size=12][color=#00688B]灵植蕴养，给灵植天才地宝蕴养灵性，可以提升灵植的各类属性\n灵石灵晶：提升灵植灵气值\n灵精精华：提升灵植灵煞值\n蕴灵残片：提升灵植蕴灵值\n蕴灵值可以用以凝结蕴灵石，蕴灵石等级越高，需要消耗的蕴灵值越高,蕴灵值所有灵植通用"
	
	
	self.fbnt1 = self:GetChild("frame"):GetChild("bnt_frame1");	
	self.fbnt1.onClick:Add(tbWindow.OnClick);
	self.fbnt1.onRightClick:Add(tbWindow.onRightClick);
	
	self.f1 = self:GetChild("bnt_f1");	
	self.f1.onClick:Add(tbWindow.OnClick);	
	self.f1.onRightClick:Add(tbWindow.onRightClick);
	self.f1.tooltips = "[size=12][color=#00688B]选择一片区域内的物品灵植将其吞噬，用以提升灵植品阶，灵植品阶越高产出的蕴灵石等级越高，品阶越高聚灵范围越大，灵气越高[/color][/size]"
	self.f2 = self:GetChild("bnt_f2");	
	self.f2.onClick:Add(tbWindow.OnClick);
	self.f2.onRightClick:Add(tbWindow.onRightClick);
	self.f2.tooltips = "[size=12][color=#00688B]消耗自身灵气提升美观度，美观度越高，消耗灵气越高，美观度提升聚灵效果系数[/color][/size]"
	self.f3 = self:GetChild("bnt_f3");	
	self.f3.onClick:Add(tbWindow.OnClick);
	self.f3.onRightClick:Add(tbWindow.onRightClick);
	self.f3.tooltips = "[size=12][color=#00688B]消耗蕴灵值收获一颗灵石\n右键吸取地图上的蕴灵残片转化为蕴灵值,每次最多抽取20个单位的残片[/color][/size]"
	self.f4 = self:GetChild("bnt_f4");	
	self.f4.onClick:Add(tbWindow.OnClick);
	self.f4.onRightClick:Add(tbWindow.onRightClick);
	self.f4.tooltips = "[size=12][color=#00688B]消耗灵植的全部成熟度采摘物品,成熟度越高出的物品越高级\n右键消耗灵气获得成长度1/1W，品阶越高，提升越低,当成熟度已满会优先采摘[/color][/size]"
	
	self.list1 = self:GetChild("list1")
	self.list1.onClickItem:Add(tbWindow.ClickSelectItem)
	self.list2 = self:GetChild("list2")
	self.list2.onClickItem:Add(tbWindow.ClickSelectItem)
	self.list3 = self:GetChild("list3")
	self.list3.onClickItem:Add(tbWindow.ClickSelectItem)
	
	self.window:Center();
	local a = self.window.position;
	self.window:SetPosition(a.x,240,a.x);
end

function tbWindow.ClickSelectItem(context)
	if context.sender.name == "list1" or context.sender.name == "list2" or context.sender.name == "list3" then
		local item = ThingMgr:FindThingByID(context.data.apexIndex)
		world:FlyLineEffect(item.Key, tbWindow.plant.Key, 0.5)
		local list = {Item_jinghua_jiejing1 = {0.3,10000},Item_LingStone = {0.01,50},Item_LingCrystal = {0.1,2000}}
		local lingshamax = 1-tbWindow.plant.LuaHelper:GetLingSha()/100
		local lingsha = list[context.data.name][1]*lingshamax
		local lingqi = list[context.data.name][2]
		tbWindow.plant:AddLingSha(lingsha*item.Count)
		tbWindow.plant:AddLing(lingqi*item.Count)
		ThingMgr:RemoveThing(item);
		tbWindow:OnShowUpdate()
	end
end 

function tbWindow.OnClick(context)
	if context.sender.name == "bnt_f1" then
		if tbWindow.plant.Rate >= 12 then
			return false
		end
		if selflist[tbWindow.plant.ID.."jinsheng"] > 0 then
			world:ShowMsgBox(tbWindow.plant:GetName().."当前晋级进度已满或者正在晋升中", "灵植晋升")
			return false
		end
		world:CastMagic(tbWindow.plant,'Magic_lingzhi_pinjiejinshen')
		tbWindow:Hide()
	elseif context.sender.name == "bnt_f2" then
		tbThing:BeautyUP(tbWindow.plant)
	elseif context.sender.name == "bnt_f3" then
		Windows:CreateWindow("XXZ_LingZhi2"):SetPlant(tbWindow.plant)
		Windows:CreateWindow("XXZ_LingZhi2"):Show()
	elseif context.sender.name == "bnt_f4" then
		if tbWindow.plant.HarvestProgress < 10 then
			world:ShowMsgBox("成熟度低于10，无法采摘", "灵植采摘")
			return false
		else
			tbThing:LingzhiHarvest(tbWindow.plant)
		end
	end
end
function tbWindow.onRightClick(context)
	if context.sender.name == "bnt_f3" then
		local cplist = World.map.Things:FindItems(nil, 50, 9999, "Item_lingshi_canpian", 0, nil, 0, 9999, nil, false, false)
		if cplist ~= nil then
			for i=0,math.min(20,cplist.Count-1) do
				selflist["lingzhidian"] = selflist["lingzhidian"]+cplist[i].Count*1
				world:FlyLineEffect(cplist[i].Key, tbWindow.plant.Key, 0.5)
				ThingMgr:RemoveThing(cplist[i])
			end
		end
	elseif context.sender.name == "bnt_f4" then
		if tbWindow.plant.HarvestProgress == 100 then
			tbThing:LingzhiHarvest(tbWindow.plant)
		end
		local ling = tbWindow.plant.LingV/10000/tbWindow.plant.Rate
		if tbWindow.plant.GrowProgress < 100 then
			tbWindow.plant.GrowProgress = tbWindow.plant.GrowProgress+ling*2
		else
			local yichu = 100-tbWindow.plant.GrowProgress
			tbWindow.plant.GrowProgress = 100
			tbWindow.plant.HarvestProgress = math.min(100,tbWindow.plant.HarvestProgress+ling+yichu/2)
		end
		world:PlayEffect(14, tbWindow.plant.Key, 1);
		tbWindow.plant:AddLing(-tbWindow.plant.LingV)
		tbWindow:OnShowUpdate()
	end
end


function tbWindow:OnShowUpdate()
	self.fbnt1.icon = tbWindow.plant.def.TexPath
	self.fbnt1.title = tbWindow.plant.def.ThingName
	self.fbnt1.onRollOver:Set(function() self.showitem1 = true self.showitem2 = tbWindow.plant end);
	self.fbnt1.onRollOut:Set(function() self.showitem1 = false self.showitem2 = nil end);
	
	self.list1:RemoveChildrenToPool()
	local jinghua = World.map.Things:FindItems(nil, 50, 9999,"Item_LingStone", 0, nil, 0, 9999, nil, false, false)
	if jinghua ~= nil and jinghua.Count > 0 then
		for i=0,jinghua.Count-1 do
			local item = self.list1:AddItemFromPool()
			local tname = jinghua[i]
			item.icon = tname.def.TexPath
			item.title = tname:GetName()
			item.name = tname.def.Name
			item.apexIndex = tname.ID
			item.onRollOver:Set(function() self.showitem1 = true self.showitem2 = tname end);
			item.onRollOut:Set(function() self.showitem1 = false self.showitem2 = nil end);
		end
	end
	self.list2:RemoveChildrenToPool()
	local jinghua = World.map.Things:FindItems(nil, 50, 9999,"Item_LingCrystal", 0, nil, 0, 9999, nil, false, false)
	if jinghua ~= nil and jinghua.Count > 0 then
		for i=0,jinghua.Count-1 do
			local item = self.list2:AddItemFromPool()
			local tname = jinghua[i]
			item.icon = tname.def.TexPath
			item.title = tname:GetName()
			item.name = tname.def.Name
			item.apexIndex = tname.ID
			item.onRollOver:Set(function() self.showitem1 = true self.showitem2 = tname end);
			item.onRollOut:Set(function() self.showitem1 = false self.showitem2 = nil end);
		end
	end
	self.list3:RemoveChildrenToPool()
	local jinghua = World.map.Things:FindItems(nil, 50, 9999, "Item_jinghua_jiejing1", 0, nil, 0, 9999, nil, false, false)
	if jinghua ~= nil and jinghua.Count > 0 then
		for i=0,jinghua.Count-1 do
			local item = self.list3:AddItemFromPool()
			local tname = jinghua[i]
			item.icon = tname.def.TexPath
			item.title = tname:GetName()
			item.name = tname.def.Name
			item.apexIndex = tname.ID
			item.onRollOver:Set(function() self.showitem1 = true self.showitem2 = tname end);
			item.onRollOut:Set(function() self.showitem1 = false self.showitem2 = nil end);
		end
	end
end

function tbWindow:OnShown()
	tbWindow.IsShowing = true
end

function tbWindow:OnUpdate(dt)
	if self.showitem1 then
		CS.Wnd_TipPopPanel.Instance.contentPane.visible = true;
		CS.Wnd_TipPopPanel.Instance:ShowOrUpdate(self.showitem2) 
	else
		CS.Wnd_TipPopPanel.Instance.contentPane.visible = false; 
	end
end

function tbWindow:OnHide()
	tbWindow.IsShowing = false
end
function tbWindow:SetPlant(plant)
	tbWindow.plant = plant
end


function tbThing:OnInit()
end

function tbThing:OnGetSaveData()
	return selflist
end



function tbThing:OnLoadData(tbData)
	selflist = tbData or {}
end



 
function tbThing:OnStep(dt)
	local plant = self.it
	local _r = plant.Rate
	local _b = plant.Beauty
	local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(plant,"灵石韵灵")
	if btn == false then
		plant:AddBtnData("灵石韵灵","Icon/16.png","GameMain:GetMod('ThingHelper'):GetThing('Plant_lingzhi_1'):Show(bind)","打开灵植蕴养界面蕴养灵石");
	end
	if selflist[plant.ID] == nil then
		selflist[plant.ID] = 0
	end
	if selflist[plant.ID.."jishi"] == nil then
		selflist[plant.ID.."jishi"] = 0
	end
	if selflist[plant.ID.."jinsheng"] == nil then
		selflist[plant.ID.."jinsheng"] = 0		--1无，2能量满，3，正在晋升
	end
	if selflist["lingzhidian"] == nil then
		selflist["lingzhidian"] = 0
	end
	selflist[plant.ID.."jishi"] = selflist[plant.ID.."jishi"]-dt
	
	if selflist[plant.ID.."jishi"] <= 0 then
		selflist[plant.ID.."jishi"] = 5
		plant.def.Ling.AddionRadius = math.floor(_r/3)+2
		plant.def.Ling.AddionLing = math.floor(_b/5+_r)*5
		local qianzhui1 = {"[color=#CCCCCC]【凡】[/color]","[color=#CCCCCC]【初】[/color]","[color=#CAE1FF]【中】[/color]","[color=#C1FFC1]【高】[/color]","[color=#BFEFFF]【极】[/color]","[color=#C0FF3E]【宝】[/color]","[color=#CD853F]【灵】[/color]","[color=#97FFFF]【法】[/color]","[color=#CD950C]【尊】[/color]","[color=#CD3700]【圣】[/color]","[color=#EE2C2C]【道】[/color]","[color=#B452CD]【混沌】[/color]"}
		plant:SetName(qianzhui1[plant.Rate]..plant.def.ThingName)
		
		if selflist[plant.ID] >= 100 and selflist[plant.ID.."jinsheng"] == 0 then
			selflist[plant.ID] = 100
			selflist[plant.ID.."jinsheng"] = 1
			plant:SetDesc(plant.def.Desc.."\n[color=#4876FF]品阶能量已满，正在晋升中")
		else
			if selflist[plant.ID] >= 0.01 then
				plant:SetDesc(plant.def.Desc.."[color=#4876FF]\n品阶能量进度："..(math.floor(selflist[plant.ID]*100)/100).."％")
			end
		end
				
		if selflist[plant.ID] >= 0 and selflist[plant.ID.."jinsheng"] >= 1 then
			if plant.LingV > plant.Rate*1000 then
				selflist[plant.ID] = selflist[plant.ID] - 1/plant.Rate
				selflist[plant.ID.."jinsheng"] = 2
				plant:AddLing(-plant.Rate*1000)
				plant:SetDesc(plant.def.Desc.."[color=#4876FF]\n品阶进度已满，正在晋升中[/color]\n[color=#76EE00]品阶晋级进度："..math.floor(100-selflist[plant.ID]).."％[/color]")
			else
				plant:SetDesc(plant.def.Desc.."[color=#4876FF]\n品阶进度已满，正在晋升中[/color]\n[color=#76EE00]品阶晋级进度："..math.floor(100-selflist[plant.ID]).."％\n品阶晋级停止：灵气不足[/color]")
			end
			if selflist[plant.ID] <= 0 then
				selflist[plant.ID] = 0
				selflist[plant.ID.."jinsheng"] = 0
				if plant.Rate < 12 then
					plant.Rate = plant.Rate+1
					plant.HarvestProgress = 0
					plant:SetDesc(plant.def.Desc)
					if WorldLua:CheckRate(0.2)  then
						local plantHarvest = tbThing:LingzhiHarvest3(plant)
					else
						local plantHarvest = tbThing:LingzhiHarvest2(plant)
					end
				end
			end
		end
	end
		
end

function tbThing:SetJinDu(plant,num)
	if num ~= nil then
		selflist[plant.ID] = selflist[plant.ID]+num
	end
	return selflist[plant.ID]
end

function tbThing:SetLingZhiDian(num)
	if num ~= nil then
		selflist["lingzhidian"] = selflist["lingzhidian"]+num
	end
	return selflist["lingzhidian"]
end
function tbThing:Show(plant)
	tbWindow:SetPlant(plant)
	tbWindow:Show()
end

function tbThing:BeautyUP(plant)
	local beauty = plant.Beauty
	local ling = plant.LingV
	if ling < beauty*10000 then
		world:ShowMsgBox("灵气不足，无法提升美观度，本次提升最低需求"..(beauty*10000).."点灵气值，灵气越高，提升几率越大", "美观晋级")
		return false
	end
	plant:AddLing(-ling)
	if WorldLua:CheckRate(plant.Rate/beauty/3+ling/(100000*beauty))  then
		plant:ChangeBeauty(beauty+1)
		world:ShowMsgBox("美观晋升成功，美观提升一点", "美观晋级")
	else
		if WorldLua:CheckRate(beauty/10-ling/(200000*beauty))  then
			plant:ChangeBeauty(beauty-1)
			world:ShowMsgBox("美观晋升失败，美观降低一点", "晋级失败")
			return false
		end
		world:ShowMsgBox("美观晋升失败", "晋级失败")
	end
end


function tbThing:LingzhiHarvest(plant)
	local ChanChuList = {
	{ZWName="Plant_lingshi_jin1",CCName="Item_lingshi_jin"}, 
	{ZWName="Plant_lingshi_mu1",CCName="Item_lingshi_mu"}, 
	{ZWName="Plant_lingshi_shui1",CCName="Item_lingshi_shui"}, 
	{ZWName="Plant_lingshi_huo1",CCName="Item_lingshi_huo"}, 
	{ZWName="Plant_lingshi_tu1",CCName="Item_lingshi_tu"}, 
	};
	for k,v in pairs(ChanChuList) do 
		if plant.def.Name == v.ZWName then
			chanchu = v.CCName
		end
	end
	if chanchu ~= nil then
		if plant.HarvestProgress < 100 then
			local scwupin = ItemRandomMachine.RandomItem("Item_lingshi_canpian",nil,1,12,1,math.floor(plant.HarvestProgress*plant.Rate))
			Map:DropItem(scwupin, plant.Key+1, true, true, false, true, 0, false)
			world:ShowMsgBox(plant.def.ThingName.."掉落了蕴灵石\n"..scwupin:GetName()..scwupin.Count.."个", "材料掉落")
		else
			local pinzhi = 0
			if WorldLua:CheckRate(1/plant.Rate)  then
				pinzhi = plant.Rate
			elseif WorldLua:CheckRate(2/plant.Rate)  then
				pinzhi = plant.Rate-1
			elseif WorldLua:CheckRate(3/plant.Rate)  then
				pinzhi = plant.Rate-2
			elseif WorldLua:CheckRate(4/plant.Rate)  then
				pinzhi = plant.Rate-3
			elseif WorldLua:CheckRate(5/plant.Rate)  then
				pinzhi = plant.Rate-4
			end
			if pinzhi <= 0 then
				pinzhi = 1
			end
			local scwupin1 = ItemRandomMachine.RandomItem(chanchu..pinzhi,nil,1,12,1,1)
			Map:DropItem(scwupin1, plant.Key+1, true, true, false, true, 0, false)
			local lingshi = {"Item_lingshi_yuan","Item_lingshi_hun","Item_lingshi_yuan","Item_lingshi_hun","Item_lingshi_yuan","Item_lingshi_hun"}
			local scwupin2 = ItemRandomMachine.RandomItem(lingshi[WorldLua:RandomInt(1,#lingshi+1)]..pinzhi,nil,1,12,1,1)
			Map:DropItem(scwupin2, plant.Key+1, true, true, false, true, 0, false)
			world:ShowMsgBox(plant.def.ThingName.."掉落了蕴灵石\n"..scwupin1:GetName()..scwupin1.Count.."个\n"..scwupin2:GetName()..scwupin2.Count.."个", "材料掉落")
			if WorldLua:CheckRate(0.1+(1-plant.Rate/10))  then
				tbThing:LingzhiHarvest3(plant)
			end
			if WorldLua:CheckRate(0.1+plant.Rate/10)  then
				tbThing:LingzhiHarvest2(plant)
			end
		end
		plant.HarvestProgress = 0
		return scwupin
	end
end

function tbThing:LingzhiHarvest2(plant)
	local chanchu = nil
	if plant.def.Name == "Plant_lingshi_jin1" then
		chanchu = "Item_cailiao_mucai1"
	end
	if plant.def.Name == "Plant_lingshi_mu1" then
		chanchu = "Item_cailiao_mucai2"
	end
	if plant.def.Name == "Plant_lingshi_shui1" then
		chanchu = "Item_cailiao_mucai3"
	end
	if plant.def.Name == "Plant_lingshi_huo1" then
		chanchu = "Item_cailiao_mucai4"
	end
	if plant.def.Name == "Plant_lingshi_tu1" then
		chanchu = "Item_cailiao_mucai5"
	end
	local scwupin1 = ItemRandomMachine.RandomItem(chanchu,nil,1,12,1,math.floor(plant.Rate*2.99))
	Map:DropItem(scwupin1, plant.Key+1, true, true, false, true, 0, false)
	local chanchu2  = {"Item_cailiao_mucai6","Item_cailiao_mucai7","Item_cailiao_mucai6","Item_cailiao_mucai7","Item_cailiao_mucai6","Item_cailiao_mucai7"}
	local scwupin2 = ItemRandomMachine.RandomItem(chanchu2[WorldLua:RandomInt(1,#chanchu2+1)],nil,1,12,1,math.floor(plant.Rate*1.49))
	Map:DropItem(scwupin2, plant.Key+1, true, true, false, true, 0, false)
	world:ShowMsgBox(plant.def.ThingName.."竟然掉落了稀有材料\n"..scwupin1:GetName()..scwupin1.Count.."个\n"..scwupin2:GetName()..scwupin2.Count.."个", "材料掉落")
	return scwupin1,scwupin2
end



function tbThing:LingzhiHarvest3(plant)
	local chanchu
	local scwupin
	local qianzhui1 = {"【凡】","【初】","【中】","【高】","【极】","【宝】","【灵】","【法】","【尊】","【圣】","【道】","【混沌】"}
	local rate = plant.Rate
	local beauty = plant.Beauty
	local itemdesc = plant.def.ThingName.."生长时领悟了一丝天地道韵，转化为可修炼的稀有秘籍，乃是不可多得的宝物"
	if plant.def.Name == "Plant_lingshi_jin1" then
		chanchu = plant.LuaHelper:DropEsotericCustomize(qianzhui1[rate].."蕴灵金法-",1 , 1,0.2+rate/5+beauty/20,rate*3+math.floor(beauty/2),math.floor(rate/2.4),itemdesc.."\n")
	end
	if plant.def.Name == "Plant_lingshi_mu1" then
		chanchu = plant.LuaHelper:DropEsotericCustomize(qianzhui1[rate].."蕴灵木法-",2 , 4,0.2+rate/5+beauty/20,rate*3+math.floor(beauty/2),math.floor(rate/2.4),itemdesc.."\n")
	end
	if plant.def.Name == "Plant_lingshi_shui1" then
		chanchu = plant.LuaHelper:DropEsotericCustomize(qianzhui1[rate].."蕴灵水法-",3 , 7,0.2+rate/5+beauty/20,rate*3+math.floor(beauty/2),math.floor(rate/2.4),itemdesc.."\n")
	end
	if plant.def.Name == "Plant_lingshi_huo1" then
		chanchu = plant.LuaHelper:DropEsotericCustomize(qianzhui1[rate].."蕴灵火法-",4 , 5,0.2+rate/5+beauty/20,rate*3+math.floor(beauty/2),math.floor(rate/2.4),itemdesc.."\n")
	end
	if plant.def.Name == "Plant_lingshi_tu1" then
		chanchu = plant.LuaHelper:DropEsotericCustomize(qianzhui1[rate].."蕴灵土法-",5 , 3,0.2+rate/5+beauty/20,rate*3+math.floor(beauty/2),math.floor(rate/2.4),itemdesc.."\n")
	end
	if plant.def.Name == "Plant_lingshi_yuan1" then
		chanchu = plant.LuaHelper:DropEsotericCustomize(qianzhui1[rate].."蕴灵元法-",0 , 2,0.2+rate/5+beauty/20,rate*3+math.floor(beauty/2),math.floor(rate/2.4),itemdesc.."\n")
	end
	if plant.def.Name == "Plant_lingshi_hun1" then
		chanchu = plant.LuaHelper:DropEsotericCustomize(qianzhui1[rate].."蕴灵混法-",0 , 6,0.2+rate/5+beauty/20,rate*3+math.floor(beauty/2),math.floor(rate/2.4),itemdesc.."\n")
	end
	chanchu.Rate = rate
	chanchu:ChangeBeauty(plant.Beauty)
	world:ShowMsgBox(plant.def.ThingName.."竟然将捕捉的一丝天地道韵，转化成了一本秘籍\n获得秘籍："..chanchu:GetName(), "灵种成熟")
	return chanchu
end














