local tbYY = GameMain:GetMod("_LogicMode"):CreateMode("LUA_cunchu_cailiao")

function tbYY:OnModeEnter(p)
	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:SetHeadMsg("请选择一个物品放入仓库中，请注意，放入的物品属性会被初始化")
end

function tbYY:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	if item ~= nil then
		if item.def.MaxStack > 1 then
			self:SetHeadMsg(item.def.ThingName.."可以放入仓库")
			return true
		else
			self:SetHeadMsg("请选择可叠加上限大于1的物品")
		end
	end
	return false
end

function tbYY:OnModeLeave()
end

function tbYY:Apply(key)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	if item ~= nil then
		GameMain:GetMod("XXZ_JianYiCangKu_SEVE"):CunChuCaiLiao(item.def.Name,item.Count)
		ThingMgr:RemoveThing(item)
		local UI = GameMain:GetMod("Windows"):CreateWindow("XXZ_JianYiCangKu")
		if UI.IsShowing then
			UI:OnShowUpdate()
		end
	end
end



















