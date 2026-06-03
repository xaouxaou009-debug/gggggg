
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Modifier_Lua_zhuanshu_buff_10");
local selflist = {}


function tbModifier:Enter(modifier, npc)
	npc.LuaHelper:AddTitle("箭射九日","",4)
	npc:AddNpcModPath("Mod/Npc/HouYi/HouYi.FBX")
	if npc.view ~= nil then
		npc.view.needUpdateMod = true
	end
	if not npc.IsDisciple then
		return false
	end
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			local list = {"Item_zhuanshu_fabao_houyi","Item_zhuanshu_wuqi_houyi","Item_zhuanshu_shangyi_houyi","Item_zhuanshu_xiayi_houyi","破日箭•[color=#D02090]秘宝[/color]"}
			GameMain:GetMod("_FabaoHelper"):ZhuangBeiShengCheng(npc,list)
			return false
		end
	end, true, "专属套装", 0, 0,"[color=#FF0000]专属模型已激活，是否更换专属套装，确定后将获得专属四件套\n法宝、武器、上衣、下衣  共四件[/color]")
	
end


--modifier step
function tbModifier:Step(modifier, npc, dt)

	if selflist[npc.ID] == nil then
		selflist[npc.ID] = 0
	end

	selflist[npc.ID] = selflist[npc.ID] - dt
	
	if selflist[npc.ID] <= 0 then
		if npc.IsDisciple then
			local NQ = npc:GetProperty("NpcFight_FabaoPowerAddP")+0.2		--获取法宝伤害
			local NW = npc:GetProperty("NpcFight_SpellPowerAddP")+0.2		--获取法术伤害
			local NE = npc:GetProperty("NpcFight_ShieldConversionRateAddP")+0.2--获取护盾加成
							
			local NR = npc.map:GetTemperature(npc.Key)/100
			local Jing = npc.PropertyMgr.Practice.LogicStage/200+0.02			--获取境界
							
			local xinjing = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState)/5
							
			npc:AddModifier("Modifier_zhuanshu_buff_10_1",NQ*(NR+Jing))
			npc:AddModifier("Modifier_zhuanshu_buff_10_2",NW*(NR+Jing))
							
			npc:AddModifier("Modifier_zhuanshu_buff_10_3",NE*(NR+Jing)*1.5)
			npc:AddModifier("Modifier_zhuanshu_buff_10_4",xinjing*NR*5)
							
			modifier.Desc = modifier.def.Desc.."\n[color=#306BC7]法宝伤害加成："..math.floor(NQ*(NR+Jing)*100).."％\n法术伤害加成："..math.floor(NW*(NR+Jing)*100).."％\n灵力护盾加成："..math.floor(NE*(NR+Jing)*1.5*100*-1).."％\n心境上限加成："..(math.floor(xinjing*NR*100*5)/100*-1).."[/color]"
		else
			modifier.Desc = modifier.def.Desc.."\n[color=#306BC7]外门弟子无法激活特效"
		end

		selflist[npc.ID] = 5
	end
end



--层数更新

function tbModifier:UpdateStack(modifier, npc, add)
end



--离开modifier

function tbModifier:Leave(modifier, npc)
	GameMain:GetMod("_FabaoHelper"):ZhuangBeiYiChu(npc,"Mod/Npc/HouYi/HouYi.FBX")
	npc:RemoveTitleByName("箭射九日")
end




--获取存档数据

function tbModifier:OnGetSaveData()
end



--载入存档数据

function tbModifier:OnLoadData(modifier, npc, tbData)
end




























