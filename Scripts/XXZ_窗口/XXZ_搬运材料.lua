local tbYY = GameMain:GetMod("_LogicMode"):CreateMode("XXZ_JianZhuCangKu_CunChu")

function tbYY:OnModeEnter(p)

	self.building = p[1]
	
	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:ShowLine(self.building)
	self:SetHeadMsg("请选择一个物品放入仓库中，多个同样物品不会再仓库中叠加")
end

function tbYY:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	local items = self.building.Bag.m_lisItems
	if item ~= nil then
		self:SetHeadMsg(item.def.ThingName.."可以放入仓库，多次放入同样的物品不会叠加")
		return true
	end
	return false
end

function tbYY:OnModeLeave()
end

function tbYY:Apply(key)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	self.building.Bag:AddItem(item)
end


















