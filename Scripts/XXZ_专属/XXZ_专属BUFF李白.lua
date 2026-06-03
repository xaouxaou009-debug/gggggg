
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Modifier_Lua_zhuanshu_buff_5");
local selflist = {}


function tbModifier:Enter(modifier, npc)
	npc.LuaHelper:AddTitle("青莲居士","",4)
	npc:AddNpcModPath("Mod/Npc/LiBai/LiBai.FBX")
	if npc.view ~= nil then
		npc.view.needUpdateMod = true
	end
	if not npc.IsDisciple then
		return false
	end
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			local list = {"Item_zhuanshu_fabao_libai","Item_zhuanshu_wuqi_libai","Item_zhuanshu_shangyi_libai","Item_zhuanshu_xiayi_libai","灵夙笔•[color=#D02090]秘宝[/color]"}
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
	
	local Things = Map.Things;
	if selflist[npc.ID] <= 0 then
		if npc.IsDisciple then
			local NQ = npc:GetProperty("DeepPracticeSpeedSpecialCoefficient")+0.2
			local NW = npc:GetProperty("IntelligenceSkillEXPConstant")+0.2
			local NE = npc:GetProperty("NpcLingMaxValue")+100
			local Jing = npc.PropertyMgr.Practice.LogicStage/100+0.3
			npc:AddModifier("Modifier_zhuanshu_buff_5_1",NQ*Jing)
			npc:AddModifier("Modifier_zhuanshu_buff_5_2",NW*Jing)
			npc:AddModifier("Modifier_zhuanshu_buff_5_3",NE*Jing*0.5)
			modifier.Desc = modifier.def.Desc.."\n[size=11][color=#306BC7]修炼速度降低"..math.floor(NQ*Jing*100).."％\n学习速度降低"..math.floor(NW*Jing*100).."％\n灵力数值降低"..math.floor(NE*Jing*0.5).."\n附近友方提升数值基数:"..(math.floor(NE*Jing/10)/10).."\n灵力恢复:基数+目标0.3％最大灵气\n修为提升:基数+目境界总修为的0.2％\n参悟提升:基数+目标当前修为的0.1％\n等级越高提升效率越低[/color]"
						
			local jiacheng = NE*Jing/100
			local Aroundkey = GameUlt.GetNearGrid(npc.Key, 15)
			for k,v in pairs(Aroundkey) do
				local oldnpcs = Things:GetNpcByKey(v);
				if oldnpcs ~= nil then
					for i = 0, oldnpcs.Count-1,1 do
						local oldnpc = oldnpcs[i];
						if oldnpc.Camp == g_emFightCamp.Player and oldnpc.IsDisciple and oldnpc:CheckCommandSingle("BrokenNeck", true) == nil and oldnpc ~= npc then
							local ling = oldnpc:GetProperty("NpcLingMaxValue")*0.003
							local zongliang = oldnpc.PropertyMgr.Practice.CurStage.Value *0.002
							local xiuwei = oldnpc.PropertyMgr.Practice.StageValue*0.001
							local jingjie = 13 - oldnpc.PropertyMgr.Practice.LogicStage
							oldnpc:AddLing(jiacheng+ling*(jingjie/10))
							oldnpc.LuaHelper:AddPracticeResource("Stage",jiacheng+zongliang*(jingjie/10))
							oldnpc.LuaHelper:AddTreeExp(jiacheng+xiuwei*(jingjie/10))
						end
					end
				end
			end
		else
			modifier.Desc = modifier.def.Desc.."\n[color=#306BC7]外门弟子无法激活特效"
		end
	selflist[npc.ID] = 3
	end
end

--层数更新

function tbModifier:UpdateStack(modifier, npc, add)
end



--离开modifier

function tbModifier:Leave(modifier, npc)
	GameMain:GetMod("_FabaoHelper"):ZhuangBeiYiChu(npc,"Mod/Npc/LiBai/LiBai.FBX")
	npc:RemoveTitleByName("青莲居士")
end




--获取存档数据

function tbModifier:OnGetSaveData()
end



--载入存档数据

function tbModifier:OnLoadData(modifier, npc, tbData)
end




























