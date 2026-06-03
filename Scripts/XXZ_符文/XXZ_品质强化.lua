local tbFBQH = GameMain:GetMod("_LogicMode"):CreateMode("LUA_FuWen_pinzhi")

function tbFBQH:OnModeEnter(p)
	self.item = p[1]

	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:ShowLine(self.item)
	self:SetHeadMsg("请选择一件有品质属性的物品")
end

function tbFBQH:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	local pinzhi = item:GetQuality()
	if pinzhi < 0 then 
		self:SetHeadMsg(item:GetName().."没有品质属性，无法提升")
		return false
	end
	if item.Count > 1 then 
		self:SetHeadMsg(item:GetName().."的数量超过1个，无法提升")
		return false
	end
	
	return true
end

function tbFBQH:OnModeLeave()
end

function tbFBQH:Apply(key)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	local selfkey = self.item.Key
	local pinzhi = tbFBQH:WuPinJianCe(self.item,item)
	
	if pinzhi[2] ~= nil then
		pinzhi[4] = tbFBQH:JiLvWenZi(pinzhi[2])
		pinzhi[5] = ((pinzhi[1]-item:GetQuality())*100).."点"
	else
		pinzhi[4] = "未知"
		pinzhi[5] = ((pinzhi[1]-item:GetQuality())*100).."点"
	end
	if pinzhi[3] == nil then
		pinzhi[6] = "无变化"
	else
		if pinzhi[3]-item:GetQuality() >= 0 then
			pinzhi[6] = "增加"..(math.abs(pinzhi[3]-item:GetQuality())*100).."点"
		else
			pinzhi[6] = "降低"..(math.abs(pinzhi[3]-item:GetQuality())*100).."点"
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
		
			world:FlyLineEffect(selfkey,item.Key,1,
			function(p)
				if WorldLua:CheckRate(pinzhi[2]) then
					item:SetQuality(pinzhi[1])
					world:ShowMsgBox("[color=#3A5FCD]品质提升成功\n"..item:GetName().."的品质提升了"..pinzhi[5] ,"升品成功")
				else
					if pinzhi[3] ~= nil then
						item:SetQuality(pinzhi[3])
					end
					world:ShowMsgBox("[color=#3A5FCD]品质提升失败\n"..item:GetName().."的品质"..pinzhi[6], "升品失败")
				end
			end)
			return false
		end
	end, true, "品质提升", 0, 0, "[color=#3A5FCD]升品物品："..item:GetName().."\n升品几率："..pinzhi[4].."\n升品加成："..pinzhi[5].."\n失败加成："..pinzhi[6])
	
end

function tbFBQH:WuPinJianCe(self,item)
	local name = self.def.Name
	local pinzhi = item:GetQuality()
	local list = {}
	
	if name == "Item_fumo_fuwen_pinzhi1" then
		if pinzhi >= 1 then  
			list[1] = item:GetQuality()+0.01
			list[2] = 0.5/pinzhi
			list[3] = item:GetQuality()-0.02
		elseif pinzhi >= 0.5 then 
			list[1] = item:GetQuality()+0.05
			list[2] = 0.3/pinzhi
		else 
			list[1] = math.min(item:GetQuality()+0.05,0.5)
			list[2] = 1
		end
	elseif name == "Item_fumo_fuwen_pinzhi2" then
		if pinzhi >= 1 then  
			list[1] = item:GetQuality()+0.03
			list[2] = 0.65/pinzhi
			list[3] = item:GetQuality()-0.05
		elseif pinzhi >= 0.8 then 
			list[1] = item:GetQuality()+0.05
			list[2] = 0.45/pinzhi
		else 
			list[1] = math.min(item:GetQuality()+0.05,0.8)
			list[2] = 1
		end
	elseif name == "Item_fumo_fuwen_pinzhi3" then
		if pinzhi >= 1 then  
			list[1] = item:GetQuality()+0.03
			list[2] = 0.8/pinzhi
			list[3] = item:GetQuality()-0.03
		else 
			list[1] = math.min(item:GetQuality()+0.05,1)
			list[2] = 1
		end
	elseif name == "Item_fumo_fuwen_pinzhi4" then
		if pinzhi >= 1 then  
			list[1] = item:GetQuality()+WorldLua:RandomInt(1,6)/100
			list[2] = 0.8/pinzhi
		else 
			list[1] = math.min(item:GetQuality()+0.05,1)
			list[2] = 1
		end
	elseif name == "Item_fumo_fuwen_pinzhi5" then
		if pinzhi >= 1 then  
			list[1] = item:GetQuality()+WorldLua:RandomInt(2,7)/100
			list[2] = 0.8/pinzhi
			list[3] = item:GetQuality()+0.01
		else 
			list[1] = math.min(item:GetQuality()+0.05,1)
			list[2] = 1
		end
	end
	return list
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



































