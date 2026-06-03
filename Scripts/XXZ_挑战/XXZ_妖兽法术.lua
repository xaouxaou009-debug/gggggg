local tbTable = GameMain:GetMod("_SkillScript");
local tbSkill = tbTable:GetSkill("Lua_yaoshou_NormalAttack");


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
	local tnpcid = nil
	if enpc == nil then
		return false
	else
		tnpcid = enpc.FightBody.TargetID
	end
	local tnpc = ThingMgr:FindThingByID(tnpcid)
	if tnpc ~= nil then
		local gwsxlist = GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE"):GetGWSXList() or {nil,10}
		local qiangdu = gwsxlist[2]
		WorldLua:CameraShake(0.2, 0.1);
		enpc:FightWith(tnpc, true, false)
		local jingjie = enpc.PropertyMgr.Practice.LogicStage
		tnpc:ReduceLingDamage((jingjie*qiangdu)/10, skilldef.Element, true, "法术打击", from);
		tnpc:AddLing(-tnpc:GetProperty("NpcLingMaxValue")*(0.01+qiangdu/100))
	end
		
		
	
end

--数值加值
function tbSkill:GetValueAddv(skilldef, fightbody, from)
end


