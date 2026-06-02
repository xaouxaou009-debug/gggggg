local tbThing = GameMain:GetMod("ThingHelper"):GetThing("Lua_Building_jianzhen");
local selflist = selflist or {}


local ItemList =
{
{JZName="Building_jianzhen1",Name="   护山灵铸-牛   ",WPNum1= 5 ,WPNum2= 0.15 ,	YYNum1=1 }, 
{JZName="Building_jianzhen2",Name="   护山灵铸-羚   ",WPNum1= 3.7 ,WPNum2= 0.2 ,YYNum1=1.5 }, 
{JZName="Building_jianzhen3",Name="   护山灵铸-鹿   ",WPNum1= 3 ,WPNum2= 0.27 ,YYNum1=2 }, 
{JZName="Building_jianzhen4",Name="   护山灵铸-豹   ",WPNum1= 2.5 ,WPNum2= 0.36 ,YYNum1=2.5 }, 
{JZName="Building_jianzhen5",Name="   护山灵铸-蟒   ",WPNum1= 2 ,WPNum2= 0.47 ,YYNum1=3 }, 
{JZName="Building_jianzhen6",Name="   护山灵铸-虎   ",WPNum1= 1.6 ,WPNum2= 0.6 ,YYNum1=3.5 }, 
{JZName="Building_jianzhen7",Name="   护山灵铸-蛟   ",WPNum1= 1.2 ,WPNum2= 0.75 ,YYNum1=4 }, 
{JZName="Building_jianzhen8",Name="   护山灵铸-麒麟   ",WPNum1= 0.8 ,WPNum2= 0.92 ,YYNum1=4.5 }, 
{JZName="Building_jianzhen9",Name="   护山灵铸-蛟龙   ",WPNum1= 0.5 ,WPNum2= 1.15 ,YYNum1=5 }, 
};

function tbThing:OnInit()
end



function tbThing:OnGetSaveData()
	return selflist
end



function tbThing:OnLoadData(tbData)
	selflist = tbData
end



 
function tbThing:OnStep(dt)

	local it = self.it
	
	if selflist[it.ID.."jishi"] == nil then
		selflist[it.ID.."jishi"] = 0
		selflist[it.ID.."jishu"] = 0
		selflist[it.ID.."gongji"] = false
	end

	selflist[it.ID.."jishi"] = selflist[it.ID.."jishi"] - dt
	
	if selflist[it.ID.."jishi"] <= 0 then
	
		selflist[it.ID.."jishi"] = 3
		selflist[it.ID.."jishu"] = selflist[it.ID.."jishu"]+1
		if selflist[it.ID.."jishu"] == 50 then
			selflist[it.ID.."jishu"] = 0
			tbThing:FaBaoUP(it)
			tbThing:AnNiu(it)
		end
		
		if selflist[it.ID.."gongji"] == true then
			tbThing:GongJi(it)
		end
		
		
		if it.LingV < (world.DayCount+1)*1000 then
			it:AddLing(selflist[it.ID.."jishi"] * (world.DayCount+1)*0.1 )
		end
			
		if it.Bag.m_lisItems.Count >= 2 then
			it.Bag:DropItem(it.Bag.m_lisItems[1],0)
		elseif it.Bag.m_lisItems.Count == 1 then
			it:SetDesc(it.def.Desc.."\n[color=#9F79EE]正在蕴养法宝："..it.Bag.m_lisItems[0]:GetName())
		else
			it:SetDesc(it.def.Desc.."\n当前未曾蕴养法宝")
		end	
			
		local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"开启剑阵");
		if btn == false and selflist[it.ID.."gongji"] == false then
			it:AddBtnData("开启剑阵","Icon/12.png","GameMain:GetMod('ThingHelper'):GetThing('Lua_Building_jianzhen'):KaiQi(bind)","开启/关闭剑阵\n开启可以主动攻击战斗中的敌方单位，关闭后不主动攻击，亦不会抽取内门弟子灵气");
		end
	
	end
		
		
end




	
		--[[if v.Camp == g_emFightCamp.Player and v.IsDisciple then

			local jiacheng = nil
			if  not v.FightBody.IsFighting then
				for k,v in pairs(ItemList) do
					if thingname == v.JZName then
						jiacheng = v.WPNum2 or 0.1
					end
				end	

				local linglist = {}
				for k,v in pairs(Npclist) do
					if v.Camp == g_emFightCamp.Player and v.IsDisciple then
					local nQ = v:GetProperty("NpcLingMaxValue")
					table.insert(linglist,nQ)
					end	
				end

				local ling = 0
				for k,v in pairs(linglist) do
					ling = ling + v
				end
				
				local junling = ling/#linglist
				local ztpd = v:CheckCommandSingle("BrokenNeck", true)		--突破状态判定
				
				if it.LingV <= junling*2 and ztpd == nil then
					v:AddLing(-v.LingV*(jiacheng/30))
						world:PlayEffect(90006, it.Key, 1);
						it:AddLing(v.LingV*(jiacheng/30)*jiacheng)
				end
			end	
		end	
	end]]










