local tbZBFW = GameMain:GetMod("_LogicMode"):CreateMode("LUA_ZhungBei_FuMo_TeShu")

function tbZBFW:OnModeEnter(p)
	self.item = p[1]
	
	self:ShowLine(self.item)
	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:SetHeadMsg("请选择一件可赋予符文的装备")
end

function tbZBFW:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	local itemlable = item.def.Item.Kind
	local citiao = item.EquptData or nil
	
	if item.Count > 1 then 
		self:SetHeadMsg(item:GetName().."的数量超过1个，无法提升")
		return false
	end
	
	if itemlable == CS.XiaWorld.g_emItemKind.Equipment or itemlable == g_emItemLable.SpellPaper then
		self:SetCheckMsg(item:GetName().."是装备类物品，可以赋予特殊符文")
		if citiao ~= nil then
			if citiao.Count > 0 then
				self:SetCheckMsg(item:GetName().."已有符文，无法赋予特殊符文")
				return false
			end
		end
		if item.ElementKind ~= self.item.ElementKind then
			self:SetCheckMsg(item:GetName().."与"..self.item:GetName().."的五行不同，无法赋予专属符文")
			return false
		end
		return true
	else
		self:SetCheckMsg(item:GetName().."不是装备类物品，无法赋予符文")
		return false
	end
	
	return false
end

function tbZBFW:OnModeLeave()
end

function tbZBFW:Apply(key)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	local bigenkey = self.item.Key
	
	local fuwen = tbZBFW:FuWenHuoQu(self.item)
	local ShuXinglist = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetShuXinglistTable()
	local SXname = "未知"
	for k,v in pairs(ShuXinglist) do
		if fuwen[2] == v.SX then
			SXname = v.SXname
		end
	end
	
	
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			if self.item.Count > 1 then
				self.item:ChangeCount(self.item.Count - 1)
			else
				ThingMgr:RemoveThing(self.item);
			end
		
			item:SetName(fuwen[1]..item:GetName())
			tbZBFW:FuWenFuYu(fuwen,item)
			world:FlyLineEffect(bigenkey,key,1)
			return false
		end
	end, true, "符文赋予", 0, 0,"[color=#4876FF]赋予物品："..item:GetName().."\n符文属性："..SXname.."\n赋予消耗："..self.item:GetName().."[/color][color=#DC143C]\n\n确认后将装备赋予特殊符文，赋予特殊符文后将无法继续赋予符文，属性强度可以消耗升华石提升，重铸符文可以随机删除一条符文[/color]")
	return false
end

function tbZBFW:FuWenFuYu(fuwen,item)

	local ShuXinglist = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetShuXinglistTable()
	local rate = item.Rate
	local pinzhi = math.abs(item:GetQuality())
	local zhiliang = item:GetQualityEquipValue()
	local jiacheng = (rate/10+pinzhi)*zhiliang*(num or 1)
	for i=2,6 do
		local jiance = true
		for k,v in pairs(ShuXinglist) do
			if v.SX == fuwen[i] then
				if item.EquptData ~= nil then
					for i=0,item.EquptData.Count-1 do
						if v.SX == item.EquptData[i].name then
							if item.EquptData[i].addv ~= 0 and v.SXV ~= 0 then
								item.EquptData[i].addv = item.EquptData[i].addv + v.SXV*jiacheng
								jiance = false
							end
							if item.EquptData[i].addp ~= 0 and v.SXP ~= 0 then
								item.EquptData[i].addp = item.EquptData[i].addp + v.SXP*jiacheng
								jiance = false
							end
						end
					end
				end
				if jiance then
					item:AddEquiptData(v.SX,v.SXV*jiacheng,v.SXP*jiacheng);
				end
			end
		end
	end
end

function tbZBFW:FuWenHuoQu(self)

	local zhuanshu = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetTeShuFuWenlist()

	if self.def.Name == "Item_fumo_fuwen_dong1" then
		fuwen = zhuanshu[1]
	end
	if self.def.Name == "Item_fumo_fuwen_dong2" then
		fuwen = zhuanshu[2]
	end
	if self.def.Name == "Item_fumo_fuwen_dong3" then
		fuwen = zhuanshu[3]
	end
	if self.def.Name == "Item_fumo_fuwen_dong4" then
		fuwen = zhuanshu[4]
	end
	if self.def.Name == "Item_fumo_fuwen_dong5" then
		fuwen = zhuanshu[5]
	end
	if self.def.Name == "Item_fumo_fuwen_dong6" then
		fuwen = zhuanshu[6]
	end
	if self.def.Name == "Item_fumo_fuwen_dong7" then
		fuwen = zhuanshu[7]
	end
	if self.def.Name == "Item_fumo_fuwen_nan1" then
		fuwen = zhuanshu[8]
	end
	if self.def.Name == "Item_fumo_fuwen_nan2" then
		fuwen = zhuanshu[9]
	end
	if self.def.Name == "Item_fumo_fuwen_nan3" then
		fuwen = zhuanshu[10]
	end
	if self.def.Name == "Item_fumo_fuwen_nan4" then
		fuwen = zhuanshu[11]
	end
	if self.def.Name == "Item_fumo_fuwen_nan5" then
		fuwen = zhuanshu[12]
	end
	if self.def.Name == "Item_fumo_fuwen_nan6" then
		fuwen = zhuanshu[13]
	end
	if self.def.Name == "Item_fumo_fuwen_nan7" then
		fuwen = zhuanshu[14]
	end
	if self.def.Name == "Item_fumo_fuwen_xi1" then
		fuwen = zhuanshu[15]
	end
	if self.def.Name == "Item_fumo_fuwen_xi2" then
		fuwen = zhuanshu[16]
	end
	if self.def.Name == "Item_fumo_fuwen_xi3" then
		fuwen = zhuanshu[17]
	end
	if self.def.Name == "Item_fumo_fuwen_xi4" then
		fuwen = zhuanshu[18]
	end
	if self.def.Name == "Item_fumo_fuwen_xi5" then
		fuwen = zhuanshu[19]
	end
	if self.def.Name == "Item_fumo_fuwen_xi6" then
		fuwen = zhuanshu[20]
	end
	if self.def.Name == "Item_fumo_fuwen_xi7" then
		fuwen = zhuanshu[21]
	end
	if self.def.Name == "Item_fumo_fuwen_bei1" then
		fuwen = zhuanshu[22]
	end
	if self.def.Name == "Item_fumo_fuwen_bei2" then
		fuwen = zhuanshu[23]
	end
	if self.def.Name == "Item_fumo_fuwen_bei3" then
		fuwen = zhuanshu[24]
	end
	if self.def.Name == "Item_fumo_fuwen_bei4" then
		fuwen = zhuanshu[25]
	end
	if self.def.Name == "Item_fumo_fuwen_bei5" then
		fuwen = zhuanshu[26]
	end
	if self.def.Name == "Item_fumo_fuwen_bei6" then
		fuwen = zhuanshu[27]
	end
	if self.def.Name == "Item_fumo_fuwen_bei7" then
		fuwen = zhuanshu[28]
	end
	
	return fuwen
end




















