local tbYY = GameMain:GetMod("_LogicMode"):CreateMode("XXZ_TiaoZhan_zhaohuan")

function tbYY:OnModeEnter(p)
	self.list = p[1]
	self:ShowLine(self.list)
	self:SetKeyCondition("NoBuilding|InLight")
	self:OpenThingCheck()
	self:SetHeadMsg("请选择一个地点召唤妖灵")
end

function tbYY:CheckThing(k)
	local map = self:GetMap()
	if map ~= nil then
		return true
	end
end

function tbYY:OnModeLeave()
end

function tbYY:Apply(key)
	local map = self:GetMap()
	GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE"):ZhaoHuan(self.list,key)
end


	--world:EnterUILuaMode("XXZ_TiaoZhan_zhaohuan",nil)
















