local tbThing = GameMain:GetMod("ThingHelper"):GetThing("Building_jilian_cailiao");
local selflist = selflist or {}
local it
local bd


function tbThing:OnInit()
end



function tbThing:OnGetSaveData()
	return selflist
end



function tbThing:OnLoadData(tbData)
	selflist = tbData or {}
end



 
function tbThing:OnStep(dt)
	it = self.it
	
	if it.def.Name == "Building_cailiao" then
		bd = it
	end
	if selflist[it.ID.."jishi"] == nil then
		selflist[it.ID.."jishi"] = 0
		selflist[it.ID.."jishu"] = 0
		selflist[it.ID.."jilian"] = false
		selflist[it.ID.."chanchu"] = nil
		selflist[it.ID.."fujia"] = nil
		selflist[it.ID.."zidong"] = false
	end
	
	tbThing:JianZhuJianCe(it)
		
	if selflist[it.ID.."jilian"] == true and selflist[it.ID.."chanchu"] ~= nil and it.def.Name == "Building_cailiao2" then
		local chanchu = ThingMgr:FindThingByID(selflist[it.ID.."chanchu"])
		if chanchu == nil then
			selflist[it.ID.."chanchu"] = ThingMgr:AddItemThing(0,selflist[it.ID.."chanchu"],nil).ID
			chanchu = ThingMgr:FindThingByID(selflist[it.ID.."chanchu"])
			chanchu.Author = it:GetName()
		end
		
		if selflist[it.ID.."fujia"] ~= nil then
			if WorldLua:CheckRate(0.05)  then
				local jiaoliao = ThingMgr:AddItemThing(0,selflist[it.ID.."fujia"],nil)
				Map:DropItem(jiaoliao, it.Key, true, true, false, true, 0, false)
			end
		end
		selflist[it.ID.."jishi"] = selflist[it.ID.."jishi"] - dt
		if selflist[it.ID.."jishi"] <= 0 then
			selflist[it.ID.."jishi"] = 10
			world:PlayEffect(37, it.Key, 0.5)
			
			selflist[it.ID.."jishu"] = selflist[it.ID.."jishu"]+it.Rate
			
			if selflist[it.ID.."jishu"] >= 100 then
				selflist[it.ID.."jishi"] = 0
				selflist[it.ID.."jishu"] = 0
				selflist[it.ID.."chanchu"] = nil
				selflist[it.ID.."fujia"] = nil
				selflist[it.ID.."jilian"] = false
				Map:DropItem(chanchu, it.Key, true, true, false, true, 0, false)
				tbThing:Desc(it)
				tbThing:RateUp(bd)
			end
			
		end
	end

end



function tbThing:JianZhuJianCe(building)
	if building.def.Name == "Building_cailiao" then
		local jianzhunum = world:GetBuildingCount("Building_cailiao2")
		local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(building,"建造子体")
		if jianzhunum < 3 and btn == false then
			it:AddBtnData("建造子体","Icon/18.png","GameMain:GetMod('ThingHelper'):GetThing('Building_jilian_cailiao'):JianSheZiTi(bind)","建造一个锻台子体，可以祭炼神材，品阶越高可建造越多");
		end
	end
	
	
	if building.def.Name == "Building_cailiao2" then
	
		tbThing:Desc(it)
		tbThing:Name(it)
		
		local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(building,"放入材料")
		if  btn == false and building:CheckCommandSingle("BagCarryItem", false) == nil and selflist[it.ID.."jilian"] == false then
			it:AddBtnData("放入材料","Icon/17.png","GameMain:GetMod('ThingHelper'):GetThing('Building_jilian_cailiao'):BanYunCaiLiao(bind)","将所选材料放入祭炼台内部，会在开启自动祭炼后自动祭炼建筑内部的材料");
		end
		
		local btn1 = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(building,"自动祭炼")
		local btn2 = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(building,"祭炼关闭")
		if btn1 == false and btn2 == false then
			it:AddBtnData("自动祭炼","Icon/16.png","GameMain:GetMod('ThingHelper'):GetThing('Building_jilian_cailiao'):ZiDongJiLian(bind)","开启后祭炼台将会在材料充足时自动祭炼材料");
		end
		
		if building.Bag.m_lisItems.Count > 0 and selflist[it.ID.."jilian"] == false and selflist[it.ID.."zidong"] == true then
		local items = it.Bag.m_lisItems
		local JiLianCaiLiaolist = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetJiLianCaiLiaolist()
			for i=0,items.Count-1 do
				local bagitem = items[i]
				for k,v in pairs(JiLianCaiLiaolist) do
					if bagitem.def.Name == v.CLName and bagitem.Count >= v.CLCount then
						selflist[it.ID.."jilian"] = true
						selflist[it.ID.."chanchu"] = v.WPName
						selflist[it.ID.."fujia"] = v.FJName
						if bagitem.Count > v.CLCount then
							bagitem:ChangeCount(bagitem.Count - v.CLCount)
						else
							ThingMgr:RemoveThing(bagitem)
						end
						tbThing:Desc(it)
						if v.CLCount ~= 3 then
							selflist[it.ID.."chanchu"] = v.WPName..WorldLua:RandomInt(1,8)
						end
						
						return false
					end
				end
			end
		end
	end
	
