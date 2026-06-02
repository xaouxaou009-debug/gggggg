local tbYY = GameMain:GetMod("_LogicMode"):CreateMode("LUA_wupin_xuanze")

function tbYY:OnModeEnter(p)
	self.lable = p[1]
	self.building = p[2]

	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:ShowLine(self.building)
	self:SetHeadMsg("请选择一个物品")
end

function tbYY:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	if self.lable == g_emItemLable.FightFabao then
		if item.Fabao ~= nil then
			self:SetCheckMsg("可蕴养此法宝，当前目标:" .. item:GetName())
			return true
		else
			self:SetCheckMsg(item:GetName().."不是法宝法宝，无法蕴养")
			return false
		end
	end
	
	return false
end

function tbYY:OnModeLeave()
	self.lable = nil
end

function tbYY:Apply(key)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	
	if self.building.Bag ~= nil then
		self.building.Bag:AddBegItem(item,item.Count)
	end
	
end
