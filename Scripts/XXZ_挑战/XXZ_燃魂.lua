local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Lua_Modifier_yaoshou_kongzhi1");
local selflist = selflist or {}


function tbModifier:Enter(modifier, npc)
end

--modifier step
function tbModifier:Step(modifier, npc, dt)
	local npcid = npc.ID
	if selflist[npcid.."jishi"] == nil then
		selflist[npcid.."jishi"] = 0
	end
	selflist[npcid.."jishi"] = selflist[npcid.."jishi"]-dt
	if selflist[npcid.."jishi"] <= 0 then
		selflist[npcid.."jishi"] = 5
		npc:AddLing(-npc.LingV/20)
		local Fightbody = npc.FightBody
		local Fabaoid = Fightbody.FabaoID
		if Fightbody.IsFighting and  Fightbody.Target ~= nil and Fightbody.Target.Camp == g_emFightCamp.Enemy then
		
			local fabaoIDs = FightMgr.FabaoMgr:GetFabaosByCamp(g_emFightCamp.Player)
			for k,v in pairs(fabaoIDs) do
				local fabao = FightMgr.FabaoMgr:GetFaBao(v)
				if fabao then
					local item = ThingMgr:FindThingByID(fabao.FromItem.ID) 
					if fabao.FromItem.ID ~= Fightbody.FabaoID then
						fabao:SetTarget(nil)
					end
				end
			end
			
			
			local Fabaoid = npc.FightBody
			npc =  world:GetSelectThing()
			local fbid = npc.FightBody.FabaoID
			local a = FightMgr.FabaoMgr:GetFaBao(fbid)
			local item = ThingMgr:FindThingByID(a.FromItem.ID) 
			a:SetTarget(nil)
			npc.Equip:UnEquipItem(item,true)
			print(item,a.Target)
					
		end
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



























