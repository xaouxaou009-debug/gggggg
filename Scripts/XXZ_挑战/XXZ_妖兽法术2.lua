local tbTable = GameMain:GetMod("_SkillScript");
local tbSkill = tbTable:GetSkill("Lua_yaoshou_NormalAttack_2");


--技能在key点生效
function tbSkill:Apply(skilldef, key, from)
	
end

--技能在fightbody身上生效
function tbSkill:FightBodyApply(skilldef, fightbody, from)

end

--技能产生的子弹在pos点爆炸
function tbSkill:MissileBomb(skilldef, pos, from)	
	
end

function tbSkill:FlyCheck(skilldef, keys, from)

	local enpc = from
	
	if enpc == nil then
		return false
	end
	
	local gwsxlist = GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE"):GetGWSXList() or {nil,10}
	local qiangdu = gwsxlist[2]
	world:PlayAudio("Ogg/Skill/leidian.ogg");
	for i =0,  keys.Count-1,1 do
		local key = keys[i];
		local oldbuilding = Map.Things:GetThingAtGrid(key,4);
		local oldplant = Map.Things:GetThingAtGrid(key,"Plant");
		if oldplant ~= nil then
			local oldplantling = oldplant.LingV
			WorldLua:PlayEffect(12, key, 1);
			oldplant:AddLing(-oldplantling/qiangdu)
			enpc:AddLing(oldplantling*(1+qiangdu/10))
		else
			if oldbuilding == nil and WorldLua:CheckRate(0.03+qiangdu/100) and oldplant == nil then
				--World.map.Terrain:RemoveTerrain(key, true)
				bd = ThingMgr:AddPlantThing(key,"Plant_shu_yaoshou_1", nil)
				bd:AddLing(enpc:GetProperty("YaoShou_BaseLing")*0.01*qiangdu)
				bd:SetName("[color=#FF7F00]妖灵的回灵树[/color]")
				bd:SetDesc("妖灵施放木系技能时种下的回灵树\n会抽取附近弟子的灵力值\n妖灵再次释放木系技能时会抽取植物的灵力恢复自身")
				bd:SetAutoDestroy(100*(1+qiangdu/4))
				enpc:AddLing(-enpc:GetProperty("YaoShou_BaseLing")*0.01)
			end
		end
			
		local npcs = Map.Things:GetNpcByKey(key);
		if npcs ~= nil then
			for i = 0, npcs.Count-1,1 do
				local npc = npcs[i];
				if npc.IsDisciple then
					local linglibi = npc.LingV/npc:GetProperty("NpcLingMaxValue")
					local jingjie = npc.PropertyMgr.Practice.LogicStage
						
					if npc.IsPlayerThing and npc.IsDeath == false and enpc.IsDeath == false then
						npc:ReduceLingDamage((jingjie*qiangdu)/5, skilldef.Element, false, "万木归源", enpc);
						npc:AddLing(-npc:GetProperty("NpcLingMaxValue")*(0.015+qiangdu/150))
					end
				end
			end
		end	
	end
end

--数值加值
function tbSkill:GetValueAddv(skilldef, fightbody, from)
	
end


