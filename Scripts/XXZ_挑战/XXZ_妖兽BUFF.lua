--妖兽BUFF
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Lua_tiaozhan_yaoshou_jianglin");
local tbEvent = GameMain:GetMod("_Event");
local selflist = selflist or {}

function tbModifier:Enter(modifier, npc)
	npc:AddSpecialFlag(g_emNpcSpecailFlag.FLAG_CANTBEMAGIC,1)
	npc:AddSpecialFlag(g_emNpcSpecailFlag.FLAG_NONEED,1)
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
	local npcid = npc.ID
	local gwsxlist = GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE"):GetGWSXList() or {nil,10}
	local qiangdu = gwsxlist[2]
	if selflist[npcid.."jishi"] == nil then
		selflist[npcid.."jishi"] = 100
	end
		
	selflist[npcid.."jishi"] = selflist[npcid.."jishi"] - math.min(dt*qiangdu,90)
	if selflist[npcid.."jishi"] <= 0 then
		selflist[npcid.."jishi"] = 100
	end
		
	if npc.FightBody.IsFighting then
	
		local zybuff = npc.PropertyMgr:FindModifier("Modifier_yaoshou_hudun")
		if zybuff == nil then
			npc:AddModifier("Modifier_yaoshou_hudun")
		end
			
		local npclist = {}
		for k,v in pairs(Map.Things.m_lisNpcs) do
			if v.IsDisciple and (v.IsPlayerThing or v.Camp == g_emFightCamp.Friend) and v.IsDeath == false and v.FightBody.IsFighting then
				local linglibi = v.LingV/v:GetProperty("NpcLingMaxValue")
				if linglibi > 0.05 then
					table.insert(npclist,v) 
				end
			end
		end
			
		if #npclist == 0 then
			local job = CS.XiaWorld.JobMgr.Instance:CreateJob("JobLeaveMap",nil)
			npc.JobEngine:BeginJob(job)
			npc:AddSpecialFlag(g_emNpcSpecailFlag.FLAG_ANIMAL_LEAVEMAP,1)
			npc:AddSpecialFlag(g_emNpcSpecailFlag.FLAG_CANTSELECT,1)
			npc:AddSpecialFlag(g_emNpcSpecailFlag.FLAG_FLYGAWALY,1)
			npc:AddSpecialFlag(g_emNpcSpecailFlag.FLAG_RUNAWAY,1)
			npc:AddSpecialFlag(g_emNpcSpecailFlag.FLAG_GODMODE,1)
			world:ShowMsgBox("本方人员失去战斗力，妖灵即将离开，离开状态下妖灵无敌", "开启失败")
			GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE"):GetGWSXList(0)
			return false
		end
		
		for k,v in pairs(Map.Things.m_lisNpcs) do
			if not v.IsDisciple and v.IsPlayerThing and v.IsDeath == false then
				local bhbuff = v.PropertyMgr:FindModifier("Modifier_yaoshou_baohu")
				if bhbuff == nil then
					v:AddModifier("Modifier_yaoshou_baohu")
				end
			end
		end
			
		local tnpc = npclist[WorldLua:RandomInt(1,#npclist+1)]
		npc:FightWith(tnpc, true, false)
			
		if selflist[npcid.."zhandoujishi"] == nil then
			selflist[npcid.."zhandoujishi"] = 0
		end
		selflist[npcid.."zhandoujishi"] = selflist[npcid.."zhandoujishi"] - math.min(dt*qiangdu,195)
		if selflist[npcid.."zhandoujishi"] <= 0 then
			selflist[npcid.."zhandoujishi"] = 200
			local tnpc = ThingMgr:FindThingByID(npc.FightBody.TargetID)
			if tnpc ~= nil then
				local skilllist = {"Skill_yaoshou_NormalAttack_1","Skill_yaoshou_NormalAttack_2","Skill_yaoshou_NormalAttack_3","Skill_yaoshou_NormalAttack_5"}
				npc:DoCastSkill(skilllist[WorldLua:RandomInt(1, #skilllist+1)], tnpc.Key,tnpc.ID)
			end
		end
	end
end



--层数更新

function tbModifier:UpdateStack(modifier, npc, add)
end



--离开modifier

function tbModifier:Leave(modifier, npc)
end


function tbModifier:YaoShouLeave(npc,num)
	if npc ~= nil and num ~= nil then
		if num == 0 then
			--npc:DoSlaughter()
			--npc:DestroySelf()
			npc.PropertyMgr.BodyData:Kill("挑战失败", false)
			npc:SetName("挑战失败的妖灵尸体")
			return false
		end
		if npc:GetName() == "挑战失败的妖灵尸体" then
			return false
		end
		
		if num > 0 then
			npc:SetEliteExtraDrop("Drop_yaoshou_list1")
		end
		if num >=2 then
			npc:SetEliteExtraDrop("Drop_yaoshou_list2")
		end
		if num >= 4 then
			npc:SetEliteExtraDrop("Drop_yaoshou_list3")
		end
		if num >= 8 then
			npc:SetEliteExtraDrop("Drop_yaoshou_list4")
		end
	
		local kuilei = CS.XiaWorld.ThingMgr.Instance:AddPuppet(10*(1+num/2),npc.Key);
		kuilei:SetName("挑战傀儡")
		kuilei:SetDesc("挑战胜利专属傀儡，用来打扫地图，清理战利品")
		kuilei.Rate = 12
		kuilei:ChangeBeauty(48)
		local elem = {g_emElementKind.Jin, g_emElementKind.Mu, g_emElementKind.Shui, g_emElementKind.Huo, g_emElementKind.Tu}
		kuilei:SetElementKind(elem[WorldLua:RandomInt(1,#elem+1)]);
		kuilei.Author= "修仙传专用傀儡"
		kuilei:SetAutoDestroy(150*(1+num/5))
		kuilei:AddNpcModPath("Mod/Npc/KuiLei-wu/KuiLei-wu.FBX")
		if kuilei.view ~= nil then
			kuilei.view.needUpdateMod = true;
		end
	end
end



function tbModifier:QiangDu(npcid)
	if npcid ~= nil then
		return selflist[npcid.."jishu"]
	end
end



