function tbThing:FaBaoUP(it)
end


function tbThing:AnNiu(it)

	local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"蕴养法宝");
	if btn == false and it.Bag.m_lisItems.Count == 0 then
		it:AddBtnData("蕴养法宝","Icon/13.png","GameMain:GetMod('ThingHelper'):GetThing('Lua_Building_jianzhen'):YunYang(bind)","选择一件法宝放入剑阵中蕴养，随着时间会缓慢的提升法宝属性");
	end
		
	local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"取出法宝");
	if btn == false and it.Bag.m_lisItems.Count > 0 then
		it:AddBtnData("取出法宝","Icon/13.png","GameMain:GetMod('ThingHelper'):GetThing('Lua_Building_jianzhen'):QuBao(bind)","将剑阵中蕴养的法宝取出");
	end
		
end


function tbThing:KaiQi(it)

	if selflist[it.ID.."gongji"] == false then
		selflist[it.ID.."gongji"] = true
		it:RemoveBtnData("开启剑阵");
		it:AddBtnData("关闭剑阵","Icon/12.png","GameMain:GetMod('ThingHelper'):GetThing('Lua_Building_jianzhen'):KaiQi(bind)","开启/关闭剑阵\n开启可以主动攻击战斗中的敌方单位，关闭后不主动攻击，亦不会抽取内门弟子灵气");
	else
		selflist[it.ID.."gongji"] = false
		it:RemoveBtnData("关闭剑阵");
		it:AddBtnData("开启剑阵","Icon/12.png","GameMain:GetMod('ThingHelper'):GetThing('Lua_Building_jianzhen'):KaiQi(bind)","开启/关闭剑阵\n开启可以主动攻击战斗中的敌方单位，关闭后不主动攻击，亦不会抽取内门弟子灵气");
	end

end


function tbThing:YunYang(it)
	it:RemoveBtnData("蕴养法宝");
    world:EnterUILuaMode("LUA_wupin_xuanze",g_emItemLable.FightFabao,it)
end

function tbThing:QuBao(it)
	it:RemoveBtnData("取出法宝")
	local items = it.Bag.m_lisItems
	local fabao = items[0]
	local leijie = fabao.Fabao.GodCount
	local weili = fabao.Fabao:GetProperty("AttackPower") --法宝威力
	local huiling = fabao.Fabao:GetProperty("LingRecover") --法宝回灵
	local lingli = fabao.Fabao:GetProperty("MaxLing") --法宝灵力
	local feixing = fabao.Fabao:GetProperty("FlySpeed") --飞行速度
	local zhuanwan = fabao.Fabao:GetProperty("RotSpeed") --转弯速度
	local dikang = fabao.Fabao:GetProperty("KnockBackResistance") --击退抵抗
	local jitui = fabao.Fabao:GetProperty("KnockBackAddition") --击退强度
	local tuowei = fabao.Fabao:GetProperty("TailLenght") --拖尾长度
	local tiji = fabao.Fabao:GetProperty("Scale") --体积
	local gongsu = fabao.Fabao:GetProperty("AttackRate") --攻击间隔
	
	for k,v in pairs(ItemList) do
		if it.def.Name == v.JZName then
			
			fabao.Fabao:AddGodCount(-leijie)
			fabao.Fabao:SetProperty("AttackPower" , weili+ v.YYNum1)
			fabao.Fabao:SetProperty("LingRecover" , huiling+(v.YYNum1*1.5))
			fabao.Fabao:SetProperty("MaxLing" , lingli+(v.YYNum1*3))
			fabao.Fabao:SetProperty("FlySpeed" , feixing+(v.YYNum1*0.02))
			fabao.Fabao:SetProperty("RotSpeed" , zhuanwan+(v.YYNum1*0.03))
			fabao.Fabao:SetProperty("KnockBackResistance" , dikang+(v.YYNum1*0.01))
			fabao.Fabao:SetProperty("KnockBackAddition" , jitui+(v.YYNum1*0.01))
			fabao.Fabao:SetProperty("TailLenght" , tuowei+(v.YYNum1*0.02))
			fabao.Fabao:SetProperty("Scale" , tiji+(v.YYNum1*0.01))
			if gongsu > 0.25 then
				if WorldLua:CheckRate(gongsu/3)  then
					fabao.Fabao:SetProperty("Scale" , gongsu-0.1)
				end
			end
			fabao.Fabao:AddGodCount(leijie)
		end
	end
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			it.Bag:DropItem(fabao,0)
		end
	end, true, "取出法宝", 0, 0, "[color=#FF0000]是否确定将正在蕴养的法宝："..fabao:GetName().."取出\n如不取出，需等待再次蕴养成功方能取出[/color]")
	
