
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Modifier_Lua_zhuanshu_buff_3");
local selflist = {}


function tbModifier:Enter(modifier, npc)
	npc.LuaHelper:AddTitle("齐天大圣","",4)
	npc:AddNpcModPath("Mod/Npc/SunWuKong/SunWuKong.FBX")
	if npc.view ~= nil then
		npc.view.needUpdateMod = true
	end
	if not npc.IsDisciple then
		return false
	end
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			local list = {"Item_zhuanshu_fabao_sunwukong","Item_zhuanshu_wuqi_sunwukong","Item_zhuanshu_shangyi_sunwukong","Item_zhuanshu_xiayi_sunwukong","如意金箍棒•[color=#D02090]秘宝[/color]"}
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
			local NQ = npc:GetProperty("NpcLingMaxValue")+100
			local NW = npc:GetProperty("NpcFight_ShieldConversionRateAddP")+0.2
			local NE = npc:GetProperty("NpcFight_FabaoPowerAddP")+0.2
			local NR = npc:GetProperty("NpcFight_SpellPowerAddP")+0.2
			local Jing = npc.PropertyMgr.Practice.LogicStage/150+0.1
			npc:AddModifier("Modifier_zhuanshu_buff_3_1",npc.PropertyMgr.Practice.LogicStage)
			npc:AddModifier("Modifier_zhuanshu_buff_3_2",NW*Jing)
			npc:AddModifier("Modifier_zhuanshu_buff_3_3",NE*Jing*2)
			npc:AddModifier("Modifier_zhuanshu_buff_3_4",NR*Jing*2)
			modifier.Desc = modifier.def.Desc.."\n[color=#306BC7]五行抗性提升"..math.floor(NQ*npc.PropertyMgr.Practice.LogicStage/100).."％\n灵力护盾提升"..math.floor(NW*Jing*100).."％\n法宝强度降低"..math.floor(NE*Jing*100*2).."％\n法术强度降低"..math.floor(NR*Jing*100*2).."％[/color]"
		else
			modifier.Desc = modifier.def.Desc.."\n[color=#306BC7]外门弟子无法激活特效"
		end

		selflist[npc.ID] = 50
	end
end



--层数更新

function tbModifier:UpdateStack(modifier, npc, add)
end



--离开modifier

function tbModifier:Leave(modifier, npc)
	GameMain:GetMod("_FabaoHelper"):ZhuangBeiYiChu(npc,"Mod/Npc/SunWuKong/SunWuKong.FBX")
	npc:RemoveTitleByName("齐天大圣")
end




--获取存档数据

function tbModifier:OnGetSaveData()
end



--载入存档数据

function tbModifier:OnLoadData(modifier, npc, tbData)
end




























