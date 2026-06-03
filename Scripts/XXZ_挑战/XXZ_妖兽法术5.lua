local tbTable = GameMain:GetMod("_SkillScript");
local tbSkill = tbTable:GetSkill("Lua_yaoshou_NormalAttack_5");


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
		if oldbuilding == nil and WorldLua:CheckRate(0.03+qiangdu/80) and oldplant == nil then
				local bd = ThingMgr:AddBuildingThing(key ,"Building_yaoling_shixiang"..WorldLua:RandomInt(1,10), nil)
				bd:SetName("[color=#FF7F00]妖灵追随者的铸像[/color]")
				bd:SetDesc("妖灵召唤出的精怪铸像，铸像会暂时留存于修仙世界，如果妖灵释放土属性技能击碎了铸像，则会召唤出来自异界的追随者")
				bd:SetAutoDestroy(100+qiangdu*2)
				enpc:AddLing(-enpc:GetProperty("YaoShou_BaseLing")*0.01)
		end
			
		if oldbuilding ~= nil and string.find(oldbuilding.def.Name,"Building_yaoling_shixiang") then 
			if ThingMgr:GetYaoShouCount() < qiangdu then
				tbSkill:ZhaoHuan(enpc,qiangdu,key)
				ThingMgr:RemoveThing(oldbuilding)
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
						npc:ReduceLingDamage((jingjie*qiangdu)/6, skilldef.Element, false, "玄坤正法", enpc);
						npc:AddLing(-npc:GetProperty("NpcLingMaxValue")*(0.015+qiangdu/180))
					end
				end
			end	
		end
	end
end

--数值加值
function tbSkill:GetValueAddv(skilldef, fightbody, from)
	
end

function tbSkill:ZhaoHuan(enpc,num,key)
	local eling = enpc:GetProperty("YaoShou_BaseLing")/100					--妖兽灵力获取
	local egongji = enpc:GetProperty("YaoShou_BaseAttack")/100				--妖兽攻击获取
	local efabao = enpc:GetProperty("NpcFight_FabaoPowerAddP")/50			--法宝伤害获取
	local efashu = enpc:GetProperty("NpcFight_SpellPowerAddP")/50			--法术伤害获取
	local ehudun1 = enpc:GetProperty("NpcFight_ShieldConversionRate")/50	--护盾获取
	local ehudun2 = enpc:GetProperty("NpcFight_ShieldConversionRateAddP")/50--护盾获取
	local jingjie = enpc.PropertyMgr.Practice.LogicStage
	
	
	local yaoshoulist ={"JYRabbit","JYWolf","JYSnake","JYBoar","JYFrog","JYTurtle"}
	local yaoshouNum = world:RandomInt(1, #yaoshoulist+1)
	local yaoshou = yaoshoulist[yaoshouNum]
	
	if enpc ~= nil and num ~= nil and key ~= nil then
		if enpc.IsDeath == false then
			local npc = NpcMgr:CreateEliteEnemy(yaoshou , key, World.map , 0, math.ceil(jingjie/2));
			npc.PropertyMgr:SetPropertyOverwrite("YaoShou_BaseLing",eling*num);
			npc.PropertyMgr:SetPropertyOverwrite("YaoShou_BaseAttack",egongji*num);
			npc.PropertyMgr:SetPropertyOverwrite("NpcFight_FabaoPowerAddP",efabao*num);
			npc.PropertyMgr:SetPropertyOverwrite("NpcFight_SpellPowerAddP",efashu*num);
			npc.PropertyMgr:SetPropertyOverwrite("NpcFight_FabaoPowerAddP",ehudun1*num);
			npc.PropertyMgr:SetPropertyOverwrite("NpcFight_SpellPowerAddP",ehudun2*num);
			npc:AddLing(npc:GetProperty("YaoShou_BaseLing")-npc.LingV)
			npc.FightBody.AttackWait = 1
			npc:SetAutoDestroy(30*(num/2))
			npc:SetName(enpc:GetName().."的追随者")
		end
	end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
end

