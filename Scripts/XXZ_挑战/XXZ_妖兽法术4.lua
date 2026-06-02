local tbTable = GameMain:GetMod("_SkillScript");
local tbSkill = tbTable:GetSkill("Lua_yaoshou_NormalAttack_4");


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
		WorldLua:PlayEffect(37, key, 1);
		local npcs = Map.Things:GetNpcByKey(key);
		if npcs ~= nil then
			for i = 0, npcs.Count-1,1 do
				local npc = npcs[i];
				if npc.IsDisciple then
					local linglibi = npc.LingV/npc:GetProperty("NpcLingMaxValue")
					local jingjie = npc.PropertyMgr.Practice.LogicStage
						
					if npc.IsPlayerThing and npc.IsDeath == false and enpc.IsDeath == false then
						npc:ReduceLingDamage((jingjie*qiangdu)/8, skilldef.Element, false, "水灵真法", from);
						npc:AddLing(-npc:GetProperty("NpcLingMaxValue")*(0.01+qiangdu/200))
						npc:AddModifier("Modifier_yaoshou_ranshao",1,false, 1,10+qiangdu/10)
					end
				end
			end
		end
	end
end

--数值加值
function tbSkill:GetValueAddv(skilldef, fightbody, from)
end


