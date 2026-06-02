--妖兽BUFF
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Lua_lingguo_jin");
local selflist = selflist or {}
local npcid

function tbModifier:Enter(modifier, npc)
	local npcid = npc.ID
	local num = tbModifier:BuffJianCe(modifier)
	if selflist[npcid.."jishu"] == nil then
		selflist[npcid.."jishu"] = num
	else
		selflist[npcid.."jishu"] = selflist[npcid.."jishu"] + num
	end
	for i=1,15 do
		local buff = npc.PropertyMgr:FindModifier("Modifier_lingguo_jin"..i)
		if buff ~= nil then
			if buff ~= modifier then
				buff.Duration = 0.001
			end
		end
	end
end

--获取存档数据
function tbModifier:OnGetSaveData()
	local save = selflist
	return save
end


--载入存档数据
function tbModifier:OnLoadData(modifier, npc, tbData)
	selflist = tbData or {}
end

--modifier step
function tbModifier:Step(modifier, npc, dt)

	npcid = npc.ID
	
	if selflist[npcid.."jishi"] == nil then
		selflist[npcid.."jishi"] = 0
	end
	if selflist[npcid.."jishu"] == nil then
		selflist[npcid.."jishu"] = 0
		modifier.Duration = 0.01
		return false
	end
	
	local jingyuan = npc.Needs:GetNeedValue(CS.XiaWorld.g_emNeedType.Practice)
	if jingyuan <= 1 then
		modifier.Name = "金灵果炼化停止"
		modifier.Desc = "[color=#CD2626]人物当前精元过低，无法持续炼化灵果，炼化中断[/color]"
		return false
	end
	
	if npc.JobEngine.CurJob == nil then
		return false
	end
	if npc.JobEngine.CurJob:GetCurToil() == nil then
		return false
	end
	local zhuangtai = npc.JobEngine.CurJob:GetCurToil():GetToilKey()
	local sudu = npc.PropertyMgr.Practice.LogicStage/4
	local shuoming = "[color=#7B68EE]\n剩余药力："..math.floor(selflist[npcid.."jishu"])
	local shuoming = shuoming.."\n炼化速度："..(sudu/5).."/S"
	local shuoming = shuoming.."\n精元消逝："..(sudu*0.1).."/S"
	
	
	if zhuangtai == "practice" then
		modifier.Name = "金灵果炼化中"
		modifier.Desc = "[color=#1C86EE]修行状态中，持续炼化灵果，炼化速度一倍，精元消逝速度一倍[/color]"..shuoming
		sudu = sudu
	elseif zhuangtai == "practiceskill1" or zhuangtai == "practiceskill2" or  zhuangtai == "practiceskill3" then
		modifier.Name = "金灵果炼化中"
		modifier.Desc = "[color=#1C86EE]练功状态中，持续炼化灵果，炼化速度两倍，精元消逝速度两倍[/color]"..shuoming
		sudu = sudu*2
	else
		modifier.Name = "金灵果炼化停止"
		modifier.Desc = "[color=#CD2626]不在修炼or练功状态中，炼化中断，精元消逝停止[/color]"..shuoming
		return false
	end
	
	selflist[npcid.."jishi"] = selflist[npcid.."jishi"]- dt
	if selflist[npcid.."jishi"] > 0 then
		return false
	end
	selflist[npcid.."jishi"] = 5
	
	if sudu < selflist[npcid.."jishu"] then
		selflist[npcid.."jishu"] = math.floor(selflist[npcid.."jishu"]) - sudu 
		npc.LuaHelper:ModifierProperty("NpcFight_FabaoPowerAddP",0.0001*sudu)
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice, -sudu*0.5)
	else
		npc.LuaHelper:ModifierProperty("NpcFight_FabaoPowerAddP",0.0001*selflist[npcid.."jishu"])
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice, -selflist[npcid.."jishu"]*0.5)
		selflist[npcid.."jishu"] = 0
		modifier.Duration = 0.01
	end
end



--层数更新

function tbModifier:UpdateStack(modifier, npc, add)

end



--离开modifier

function tbModifier:Leave(modifier, npc)
end

function tbModifier:BuffJianCe(modifier)
	local name = modifier.def.Name
	local num = 0
	if name == "Modifier_lingguo_jin1" then
		num = 180*modifier.Scale
	elseif name == "Modifier_lingguo_jin2" then
		num = 360*modifier.Scale
	elseif name == "Modifier_lingguo_jin3" then
		num = 720*modifier.Scale
	elseif name == "Modifier_lingguo_jin4" then
		num = 1280*modifier.Scale
	elseif name == "Modifier_lingguo_jin5" then
		num = 1880*modifier.Scale
	elseif name == "Modifier_lingguo_jin6" then
		num = 2680*modifier.Scale
	elseif name == "Modifier_lingguo_jin7" then
		num = 3680*modifier.Scale
	elseif name == "Modifier_lingguo_jin8" then
		num = 4880*modifier.Scale
	elseif name == "Modifier_lingguo_jin9" then
		num = 6880*modifier.Scale
	elseif name == "Modifier_lingguo_jin10" then
		num = 9880*modifier.Scale
	elseif name == "Modifier_lingguo_jin11" then
		num = 12800*modifier.Scale
	end
	return num
end

























