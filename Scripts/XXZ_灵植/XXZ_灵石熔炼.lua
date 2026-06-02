local Windows = GameMain:GetMod("Windows");--先注册一个新的MOD模块
local tbWindow = Windows:CreateWindow("XXZ_LingZhi2");

function tbWindow:OnInit()
	self.window.contentPane =  UIPackage.CreateObject("XXZUI", "XXZLingZhi2");--载入UI包里的窗口
	self.window.closeButton = self:GetChild("frame"):GetChild("n5");
	
	self.list1 = self:GetChild("list1")
	self.list1.onClickItem:Add(tbWindow.ClickSelectItem)
	self.list1.onRightClickItem:Add(tbWindow.RightClickSelectItem)
	
	self.box1 = self:GetChild("ComboBox1")
	self.box1.onClick:Add(tbWindow.OnClick)
	self.box1.onChanged:Add(tbWindow.onSelected)
	self.text1 = self:GetChild("TextInput1")
	self.text1.tooltips = "[size=15][color=#1C86EE]点击蕴灵石消耗指定物品和蕴灵值获得，分解蕴灵系列的灵石可以获得对应的蕴灵值，右键可以一键分解地图上对应的蕴灵石[/color][/size]"

	self.window:Center();
	local a = self.window.position;
	self.window:SetPosition(a.x,400,a.x);
end

function tbWindow.ClickSelectItem(context)
	if context.sender.name == "list1" then
		local name = context.data.name
		local index = context.data.apexIndex
		local tname = ThingMgr:GetDef(g_emThingType.Item,name..index)
		local jiage = {9,27,81,240,720,2100,6400,18800,38880,98880,288888}
		local jiage = jiage[index]
		local lingzhidian = GameMain:GetMod("ThingHelper"):GetThing("Plant_lingzhi_1"):SetLingZhiDian()
		if lingzhidian >= jiage then
			if tbWindow.plant ~= nil then
				local xqitem = World.map.Things:FindItem(Npc, 9999, "Item_lingshi_canpian", 0, false, nil, 0, 9999, nil, false)
				if index > 1 then
					xqitem = World.map.Things:FindItem(Npc, 9999,name..(index-1), 0, false, nil, 0, 9999, nil, false)
				end
				if xqitem == nil then
					world:ShowMsgBox("地图上未曾找到需求物品"..tname.ThingName.."无法提升", "提升升级")
					return false
				else
					GameMain:GetMod("ThingHelper"):GetThing("Plant_lingzhi_1"):SetLingZhiDian(-jiage)
					world:FlyLineEffect(xqitem.Key, tbWindow.plant.Key, 1,
					function(p)
						tbWindow.plant.LuaHelper:DropAwardItem(name..index,1)
					end,nil,nil,nil,"Effect/A/Prefabs/Projectiles/Earth/EarthProjectileTiny")
					if xqitem.Count > 1 then
						xqitem:ChangeCount(xqitem.Count-1)
					else
						ThingMgr:RemoveThing(xqitem)
					end
					tbWindow:OnShowUpdate()
				end
			end
		else
			world:ShowMsgBox("拥有的蕴灵值不足，无法生成"..tname.ThingName, "分解失败")
		end
	end
end
function tbWindow.RightClickSelectItem(context)
	if context.sender.name == "list1" then
		local name = context.data.name
		local index = context.data.apexIndex
		local tname = ThingMgr:GetDef(g_emThingType.Item,name..index)
		local jiage = {9,27,81,240,720,2100,6400,18800,38880,98880,288888}
		local jiage = jiage[index]
		local lslist = World.map.Things:FindItems(nil, 50, 9999, name..index, 0, nil, 0, 9999, nil, false, false)
		if lslist ~= nil then
			CS.Wnd_Message.Show(nil, 2,
			function (s)
				if s == "1" then	
					for i=0,math.min(10,lslist.Count-1) do
						world:FlyLineEffect(lslist[i].Key, lslist[i].Key, 0.5)
						local num = jiage*lslist[i].Count
						GameMain:GetMod("ThingHelper"):GetThing("Plant_lingzhi_1"):SetLingZhiDian(num)
						ThingMgr:RemoveThing(lslist[i])
						tbWindow:OnShowUpdate()
					end
				end
			end, true, "灵石分解", 0, 0,"是否确定一键分解地图上的"..tname.ThingName)
		else
			world:ShowMsgBox("没有检测到地图上有"..tname.ThingName, "分解失败")
		end
	end
	if tbWindow.IsShowing then
		tbWindow:OnShowUpdate()
	end
end
function tbWindow.OnClick(context)
end

function tbWindow.onSelected(context)
	tbWindow:OnShowUpdate()
end

function tbWindow:OnShowUpdate()
	local lingzhidian = GameMain:GetMod("ThingHelper"):GetThing("Plant_lingzhi_1"):SetLingZhiDian()
	self.text1.title = "灵植点："..lingzhidian
	local oldvalue =  self.box1.value
	local jiage = {9,27,81,240,720,2100,6400,18800,38880,98880,288888}
	if oldvalue ~= nil then
		self.list1:RemoveChildrenToPool()
		for i=1,11 do
			local tname = ThingMgr:GetDef(g_emThingType.Item,oldvalue..i)
			local item = self.list1:AddItemFromPool()
			local JuLing = ""
			if tname.Ling ~= nil then 
				JuLing = string.format("[size=12][color=#CD950C]聚灵：%s\n范围：%s[/color][/size]", tname.Ling.AddionLing, tname.Ling.AddionRadius)
			end
			item.icon = tname.TexPath
			item.title = tname.ThingName
			item.name = oldvalue
			item.apexIndex = i
			local xqname = ThingMgr:GetDef(g_emThingType.Item,"Item_lingshi_canpian")
			if i > 1 then
			xqname = ThingMgr:GetDef(g_emThingType.Item,oldvalue..(i-1))
			end
			local thingname = "[size=15][color=#1C86EE]"..tname.ThingName.."[/color][/size]"
			local desc = string.format("[size=12][color=#CD950C]%s\n美观：%s\n品阶：%s[/color][/size]", JuLing, tname.Beauty, tname.Rate)
			local desc = desc.."\n[size=12][color=#20B2AA]"..tname.Desc.."[/color][/size]"
			item.tooltips = string.format("%s\n%s\n必须物品：%s\n消耗点数：%s\n选择后将世界随机选择一个必须物品将其升级为指定的蕴灵石", thingname, desc,xqname.ThingName,jiage[i])
		end
	end
end

function tbWindow:OnShown()

end

function tbWindow:OnUpdate(dt)
end

function tbWindow:OnHide()

end
function tbWindow:SetPlant(plant)
	tbWindow.plant = plant
end

--GameMain:GetMod("Windows"):CreateWindow("XXZ_LingZhi2"):Show()






















