local tbZBFW = GameMain:GetMod("_LogicMode"):CreateMode("LUA_ZhungBei_FuMo")

function tbZBFW:OnModeEnter(p)
	self.building = p[1]
	self.item = p[2]
	self.fuwen = p[3]
	self.num = p[4]
	if self.building ~= nil then
		self:ShowLine(self.building)
	elseif self.item ~= nil then
		self:ShowLine(self.item)
	end
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
		self:SetCheckMsg(item:GetName().."是装备类物品，可以赋予符文")
		
		if citiao ~= nil then
			if citiao.Count >= 5 then 
				self:SetCheckMsg(item:GetName().."的词条达到上限，无法继续赋予符文，请移除符文后方可继续赋予符文")
				return false
			end
			if world:GetFlag(item,6201)-citiao.Count < 0 then
				self:SetCheckMsg(item:GetName().."符文栏位已满，请开辟新的符文空位")
				return false
			end
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
	local fuwen = tbZBFW:FuWenHuoQu(item,self.fuwen,self.num)
	local bigenkey
	local xiaohao = "无"
	
	if self.building ~= nil then
		bigenkey = self.building.Key
	elseif self.item ~= nil then
		bigenkey = self.item.Key
		xiaohao = self.item:GetName()
	else
		bigenkey = item.Key
	end
	
	fuwen[4] = "未知符文"
	
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			if self.item ~= nil then
				if self.item.Count > 1 then
					self.item:ChangeCount(self.item.Count - 1)
				else
					ThingMgr:RemoveThing(self.item);
				end
			end
			
			world:FlyLineEffect(bigenkey,key,1)
			if item.EquptData ~= nil then
				for i=0,item.EquptData.Count-1 do
					if fuwen[1] == item.EquptData[i].name then
						if item.EquptData[i].addv ~= 0 and fuwen[2] ~= 0 then
							item.EquptData[i].addv = item.EquptData[i].addv + fuwen[2]
							return false
						end
						if item.EquptData[i].addp ~= 0 and fuwen[3] ~= 0 then
							item.EquptData[i].addp = item.EquptData[i].addp + fuwen[3]
							return false
						end
					end
				end
			end
			item:AddEquiptData(fuwen[1],fuwen[2],fuwen[3])
			tbZBFW:QianZhuiFuYu(item)
			return false
		end
	end, true, "符文赋予", 0, 0,"[color=#4876FF]赋予物品："..item:GetName().."\n符文属性："..fuwen[4].."\n赋予消耗："..xiaohao.."[/color][color=#DC143C]\n\n确认后将消耗一个符文位以获得符文加持，更多符文位需要启灵，属性强度可以消耗升华石提升，重铸符文可以随机删除一条符文[/color]")
	return false
end

function tbZBFW:FuWenHuoQu(item,fuwen,num)

	local rate = item.Rate
	local pinzhi = math.abs(item:GetQuality())
	local zhiliang = item:GetQualityEquipValue()
	local jiacheng = (rate/10+pinzhi)*zhiliang*(num or 1)

	local ShuXinglist = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetShuXinglistTable()
	local SXNum = WorldLua:RandomInt(1,#ShuXinglist+1)
	local shuxing = ShuXinglist[SXNum].SX
	local shuxingaddv = ShuXinglist[SXNum].SXV*jiacheng
	local shuxingaddp = ShuXinglist[SXNum].SXP*jiacheng
	local shuxingname = ShuXinglist[SXNum].SXname
	
	
	if fuwen ~= nil then
		for k,v in pairs(ShuXinglist) do 
			if fuwen == v.SX then
				shuxing = v.SX
				shuxingaddv = v.SXV*jiacheng
				shuxingaddp = v.SXP*jiacheng
				shuxingname = v.SXname
			end
		end
	end
	
	local ShuXinglist = {shuxing,shuxingaddv,shuxingaddp,shuxingname}
	return ShuXinglist
end

function tbZBFW:QianZhuiFuYu(item)
	local qianzhui1 = {"[color=#FFF8DC]〖凡〗◆ [/color]","[color=#98FB98]〖宝〗◆ [/color]","[color=#00F5FF]〖灵〗◆ [/color]","[color=#EE00EE]〖神〗◆ [/color]","[color=#FFC125]〖圣〗◆ [/color]"}
	local qianzhui2 = {"%[color=#FFF8DC%]〖凡〗◆ %[/color%]","%[color=#98FB98%]〖宝〗◆ %[/color%]","%[color=#00F5FF%]〖灵〗◆ %[/color%]","%[color=#EE00EE%]〖神〗◆ %[/color%]","%[color=#FFC125%]〖圣〗◆ %[/color%]"}
	
	for i=1,#qianzhui2 do
		local name = string.gsub(item:GetName(),qianzhui2[i],"")
		item:SetName(name)
	end
	
	if item.EquptData.Count > 0 then
		local num = item.EquptData.Count
		if num > 5 then
			num = 5
		end
		item:SetName(qianzhui1[num]..item:GetName())
	end
	
end




















