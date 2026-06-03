local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Lua_Modifier_yaoshou_kongzhi1");
local selflist = selflist or {}


function tbModifier:Enter(modifier, npc)
		local Jing = npc.PropertyMgr.Practice.LogicStage			--获取境界
		local FaBao = npc:GetProperty("NpcFight_FabaoPowerAddP")		--获取法宝伤害
		local FaShu = npc:GetProperty("NpcFight_SpellPowerAddP")		--获取法术伤害
		local HuDun1 = npc:GetProperty("NpcFight_ShieldConversionRateAddP")--获取护盾加成
		local HuDun2 = npc:GetProperty("NpcFight_ShieldConversionRate")	--获取护盾加值
		local Jin = npc:GetProperty("NpcFight_ShieldConversionRate")	--获取护盾加值
		local Mu = npc:GetProperty("NpcFight_ShieldConversionRate")	--获取护盾加值
		local Shui = npc:GetProperty("NpcFight_ShieldConversionRate")	--获取护盾加值
		local Huo = npc:GetProperty("NpcFight_ShieldConversionRate")	--获取护盾加值
		local Tu = npc:GetProperty("NpcFight_ShieldConversionRate")	--获取护盾加值
		
		
		
		
		npc.PropertyMgr:SetPropertyOverwrite("NpcFight_FabaoPowerAddP",FaBao-(FaBao/2)*(1+Jing/20));
		npc.PropertyMgr:SetPropertyOverwrite("NpcFight_SpellPowerAddP",FaShu-(FaShu/2)*(1+Jing/20));
		npc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldConversionRateAddP",HuDun1+(HuDun1/5)*(1+Jing/10));
		npc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldConversionRate",HuDun2+(HuDun2/5)*(1+Jing/10));
		npc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldResistanceToJin",Jin+Jin*(1-Jing/10));
		npc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldResistanceToMu",Mu+Mu*(1-Jing/10));
		npc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldResistanceToShui",Shui+Shui*(1-Jing/10));
		npc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldResistanceToHuo",Huo+Huo*(1-Jing/10));
		npc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldResistanceToTu",Tu+Tu*(1-Jing/10));
		npc.LockMove = true
		modifier.Desc = modifier.def.Desc.."\n[color=#CD0000]伤害降低"..math.ceil((FaBao/2)*(1+Jing/20)*100).."％[/color]\n[color=#B452CD]防御增加"..math.ceil((HuDun1/5)*(1+Jing/10)*100).."％[/color]"
end

--modifier step
function tbModifier:Step(modifier, npc, dt)
	local npcid = npc.ID
	if selflist[npcid.."jishi"] == nil then
		selflist[npcid.."jishi"] = 0
	end
	selflist[npcid.."jishi"] = selflist[npcid.."jishi"]-dt
	if selflist[npcid.."jishi"] <= 0 then
		selflist[npcid.."jishi"] = 2
		npc:AddLing(-npc.LingV/20)
		local jiance = GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE"):YaoLingJianCe()
		if jiance == true then
			modifier.Duration = 0.1
		end
	end
end



--层数更新

function tbModifier:UpdateStack(modifier, npc, add)
end



--离开modifier

function tbModifier:Leave(modifier, npc)
		npc.LockMove = false
		npc.PropertyMgr:RemovePropertyOverwrite("NpcFight_FabaoPowerAddP");
		npc.PropertyMgr:RemovePropertyOverwrite("NpcFight_SpellPowerAddP");
		npc.PropertyMgr:RemovePropertyOverwrite("NpcFight_ShieldConversionRateAddP");
		npc.PropertyMgr:RemovePropertyOverwrite("NpcFight_ShieldConversionRate");
		npc.PropertyMgr:RemovePropertyOverwrite("NpcFight_ShieldResistanceToJin");
		npc.PropertyMgr:RemovePropertyOverwrite("NpcFight_ShieldResistanceToMu");
		npc.PropertyMgr:RemovePropertyOverwrite("NpcFight_ShieldResistanceToShui");
		npc.PropertyMgr:RemovePropertyOverwrite("NpcFight_ShieldResistanceToHuo");
		npc.PropertyMgr:RemovePropertyOverwrite("NpcFight_ShieldResistanceToTu");
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



























