
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Modifier_Lua_zhuanshu_buff_8");
local selflist = {}


function tbModifier:Enter(modifier, npc)
	npc.LuaHelper:AddTitle("闭月灵殇","",4)
	npc:AddNpcModPath("Mod/Npc/DiaoChan/DiaoChan.FBX")
	if npc.view ~= nil then
		npc.view.needUpdateMod = true
	end
	if not npc.IsDisciple then
		return false
	end
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			local list = {"Item_zhuanshu_fabao_diaochan","Item_zhuanshu_wuqi_diaochan","Item_zhuanshu_shangyi_diaochan","Item_zhuanshu_xiayi_diaochan","霓裳扇•[color=#D02090]秘宝[/color]"}
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
			modifier.Desc = modifier.def.Desc.."\n[size=11][color=#306BC7]友军灵力提升：最大值1％-12％\n友方心境提升：当前值10％\n内门心情提升：当前值10％\n内门心情提升：当前值20％\n工作速度提升：最大值20％[/color]"
				local Aroundkey = GameUlt.GetNearGrid(npc.Key, 20)
				for k,v in pairs(Aroundkey) do
					local oldnpcs = Things:GetNpcByKey(v);
					if oldnpcs ~= nil then
						for i = 0, oldnpcs.Count-1,1 do
							local oldnpc = oldnpcs[i];
							if oldnpc.Camp == g_emFightCamp.Player and oldnpc.IsDisciple and oldnpc:CheckCommandSingle("BrokenNeck", true) == nil and oldnpc ~= npc then
											
							local jingjie = (13 - oldnpc.PropertyMgr.Practice.LogicStage)/100
							local ling = oldnpc:GetProperty("NpcLingMaxValue")+100
							local xinjing = oldnpc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.MindState)/10
							local xinqing = oldnpc.PropertyMgr.MoodData.RealMoodValue/10
											
							oldnpc:AddModifier("Modifier_zhuanshu_buff_8_1",ling*jingjie)
							oldnpc:AddModifier("Modifier_zhuanshu_buff_8_2",xinjing)
							oldnpc:AddModifier("Modifier_zhuanshu_buff_8_4",xinqing)
											
							end
										
							if not oldnpc.IsDisciple then
								local xinqing = oldnpc.PropertyMgr.MoodData.RealMoodValue/5
								local gongzuo = oldnpc:GetProperty("GlobalEfficiency")/5
								oldnpc:AddModifier("Modifier_zhuanshu_buff_8_3",gongzuo)
								oldnpc:AddModifier("Modifier_zhuanshu_buff_8_4",xinqing)
											
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
	GameMain:GetMod("_FabaoHelper"):ZhuangBeiYiChu(npc,"Mod/Npc/DiaoChan/DiaoChan.FBX")
	npc:RemoveTitleByName("闭月灵殇")
end




--获取存档数据

function tbModifier:OnGetSaveData()
end



--载入存档数据

function tbModifier:OnLoadData(modifier, npc, tbData)
end




























