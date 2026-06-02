local tbFBQH = GameMain:GetMod("_LogicMode"):CreateMode("LUA_FaBao_qianghua")

function tbFBQH:OnModeEnter(p)
	self.item = p[1]

	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:ShowLine(self.item)
	self:SetHeadMsg("请选择一件法宝")
end

function tbFBQH:CheckThing(k)
	local map = self:GetMap()
	local fabao = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	
	if fabao.def.Item.Lable == g_emItemLable.FightFabao then
	
		local gongsu = fabao.Fabao:GetProperty("AttackRate") --攻击间隔
		if self.item.def.Name == "Item_qianghua_suipian10" and gongsu < 0.15 then
			self:SetCheckMsg(fabao:GetName().."攻速已达到上限，无法继续强化")
			return false
		end
		if self.item.Count >= fabao.Rate then
			self:SetCheckMsg("法宝强化，当前目标:" .. fabao:GetName().."，消耗"..self.item:GetName()..fabao.Rate.."个")
			return true
		else
			self:SetCheckMsg("碎片不足，无法强化当前目标:" .. fabao:GetName().."，需求碎片"..self.item:GetName()..fabao.Rate.."个")
			return false
		end
	else
		self:SetCheckMsg("当前目标并非法宝不能强化")
	end
	return false
end

function tbFBQH:OnModeLeave()
end

function tbFBQH:Apply(key)
	local map = self:GetMap()
	local fabao = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	local leijie = fabao.Fabao.GodCount
	fabao.Fabao:AddGodCount(-leijie)
	local jiance = tbFBQH:QiangHuaJianCe(fabao,self.item)
	local qianghuajilv = tbFBQH:JiLvWenZi(jiance[6])
	
	jiance[2] = jiance[1]+jiance[2]
	
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			local selfkey = self.item.Key
			if self.item.Count > fabao.Rate then
				self.item:ChangeCount(self.item.Count - fabao.Rate)
			else
				ThingMgr:RemoveThing(self.item);
			end
		
			world:FlyLineEffect(selfkey,fabao.Key,1,
			function(p)
				if WorldLua:CheckRate(jiance[6])  then
					world:PlayEffect(10, fabao.Key, 2);
					fabao.Fabao:SetProperty(jiance[3] , jiance[2])
					world:ShowMsgBox("强化成功"..jiance[5], "强化成功")
				else
					world:ShowMsgBox("强化失败，属性没有任何变化", "强化失败")
				end
			fabao.Fabao:AddGodCount(leijie)
			end)
			return false
		end
		fabao.Fabao:AddGodCount(leijie)
	end, true, jiance[4], 0, 0, "强化物品："..fabao:GetName().."\n强化加成："..jiance[5].."\n强化几率："..qianghuajilv.."\n符文消耗："..fabao.Rate.."个")
	return false
end

