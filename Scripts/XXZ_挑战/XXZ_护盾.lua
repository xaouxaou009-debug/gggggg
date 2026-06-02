local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Lua_Modifier_yaoshou_hudun");
local selflist = selflist or {}


function tbModifier:Enter(modifier, npc)
end

--modifier step
function tbModifier:Step(modifier, npc, dt)
	local npcid = npc.ID
	local gwsxlist = GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE"):GetGWSXList() or {nil,10}
	local qiangdu = gwsxlist[2]
	if selflist[npcid.."jishi"] == nil then
		selflist[npcid.."jishi"] = 0
	end
	if selflist[npcid.."jishu"] == nil then
		selflist[npcid.."jishu"] = 0
	end
	local zybuff = npc.PropertyMgr:FindModifier("Modifier_Sys_GodMode")
	if zybuff ~= nil then
		zybuff.Desc = "无敌中，无法受到伤害"
		return false
	end
	selflist[npcid.."jishi"] = selflist[npcid.."jishi"]-dt
	if selflist[npcid.."jishi"] <= 0 then
		selflist[npcid.."jishi"] = 5
		local jingjie = npc.PropertyMgr.Practice.LogicStage		--获取境界
		local jiacheng = 0.01*qiangdu*jingjie
		npc.LuaHelper:ModifierProperty("NpcFight_ShieldConversionRateAddP",0,jiacheng)
		npc.LuaHelper:ModifierProperty("NpcFight_ShieldConversionRate",0, jiacheng)
		
		npc.LuaHelper:ModifierProperty("YaoShou_BaseAttack",0,-jiacheng)
		npc.LuaHelper:ModifierProperty("NpcFight_FabaoPowerAddP",0,-jiacheng)
		npc.LuaHelper:ModifierProperty("NpcFight_SpellPowerAddP",0,-jiacheng)
		selflist[npcid.."jishu"] = selflist[npcid.."jishu"]+1
		modifier:UpdateStack(1)
		modifier.Desc = "随着战斗的进行\n"..npc:GetName().."会持续获得额外的护盾加成，降低根本攻击\n当层数达到20层，将获得无敌状态，持续期间与强度有关"
		local duration = jingjie*(1+qiangdu/5)
		if modifier.Stack >= 20 then
			modifier:UpdateStack(1-modifier.Stack)
			npc:AddModifier("Modifier_Sys_GodMode", 1, false, 1, duration)
		end
	end
end



--层数更新

function tbModifier:UpdateStack(modifier, npc, add)
end



--离开modifier

function tbModifier:Leave(modifier, npc)
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



























