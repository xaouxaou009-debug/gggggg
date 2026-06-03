local tbThing = GameMain:GetMod("ThingHelper"):GetThing("Building_kuangshan");
local selflist = selflist or {}

local kuang1 =

{

	{10,"Rock_kuangshan_shikuang1",0.3},
	{10,"Rock_kuangshan_jinkuang1",0.3},
	{10,"Rock_kuangshan_jin1",0.3},
	{10,"Rock_kuangshan_mu1",0.3},
	{10,"Rock_kuangshan_shui1",0.3},
	{10,"Rock_kuangshan_huo1",0.3},
	{10,"Rock_kuangshan_tu1",0.3},
	{10,"Rock_kuangshan_yuan1",0.3},
	{10,"Rock_kuangshan_hun1",0.3},
	{5,"Rock_kuangshan_jin2",0.5},
	{5,"Rock_kuangshan_mu2",0.5},
	{5,"Rock_kuangshan_shui2",0.5},
	{5,"Rock_kuangshan_huo2",0.5},
	{5,"Rock_kuangshan_tu2",0.5},
	{5,"Rock_kuangshan_yuan2",0.5},
	{5,"Rock_kuangshan_hun2",0.5},


};

local kuang2 =
{
	{20,"Building_kuangshan1",0.7},
	{5,"Building_kuangshan2",0.85},
	{1,"Building_kuangshan3",0.99},
};

function tbThing:OnInit()
end

function tbThing:OnGetSaveData()
	local save = selflist
	return save
end



function tbThing:OnLoadData(tbData)
	selflist = tbData or {}
end



 
function tbThing:OnStep(dt)
	local building = self.it
	local buildingid = building.ID
	if selflist[buildingid.."jishi"] == nil then
		selflist[buildingid.."jishi"] = 0
		selflist[buildingid.."jishu"] = 1
		selflist[buildingid.."huiling"] = 1
	end
	
	selflist[buildingid.."jishi"] = selflist[buildingid.."jishi"]-dt
	if selflist[buildingid.."jishi"] <= 0 then
		selflist[buildingid.."jishi"] = 5
	
		local daycount = world.DayCount			--获取天数
		local buildingkey = building.Key
		local buildingkeyling = World.map:GetLing(buildingkey)/1000	--周围灵力加成
		
		selflist[buildingid.."huiling"] = selflist[buildingid.."huiling"] + 0.01
		local addling = (selflist[buildingid.."huiling"]+daycount*0.01+buildingkeyling)*selflist[buildingid.."jishi"]
		building:AddLing(addling)
		
		if building.LingV > 10000 then
			local randomkey = Map:GetRandomGrid(buildingkey, 5)			--获取指定key附近范围内的随机key
			local oldbuilding = Map.Things:GetThingAtGrid(randomkey, 4);
			local oldplant = Map.Things:GetThingAtGrid(randomkey, 3);
			local olditem = Map.Things:GetThingAtGrid(randomkey, 2);
			
			if oldbuilding ~= nil or oldplant ~= nil or olditem ~= nil then
				return false
			end
			
				
			if building.LingV > 100000 and WorldLua:CheckRate(0.01) then
			
				
				local getlist = Lib:CountRateTable(kuang2, 1);			--按几率获取子表
				local kuangshan = kuang2[getlist][2]					--获取子表矿山
				local xiaohao = kuang2[getlist][3]						--获取子表消耗
					
				world:FlyLineEffect(buildingkey, randomkey, 1,
				function(p)
					world:PlayEffect(87, randomkey, 0.5);
					local newbuilding = ThingMgr:AddBuildingThing(randomkey , kuangshan, nil)
					
					--矿山消耗
					building:AddLing(-building.LingV*xiaohao)			
					selflist[buildingid.."huiling"] = selflist[buildingid.."huiling"]*0.9
					
					--矿物赋予属性
					local wuxing = {g_emElementKind.Jin, g_emElementKind.Mu, g_emElementKind.Shui, g_emElementKind.Huo, g_emElementKind.Tu}
					newbuilding:SetElementKind(wuxing[WorldLua:RandomInt(1,#wuxing+1)]);
					newbuilding:SetAutoDestroy(4200)
					MessageMgr:AddMessage(6287,{building}, newbuilding:GetName(), -1, newbuilding.Key, 0)
					--MessageMgr:AddChainEventMessage(6288,-1,building:GetName().."与此日灵性大发，衍生出了神矿投影【"..newbuilding:GetName().."】由于投影十分神异。衍化此物大量消耗灵气，并降低自身潜力，投影持续七天", newbuilding.Key,0,nil,"矿脉衍生")
				end);
				return false
			end	
			
			
			local getlist = Lib:CountRateTable(kuang1, 1);			--按几率获取子表
			local kuangshan = kuang1[getlist][2]					--获取子表矿山
			local xiaohao = kuang1[getlist][3]						--获取子表消耗
			world:FlyLineEffect(buildingkey, randomkey, 1,
			function(p)
				world:PlayEffect(48, randomkey, 0.5);
				local newrock = ThingMgr:AddPlantThing(randomkey , kuangshan, nil)	--生成矿物
				building:AddLing(-building.LingV*xiaohao)	
				newrock:SetAutoDestroy(1800)
				
				MessageMgr:AddMessage(6286,{building}, newrock:GetName(), -1, newrock.Key, 0)
				--MessageMgr:AddChainEventMessage(6288,-1,building:GetName().."由于灵气充足，衍生出了矿脉【"..newrock:GetName().."】。衍化此物少量消耗灵气，矿脉存在三天", newrock.Key,0,nil,"矿脉衍生")		
			end)
		end
	end
	
	
	
	
end




















