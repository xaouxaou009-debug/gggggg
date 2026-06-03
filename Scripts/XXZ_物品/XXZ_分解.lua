local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_jianzhu_lingshifenjie");



--目标合法检测 首先会通过magic的SelectTarget过滤，然后再通过这里过滤
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体



function tbMagic:TargetCheck(key, t)
	return true
end




function tbMagic:MagicEnter(IDs, IsThing)
	local selfkeys = IDs;
	
	local selfkey = self.bind.Key		--自身KEY
	local Things = Map.Things;
	
	for i=0,selfkeys.Count-1 do
		local olditem = Map.Things:GetThingAtGrid(selfkeys[i],2);
		if olditem ~= nil then
			for k,v in pairs() do
				if olditem.def.Name == v.Name then
				end
			end
		end
	end
	
	
	local Q = nil
	local W = nil
	local Qsm = nil
	local Wsm = nil
	if self.bind.LingV < 1 then
		world:ShowMsgBox(self.bind:GetName().."能量不足", "失败")
			return false
	end
	if self.bind.LingV >= 1 then
	Q = "甘霖神水"
	Qsm = "甘霖神水:消耗全部能量后给范围内植物施加万物复生，短时间内提升大量生长度"
	Wsm = "\n"
	end
	
	if self.bind.LingV >= 10 then
	W = "甘霖灵术"
	Wsm = "\n\n甘霖灵术:消耗全部能量后给范围内人员施加灵气灌顶，每秒恢复5%的最大灵气值"
	end
	
	world:ShowStoryBox(Qsm..Wsm,"甘霖之术", {Q, W}, 
	function(s)
	if s == 0 then
		if selfPcount == 0 then
			world:ShowMsgBox("范围内没有植物，甘霖神水无法浇灌", "失败")
			return false
		end
		
		plantnum = (rate+beauty+ling+worldnum)/selfPcount
	
		self.bind:AddLing(-self.bind.LingV)
		for i=0,selfkeys.Count-1 do
			local oldplant = Map.Things:GetThingAtGrid(selfkeys[i],"Plant");
			if oldplant ~= nil then
				world:FlyLineEffect(selfkey, selfkeys[i], 1,
				function(p)
				WorldLua:PlayEffect(14, selfkeys[i], 5);
				
				local tuling1 = oldplant.map:GetLing(oldplant.Key)/2000	--周围灵力加成
				local tuling2 = self.bind.map:GetLing(selfkey)/2000	--周围灵力加成
				local dixing1 = self.bind.map:GetElementPower(selfkey, self.bind.ElementKind)
				local dixing2 = oldplant.map:GetElementPower(oldplant.Key, oldplant.ElementKind)
				
				plantnum2 = (plantnum+tuling1+tuling2)*(dixing1+dixing2)
				oldplant:SetGrowEffectAddP(plantnum2, 1800, true)
				end)
			end
		end
	else
		if selfNcount == 0 then
			world:ShowMsgBox("范围内没有内门弟子，甘霖灵术无法释放", "失败")
			return false
		end
		self.bind:AddLing(-10)
		for i=0,selfkeys.Count-1 do
			local oldnpc = Map.Things:GetThingAtGrid(selfkeys[i],1);
			if oldnpc ~= nil then
				world:FlyLineEffect(selfkey, selfkeys[i], 1,
				function(p)
					WorldLua:PlayEffect(14, oldnpc.Pos, 0.5);
					oldnpc.LuaHelper:AddModifier("Modifier_zhiwu_jingping1")
				end)
			end
		end
	
	end
	end
	)
end
























