local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_Magic_lingzhi_pinjiejinshen");
--目标合法检测 首先会通过magic的SelectTarget过滤，然后再通过这里过滤
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体





function tbMagic:TargetCheck(key, t)
	return true
end







function tbMagic:MagicEnter(IDs, IsThing)
	local key = IDs; 
	local plant = self.bind
	local selfkey = plant.Key
	local name = plant.def.Name
	local id = plant.ID
	
	for i=0 ,key.Count-1 do
		local olditem = Map.Things:GetThingAtGrid(key[i],"Item");
		local oldplant = Map.Things:GetThingAtGrid(key[i],3);
		
		if olditem ~= nil then
			local wuxing = tbMagic:ShuXingJianCe(plant,olditem)
			if wuxing > 0 then
				world:FlyLineEffect(olditem.Key, plant.Key, 0.5,
				function(s)
					local num = olditem.Rate/(plant.Rate*50)*olditem.Count*wuxing
					plant:AddLing(olditem.LingV/20)
					GameMain:GetMod("ThingHelper"):GetThing("Plant_lingzhi_1"):SetJinDu(plant,num)
					world:PlayEffect(14, plant.Key, 1);
				end)
				ThingMgr:RemoveThing(olditem)
			end
		end
		
		if oldplant ~= nil then
			local wuxing = tbMagic:ShuXingJianCe(plant,oldplant)
			if oldplant.def.Name ~= "Plant_shu_yaoshou_1" and oldplant ~= plant and wuxing > 0 then
				world:FlyLineEffect(oldplant.Key, plant.Key, 0.5,
				function(s)
					local num = oldplant.Rate/(plant.Rate*30)*wuxing
					plant:AddLing(oldplant.LingV/20)
					GameMain:GetMod("ThingHelper"):GetThing("Plant_lingzhi_1"):SetJinDu(plant,num)
					world:PlayEffect(14, plant.Key, 1);
				end)
				ThingMgr:RemoveThing(oldplant);
			end
		end
	end
end

function tbMagic:ShuXingJianCe(plant,old)
	local xiangsheng = CS.XiaWorld.GameDefine.CheckElementRelation(plant.ElementKind, old.ElementKind)
	local jiacheng = 0
	if xiangsheng == CS.XiaWorld.g_emElementRelation.Same then
		jiacheng = 1
	elseif xiangsheng == CS.XiaWorld.g_emElementRelation.None then
		jiacheng = 1
	elseif xiangsheng == CS.XiaWorld.g_emElementRelation.Born then
		jiacheng = 2
	elseif xiangsheng == CS.XiaWorld.g_emElementRelation.Contrary then
		jiacheng = 0.5
	end
	return jiacheng
end





















