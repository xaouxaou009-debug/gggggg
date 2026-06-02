local tbYY = GameMain:GetMod("_LogicMode"):CreateMode("LUA_wuqi_cailiao")

function tbYY:OnModeEnter(p)
	self.building = p[1]

	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:ShowLine(self.building)
	self:SetHeadMsg("请选择一个物品")
end

function tbYY:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	local items = self.building.Bag.m_lisItems
	
	if self.building:CheckCommandSingle("BagCarryItem", false) ~= nil then
		self:SetHeadMsg("当前正在等待搬运材料中，等待当前工作结束再继续添加新的物品")
		return false
	end
	
	if item.def.Item.Lable == g_emItemLable.WoodBlock or item.def.Item.Lable == g_emItemLable.RockBlock or item.def.Item.Lable == g_emItemLable.MetalBlock then
		self:SetHeadMsg("当前物品："..item:GetName().." 可用于锻造特殊物品")
		return true
	else
		self:SetHeadMsg("当前物品："..item:GetName().." 不可用于锻造特殊物品")
		return false
	end
	
	
	
	
	
	return false
end

function tbYY:OnModeLeave()
end

function tbYY:Apply(key)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	local items = self.building.Bag.m_lisItems
	
	for i=0,items.Count-1 do
		if item.def.Name == items[i].def.Name then
			local count = item.Count + items[i].Count
			if count > item.def.MaxStack then
				count = item.def.MaxStack
				item:ChangeCount(item.Count-(count-items[i].Count))
				
			else
				ThingMgr:RemoveThing(item)
			end
			
			
			world:FlyLineEffect(key, self.building.Key, 0.5, 
			function(p)
				items[i]:ChangeCount(count)
			end)
			return false
		end
	end
	
	self.building.Bag:AddBegItem(item,1)
end




















