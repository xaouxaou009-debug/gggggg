local tbBuilding = GameMain:GetMod("_LogicMode"):CreateMode("LUA_JianZhu_jilian")

function tbBuilding:OnModeEnter(p)
	self.oldbuilding = p[1]
	self.newbuilding = p[2]
	self.juli = p[3]
	print(self.oldbuilding.Rate,self.oldbuilding.Beauty)
	
	self:SetKeyCondition("NoBuilding|InLight")
	self:ShowThingByName(g_emThingType.Building, self.newbuilding)
	self:OpenThingCheck()
	self:ShowLine(self.oldbuilding)
	
	self:SetHeadMsg("请选择一块空地")
end

function tbBuilding:CheckThing(k)

	local juli = false
	local Aroundkey = GameUlt.GetNearGrid(self.oldbuilding.Key, self.juli)
	for _,v in pairs(Aroundkey) do
		if k == v then
			juli = true
		end
	end
	if juli ~= true then
		self:SetHeadMsg("所选位置距离"..self.oldbuilding:GetName().."太远，无法建造")
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
	self.oldbuilding = nil
	self.newbuilding = nil
	self.juli = nil
end

function tbBuilding:Apply(key)
	local building = self.newbuilding
	local rate = self.oldbuilding.Rate
	local beauty = self.oldbuilding.Beauty
	beginkey = self.oldbuilding.Key
	
	world:FlyLineEffect(beginkey, key, 0.5, 
	function(p)
		local building = ThingMgr:AddBuildingThing(key,building, World.map)
		building.Rate = rate
		building:ChangeBeauty(beauty)
	end);
	self:GetLogicMode():RemoveAllColLowPlant(key)
end















