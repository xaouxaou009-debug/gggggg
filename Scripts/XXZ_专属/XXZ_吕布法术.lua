local tbTable = GameMain:GetMod("_SkillScript");
local tbSkill = tbTable:GetSkill("Lua_Skill_zhuanshu_lvbu");


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
	for i =0,  keys.Count-1,1 do
		local key = keys[i];
		WorldLua:PlayEffect(10002, key, 1);
		
		local npcs = Map.Things:GetNpcByKey(key);
		if npcs ~= nil then
			for i = 0, npcs.Count-1,1 do
				local npc = npcs[i];
				if npc.IsDeath == false and npc.Race.RaceType == g_emNpcRaceType.Wisdom and npc.IsPlayerThing then
				
					if npc.IsDisciple then
						if npc:CheckCommandSingle("BrokenNeck", true) == nil then
							WorldLua:PlayEffect(90001,npc.Pos, 1);
						end
					end
					
				end
			end
		end
	end
	
end

--数值加值
function tbSkill:GetValueAddv(skilldef, fightbody, from)
end


