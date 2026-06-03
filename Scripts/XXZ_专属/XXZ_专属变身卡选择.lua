local tbFBQH = GameMain:GetMod("_LogicMode"):CreateMode("LUA_zhuanshu_bianshenka")

function tbFBQH:OnModeEnter(p)
	self.item = p[1]

	self:SetKeyCondition("Npc")
	self:OpenThingCheck()
	self:ShowLine(self.item)
	self:SetHeadMsg("选择一个未在变身状态的人物")
end

function tbFBQH:CheckThing(k)
	local map = self:GetMap()
	local npc = map.Things:GetThingAtGrid(k, g_emThingType.Npc)
	if npc ~= nil then
		local npcMod = npc.NpcMods
		if npcMod == nil then
			return true
		else
			self:SetHeadMsg(npc:GetName().."已经有了新的外形，无法再次幻化")
			return false
		end
	end
	return false
end

function tbFBQH:OnModeLeave()
end

function tbFBQH:Apply(key)
	local map = self:GetMap()
	local npc = map.Things:GetThingAtGrid(key, g_emThingType.Npc)
	
	local selfkey = self.item.Key
	local xuanxiang = {"取消幻化"}
	local buffs = {nil}
	if npc.Sex == g_emNpcSex.Male then			--检查对应性别
		xuanxiang = {"取消幻化","孙悟空","吕布","李白","关羽","后羿"}
		buffs = {"Modifier_zhuanshu_bianshen_wukong","Modifier_zhuanshu_bianshen_lvbu","Modifier_zhuanshu_bianshen_libai","Modifier_zhuanshu_bianshen_guanyu","Modifier_zhuanshu_bianshen_houyi"}
	elseif npc.Sex == g_emNpcSex.Female then
		xuanxiang = {"取消幻化","陆雪琪","碧瑶","貂蝉","虞姬","紫霞"}
		buffs = {"Modifier_zhuanshu_bianshen_luxueqi","Modifier_zhuanshu_bianshen_biyao","Modifier_zhuanshu_bianshen_diaochan","Modifier_zhuanshu_bianshen_yuji","Modifier_zhuanshu_bianshen_zixia"}
	else
		world:ShowMsgBox(npc:GetName().."的性别超出了系统限制", "无法幻化")
		return false
	end
	
	world:ShowStoryBox("上古灵神创作的神灵卷轴，记载了特殊的幻化之术，使用此卷轴可以激活画卷的神秘力量，在一定的时间内幻化成新的模型","幻化", xuanxiang,
	function(s)
		local modifier
		if s == 0 then 
			return false
		end
			
		if self.item.Count > 1 then
			self.item:ChangeCount(self.item.Count-1)
		else
			ThingMgr:RemoveThing(self.item);
		end
		
		world:FlyLineEffect(selfkey , npc.Key, 1,
		function(p)
			npc:AddModifier(buffs[s])
		end
		,nil,nil,nil,"Effect/A/Prefabs/Projectiles/Frost/FrostProjectileTiny")
	end)
end










