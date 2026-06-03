local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_Magic_zhuanshu_naijiu");



--目标合法检测 首先会通过magic的SelectTarget过滤，然后再通过这里过滤
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体


function tbMagic:TargetCheck(key, t)
	if string.find(t.def.Name,"Item_zhuanshu_wuqi_") then 
		return true
	end
	return false
end







function tbMagic:MagicEnter(IDs, IsThing)
	local targetId = IDs[0]
	local target = ThingMgr:FindThingByID(targetId)
	local me = self.bind
	local selfkey = me.Key
	local name = me.def.Name
	local naijiu
	
	if name == "Item_zhuanshu_naijiu_1" then
		naijiu = 1
	elseif name == "Item_zhuanshu_naijiu_2" then
		naijiu = 2
	elseif name == "Item_zhuanshu_naijiu_3" then
		naijiu = 5
	elseif name == "Item_zhuanshu_naijiu_4" then
		naijiu = 10
	elseif name == "Item_zhuanshu_naijiu_5" then
		naijiu = 20
	end
	
	local equptdata = target.EquptData
	if equptdata ~= nil and naijiu ~= nil then
		for i=0,equptdata.Count-1 do
			if equptdata[i].name == "Property_wuqi_zhuanshu_naijiu" then
				local Q = "恢复耐久"	
				local W = "取消恢复"
				world:ShowStoryBox("是否为专属装备"..target:GetName().."补充耐久度", "充能",{Q, W},
				function(s)
					if s == 0 then
						if me.Count > 1 then	
							me:ChangeCount(me.Count-1)
						else
							ThingMgr:RemoveThing(self.bind);
						end
			
						world:FlyLineEffect(selfkey,target.Key, 2,
						function(p)
							world:PlayEffect(65, target.Key, 0.5);
							equptdata[i].addv = equptdata[i].addv+naijiu
							return false
						end,nil,nil,nil,"Effect/gsq/Prefab/Fx_FaShu_03"
						)
						
					else
						return false
					end
				end
				);
			end
		end
	else
		world:ShowMsgBox(target:GetName().." 未激活耐久度系统，请装备后激活", "补充失败")
	end		
end

























