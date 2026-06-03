local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_zawu_ganlin1");



--目标合法检测 首先会通过magic的SelectTarget过滤，然后再通过这里过滤
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体



function tbMagic:TargetCheck(key, t)
	return true
end




function tbMagic:MagicEnter(IDs, IsThing)
	local selfkeys = IDs;
	local plantcount = 0			--范围内植物数量
	local plantnum = 0			--效率加成
	
	local selfkey = self.bind.Key		--自身KEY
	local worldnum = world.DayCount/(world.DayCount+500)		--天数加成
	
	for i=0,selfkeys.Count-1 do
		local oldplant = Map.Things:GetThingAtGrid(selfkeys[i],"Plant");
		if oldplant ~= nil then
			plantcount = plantcount+1
		end
	end
	
	if plantcount == 0 then
		return false
	end
	
	for i=0,selfkeys.Count-1 do
		local oldplant = Map.Things:GetThingAtGrid(selfkeys[i],"Plant");
		if oldplant ~= nil then
			world:FlyLineEffect(selfkey, selfkeys[i], 1,
			function(p)
			
				WorldLua:PlayEffect(14, selfkeys[i], 0.2);
				local oldplantmapling = World.map:GetLing(oldplant.Key)/500	--周围灵力加成
				local oldplantmapbeauty = Map:GetBeauty(oldplant.Key)/50	--周围美观加成
				local oldplantmapfertility = World.map:GetFertility(oldplant.Key)*2
				local plantnum = (oldplantmapling+oldplantmapbeauty+oldplantmapfertility+worldnum)/plantcount+1	--效率加成
				
				oldplant:SetGrowEffectAddP(plantnum, 1800, true)
			end)
		end
	end
end
