function tbFBQH:QiangHuaJianCe(fabao,olditem)

	local rate = fabao.Rate; --目标品阶
	local quality = fabao:GetQualityEquipValue()--目标品质强度
	local beauty = fabao.Beauty; --目标美观
	
	local list = {} -- 1基础，2加成，3属性name，4属性名，5加成说明，6成功几率
	if olditem.def.Name == "Item_qianghua_suipian1" then
		list[1] = fabao.Fabao:GetProperty("AttackPower") --法宝威力
		list[2] = (rate*0.12+beauty*0.05)*quality	--加成强度
		list[3] = "AttackPower"
		list[4] = "法宝威力"
		list[5] = "[color=#FF0000]法宝威力+ "..(math.floor(list[2]*100)/100).."[/color]"
		list[6] = 0.05+(10*rate+beauty*5+quality*0.5)/list[1]
		
	elseif olditem.def.Name == "Item_qianghua_suipian2" then
		list[1] = fabao.Fabao:GetProperty("LingRecover") --回灵速度
		list[2] = (rate*0.13+beauty*0.06)*quality	--加成强度
		list[3] = "LingRecover"
		list[4] = "回灵速度"
		list[5] = "[color=#FF0000]回灵速度+ "..(math.floor(list[2]*100)/100).."/秒[/color]"
		list[6]  = 0.05+(10*rate+beauty*5+quality*0.7)/list[1]

	elseif olditem.def.Name == "Item_qianghua_suipian3" then
		list[1] = fabao.Fabao:GetProperty("MaxLing") --灵气容量
		list[2] = (rate*0.15+beauty*0.07)*quality	--加成强度
		list[3] = "MaxLing"
		list[4] = "灵气上限"
		list[5] = "[color=#FF0000]灵气上限+ "..(math.floor(list[2]*100)/100).."[/color]"
		list[6]  = 0.05+(40*rate+beauty*20+quality*10)/list[1]
		
	elseif olditem.def.Name == "Item_qianghua_suipian4" then
		list[1] = fabao.Fabao:GetProperty("FlySpeed") --飞行速度
		list[2] = (rate*0.07+beauty*0.03)*quality	--加成强度
		list[3] = "FlySpeed"
		list[4] = "飞行速度"
		list[5] = "[color=#FF0000]飞行速度+ "..(math.floor(list[2]*100)/100).."米/秒[/color]"
		list[6]  = 0.05+(1*rate+beauty*0.5+quality*0.1)/list[1]
		
	elseif olditem.def.Name == "Item_qianghua_suipian5" then
		list[1] = fabao.Fabao:GetProperty("RotSpeed") --转弯速度
		list[2] = (rate*0.05+beauty*0.01)*quality	--加成强度
		list[3] = "RotSpeed"
		list[4] = "转弯速度"
		list[5] = "[color=#FF0000]转弯速度+ "..(math.floor(list[2]*100)/100).."度/秒[/color]"
		list[6]  = 0.05+(8*rate+beauty*4+quality*0.4)/list[1]
		
	elseif olditem.def.Name == "Item_qianghua_suipian6" then
		list[1] = fabao.Fabao:GetProperty("KnockBackResistance") --击退抵抗
		list[2] = (rate*0.004+beauty*0.001)*quality	--加成强度
		list[3] = "KnockBackResistance"
		list[4] = "击退抵抗"
		list[5] = "[color=#FF0000]击退抵抗+ "..math.floor(list[2]*100).."%[/color]"
		list[6]  = 0.05+(0.03*rate+beauty*0.02+quality*0.01)/list[1]
		
	elseif olditem.def.Name == "Item_qianghua_suipian7" then
		list[1] = fabao.Fabao:GetProperty("KnockBackAddition") --击退强度
		list[2] = (rate*0.004+beauty*0.001)*quality	--加成强度
		list[3] = "KnockBackAddition"
		list[4] = "击退强度"
		list[5] = "[color=#FF0000]击退强度+ "..math.floor(list[2]*100).."%[/color]"
		list[6]  = 0.05+(0.03*rate+beauty*0.02+quality*0.01)/list[1]
		
	elseif olditem.def.Name == "Item_qianghua_suipian8" then
		list[1] = fabao.Fabao:GetProperty("TailLenght") --拖尾长度
		list[2] = (rate*0.02+beauty*0.005)*quality	--加成强度
		list[3] = "TailLenght"
		list[4] = "拖尾长度"
		list[5] = "[color=#FF0000]拖尾长度+  "..(math.floor(list[2]*100)/100).."米[/color]"
		list[6]  = 0.05+(0.3*rate+beauty*0.1+quality*0.03)/list[1]
		
	elseif olditem.def.Name == "Item_qianghua_suipian9" then
		list[1] = fabao.Fabao:GetProperty("Scale") --体积
		list[2] = (rate*0.003+beauty*0.0008)*quality	--加成强度
		list[3]= "Scale"
		list[4] = "法宝体积"
		list[5] = "[color=#FF0000]法宝体积+ "..math.floor(list[2]*100).."%[/color]"
		list[6] = 0.05+(0.04*rate+beauty*0.02+quality*0.01)/list[1]
		
	elseif olditem.def.Name == "Item_qianghua_suipian10" then
		list[1] = fabao.Fabao:GetProperty("AttackRate") --攻击间隔
		list[2] = -0.1	--加成强度
		list[3] = "AttackRate"
		list[4] = "法宝攻速"
		list[5] = "[color=#FF0000]法宝攻速- 0.1[/color]"
		list[6] = list[1]/2+0.05
	end
	return list
	
end

function tbFBQH:JiLvWenZi(num)

	local desc
	if num >= 0.1 then
		desc = {"一成","二成","三成","四成","五成","六成","七成","八成","九成","十成"}
		desc = "[color=#3A5FCD]"..desc[math.min(math.floor(num*10),10)].."[/color]"
	else
		desc = "[color=#3A5FCD]低于一成[/color]"
	end
	return desc
end




















