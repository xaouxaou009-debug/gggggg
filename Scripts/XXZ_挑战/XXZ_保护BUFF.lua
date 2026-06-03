--妖兽BUFF
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Lua_tiaozhan_yaoshou_baohu");
local selflist = selflist or {}
local FalgList = {
	g_emNpcSpecailFlag.FLAG_NONEED,			--没有需求
	g_emNpcSpecailFlag.FLAG_GODMODE,		--无敌
	g_emNpcSpecailFlag.FLAG_NOFIGHT,		--无法战斗
	g_emNpcSpecailFlag.FLAG_CANNOT_UNEQUPT,	--不能脱掉装备
	g_emNpcSpecailFlag.FLAG_FIGHTHIDE		--隐身
	}

function tbModifier:Enter(modifier, npc)
	selflist["flaglist"] = {}
	for i=1,#FalgList do
		local check = npc:CheckSpecialFlag(FalgList[i])
		selflist["flaglist"][i] = check
		if check == 0 then
			npc:SetSpecialFlag(FalgList[i],1)
		end
	end
	npc.LockMove = true
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
	if selflist[npcid.."jishi"] == nil then
		selflist[npcid.."jishi"] = 0
	end
	selflist[npcid.."jishi"] = selflist[npcid.."jishi"]-dt
	if selflist[npcid.."jishi"] <= 0 then
		selflist[npcid.."jishi"] = 3
		npc:PlayAnimation("dazuo", true, 3)
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
	for i=1,#FalgList do
		if selflist["flaglist"][i] ~= nil then
			npc:SetSpecialFlag(FalgList[i],selflist["flaglist"][i])
		end
	end
	npc.LockMove = false
end