end

function tbThing:ZiDongJiLian(building)
	if selflist[building.ID.."zidong"] == false then
		building:RemoveBtnData("自动祭炼")
		selflist[building.ID.."zidong"] = true
		building:AddBtnData("祭炼关闭","Icon/16.png","GameMain:GetMod('ThingHelper'):GetThing('Building_jilian_cailiao'):ZiDongJiLian(bind)","关闭后将不会在材料充足时自动祭炼材料");
		return false
	end
	if selflist[building.ID.."zidong"] == true then
		building:RemoveBtnData("祭炼关闭")
		selflist[building.ID.."zidong"] = false
		building:AddBtnData("自动祭炼","Icon/16.png","GameMain:GetMod('ThingHelper'):GetThing('Building_jilian_cailiao'):ZiDongJiLian(bind)","开启后祭炼台将会在材料充足时自动祭炼材料");
	end
end

function tbThing:JianSheZiTi(building)
	building:RemoveBtnData("建造子体");
	world:EnterUILuaMode("LUA_JianZhu_jilian",building,"Building_cailiao2",4,false)
end

function tbThing:BanYunCaiLiao(building)
	building:RemoveBtnData("放入材料");
	world:EnterUILuaMode("LUA_jilian_cailiao",building)
end


function tbThing:Desc(it)
	if selflist[it.ID.."jilian"] == true and selflist[it.ID.."chanchu"] ~= nil then
		local chanchu = ThingMgr:FindThingByID(selflist[it.ID.."chanchu"])
		if chanchu ~= nil then
			it:SetDesc(it.def.Desc.."[color=#7CCD7C]\n正在祭炼神材中\n祭炼物品："..chanchu:GetName().."\n祭炼进度："..(selflist[it.ID.."jishu"]).."％[/color]")
			return false
		end
	end 
	
	if it.Bag.m_lisItems.Count > 0 and selflist[it.ID.."jilian"] == false then
		local Q = {}
		local items = it.Bag.m_lisItems
		local itdesc
		for i=0,items.Count-1 do
			if itdesc == nil then
				itdesc = "[color=#4F94CD]\n原料:"..items[i]:GetName().." 数量:"..items[i].Count.."[/color]"
			else
				itdesc = itdesc.."[color=#4F94CD]\n原料:"..items[i]:GetName().." 数量:"..items[i].Count.."[/color]"
			end
		end
		if itdesc ~= nil then
			it:SetDesc("[color=#436EEE]当前已储存材料列表[/color]"..itdesc)
		end
	else
		it:SetDesc(it.def.Desc)
	end
end

function tbThing:Name(it)
	local peifang = 0
	if it.def.Name == "Building_cailiao2" and it.Bag.m_lisItems.Count > 0 then
		if it.Bag.m_lisItems[0].def.Item.Lable == g_emItemLable.Metal then
			it:SetName(it.def.ThingName.."[color=#CD9B1D] ' 金属 ' [/color]")
			peifang = 3
		elseif it.Bag.m_lisItems[0].def.Item.Lable == g_emItemLable.Rock then
			it:SetName(it.def.ThingName.."[color=#8B6914] ' 石头 ' [/color]")
			peifang = 2
		elseif it.Bag.m_lisItems[0].def.Item.Lable == g_emItemLable.Wood then
			it:SetName(it.def.ThingName.."[color=#9AFF9A] ' 木材 ' [/color]")
			peifang = 1
		else
			it:SetName(it.def.ThingName)
			it:RemoveBtnData("祭炼配方");
		end
	end
	
	local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"祭炼配方")
	if  btn == false and peifang >= 1 then
		it:AddBtnData("祭炼配方","Icon/17.png","GameMain:GetMod('XXZ_xiuxianzhuanluatable'):GetCaiLiaoShuoMing("..peifang..")","将所选材料放入祭炼台内部，会在开启自动祭炼后自动祭炼建筑内部的材料");
	end
end




function tbThing:RateUp(bd)
	if selflist[bd.ID.."jishu"] == nil then
		selflist[bd.ID.."jishu"] = 1
	else
		selflist[bd.ID.."jishu"] = selflist[bd.ID.."jishu"] + 1
	end
	
	if bd.Rate < 12 then
		bd.Rate = math.min(12,math.floor(selflist[bd.ID.."jishu"]/100)+1)
	end
	
	bd:ChangeBeauty(math.floor(selflist[bd.ID.."jishu"]/50)+1)
end


































