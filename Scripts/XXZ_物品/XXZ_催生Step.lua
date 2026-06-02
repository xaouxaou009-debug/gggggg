local tbThing = GameMain:GetMod("ThingHelper"):GetThing("Lua_zhiwu_jingping1");
local selflist = selflist or {}
function tbThing:OnInit()
end



function tbThing:OnGetSaveData()
end



function tbThing:OnLoadData(tbData)
end

function tbThing:OnStep(dt)


	if selflist[self.it.ID.."jishi"] == nil then
		selflist[self.it.ID.."jishi"] = 0
		selflist[self.it.ID.."jishu"] = 0
	end
	
	local plantcount = 0			--周围植物数量
	local worldnum = world.DayCount/(world.DayCount+1000)		--天数加成
	
	if self.it.InWhoseBag ~= 0 then
		
		selflist[self.it.ID.."jishi"] = selflist[self.it.ID.."jishi"]-dt
		if selflist[self.it.ID.."jishi"] <= 0 then
			selflist[self.it.ID.."jishi"] = 5
			selflist[self.it.ID.."jishu"] = selflist[self.it.ID.."jishu"]+1
			
			if selflist[self.it.ID.."jishu"] == 12 then
				self.it:AddLing(1)
				selflist[self.it.ID.."jishu"] = 0
			end
			
			world:PlayEffect(10004, self.it.ViewPos, 0.5);
			local Aroundkey = GameUlt.GetNearGrid(self.it.Key, 2)
			for k,v in pairs(Aroundkey) do
				local oldplant = Map.Things:GetThingAtGrid(v, 3);
				if oldplant ~= nil then
					plantcount = plantcount + 1
				end
			end
		end
	
		local itembag = ThingMgr:FindThingByID(self.it.InWhoseBag)
		local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(itembag,"甘霖之术")
		if btn == false then
			if self.it.LingV >= 100 then
				itembag:AddBtnData("甘霖之术","Icon/5.png","GameMain:GetMod('ThingHelper'):GetThing('Lua_zhiwu_jingping1'):GanLinShu(bind)","选择一片区域释放甘霖之术，给区域内植物加持生长效率，区域内植物越多，加成效率越低。");
			end
		else
			if self.it.LingV < 100 then
				itembag:RemoveBtnData("甘霖之术")
			end
		end
			
			
			
	end
	
	
	
	
	
	
		if plantcount == 0 then
			return false
		end
	
		local Aroundkey = GameUlt.GetNearGrid(self.it.Key, 2)
		for k,v in pairs(Aroundkey) do
			local oldplant = Map.Things:GetThingAtGrid(v, 3);
			if oldplant ~= nil then
				local oldplantmapling = World.map:GetLing(oldplant.Key)/1000	--周围灵力加成
				local oldplantmapbeauty = Map:GetBeauty(oldplant.Key)/10	--周围美观加成
				local oldplantmapfertility = World.map:GetFertility(oldplant.Key)
				local selfling = self.it.LingV/500	--效率加成
				local plantnum = (oldplantmapling+oldplantmapbeauty+oldplantmapfertility+worldnum+selfling)/plantcount+0.1	--效率加成
				local growday = oldplant.GrowAddKeep
				if growday < 5 and oldplant.def.Plant.Kind ~= g_emPlantKind.HighPlant then
					oldplant:SetGrowEffectAddP(plantnum, 50, true)
				end
				
				if oldplant.def.Plant.Kind == g_emPlantKind.HighPlant then
					if oldplant.LuaHelper:GetLingSha() < 10 and oldplant.LingV >= oldplant.Rate*1000 and self.it.LingV > oldplant.Rate*0.1 then
						oldplant:AddLingSha(0.01*oldplant.Rate)
						self.it:AddLing(-oldplant.Rate*0.1)
						oldplant:AddLing(-oldplant.Rate*1000)
					end
				end
				if oldplant.IsRiped and oldplant.def.Plant.Kind ~= g_emPlantKind.HighPlant then
					oldplant:DoHarvest(Npc)
				end
			end
		end
end


function tbThing:GanLinShu(itembag)
	itembag:RemoveBtnData("甘霖之术")
	if itembag.Bag.m_lisItems.Count == 0 then
		world:ShowMsgBox(itembag:GetName().."上宝物以不在,无法施展灵术","施法失败")
		return false
	end
	
	local item = itembag.Bag.m_lisItems[0]
	if item.def.Name ~= "Item_zhiwu_jingping_1" then
		world:ShowMsgBox(itembag:GetName().."上不是施展神术的灵物，无法施展灵术","施法失败")
		return false
	end

	if item.LingV < 100 then
		world:ShowMsgBox(item:GetName().."灵气不足，无法施展灵术", "施法失败")
		return false
	end
	world:CastMagic(bind,'Magic_zawu_ganlin1','Icon/5.png')
	item:AddLing(-100)
	
end
