--[[local Q = {}
	local W = {}
	Q[0] = "全部取出"
	if it.Bag ~= nil then
		local items = it.Bag.m_lisItems
		for i=0,items.Count-1 do
			Q[i+1] = "取出-"..items[i]:GetName()..""
			W[i+1] = items[i]
		end
	end
	world:ShowStoryBox("[color=#FF0000]请选择取出的法宝[/color]","取出法宝", {Q[0],Q[1],Q[2],Q[3],Q[4],Q[5],Q[6],Q[7],Q[8]}, 
	function(s)
		if s == 0 then
			it.Bag:DropAll()
		elseif s == 1 then
				it.Bag:DropItem(W[1],0)
		elseif s == 2 then
			it.Bag:DropItem(W[2],0)
		elseif s == 3 then
			it.Bag:DropItem(W[3],0)
		elseif s == 4 then
			it.Bag:DropItem(W[4],0)
		elseif s == 5 then
			it.Bag:DropItem(W[5],0)
		elseif s == 6 then
			it.Bag:DropItem(W[6],0)
		elseif s == 7 then
			it.Bag:DropItem(W[7],0)
		elseif s == 8 then
			it.Bag:DropItem(W[8],0)
		elseif s == 9 then
			it.Bag:DropItem(W[9],0)
		end
	end)]]
end




