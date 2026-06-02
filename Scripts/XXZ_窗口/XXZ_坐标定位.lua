local tbYY = GameMain:GetMod("_LogicMode"):CreateMode("XXZ_CangKu_DingWei")

function tbYY:OnModeEnter(p)
	self:ShowLine(0)
	self:SetKeyCondition("InLight")
	self:OpenThingCheck()
	self:SetHeadMsg("请选择一个一个坐标点作为物品的投放位置")
end

function tbYY:CheckThing(k)
	return true
end

function tbYY:OnModeLeave()
end

function tbYY:Apply(key)
	local key2 = GameMain:GetMod("XXZ_JianYiCangKu_SEVE"):SetDropKey(key)
end

















