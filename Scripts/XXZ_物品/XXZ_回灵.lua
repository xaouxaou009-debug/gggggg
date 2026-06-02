
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Modifier_Lua_zhiwu_jingping1");




function tbModifier:Enter(modifier, npc)

end


--modifier step
function tbModifier:Step(modifier, npc, dt)
	local dd = modifier:GetCurDuration();
	local jishi = dd.x * dd.y
	local xhpd = world:GetFlag(npc,6202)
	local ztpd = npc:CheckCommandSingle("BrokenNeck", true)
	local linglibi = npc.LingV/npc:GetProperty("NpcLingMaxValue")
	if ztpd == nil then
		if linglibi > 0.99 then
		modifier.Desc = string.format(modifier.def.Desc.."\n[color=#306BC7]灵力满溢，回灵终止[/color]", math.floor(jishi*1000))
		return false
		end
		if xhpd == 0 then
			world:SetFlag(npc,6202,math.floor(jishi))
		else
			if xhpd < jishi then
			local jingjie = (13 - npc.PropertyMgr.Practice.LogicStage)/10
			local huiling = npc:GetProperty("LingAbsorbSpeed")/100
			local tuling = npc.map:GetLing(npc.Key)/100	--周围灵力加成
			local dixing = npc.map:GetElementPower(npc.Key,npc.PropertyMgr.Practice.Gong.ElementKind)
			local ling = npc:GetProperty("NpcLingMaxValue")/100
			local lingup = ling * (jingjie *(huiling+tuling+dixing))
				world:SetFlag(npc,6202,math.floor(jishi)+1) 
				npc:BindEffect(90001,"Bip001 Head", 1)
				npc:AddLing(lingup)
				modifier.Desc = string.format(modifier.def.Desc.."\n[color=#306BC7]回灵效率：%s％[/color]", math.floor(lingup/ling*10)/10)
			end
		end
	else
		modifier.Desc = string.format(modifier.def.Desc.."\n[color=#306BC7]突破状态，回灵终止[/color]", math.floor(jishi*100))
	end
end



--层数更新

function tbModifier:UpdateStack(modifier, npc, add)

end



--离开modifier

function tbModifier:Leave(modifier, npc)
	world:SetFlag(npc,6202,0)
end




--获取存档数据

function tbModifier:OnGetSaveData()
end



--载入存档数据

function tbModifier:OnLoadData(modifier, npc, tbData)
end




























