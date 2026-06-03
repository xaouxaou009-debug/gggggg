
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Modifier_Lua_zhuanshu_buff_4");
local selflist ={}


function tbModifier:Enter(modifier, npc)
	npc.LuaHelper:AddTitle("不败战神","",4)
	npc:AddNpcModPath("Mod/Npc/LvBu/LvBu.FBX")
	if npc.view ~= nil then
		npc.view.needUpdateMod = true
	end
	if not npc.IsDisciple then
		return false
	end
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			local list = {"Item_zhuanshu_fabao_lvbu","Item_zhuanshu_wuqi_lvbu","Item_zhuanshu_shangyi_lvbu","Item_zhuanshu_xiayi_lvbu","方天画戟•[color=#D02090]秘宝[/color]"}
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
			local NQ = npc:GetProperty("NpcFight_ShieldConversionRateAddP")+0.2--获取护盾加成
			local NW = npc:GetProperty("NpcFight_FabaoPowerAddP")+0.2		--获取法宝伤害
			local NE = npc:GetProperty("NpcFight_SpellPowerAddP")+0.2		--获取法术伤害
			local Jing = npc.PropertyMgr.Practice.LogicStage/200+0.1			--获取境界
			npc:AddModifier("Modifier_zhuanshu_buff_4_1",NQ*Jing)
			npc:AddModifier("Modifier_zhuanshu_buff_4_2",NW*Jing)
			npc:AddModifier("Modifier_zhuanshu_buff_4_3",NE*Jing*2.5)
			modifier.Desc = modifier.def.Desc.."\n[color=#306BC7]灵力护盾提升"..math.floor(NQ*Jing*100).."％\n法宝强度提升"..math.floor(NW*Jing*100).."％\n法术强度降低"..math.floor(NE*Jing*100*2.5).."％[/color]"
		else
			modifier.Desc = modifier.def.Desc.."\n[color=#306BC7]外门弟子无法激活特效"
		end

		selflist[npc.ID] = 0
	end
end



--层数更新

function tbModifier:UpdateStack(modifier, npc, add)
end



--离开modifier

function tbModifier:Leave(modifier, npc)
	GameMain:GetMod("_FabaoHelper"):ZhuangBeiYiChu(npc,"Mod/Npc/LvBu/LvBu.FBX")
	npc:RemoveTitleByName("不败战神")
end




--获取存档数据

function tbModifier:OnGetSaveData()
end



--载入存档数据

function tbModifier:OnLoadData(modifier, npc, tbData)
end




























