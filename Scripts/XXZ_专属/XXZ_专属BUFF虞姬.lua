
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Modifier_Lua_zhuanshu_buff_7");
local selflist ={}


function tbModifier:Enter(modifier, npc)
	npc.LuaHelper:AddTitle("死生契阔","",4)
	npc:AddNpcModPath("Mod/Npc/YuJi/YuJi.FBX")
	if npc.view ~= nil then
		npc.view.needUpdateMod = true
	end
	if not npc.IsDisciple then
		return false
	end
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			local list = {"Item_zhuanshu_fabao_yuji","Item_zhuanshu_wuqi_yuji","Item_zhuanshu_shangyi_yuji","Item_zhuanshu_xiayi_yuji","流光舞月剑•[color=#D02090]秘宝[/color]"}
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
			local NQ = npc:GetProperty("NpcFight_FabaoPowerAddP")+0.2
			local NE = npc.LingV/npc:GetProperty("NpcLingMaxValue")+100
			local Jing = npc.PropertyMgr.Practice.LogicStage/100+0.2
			npc:AddModifier("Modifier_zhuanshu_buff_7_1",NQ*Jing)
			modifier.Desc = modifier.def.Desc.."\n[size=11][color=#306BC7]法宝伤害降低"..math.floor(NQ*Jing*100).."％\n友方法伤提升"..math.floor(NQ*Jing*0.28*100).."％\n提升数值基数:"..(math.floor(NQ*Jing*100)/100).."\n灵力恢复:基数+目标1％当前灵气\n恢复效果随着境界降低[/color]"
						
							
			local jiacheng = NQ*Jing
			local Aroundkey = GameUlt.GetNearGrid(npc.Key, 20)
			for k,v in pairs(Aroundkey) do
				local oldnpcs = Things:GetNpcByKey(v);
				if oldnpcs ~= nil then
					for i = 0, oldnpcs.Count-1,1 do
						local oldnpc = oldnpcs[i];
						if oldnpc.Camp == g_emFightCamp.Player and oldnpc.IsDisciple and oldnpc:CheckCommandSingle("BrokenNeck", true) == nil and oldnpc ~= npc then
							local ling = npc.LingV*0.01
							local jingjie = 13 - oldnpc.PropertyMgr.Practice.LogicStage
							oldnpc:AddModifier("Modifier_zhuanshu_buff_7_2",NQ*Jing*0.28)
							oldnpc:AddLing(jiacheng+ling*(jingjie/8))
											
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
	GameMain:GetMod("_FabaoHelper"):ZhuangBeiYiChu(npc,"Mod/Npc/YuJi/YuJi.FBX")
	npc:RemoveTitleByName("死生契阔")
end




--获取存档数据

function tbModifier:OnGetSaveData()
end



--载入存档数据

function tbModifier:OnLoadData(modifier, npc, tbData)
end




























