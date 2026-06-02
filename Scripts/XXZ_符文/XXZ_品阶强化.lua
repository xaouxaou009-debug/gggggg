local tbFBQH = GameMain:GetMod("_LogicMode"):CreateMode("LUA_FuWen_pinjie")

function tbFBQH:OnModeEnter(p)
	self.item = p[1]

	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:ShowLine(self.item)
	self:SetHeadMsg("请选择一件低于十二阶的物品")
end

function tbFBQH:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	local pinjie = item.Rate
	if pinjie >= 12 then 
		self:SetHeadMsg(item:GetName().."的品阶已达到上限，无法继续提升")
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
	local pinjie = {}
	
	pinjie[2] = "提升一阶"
	pinjie[3] = "无变化"
	
	if item.def.Item.Elixir == nil and item.def.Item.Food == nil then
		pinjie[1] = 0.2 + 1/item.Rate
		if item.Rate >= 9 then
			pinjie[3] = "几率降低一阶"
		end
	else
		pinjie[1] = 0.15 + 1/item.Rate
	end
	pinjie[5] = tbFBQH:JiLvWenZi(pinjie[1])
	
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
				if WorldLua:CheckRate(pinjie[1]) then
					world:ShowMsgBox("[color=#3A5FCD]品阶提升成功\n"..item:GetName().."的品阶提升了一阶","升品成功")
					if item.def.Item.Elixir == nil and item.def.Item.Food == nil then
						item.Rate = item.Rate + 1
						return false
					end
					item:SoulCrystalYouPowerUp(0,1,1);
				else
					if item.def.Item.Elixir == nil and item.def.Item.Food == nil and item.Rate >= 9 then
						if WorldLua:CheckRate(item.Rate/20) then
							item.Rate = item.Rate - 1
							pinjie[7] = "降低一阶"
						end
					end
					if pinjie[7] == nil then
						pinjie[7] = "无变化"
					end
					world:ShowMsgBox("[color=#3A5FCD]品阶提升失败\n"..item:GetName().."的品阶"..pinjie[7], "升品失败")
				end
			end)
			return false
		end
	end, true, "品阶提升", 0, 0, "[color=#3A5FCD]升阶物品："..item:GetName().."\n升阶几率："..pinjie[5].."\n升阶加成："..pinjie[2].."\n失败加成："..pinjie[3])
	
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



































