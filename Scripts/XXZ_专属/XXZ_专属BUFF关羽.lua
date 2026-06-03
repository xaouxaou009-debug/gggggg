
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Modifier_Lua_zhuanshu_buff_6");
local selflist = {}









function tbModifier:Enter(modifier, npc)
	npc.LuaHelper:AddTitle("忠义无双","",4)
	npc:AddNpcModPath("Mod/Npc/GuanYu/GuanYu.FBX")
	if npc.view ~= nil then
		npc.view.needUpdateMod = true
	end
	if not npc.IsDisciple then
		return false
	end
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			local list = {"Item_zhuanshu_fabao_guanyu","Item_zhuanshu_wuqi_guanyu","Item_zhuanshu_shangyi_guanyu","Item_zhuanshu_xiayi_guanyu","青龙偃月刀•[color=#D02090]秘宝[/color]"}
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
			local NQ = npc:GetProperty("NpcFight_ShieldConversionRateAddP")+0.5	--获取法宝伤害
			local Jing = 1/npc.PropertyMgr.Practice.LogicStage+0.1		--获取境界
			local Ling = npc.LingV/npc:GetProperty("NpcLingMaxValue")
			local JCSZ = math.floor(NQ*Jing*(1.2-Ling)*1000000)/1000000
			npc:AddModifier("Modifier_zhuanshu_buff_6_1",JCSZ)
			modifier.Desc = modifier.def.Desc.."\n[color=#306BC7]灵力护盾降低"..math.floor(JCSZ*100).."％\n光环法宝加成"..math.floor(JCSZ*100/6.6).."％\n光环护盾加成"..math.floor(JCSZ*100/4.4).."％[/color]"

			local Aroundkey = GameUlt.GetNearGrid(npc.Key, 10)
			for k,v in pairs(Aroundkey) do
				local oldnpcs = Things:GetNpcByKey(v);
				if oldnpcs ~= nil then
					for i = 0, oldnpcs.Count-1,1 do
						local oldnpc = oldnpcs[i];
						if oldnpc.Camp == g_emFightCamp.Player and oldnpc.IsDeath == false and oldnpc.IsDisciple and oldnpc ~= npc then 
							oldnpc:AddModifier("Modifier_zhuanshu_buff_6_2",JCSZ/6.6)
							oldnpc:AddModifier("Modifier_zhuanshu_buff_6_3",JCSZ/4.4)
						end
					end
				end
			end
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
	GameMain:GetMod("_FabaoHelper"):ZhuangBeiYiChu(npc,"Mod/Npc/GuanYu/GuanYu.FBX")
	npc:RemoveTitleByName("忠义无双")
end




--获取存档数据

function tbModifier:OnGetSaveData()
end



--载入存档数据

function tbModifier:OnLoadData(modifier, npc, tbData)
end




























