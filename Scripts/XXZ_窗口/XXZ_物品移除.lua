local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_Magic_wupin_yichu");



--目标合法检测 首先会通过magic的SelectTarget过滤，然后再通过这里过滤
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体



function tbMagic:TargetCheck(key, t)
	return true
end




function tbMagic:MagicEnter(IDs, IsThing)
	local keys = IDs;
	local count = 0
	local tcount = 0
	
	for i=0,keys.Count-1 do
		local olditem = Map.Things:GetThingAtGrid(keys[i],"Item");
		if olditem ~= nil then
			count = count+WorldLua:RandomFloat(0.03,0.3)*olditem.Count
			tcount = tcount+olditem.Count
			ThingMgr:RemoveThing(olditem)
		end
	end
	count = math.floor(count*100)/100
	GameMain:GetMod("ZH_zhanghu"):AddLingNum(count)
	world:ShowMsgBox("本次一共移除"..tcount.."件物品，随机获得点数"..count.."点", "物品移除")
end
























