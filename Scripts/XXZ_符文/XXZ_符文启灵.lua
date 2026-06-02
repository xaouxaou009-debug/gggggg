local tbZBFW = GameMain:GetMod("_LogicMode"):CreateMode("LUA_ZhungBei_FuMo_QiLing")

function tbZBFW:OnModeEnter(p)
	self.item = p[1]
	self.num = p[2]
	
	self:ShowLine(self.item)
	self:SetKeyCondition("Item")
	self:OpenThingCheck()
	self:SetHeadMsg("请选择一件有符文的装备")
end

function tbZBFW:CheckThing(k)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item)
	local itemlable = item.def.Item.Kind
	
	if itemlable ~= CS.XiaWorld.g_emItemKind.Equipment then
		self:SetCheckMsg(item:GetName().."不是装备类物品，无法启灵")
		return false
	end
	
	if world:GetFlag(item,6201) < self.num then
		self:SetCheckMsg(item:GetName().."无法跳跃启灵，请先开启前一个符文位")
		return false
	elseif world:GetFlag(item,6201) > self.num then
		self:SetCheckMsg(item:GetName().."已经开启了这个符文")
		return false
	elseif world:GetFlag(item,6201) == self.num then
		self:SetCheckMsg(item:GetName().."可以启灵，启灵后开启一个符文位")
		return true
	end
	return false
end

function tbZBFW:OnModeLeave()
end

function tbZBFW:Apply(key)
	local map = self:GetMap()
	local item = map.Things:GetThingAtGrid(key, g_emThingType.Item)
	local count = self.item.Count
	local bigenkey = self.item.Key
	
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			if self.item.Count > 1 then
				self.item:ChangeCount(self.item.Count - 1)
			else
				ThingMgr:RemoveThing(self.item);
			end
		
			world:FlyLineEffect(bigenkey,key,1,
			function(p)
				if WorldLua:CheckRate(1/(world:GetFlag(item,6201)+1)) then
					world:SetFlag(item,6201,self.num+1)
					local shuoming = "。"
					if world:GetFlag(item,6201) == 1 then
						shuoming = "\n当前拥有符文位2，上限5"
						item.Author= "[color=#4876FF]启灵一阶[/color]"
					elseif world:GetFlag(item,6201) == 2 then
						shuoming = "\n当前拥有符文位3，上限5"
						item.Author= "[color=#4876FF]启灵二阶[/color]"
					elseif world:GetFlag(item,6201) == 3 then
						shuoming = "\n当前拥有符文位4，上限5"
						item.Author= "[color=#4876FF]启灵三阶[/color]"
					elseif world:GetFlag(item,6201) == 4 then
						shuoming = "\n当前拥有符文位5，已达到上限"
						item.Author= "[color=#4876FF]启灵四阶[/color]"
					elseif world:GetFlag(item,6201) == 5 then
						shuoming = "\n当前拥有符文位6，已经超越了上限"
						item.Author= "[color=#4876FF]极限启灵[/color]"
					end
					world:ShowMsgBox("[color=#4876FF]启灵成功，"..item:GetName().."开启了新的符文位，你可以继续赋予新的符文了\n"..shuoming, "启灵成功")
				else
					local shuoming = "。"
					if world:GetFlag(item,6201) == 0 then
						shuoming = "\n当前拥有符文位1，上限5"
						item.Author= "[color=#4876FF]未启灵[/color]"
					elseif world:GetFlag(item,6201) == 1 then
						shuoming = "\n当前拥有符文位2，上限5"
						item.Author= "[color=#4876FF]启灵一阶[/color]"
					elseif world:GetFlag(item,6201) == 2 then
						shuoming = "\n当前拥有符文位3，上限5"
						item.Author= "[color=#4876FF]启灵二阶[/color]"
					elseif world:GetFlag(item,6201) == 3 then
						shuoming = "\n当前拥有符文位4，上限5"
						item.Author= "[color=#4876FF]启灵三阶[/color]"
					elseif world:GetFlag(item,6201) == 4 then
						shuoming = "\n当前拥有符文位5，已达到上限"
						item.Author= "[color=#4876FF]启灵四阶[/color]"
					elseif world:GetFlag(item,6201) == 5 then
						shuoming = "\n当前拥有符文位6，已经超越了上限"
						item.Author= "[color=#4876FF]极限启灵[/color]"
					end
					world:ShowMsgBox("[color=#4876FF]启灵失败，"..item:GetName().."没有开启新的符文位\n"..shuoming, "启灵失败")
				end
			end)
			
			
			return false
		end
	end, true, "符文启灵", 0, 0,"[color=#4876FF]物品消耗："..self.item:GetName().."\n当前装备："..item:GetName().."\n\n是否确定对当前装备进行启灵，启灵后将开启一个新的符文位，启灵有几率失败，启灵越高，失败几率越高[/color]")
	return false
end