function tbThing:GongJi(it)

	local Key = it.Key			--获取Key
	local ling = it.LingV
	local rate = it.Rate
	local thingname = it.def.Name
	
	local texiao1 = {"Effect/A/Prefabs/Projectiles/Arcane/ArcaneProjectileTiny","Effect/A/Prefabs/Projectiles/Arcane/ArcaneProjectileSmall","Effect/A/Prefabs/Projectiles/Earth/EarthProjectileTiny","Effect/A/Prefabs/Projectiles/Earth/EarthProjectileSmall","Effect/A/Prefabs/Projectiles/Fire/FireProjectileTiny","Effect/A/Prefabs/Projectiles/Fire/FireProjectileSmall","Effect/A/Prefabs/Projectiles/Fire/FireProjectileNormal","Effect/A/Prefabs/Projectiles/Frost/FrostProjectileTiny","Effect/A/Prefabs/Projectiles/Frost/FrostProjectileSmall","Effect/A/Prefabs/Projectiles/Legacy/LightningProjectileSmallOld","Effect/A/Prefabs/Projectiles/Legacy/LightningProjectileOld","Effect/A/Prefabs/Projectiles/Life/LifeProjectileTiny","Effect/A/Prefabs/Projectiles/Life/LifeProjectileSmall","Effect/A/Prefabs/Projectiles/Life/LifeProjectileNormal","Effect/A/Prefabs/Projectiles/Light/LightProjectileTiny","Effect/A/Prefabs/Projectiles/Light/LightProjectileSmall","Effect/A/Prefabs/Projectiles/Light/LightProjectileNormal","Effect/A/Prefabs/Projectiles/Lightning/LightningProjectileTiny","Effect/A/Prefabs/Projectiles/Lightning/LightningProjectileSmall","Effect/A/Prefabs/Projectiles/Shadow/ShadowProjectileTiny","Effect/A/Prefabs/Projectiles/Shadow/ShadowProjectileSmall","Effect/A/Prefabs/Projectiles/Shadow/ShadowProjectileNormal","Effect/A/Prefabs/Projectiles/Storm/StormProjectileTiny","Effect/A/Prefabs/Projectiles/Storm/StormProjectileSmall","Effect/A/Prefabs/Projectiles/Storm/StormProjectileNormal","Effect/A/Prefabs/Projectiles/Water/WaterProjectileTiny","Effect/A/Prefabs/Projectiles/Water/WaterProjectileSmall","Effect/A/Prefabs/Projectiles/Water/WaterProjectileNormal","Effect/gsq/Prefab/Fx_FaShu_03"}
	local texiao3 = {"Effect/A/Prefabs/Projectiles/Arcane/ArcaneImpactMega","Effect/System/TeacherEnter","Effect/gsq/Prefab/long/fx_long002_shuibao","Effect/gsq/Prefab/long/fx_long002_shuilei_01","Effect/gsq/Prefab/long/fx_long002_shuilei_02","Effect/gsq/Prefab/zhulong/Fx_zhulong_zanian01","Effect/gsq/Prefab/zhulong/Fx_zhulong_zuinie01","Effect/A/Prefabs/Projectiles/Lightning/LightningImpactMega","Effect/gsq/Prefab/zhulong/fx_zhulong_zuiyetuxi01","Effect/gsq/Prefab/zhulong/fx_zhulong_xinmotuxi01","Effect/A/Prefabs/Projectiles/Fire/FireProjectileMega","Effect/A/Prefabs/Pillar Blast/WaterPillarBlast","Effect/A/Prefabs/Pillar Blast/StormPillarBlast","Effect/A/Prefabs/Pillar Blast/LightPillarBlast","Effect/A/Prefabs/Pillar Blast/LightningPillarBlast","Effect/A/Prefabs/Pillar Blast/LifePillarBlast","Effect/A/Prefabs/Pillar Blast/FrostPillarBlast","Effect/A/Prefabs/Pillar Blast/FirePillarBlast","Effect/A/Prefabs/Pillar Blast/EarthPillarBlast","Effect/A/Prefabs/Pillar Blast/ArcanePillarBlast","Effect/A/Prefabs/Projectiles/Water/WaterImpactMega","Effect/A/Prefabs/Projectiles/Water/WaterImpactNormal","Effect/A/Prefabs/Projectiles/Storm/StormImpactMega","Effect/A/Prefabs/Projectiles/Storm/StormImpactNormal","Effect/A/Prefabs/Projectiles/Shadow/ShadowImpactMega","Effect/A/Prefabs/Projectiles/Shadow/ShadowImpactNormal","Effect/A/Prefabs/Projectiles/Lightning/LightningImpactMega","Effect/A/Prefabs/Projectiles/Light/LightImpactMega","Effect/A/Prefabs/Projectiles/Life/LifeImpactMega","Effect/A/Prefabs/Projectiles/Legacy/LightningImpactOld","Effect/A/Prefabs/Projectiles/Fire/FireImpactMega","Effect/A/Prefabs/Projectiles/Frost/FrostImpactMega","Effect/A/Prefabs/Projectiles/Earth/EarthImpactMega","Effect/A/Prefabs/Projectiles/Arcane/ArcaneImpactMega","Effect/A/Prefabs/Projectiles/Light/LightImpactNormal"}
	local Damage1 = {"Damage_jianzhu1","Damage_jianzhu2","Damage_jianzhu3","Damage_jianzhu4","Damage_jianzhu5","Damage_jianzhu6","Damage_jianzhu7","Damage_jianzhu8"}

	for k,v in pairs(Map.Things.m_lisNpcs) do
		local jingjie = v.PropertyMgr.Practice.LogicStage or 1
		
		if v.FightBody.IsFighting and v.Race.RaceType ~= g_emNpcRaceType.Boss and v.Camp == g_emFightCamp.Enemy and v.IsDisciple and v.IsDeath == false then

			local texiao2 = WorldLua:RandomInt(1, #texiao1+1);
			local texiao4 = WorldLua:RandomInt(1, #texiao3+1);
			local Damage2 = WorldLua:RandomInt(1, #Damage1+1);

			if v.Race.RaceType == g_emNpcRaceType.Animal then
				shuxing = "YaoShou_BaseLing"
				beishu = 2
			elseif v.Race.RaceType == g_emNpcRaceType.Wisdom then
				shuxing = "NpcLingMaxValue"
				beishu = 4
			else
				beishu = 5
			end
			local enpc = v
					
			for k,v in pairs(ItemList) do
				if thingname == v.JZName then
					if enpc.LingV >= ling/20*v.WPNum2 then
						world:FlyLineEffect(it.Pos, enpc.ViewPos , v.WPNum1, 
						function(p)
							world:PlayEffect(texiao3[texiao4], enpc.ViewPos, 0.3)
							enpc:AddLing(-ling/20*v.WPNum2)
							it:AddLing(-ling/20)
							
							if shuxing ~= nil then
								enpc.LuaHelper:ModifierProperty(shuxing,-(ling/20*v.WPNum2)/beishu)
							end
							
							if WorldLua:CheckRate(rate/20/jingjie)  then
								enpc.LuaHelper:AddDamageRandomPart(5 , Damage1[Damage2] , v.WPNum2/WorldLua:RandomFloat(5, 10) , shanghailaiyuan )
							end
								
							if WorldLua:CheckRate(0.05) and it.LingV >= 10000 then
							local diaoxie = rate+it.LingV/1000000
								World.map:StrikePoint(enpc.Key , diaoxie , 0.01)
								enpc:AddLing(-diaoxie*100)
							end		
						end
						, "#0D0D0DFF", nil, nil, texiao1[texiao2]);
					end
				end
			end	
		end
	end
end











