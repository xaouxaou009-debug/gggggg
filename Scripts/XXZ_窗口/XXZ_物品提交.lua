local tbYY = GameMain:GetMod("_LogicMode"):CreateMode("LUA_XXZ_wupin_tijiao")

function tbYY:OnModeEnter(p)
	self.item = p[1]
	self.jiage = p[2]
	self.count = p[3]
	self.num = p[4]
	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	local tname = ThingMgr:GetDef(g_emThingType.Item,self.item)
	self:SetHeadMsg("请选择"..tname.ThingName.."进行提交，当前可提交数量"..self.count)
end


function tbYY:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	if item.def.Name == self.item then
		return true
	end
	return false
end

function tbYY:OnModeLeave()
end

function tbYY:Apply(key)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	local tname = item.def
	local count = item.Count
	if item.Count > self.count then
		count = self.count
		item:ChangeCount(item.Count-self.count)
	else
		ThingMgr:RemoveThing(item)
	end
	if self.jiage ~= nil then
		GameMain:GetMod("ZH_zhanghu"):AddLingNum(self.jiage*count)
	end
	local sycount = GameMain:GetMod("XXZ_RenWuTable_SEVE"):SetChangZhuCount(self.num,count)
	world:ShowMsgBox(tname.ThingName.."提交成功，本次共提交"..count.."个\n共获得点数"..self.jiage*count.."点\n剩余可提交数量"..sycount, "提交成功")
end



















