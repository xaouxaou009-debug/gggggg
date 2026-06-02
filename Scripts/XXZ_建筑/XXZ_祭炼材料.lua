local tbYY = GameMain:GetMod("_LogicMode"):CreateMode("LUA_jilian_cailiao")

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
	
	if item.def.Item.Lable == g_emItemLable.Wood or item.def.Item.Lable == g_emItemLable.Rock or item.def.Item.Lable == g_emItemLable.Metal then
		if items.Count == 0 then
			self:SetHeadMsg("当前物品："..item:GetName().." 可用于祭炼高级材料")
			return true
		end
		if items.Count >= 1 then 
		
			if items.Count >= (self.building.Rate/3)+2 then
				local jiance = false
				for i=0,items.Count-1 do
					if items[i].def.Name == item.def.Name then
						jiance = true
					end
				end
				if jiance == false then
					self:SetHeadMsg("子台物品种类达到上限，当前物品："..item:GetName().." 无法放入祭炼子，品阶越高上限物品越多")
					return false
				end
			end
			
			if items[0].def.Item.Lable == item.def.Item.Lable then
				self:SetHeadMsg("当前物品："..item:GetName().." 可用于祭炼高级材料")
				return true
			else
				local wupinlable
				if items[0].def.Item.Lable == g_emItemLable.Rock then
					wupinlable = "石头"
				elseif items[0].def.Item.Lable == g_emItemLable.Wood then
					wupinlable = "木材"
				elseif items[0].def.Item.Lable == g_emItemLable.Metal then
					wupinlable = "金属"
				end
					self:SetHeadMsg("当前物品："..item:GetName().." 与祭炼台当前可祭炼材料类型不符，当前可祭炼类型为："..wupinlable)
				return false
			end
		end
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
				GameMain:GetMod("ThingHelper"):GetThing("Building_jilian_cailiao"):Desc(self.building)
			end)
			return false
		end
	end
	
	self.building.Bag:AddBegItem(item,1)
end


















