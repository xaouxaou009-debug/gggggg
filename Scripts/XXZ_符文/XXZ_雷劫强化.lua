local tbFBQH = GameMain:GetMod("_LogicMode"):CreateMode("LUA_FuWen_leijie")

function tbFBQH:OnModeEnter(p)
	self.item = p[1]

	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:ShowLine(self.item)
	self:SetHeadMsg("请选择一件法宝类的物品")
end

function tbFBQH:CheckThing(k)
	local map = self:GetMap()
	local fabao = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	if fabao.Count > 1 then 
		self:SetHeadMsg(fabao:GetName().."的数量超过1个，无法提升")
		return false
	end
	if fabao.def.Item.Lable == g_emItemLable.FightFabao then
		self:SetHeadMsg(fabao:GetName().."是法宝，可以淬炼，成功后增加雷劫数")
		return true
	else
		self:SetHeadMsg(fabao:GetName().."不是法宝，无法淬炼，请选择其他法宝类物品")
		return false
	end
end

function tbFBQH:OnModeLeave()
end

function tbFBQH:Apply(key)
	local map = self:GetMap()
	local fabao = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	local rate = fabao.Rate; --目标品阶
	local quality = fabao:GetQualityEquipValue()--目标品质强度
	local selfkey = self.item.Key
	local leijie = tbFBQH:WuPinJianCe(self.item,fabao)
	local godcount = fabao.Fabao.GodCount
	
	if godcount < leijie[1] then
		leijie[1] = 1
		leijie[3] = tbFBQH:JiLvWenZi(leijie[1])
		leijie[4] = "0％"
		leijie[5] = "无变化"
		leijie[7] = "0％"
	else
		if godcount > leijie[1]*2 then
			leijie[5] = "雷劫数-1"
			leijie[6] = math.min(0.33,godcount/(rate*5*quality))
			leijie[7] = math.floor(leijie[6]*101).."％"
		else
			leijie[5] = "无变化"
			leijie[7] = "0％"
		end
		
		leijie[1] = ((leijie[1]/godcount/2)*(0.3+rate/24+quality))*(1+(world:GetFlag(fabao,6202)/100))
		leijie[3] = tbFBQH:JiLvWenZi(leijie[1])
		
		
		if world:GetFlag(fabao,6202) > 0 then
			leijie[4] = world:GetFlag(fabao,6202).."％"
		else
			leijie[4] = "无失败加成"
		end
	end
	

	
	
	
	
	
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			local selfkey = self.item.Key
			if self.item.Count > 1 then
				self.item:ChangeCount(self.item.Count - 1)
			else
				ThingMgr:RemoveThing(self.item)
			end
		
			world:FlyLineEffect(selfkey,fabao.Key,0.5,
			function(p)
			
			
				if WorldLua:CheckRate(leijie[1]) then
					fabao.Fabao:AddGodCount(1)
					world:SetFlag(fabao,6202,0)
					world:ShowMsgBox("[color=#3A5FCD]雷劫淬炼成功\n"..fabao:GetName().."的历劫数增加了一次","淬炼成功")
					return false
				else
					world:SetFlag(fabao,6202,world:GetFlag(fabao,6202)+leijie[2])
					
					leijie[4] = world:GetFlag(fabao,6202).."％"
					
					if leijie[6] ~= nil then	
						if WorldLua:CheckRate(leijie[6]) then
							fabao.Fabao:AddGodCount(-1)
							leijie[5] = "雷劫数-1"
						else
							leijie[5] = "无变化"
						end
					end
				
					world:ShowMsgBox("[color=#3A5FCD]雷劫淬炼失败\n"..fabao:GetName().."的历劫数"..leijie[5].."\n下次淬炼成功基数增加"..leijie[4],"淬炼失败")
					
					return false
				end
			end)
			return false
		end
	end, true, "雷劫淬炼", 0, 0, "[color=#3A5FCD]当前淬炼法宝："..fabao:GetName().."\n成功几率基数："..leijie[3].."\n成功基数加成："..leijie[4].."\n失败法宝损坏："..leijie[5].."\n法宝损坏几率："..leijie[7])
	
end


function tbFBQH:WuPinJianCe(self,fabao)

	local leijie = {}
	local rate = fabao.Rate

	if self.def.Name == "Item_fumo_fuwen_leijie1" then
		leijie[1] = rate/3
		leijie[2] = 10
	elseif self.def.Name == "Item_fumo_fuwen_leijie2" then
		leijie[1] = rate/2
		leijie[2] = 15
	elseif self.def.Name == "Item_fumo_fuwen_leijie3" then
		leijie[1] = rate
		leijie[2] = 25
	elseif self.def.Name == "Item_fumo_fuwen_leijie4" then
		leijie[1] = rate*1.2
		leijie[2] = 40
	elseif self.def.Name == "Item_fumo_fuwen_leijie5" then
		leijie[1] = rate*1.5
		leijie[2] = 80
	end

	return leijie
end










function tbFBQH:JiLvWenZi(num)
	local desc
	if num >= 1 then 
		desc = "[color=#3A5FCD]十成[/color]"
	elseif num > 0.9 then 
		desc = "[color=#3A5FCD]九成[/color]"
	elseif num > 0.8 then 
		desc = "[color=#3A5FCD]八成[/color]"
	elseif num > 0.7 then 
		desc = "[color=#3A5FCD]七成[/color]"
	elseif num > 0.6 then 
		desc = "[color=#3A5FCD]六成[/color]"
	elseif num > 0.5 then 
		desc = "[color=#3A5FCD]五成[/color]"
	elseif num > 0.4 then 
		desc = "[color=#3A5FCD]四成[/color]"
	elseif num > 0.3 then 
		desc = "[color=#3A5FCD]三成[/color]"
	elseif num > 0.2 then 
		desc = "[color=#3A5FCD]二成[/color]"
	elseif num > 0.1 then 
		desc = "[color=#3A5FCD]一成[/color]"
	else
		desc = "[color=#3A5FCD]低于一成[/color]"
	end
	return desc
end



































