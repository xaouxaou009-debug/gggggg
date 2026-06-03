local tbZBFW = GameMain:GetMod("_LogicMode"):CreateMode("LUA_ZhungBei_FuMo_TiSheng")

function tbZBFW:OnModeEnter(p)
	self.item = p[1]
	
	self:ShowLine(self.item)
	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:SetHeadMsg("请选择一件有符文的装备")
end

function tbZBFW:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	local itemlable = item.def.Item.Kind
	local citiao = item.EquptData or nil
	
	
	if citiao ~= nil then
		self:SetCheckMsg(item:GetName().."已有符文，可以提升符文强度")
		return true
	else
		self:SetCheckMsg(item:GetName().."没有符文，无法提升符文强度")
	end
	return false
end

function tbZBFW:OnModeLeave()
end

function tbZBFW:Apply(key)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	local count = self.item.Count
	local bigenkey = self.item.Key
	
	local qiangdu = tbZBFW:QingDu(self.item)
	
	
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			if self.item.Count > 10 then
				self.item:ChangeCount(self.item.Count - 10)
			else
				ThingMgr:RemoveThing(self.item);
			end
		
			world:FlyLineEffect(bigenkey,key,1)
			tbZBFW:TiSheng(qiangdu,item,count)
			return false
		end
	end, true, "符文提升", 0, 0,"[color=#4876FF]物品消耗："..self.item:GetName().."\n当前装备："..item:GetName().."\n\n是否确定提升所选装备的符文属性，确定后将消耗当前所选的符文碎片并随机提升所选装备的符文属性，每次最多消耗十个，低于十个则全部消耗[/color]")
	return false
end

function tbZBFW:TiSheng(num,item,count)

	local rate = item.Rate
	local pinzhi = math.abs(item:GetQuality())
	local zhiliang = item:GetQualityEquipValue()
	local jiacheng = (rate/10+pinzhi)*zhiliang*(1+(num or 0.05))
	
	for i=1,math.min(count,10) do
		local ShuXinglist = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetShuXinglistTable()
		local citiao = item.EquptData[WorldLua:RandomInt(0,item.EquptData.Count)]
		for k,v in pairs(ShuXinglist) do
			if v.SX == citiao.name then
				if citiao.addv ~= 0 and v.SXV ~= 0 then
					citiao.addv = citiao.addv + v.SXV*jiacheng
				end
				if citiao.addp ~= 0 and v.SXP ~= 0 then
					citiao.addp = citiao.addp + v.SXP*jiacheng
				end
			end
		end
	end
end

function tbZBFW:QingDu(self)
	local qiangdu = 1
	if self.def.Name == "Item_fumo_suipian1" then
		qiangdu = 0.1
	end
	if self.def.Name == "Item_fumo_suipian2" then
		qiangdu = 0.2
	end
	if self.def.Name == "Item_fumo_suipian3" then
		qiangdu = 0.35
	end
	if self.def.Name == "Item_fumo_suipian4" then
		qiangdu = 0.55
	end
	if self.def.Name == "Item_fumo_suipian5" then
		qiangdu = 0.8
	end
	if self.def.Name == "Item_fumo_suipian6" then
		qiangdu = 1.1
	end
	if self.def.Name == "Item_fumo_suipian7" then
		qiangdu = 1.5
	end
	if self.def.Name == "Item_fumo_suipian8" then
		qiangdu = 2.0
	end
	if self.def.Name == "Item_fumo_suipian9" then
		qiangdu = 2.6
	end
	if self.def.Name == "Item_fumo_suipian10" then
		qiangdu = 3.5
	end
	
	return qiangdu
end




















