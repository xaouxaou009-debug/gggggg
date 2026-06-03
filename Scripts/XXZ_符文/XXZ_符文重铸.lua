local tbZBFW = GameMain:GetMod("_LogicMode"):CreateMode("LUA_ZhungBei_FuMo_YiChu")

function tbZBFW:OnModeEnter(p)
	self.item = p[1]
	self.num = p[2]
	
	self:ShowLine(self.item)
	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:SetHeadMsg("请选择一件有符文的装备")
end

function tbZBFW:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	local citiao = item.EquptData or nil
	
	if item.EquptData == nil then
		self:SetHeadMsg("当前物品无有符文系统，无法削减符文")
		return false
	end
	if item.EquptData.Count == 0 then
		self:SetHeadMsg("当前物品符文数量为零，无法继续削减符文")
		return false
	end
	
	
	
	return true
end

function tbZBFW:OnModeLeave()
end

function tbZBFW:Apply(key)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	local count = self.item.Count
	local bigenkey = self.item.Key
	
	local fuwen = {}
	local ShuXinglist = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetShuXinglistTable()
	fuwen[0] = WorldLua:RandomInt(0,item.EquptData.Count)
	fuwen[1] = item.EquptData[fuwen[0]].name
	
	for k,v in pairs(ShuXinglist) do
		if v.SX == fuwen[1] then
			fuwen[2] = v.SXname
		end 
	end
	
	if fuwen[2] == nil then
		fuwen[2] = "未知符文"
	end
	if self.num == 2 then 
		fuwen[2] = "未知符文*2"
		fuwen[3] = "提升一条符文属性"
	elseif self.num == 3 then 
		fuwen[2] = "未知符文*3"
		fuwen[3] = "提升全部符文属性"
	elseif self.num == 4 then 
		fuwen[2] = fuwen[2]
		fuwen[3] = "所有符文属性降低"
	elseif self.num == 5 then 
		fuwen[2] = fuwen[2]
		fuwen[3] = "提升一条符文属性"
	else
		fuwen[2] = "未知符文*1"
		fuwen[3] = "无变化"
	end
	
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			if self.item.Count > 1 then
				self.item:ChangeCount(self.item.Count - 1)
			else
				ThingMgr:RemoveThing(self.item);
			end
		
			world:FlyLineEffect(bigenkey,key,1)
					
			if self.num == 1 then 
				fuwen[4] = 1
				fuwen[5] = 0
			elseif self.num == 2 then 
				fuwen[4] = 2
				fuwen[5] = 0
			elseif self.num == 3 then 
				fuwen[4] = 3
				fuwen[5] = 0.5
			elseif self.num == 4 then 
				fuwen[4] = 1
				fuwen[5] = -0.5
			elseif self.num == 5 then 
				fuwen[4] = 1
				fuwen[5] = 0
			end
			item.EquptData:Remove(item.EquptData[fuwen[0]])
			if fuwen[4] > 1 then 
				for i=1,math.min(item.EquptData.Count,fuwen[4]-1) do
					if item.EquptData.Count > 0 then
						item.EquptData:Remove(item.EquptData[WorldLua:RandomInt(0,item.EquptData.Count)])
					end 
				end
			end
			tbZBFW:ShuXingBianHua(item,fuwen[5])
			
			if item.EquptData.Count >= 1 then
				local Random = WorldLua:RandomInt(0,item.EquptData.Count)
				item.EquptData[Random].addv = item.EquptData[Random].addv*1.5
				item.EquptData[Random].addp = item.EquptData[Random].addp*1.5
			end
			
			return false
		end
	end, true, "符文削减", 0, 0,"[color=#4876FF]物品消耗："..self.item:GetName().."\n当前装备："..item:GetName().."\n削除符文："..fuwen[2].."\n符文变化："..fuwen[3].."\n\n是否确定删除一条符文，确定后将直接移除此符文[/color]")
	return false
end

function tbZBFW:ShuXingBianHua(item,num)
	local zifu = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetTeShuFuWenlist()
	
	for k,v in pairs(zifu) do
		local name = string.gsub(item:GetName(),v[7],"")
		item:SetName(name)
	end
	
	local fuwen = item.EquptData
	if fuwen.Count > 0 and num > 0 then
		for i=0,item.EquptData.Count-1 do
			item.EquptData[i].addv = item.EquptData[i].addv*(1+num)
			item.EquptData[i].addp = item.EquptData[i].addp*(1+num)
		end
	end
	
	
	local qianzhui1 = {"[color=#FFF8DC]〖凡〗◆ [/color]","[color=#98FB98]〖宝〗◆ [/color]","[color=#00F5FF]〖灵〗◆ [/color]","[color=#EE00EE]〖神〗◆ [/color]","[color=#FFC125]〖圣〗◆ [/color]"}
	local qianzhui2 = {"%[color=#FFF8DC%]〖凡〗◆ %[/color%]","%[color=#98FB98%]〖宝〗◆ %[/color%]","%[color=#00F5FF%]〖灵〗◆ %[/color%]","%[color=#EE00EE%]〖神〗◆ %[/color%]","%[color=#FFC125%]〖圣〗◆ %[/color%]"}
	
	
	for i=1,#qianzhui2 do
		local name = string.gsub(item:GetName(),qianzhui2[i],"")
		item:SetName(name)
	end
	
	if item.EquptData.Count == 0 then
		return false
	end
	
	local num = item.EquptData.Count
	if num > 5 then
		num = 5
	end
	item:SetName(qianzhui1[num]..item:GetName())
	
end







