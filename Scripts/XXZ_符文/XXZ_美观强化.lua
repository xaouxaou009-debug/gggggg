local tbFBQH = GameMain:GetMod("_LogicMode"):CreateMode("LUA_FuWen_meiguan")

function tbFBQH:OnModeEnter(p)
	self.item = p[1]

	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:ShowLine(self.item)
	self:SetHeadMsg("请选择一件可提升美观的物品")
end

function tbFBQH:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
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
	local meiguan = {}
	
	meiguan[1] = 0.15 + 1/item.Beauty + item.Rate/30
	meiguan[2] = tbFBQH:JiLvWenZi(meiguan[1])
	meiguan[3] = "提升一点"
	meiguan[4] = "无变化"
	
	if item.Beauty >= item.Rate*3+10 then
		meiguan[4] = "降低一点"
		meiguan[5] = "美观降低了一点"
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
				if WorldLua:CheckRate(meiguan[1]) then
					item:ChangeBeauty(item.Beauty+1)
					world:ShowMsgBox("[color=#3A5FCD]美观提升成功\n"..item:GetName().."的美观提升了一点", "美观提升")
				else
					if meiguan[5] ~= nil then
						item:ChangeBeauty(item.Beauty-1)
					else
						meiguan[5] = "无变化"
					end
					world:ShowMsgBox("[color=#3A5FCD]美观提升失败\n"..item:GetName().."的美观"..meiguan[5], "升品失败")
				end
			end)
			return false
		end
	end, true, "美观提升", 0, 0, "[color=#3A5FCD]美化物品："..item:GetName().."\n美化几率："..meiguan[2].."\n美化加成："..meiguan[3].."\n失败加成："..meiguan[4].."\n物品品阶越高，提升几率越高")
	
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



































