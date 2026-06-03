--妖兽BUFF
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Lua_lingguo_wuxing");
local selflist = selflist or {}
local npcid

function tbModifier:Enter(modifier, npc)
	local npcid = npc.ID
	if selflist[npcid.."jishu"] == nil then
		selflist[npcid.."jishu"] = 4800*modifier.Scale
	else
		selflist[npcid.."jishu"] = selflist[npcid.."jishu"] + 4800*modifier.Scale
	end
end

--获取存档数据
function tbModifier:OnGetSaveData()
	return selflist
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
		modifier.Name = "五行灵果炼化停止"
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
	local sudu = npc.PropertyMgr.Practice.LogicStage/5
	local shuoming = "[color=#7B68EE]\n剩余药力："..math.floor(selflist[npcid.."jishu"])
	local shuoming = shuoming.."\n炼化速度："..(sudu/5).."/S"
	local shuoming = shuoming.."\n精元消逝："..(sudu*0.5).."/S"
	
	
	if zhuangtai == "practice" then
		modifier.Name = "五行灵果炼化中"
		modifier.Desc = "[color=#1C86EE]修行状态中，持续炼化灵果，炼化速度一倍，精元消逝速度一倍[/color]"..shuoming
		sudu = sudu
	elseif zhuangtai == "practiceskill1" or zhuangtai == "practiceskill2" or  zhuangtai == "practiceskill3" then
		modifier.Name = "五行灵果炼化中"
		modifier.Desc = "[color=#1C86EE]练功状态中，持续炼化灵果，炼化速度两倍，精元消逝速度两倍[/color]"..shuoming
		sudu = sudu*2
	else
		modifier.Name = "五行灵果炼化停止"
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
		npc.LuaHelper:ModifierProperty("NpcFight_ShieldConversionRateAddP",0.00005*sudu)
		npc.LuaHelper:ModifierProperty("NpcFight_FabaoPowerAddP",0.0001*sudu)
		npc.LuaHelper:ModifierProperty("NpcFight_SpellPowerAddP",0.0001*sudu)
		npc.LuaHelper:ModifierProperty("NpcLingMaxValue",0,0.0001*sudu)
		npc.LuaHelper:ModifierProperty("MaxAge",0.001*sudu)
		npc.LuaHelper:ModifierProperty("IntelligenceSkillEXPConstant",0.00002*sudu)
		npc.LuaHelper:ModifierProperty("DeepPracticeSpeedSpecialCoefficient",0.00002*sudu)
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice, -sudu*2.5)
	else
		npc.LuaHelper:ModifierProperty("NpcFight_ShieldConversionRateAddP",0.00005*selflist[npcid.."jishu"])
		npc.LuaHelper:ModifierProperty("NpcFight_FabaoPowerAddP",0.0001*selflist[npcid.."jishu"])
		npc.LuaHelper:ModifierProperty("NpcFight_SpellPowerAddP",0.0001*selflist[npcid.."jishu"])
		npc.LuaHelper:ModifierProperty("NpcLingMaxValue",0,0.0001*selflist[npcid.."jishu"])
		npc.LuaHelper:ModifierProperty("MaxAge",0.0001*sudu)
		npc.LuaHelper:ModifierProperty("IntelligenceSkillEXPConstant",0.00002*selflist[npcid.."jishu"])
		npc.LuaHelper:ModifierProperty("DeepPracticeSpeedSpecialCoefficient",0.00002*selflist[npcid.."jishu"])
		npc.Needs:AddNeedValue(CS.XiaWorld.g_emNeedType.Practice, -selflist[npcid.."jishu"]*2.5)
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


























