local tbBuilding = GameMain:GetMod("_LogicMode"):CreateMode("LUA_JianZhu_shengcheng")

function tbBuilding:OnModeEnter(p)
	self.building = p[1]
	self.item = p[2]
	self.jianzhen = p[3]
	self.jiance = tbBuilding:JianCe()
	
	self:SetKeyCondition("NoBuilding|InLight")
	self:ShowThingByName(g_emThingType.Building, self.building)
	self:OpenThingCheck()
	--self:ShowLine(self.pItem)
	if self.item ~= nil then
		self:ShowLine(self.item)
	end
	if self.jianzhen then
		if self.jiance then
			self:SetHeadMsg("请选择一块空地")
		else
			self:SetHeadMsg("地图上已经有了剑阵，请拆除后建造，剑阵上限1")
		end
	else
		self:SetHeadMsg("请选择一块空地")
	end
end

function tbBuilding:CheckThing(k)

	if self.jiance == false and self.jianzhen then
		return false
	end

	local map = self:GetMap()
	local def = self:GetLogicMode():GetDef()
	local terrain = map.Terrain:GetTerrain(k)
	if (not terrain:CheckVaild(def.Building.TerrainAffordanceNeeded)) and terrain.TerrainType ~= CS.XiaWorld.g_emTerrainType.Floor then
		return false
	end
	local building = map.Things:GetThingAtGrid(k, g_emThingType.Building)
	if building ~= nil then
		return false
	end
	return true
end

function tbBuilding:OnModeLeave()
	self.building = nil
	self.item = nil
	self.jianzhen = nil
end

function tbBuilding:Apply(key)
	local oldbuilding = self.building
	local beginkey = 0
	
	if self.item ~= nil then
		beginkey = self.item.Key
		ThingMgr:RemoveThing(self.item);
	end
	
	ThingMgr:AddBuildingThing(key,self.building, World.map)
	
	GameMain:GetMod("XXZ_JianYiCangKu_SEVE"):SetJianZhu(self.building)
	self:GetLogicMode():RemoveAllColLowPlant(key)
end

function tbBuilding:JianCe()
	for i=1,9 do
		local jianzhen = world:GetBuildingCount("Building_jianzhen"..i)
		if jianzhen > 0 then
			return false
		end
	end
	return true
end















