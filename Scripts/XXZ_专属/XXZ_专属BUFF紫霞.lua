
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Modifier_Lua_zhuanshu_buff_9");
local selflist ={}


function tbModifier:Enter(modifier, npc)
	npc.LuaHelper:AddTitle("紫霞仙子","",4)
	npc:AddNpcModPath("Mod/Npc/ZiXia/ZiXia.FBX")
	if npc.view ~= nil then
		npc.view.needUpdateMod = true
	end
	if not npc.IsDisciple then
		return false
	end
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			local list = {"Item_zhuanshu_fabao_zixia","Item_zhuanshu_wuqi_zixia","Item_zhuanshu_shangyi_zixia","Item_zhuanshu_xiayi_zixia","紫青双剑•[color=#D02090]秘宝[/color]"}
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
			local shijian = World.DayHour
			local FaBao = npc:GetProperty("NpcFight_FabaoPowerAddP")+0.3		--获取法宝伤害
			local FaShu = npc:GetProperty("NpcFight_SpellPowerAddP")+0.3		--获取法术伤害
			local Jing = 0.5+2/npc.PropertyMgr.Practice.LogicStage
							
			if shijian >= 7 and shijian <= 19 then
				npc:AddModifier("Modifier_zhuanshu_buff_9_1",FaShu*Jing)
				npc:AddModifier("Modifier_zhuanshu_buff_9_2",-FaShu*0.95)
				modifier.Desc = modifier.def.Desc.."\n[color=#306BC7]白昼状态\n法宝伤害提升"..math.floor(FaShu*Jing*100).."％\n法术伤害降低"..math.floor(FaShu*0.95*100).."％\n境界越高额外加成越低[/color]"
			else
				npc:AddModifier("Modifier_zhuanshu_buff_9_1",-FaBao*0.95)
				npc:AddModifier("Modifier_zhuanshu_buff_9_2",FaBao*Jing)
				modifier.Desc = modifier.def.Desc.."\n[color=#306BC7]黑夜状态\n法术伤害提升"..math.floor(FaBao*Jing*100).."％\n法宝伤害降低"..math.floor(FaBao*0.95*100).."％\n境界越高额外加成越低[/color]"
			end
		else
			modifier.Desc = modifier.def.Desc.."\n[color=#306BC7]外门弟子无法激活特效"
		end

		selflist[npc.ID] = 10
	end
end



--层数更新

function tbModifier:UpdateStack(modifier, npc, add)
end



--离开modifier

function tbModifier:Leave(modifier, npc)
	GameMain:GetMod("_FabaoHelper"):ZhuangBeiYiChu(npc,"Mod/Npc/ZiXia/ZiXia.FBX")
	npc:RemoveTitleByName("紫霞仙子")
end




--获取存档数据

function tbModifier:OnGetSaveData()
end



--载入存档数据

function tbModifier:OnLoadData(modifier, npc, tbData)
end




























