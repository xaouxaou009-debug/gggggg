local tbThing = GameMain:GetMod("ThingHelper"):GetThing("Building_shenjian");
local selflist = selflist or {}
local it



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

	it = self.it
	tbThing:Desc(it)
	
	if selflist[it.ID.."jishi"] == nil then
		selflist[it.ID.."jishi"] = 0
	end
	if selflist[it.ID.."jishu"] == nil then
		selflist[it.ID.."jishu"] = 0
	end
	if selflist[it.ID.."gongzuo"] == nil then
		selflist[it.ID.."gongzuo"] = false
	end
	
	selflist[it.ID.."jishi"] = selflist[it.ID.."jishi"] + dt
	
	if selflist[it.ID.."jishi"] >= 5 then
	
	
		local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"搬运材料")
		if btn == false then
			it:AddBtnData("搬运材料","Icon/15.png","GameMain:GetMod('ThingHelper'):GetThing('Building_shenjian'):BanYun(bind)","将可锻造材料放入神器内部，可锻神兵利器");
		end
		
		local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"查看材料")
		if  btn == false then		
			it:AddBtnData("查看材料","Icon/14.png","GameMain:GetMod('ThingHelper'):GetThing('Building_shenjian'):ChaKanCaiLiao(bind)","锻造神兵，锻造神材化为神兵利器")
		end
		
		local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"配方锻造")
		if btn == false then		
			it:AddBtnData("配方锻造","Icon/14.png","GameMain:GetMod('ThingHelper'):GetThing('Building_shenjian'):ChaKanPeiFang(bind)","锻造神兵，锻造神材化为神兵利器")
		end
		
		local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"随机锻造")
		if btn == false then		
			it:AddBtnData("随机锻造","Icon/14.png","GameMain:GetMod('ThingHelper'):GetThing('Building_shenjian'):SuiJiDuanZao(bind)","锻造神兵，锻造神材化为神兵利器")
		end


		if selflist[it.ID.."gongzuo"] == true then
			
			selflist[it.ID.."jishu"] = selflist[it.ID.."jishu"] + 1
			
			if selflist[it.ID.."wuqi"] ~= nil then
			
				world:PlayEffect(38, it.Key, 0.5)
				
				local wupin = ThingMgr:FindThingByID(selflist[it.ID.."wuqi"])
				if wupin == nil then
					selflist[it.ID.."wuqi"] = ThingMgr:AddItemThing(0,selflist[it.ID.."wuqi"],nil).ID
					wupin = ThingMgr:FindThingByID(selflist[it.ID.."wuqi"])
					
					if selflist[it.ID.."cailiao"] ~= nil and wupin.StuffDef ~= nil then
										
						local stuff = ThingMgr:GetDef(2, selflist[it.ID.."cailiao"])   --物品原材料
						wupin:InheritDataFromMade(stuff,0,0)
						selflist[it.ID.."cailiao"] = nil
						wupin:SetName(wupin.def.ThingName)
						
						if wupin.def.ElementKind ~= g_emElementKind.None then
							wupin:SetElementKind(wupin.def.ElementKind)
						end
					end
											
					wupin:SetQuality(1.2)
					wupin.Author = it:GetName()
				end
				
				if selflist[it.ID.."jishu"] >= 100 then
					selflist[it.ID.."jishu"] = 0
					selflist[it.ID.."gongzuo"] = false
					selflist[it.ID.."wuqi"] = nil
				
					Map:DropItem(wupin, it.Key, true, true, false, true, 0, false)
					wupin:SetName("[color=#836FFF]【神锻】· [/color]"..wupin.def.ThingName)
					if WorldLua:CheckRate(0.01)  then
					end
					--MessageMgr:AddChainEventMessage(6270,-1,it:GetName().."耗费大量材料锻造出了一柄神兵利器"..wupin:GetName(), it.Key,0,nil,"神兵锻造")
				end
			elseif selflist[it.ID.."wuqi"] == nil then
				selflist[it.ID.."gongzuo"] = false
			end
		end
	end
end

function tbThing:Desc(it)
	if it.Bag.m_lisItems.Count > 0 then
	
		it:SetDesc(it.def.Desc.."\n[color=#DA70D6]当前已存储材料[color=#CD853F]"..it.Bag.m_lisItems.Count.."[/color]种")
		
		local wupin = ThingMgr:FindThingByID(selflist[it.ID.."wuqi"])
		if selflist[it.ID.."gongzuo"] == true and wupin ~= nil and selflist[it.ID.."jishu"] ~= nil then
			it:SetDesc(it.def.Desc.."[color=#1874CD]\n正在炼制神兵利器中\n炼制进度："..math.floor(selflist[it.ID.."jishu"]).."％\n炼制物品："..wupin:GetName())
			return false
		end
	else
		it:SetDesc(it.def.Desc)
	end
end



function tbThing:BanYun(it)
    world:EnterUILuaMode("LUA_wuqi_cailiao",it)
end

function tbThing:ChaKanCaiLiao(it)
	local items = it.Bag.m_lisItems
	local cailiaodrop = {{},{},{},{}}
	local cailiaobiao = {"","","",nil}
	for p=1,7 do
		local jinnum,shinum,munum = 0,0,0
		local jin = ThingMgr:GetDef(g_emThingType.Item,"Item_cailiao_jinshu"..p)
		local shi = ThingMgr:GetDef(g_emThingType.Item,"Item_cailiao_shizhuan"..p)
		local mu = ThingMgr:GetDef(g_emThingType.Item,"Item_cailiao_muliao"..p)
		
		for i=0,items.Count-1 do
			if items[i].def.Name == jin.Name then
				cailiaobiao[1] = cailiaobiao[1].."[color=#FF7F00]稀有金属："..jin.ThingName.."     存储量："..items[i].Count.."个[/color]\n"
				table.insert(cailiaodrop[1],items[i])
			elseif items[i].def.Name == shi.Name then
				cailiaobiao[2] = cailiaobiao[2].."[color=#8B4726]稀有石材："..shi.ThingName.."     存储量："..items[i].Count.."个[/color]\n"
				table.insert(cailiaodrop[2],items[i])
			elseif items[i].def.Name == mu.Name then
				cailiaobiao[3] = cailiaobiao[3].."[color=#698B22]稀有木料："..mu.ThingName.."     存储量："..items[i].Count.."个[/color]\n"
				table.insert(cailiaodrop[3],items[i])
			else
				if string.find(items[i].def.Name,"Item_cailiao_") == nil and p == 1 then
					if cailiaobiao[4] == nil then
						cailiaobiao[4] = ""
					end
					cailiaobiao[4] = cailiaobiao[4].."[color=#4A708B]其他材料："..items[i]:GetName().."     存储量："..items[i].Count.."个[/color]\n"
					table.insert(cailiaodrop[4],items[i])
				end
			end
		end
	end
	cailiaobiao[1] = cailiaobiao[1].."[color=#FF6347]\n稀有金属存储共"..#cailiaodrop[1].."种。是否取出列表中的材料[/color]"
	cailiaobiao[2] = cailiaobiao[2].."[color=#FF6347]\n稀有石材存储共"..#cailiaodrop[2].."种。是否取出列表中的材料[/color]"
	cailiaobiao[3] = cailiaobiao[3].."[color=#FF6347]\n稀有木料存储共"..#cailiaodrop[3].."种。是否取出列表中的材料[/color]"
	cailiaobiao[4] = cailiaobiao[4].."[color=#FF6347]\n其他材料存储共"..#cailiaodrop[4].."种。是否取出列表中的材料[/color]"
	local biaoti = {"稀有金属","稀有石材","稀有木料","其他材料"}
	local wupinbiao = {}
	for i=4,1,-1 do
		local cailiaodrop = cailiaodrop[i]
		if #cailiaodrop ~= nil then
			CS.Wnd_Message.Show(nil, 2,
			function (s)
				if s == "1" then
					wupinbiao[i] = {"取消取出"}
					for s=1,#cailiaodrop do
						table.insert(wupinbiao[i],cailiaodrop[s]:GetName())
					end
					
					local shuoming = "[color=#FF7F00]\n"..biaoti[i].."中物品共"..#cailiaodrop.."种，材料存储上限为物品的最大叠加[/color][color=#8B4726]\n\n请选择取出的物品，取出物品数量不可选择[/color][color=#698B22]\n\n每次取出物品会取出当前存储量-1，会保留一个在存储中[/color][color=#FF6347]\n\n保留一个用以下次存储物品可以快速完成[/color]"
					world:ShowStoryBox(shuoming,biaoti[i],wupinbiao[i], 
					function(s)
						if s > 0 then
							if cailiaodrop[s].Count == 1 then
								return cailiaodrop[s]:GetName().."的数量小于等于一个，不能取出"
							end
							local count = cailiaodrop[s].Count - 1
							cailiaodrop[s]:ChangeCount(1)
							local wupin = ItemRandomMachine.RandomItem(cailiaodrop[s].def.Name,nil,1,12,1,count)
							Map:DropItem(wupin, it.Key)
							world:FlyLineEffect(it.Key, wupin.Key, 1,
							function(p)
								wupin:SetActable(true)
							end
							,nil,nil,nil,"Effect/A/Prefabs/Projectiles/Frost/FrostProjectileTiny")
						end
					end)
				end
			end, true, biaoti[i], 0, 0,cailiaobiao[i])
		end
	end
	
end



function tbThing:SuiJiDuanZao(it)
	if selflist[it.ID.."gongzuo"] == true then
		world:ShowMsgBox("锻造台正在工作，请等待工作结束","无法锻造")
		return false
	end

	local qitalist = {
	{"Item_cailiao_jinshu",5},{"Item_cailiao_shizhuan",5},{"Item_cailiao_muliao",5},
	{"Item_RoughWoodBlock",3888},{"Item_HardWoodBlock",288},{"Item_LingWoodBlock",188},{"Item_ParasolWoodBlock",18},
	{"Item_BrownRockBlock",2888},{"Item_GrayRockBlock",1888},{"Item_MarbleBlock",888},{"Item_LingStoneBlock",588},{"Item_JadeBlock",288},{"Item_LingCrystalBlock",88},{"Item_SkyStoneBlock",18},
	{"Item_IronBlock",888},{"Item_CopperBlock",288},{"Item_SilverBlock",288},{"Item_DarksteelBlock",88},{"Item_StarEssenceBlock",18},{"Item_SilverBlock1",8},{"Item_CopperBlock1",8},
	}



	local items = it.Bag.m_lisItems
	local counts = items.Count
	local cailiaoname = {{},{},{},{}}
	for i=0,counts-1 do
		local name = items[i].def.Name
		local count = items[i].Count
		for k,v in pairs(qitalist) do
			if string.find(name,v[1]) and count >= v[2] then
				if string.find(name,"Item_cailiao_jinshu") then
					table.insert(cailiaoname[1],items[i])
				elseif string.find(name,"Item_cailiao_shizhuan") then
					table.insert(cailiaoname[2],items[i])
				elseif string.find(name,"Item_cailiao_muliao") then
					table.insert(cailiaoname[3],items[i])
				else
					table.insert(cailiaoname[4],items[i])
				end
			end
		end
	end
	
	local wupinbiao = {}
	if #cailiaoname[1] > 0 then
		table.insert(wupinbiao,"稀有金属")
	end
	if #cailiaoname[2] > 0 then
		table.insert(wupinbiao,"稀有石材")
	end
	if #cailiaoname[3] > 0 then
		table.insert(wupinbiao,"稀有木料")
	end
	if #cailiaoname[4] > 0 then
		table.insert(wupinbiao,"其他材料")
	end
	if #wupinbiao == 0 then
		world:ShowMsgBox("当前存储的材料不足以进行一次随机锻造","无法锻造")
		return false
	end
	local leixingshuoming = "\n"
	local leixingshuoming = leixingshuoming.."[color=#FF7F00]稀有金属：荒古神矿生成的矿石开采后，通过神材锻台祭炼获得的稀有金属[/color]\n"
	local leixingshuoming = leixingshuoming.."[color=#8B4726]稀有石材：荒古神矿生成的矿石开采后，通过神材锻台祭炼获得的稀有石材[/color]\n"
	local leixingshuoming = leixingshuoming.."[color=#698B22]稀有木料：灵植或砍伐植物后获得材料，通过神材锻台祭炼获得的稀有木料[/color]\n"
	local leixingshuoming = leixingshuoming.."[color=#4A708B]其他材料：获得木材、石材、矿石原料，通过加工台加工后获得的其他材料[/color]\n"
	local leixingshuoming = leixingshuoming.."\n[color=#8B2500]材料类型只支持游戏自带的材料类与修仙传MOD附带的凤纹木、螭吻玉、龙纹金系列，其他物品不支持"
	world:ShowStoryBox(leixingshuoming,"材料类型选择",wupinbiao, 
	function(s)
		if wupinbiao[s+1] == "稀有金属" then
			cailiaoname = cailiaoname[1]
		elseif wupinbiao[s+1] == "稀有石材" then
			cailiaoname = cailiaoname[2]
		elseif wupinbiao[s+1] == "稀有木料" then
			cailiaoname = cailiaoname[3]
		elseif wupinbiao[s+1] == "其他材料" then
			cailiaoname = cailiaoname[4]
		end
		
		local cailiaojieshao = ""
		local cailiaodesc = {}
		local xiaohao = {}
		for i=1,#cailiaoname do
			local name = cailiaoname[i].def.Name
			local tname = cailiaoname[i].def.ThingName
			local count = cailiaoname[i].Count
			for k,v in pairs(qitalist) do
				if string.find(name,v[1]) then
					cailiaojieshao = cailiaojieshao.."[color=#8B2500]可选材料："..tname.."     [/color][color=#9400D3]基础消耗："..v[2].."     [/color][color=#8B2500]当前存量："..count.."[/color]\n"
					table.insert(xiaohao,v[2])
				end
			end
			table.insert(cailiaodesc,tname)
		end
		cailiaojieshao = cailiaojieshao.."[color=#4682B4]随机锻造系统可以选择锻造的物品方向，但物品随机\n每个种类可锻造出对应的随机物品，不同方向消耗亦有所增减[/color]"
		world:ShowStoryBox(cailiaojieshao,"消耗材料选择",cailiaodesc, 
		function(s)
			local item = cailiaoname[s+1]
			local xiaohao = xiaohao[s+1]
			
			local wuxing = {"Item_baowu_wuxing_jin1","Item_baowu_wuxing_mu1","Item_baowu_wuxing_shui1","Item_baowu_wuxing_huo1","Item_baowu_wuxing_tu1"}
			local wuxing = wuxing[WorldLua:RandomInt(1,#wuxing+1)]
			local bagua = "Item_baowu_bagua"..WorldLua:RandomInt(1,9)
			local fuzhou = "Item_Spellsanjiefuzhou"..WorldLua:RandomInt(1,13)
			local fabao = "Item_Other_fabaosucai"..WorldLua:RandomInt(1,102)
			local fuwen = tbThing:SuiJiWuPinHuiZi("fuwen")
			local wupin = {fabao,wuxing,bagua,fuzhou,fuwen}
			
			local leixingbiao = {"随机法宝原型","随机五行碎片","随机八卦之一","随机护身灵符","随机符文碎片"}
			local xiaohao = {xiaohao,math.ceil(xiaohao/1.5),math.ceil(xiaohao/1.5),math.ceil(xiaohao/2),math.ceil(xiaohao/3)}
			
			local xiaohaojieshao = "[color=#8B2500]当前所选材料："..item:GetName().."[/color][color=#9400D3]     当前材料数量："..item.Count.."[/color]"
			local xiaohaojieshao = xiaohaojieshao.."[size=12][color=#4169E1]\n随机法宝原型：获得随机的法宝原型，可以用来锻造法宝，锻造的法宝属性极高，消耗物品"..xiaohao[1].."个[/color]"
			local xiaohaojieshao = xiaohaojieshao.."[size=12][color=#5D478B]\n随机五行碎片：获得随机的五行碎片，碎片可以祭炼灵宝，灵宝乃是稀有的镇物，消耗物品"..xiaohao[2].."个[/color]"
			local xiaohaojieshao = xiaohaojieshao.."[size=12][color=#528B8B]\n随机八卦之一：获得随机的八卦灵物，八卦残片合而为一，蕴养后乃是天地神器，消耗物品"..xiaohao[3].."个[/color]"
			local xiaohaojieshao = xiaohaojieshao.."[size=12][color=#4A708B]\n随机护身灵符：获得随机的护身灵符，灵符弟子可以佩戴，佩戴后激活隐藏属性，消耗物品"..xiaohao[4].."个[/color]"
			local xiaohaojieshao = xiaohaojieshao.."[size=12][color=#8B3A62]\n随机符文碎片：获得随机的符文碎片，符文碎片分为数类，附魔强化启灵升华等，消耗物品"..xiaohao[5].."个[/color]"
			local xiaohaojieshao = xiaohaojieshao.."[size=14][color=#8B5A2B]\n每次随机锻造会自动消耗材料立即获得物品\n选择物品后会二次确认，可以确定或者取消[/color]"
			world:ShowStoryBox(xiaohaojieshao,"锻造类型选择",leixingbiao, 
			function(s)
				local xiaohao = xiaohao[s+1]
				local tname = cailiaodesc[s+1]
				local wupin = wupin[s+1]
				
				local duanzaojieshao = ""
				local duanzaojieshao = duanzaojieshao.."[color=#8B2500]当前所选材料："..item:GetName().."[/color]\n"
				local duanzaojieshao = duanzaojieshao.."[color=#4169E1]锻造物品类型："..leixingbiao[s+1] .."[/color]\n"
				local duanzaojieshao = duanzaojieshao.."[color=#9400D3]当前材料数量："..item.Count.."[/color]\n"
				local duanzaojieshao = duanzaojieshao.."[color=#4A708B]锻造物品消耗："..xiaohao.."[/color]\n" 
				local duanzaojieshao = duanzaojieshao.."[color=#8B5A2B][size=12]是否确定锻造物品，确定后将消耗材料锻造物品[/color]" 
				CS.Wnd_Message.Show(nil, 2,
				function (s)
					if s == "1" then
					
						if item.Count >= xiaohao then
							item:ChangeCount(item.Count-xiaohao)
						else
							ThingMgr:RemoveThing(item)
						end
						
						wupin = ItemRandomMachine.RandomItem(wupin,nil,1,12,1,1)
						if wupin.StuffDef ~= nil then
							local stuff = ThingMgr:GetDef(2,item.def.Name)   --物品原材料
							wupin:InheritDataFromMade(stuff,0,0)
						end
						Map:DropItem(wupin, it.Key)
						world:FlyLineEffect(it.Key, wupin.Key, 1,
						function(p)
							world:PlayEffect(38, wupin.Key, 1)
							wupin:SetActable(true)
						end
						,nil,nil,nil,"Effect/A/Prefabs/Projectiles/Frost/FrostProjectileTiny")
					end
				end, true,leixingbiao[s+1] , 0, 0,duanzaojieshao)
				
			end)
		end)
	end)
	
end








function tbThing:WuPinPeiFang()

	local ling = "Item_zhuanshu_lingpai_"
	local wuxing = "Item_wuqi_lingjian_"
	
	local jin = "Item_cailiao_jinshu"
	local shi = "Item_cailiao_shizhuan"
	local mu = "Item_cailiao_muliao"
	
	
	local ZhuanShuList =
	{
	{7,ling.."luxueqi",{jin.."1",shi.."4",jin.."7",shi.."3",mu.."1","Item_StarEssenceBlock","Item_SilverBlock1",7,4,4,4,2,12,5},"专属物品配方",false},
	
	{7,ling.."biyao",{jin.."2",shi.."3",jin.."5",shi.."2",mu.."5","Item_SilverBlock","Item_IronBlock",8,2,2,4,1,2,35},"专属物品配方"},
	
	{7,ling.."sunwukong",{jin.."5",shi.."7",jin.."7",shi.."1",mu.."4","Item_LingWoodBlock","Item_LingCrystalBlock",6,6,5,2,2,49,62},"专属物品配方"},
	
	{7,ling.."lvbu",{jin.."2",shi.."3",jin.."4",shi.."2",mu.."3","Item_HardWoodBlock","Item_StarEssenceBlock",9,3,3,3,3,98,7},"专属物品配方"},
	
	{7,ling.."libai",{jin.."6",shi.."2",jin.."2",shi.."1",mu.."1","Item_JadeBlock","Item_HardWoodBlock",9,2,1,8,1,29,86},"专属物品配方"},
	
	{7,ling.."guanyu",{jin.."5",shi.."7",jin.."2",shi.."6",mu.."7","Item_LingCrystalBlock","Item_LingStoneBlock",7,3,3,7,1,49,96},"专属物品配方"},
	
	{7,ling.."yuji",{jin.."3",shi.."1",jin.."4",shi.."7",mu.."4","Item_SkyStoneBlock","Item_IronBlock",4,5,6,2,4,25,87},"专属物品配方"},
	
	{7,ling.."diaochan",{jin.."1",shi.."2",jin.."6",shi.."4",mu.."2","Item_LingWoodBlock","Item_SkyStoneBlock",3,4,7,4,3,81,18},"专属物品配方"},
	
	{7,ling.."zixia",{jin.."5",shi.."4",jin.."1",shi.."7",mu.."3","Item_CopperBlock","Item_DarksteelBlock",4,5,5,4,3,59,79},"专属物品配方"},
	
	{7,ling.."houyi",{jin.."6",shi.."3",jin.."2",shi.."5",mu.."6","Item_ParasolWoodBlock","Item_SilverBlock1",5,6,3,2,5,45,3},"专属物品配方"},
	
	{9,"Item_wuqi_wuxingjian2",{jin.."1",jin.."2",jin.."3",jin.."4",jin.."5",jin.."6",jin.."7",shi.."1",mu.."1",999,999,999,999,999,999,999,999,999},"五行灵剑配方"},
	{7,"Item_wuqi_wuxingjian1",{jin.."1",jin.."2",jin.."3",shi.."4",jin.."5",shi.."3",mu.."4",9,9,9,9,9,9,9},"五行灵剑配方"},
	{5,wuxing.."1",{jin.."1",shi.."1",mu.."1","Item_StarEssenceBlock","Item_DarksteelBlock",3,3,3,4,24},"五行灵剑配方"},
	{5,wuxing.."2",{jin.."2",shi.."2",mu.."2","Item_ParasolWoodBlock","Item_LingWoodBlock",3,3,3,8,36},"五行灵剑配方"},
	{5,wuxing.."3",{jin.."3",shi.."3",mu.."3","Item_SilverBlock1","Item_SilverBlock",3,3,3,2,36},"五行灵剑配方"},
	{5,wuxing.."4",{jin.."4",shi.."4",mu.."4","Item_CopperBlock1","Item_CopperBlock",3,3,3,2,36},"五行灵剑配方"},
	{5,wuxing.."5",{jin.."5",shi.."5",mu.."5","Item_SkyStoneBlock","Item_LingCrystalBlock",3,3,3,6,48},"五行灵剑配方"},
	
	{4,"Item_wuqi_sanji_jian1",{jin.."1",shi.."1",mu.."1","Item_LingCrystalBlock",2,2,2,4},"高级武器配方"},
	{3,"Item_wuqi_erji_gong2",{jin.."1",shi.."4",mu.."2",2,1,1},"高级武器配方"},
	{3,"Item_wuqi_erji_dao2",{jin.."3",shi.."7",mu.."5",1,2,1},"高级武器配方"},
	{3,"Item_wuqi_erji_qiang2",{jin.."5",shi.."2",mu.."1",2,1,1},"高级武器配方"},
	{3,"Item_wuqi_erji_jian2",{jin.."2",shi.."6",mu.."5",1,1,2},"高级武器配方"},
	{3,"Item_wuqi_erji_chui2",{jin.."6",shi.."3",mu.."4",1,2,1},"高级武器配方"},
	{3,"Item_wuqi_erji_huan2",{jin.."4",shi.."1",mu.."3",2,1,1},"高级武器配方"},
	{3,"SP_Sword2",{jin.."2",jin.."3",mu.."3",2,2,1},"高级武器配方"},
	
	{2,"Item_wuqi_yiji_jian1",{jin.."1",shi.."1",1,2},"初级武器配方"},
	{2,"Item_wuqi_yiji_gong1",{mu.."5",shi.."3",2,1},"初级武器配方"},
	{2,"Item_wuqi_yiji_qiang1",{jin.."3",mu.."3",1,2},"初级武器配方"},
	{2,"Item_wuqi_yiji_dao1",{jin.."2",jin.."2",2,1},"初级武器配方"},
	{2,"Item_wuqi_yiji_chui1",{jin.."5",shi.."6",2,1},"初级武器配方"},
	{2,"Item_wuqi_yiji_huan1",{shi.."1",shi.."7",1,2},"初级武器配方"},
	
	{1,"SP_Sword1",{jin.."1",1},"初级武器配方"},
	{1,"SP_Sword3",{jin.."1",1},"初级武器配方"},
	{1,"SP_Sword4",{jin.."1",1},"初级武器配方"},

	}
	
	return ZhuanShuList
	
end

function tbThing:ChaKanPeiFang(it)
	local peifanglist = tbThing:WuPinPeiFang()
	
	local peifang = {{},{},{},{},{},{}}
	peifang["list"] = {"专属物品配方","五行灵剑配方","高级武器配方","初级武器配方"}
	
	for k,v in pairs(peifanglist) do
		local peifangcailiao = ""
		local name = ThingMgr:GetDef(g_emThingType.Item,v[2]).ThingName
		if v[4] == "专属物品配方" then
			table.insert(peifang[1],name)
		end
		if v[4] == "五行灵剑配方" then
			table.insert(peifang[2],name)
		end
		if v[4] == "高级武器配方" then
			table.insert(peifang[3],name)
		end
		if v[4] == "初级武器配方" then
			table.insert(peifang[4],name)
		end
	end
	local wzdesc1 = "[color=#8B2252]专属物品配方，每个配方对应一种专属物品，专属物品认主后可以装备给主人[/color][color=#8B4C39]\n\n装备后的人物可以开启专属模型，每个模型对应一个新的形象[/color][color=#8E8E38]\n\n并激活新的装备  ： 法宝 、 武器 、 上衣 、 下衣  与称号一个[/color][color=#7A378B]\n\n并开启一个人物对应的强力BUFF，BUFF不共存，每个人物仅能激活一个[/color]"
	local wzdesc2 =  "\n[color=#8B2252]五行灵剑配方，五行灵剑共分为七把，每个武器可以激活一个特殊的BUFF[/color][color=#8B4C39]\n\n当内门人物佩戴上对应的内门装备与五行灵剑的时候会自动激活一个内门套装BUFF[/color][color=#8E8E38]\n\n内门套装BUFF仅内门穿戴后激活，外门弟子无法激活套装属性[/color]"
	local wzdesc3 =  "\n[color=#8B2252]高级武器配方，高级武器可以装备给外门弟子，部分武器佩戴后可以和特定的装备组合并开启一个套装BUFF，内门弟子无法激活此属性[/color][color=#8B4C39]\n\n高级武器激活的BUFF强度较之初级武器更高，装备的品质亦影响套装BUFF的效果[/color]"
	local wzdesc4 =  "\n[color=#8B2252]初级武器配方，初级武器可以装备给外门弟子，部分武器佩戴后可以和特定的装备组合并开启一个套装BUFF，内门弟子无法激活此属性[/color][color=#8B4C39]\n\n初级武器激活的BUFF强度较之高级武器属性略低，装备的品质亦影响套装BUFF的效果[/color]"
	
	local wzdesc = {wzdesc1,wzdesc2,wzdesc3,wzdesc4}
	local jieshao = "\n[color=#8B2252]锻造台配方表，可以查看物品的配方，物品配方分为几项，每项对应不同的物品，不同的配方需求的材料不同，配方材料充足的情况下，可以将材料祭炼为神兵利器、各类宝物[/color][color=#8B4C39]\n\n锻造方法：在材料充足的情况下可以选择开启锻造，确定选择后会自动锻造物品[/color][color=#4169E1]\n\n锻造开启后会自动消耗材料进行锻造且无法重置[/color]"
	world:ShowStoryBox(jieshao,"配方查看", peifang["list"], 
	function(s)
		local xuanxiang = peifang[s+1]
		local wzdesc = wzdesc[s+1]
		local cailiaobiao
			
		world:ShowStoryBox(wzdesc,"配方查看", xuanxiang, 
		function(s)
			local peifangshuoming = ""
			local duanzaokaiqi = false
			local wupin = nil
			local cailiao = nil
			local xiaohao = nil
			
			for k,v in pairs(peifanglist) do
				local name = ThingMgr:GetDef(g_emThingType.Item,v[2]).ThingName
				local duanzao = 0
				
				if name == xuanxiang[s+1] then
					wupin = v[2]
					xiaohao = {v[1],v[3]}
					cailiao = v[3][WorldLua:RandomInt(1,#v[3])]
					for i=1,v[1] do
						local shuliang = v[3][i+v[1]]
						local itemthingname = ThingMgr:GetDef(g_emThingType.Item,v[3][i]).ThingName
						local count = 0
						local items =  it.Bag.m_lisItems
						local itemname = v[3][i]
						local shuoming = "[color=#5E5E5E]不足[/color]"
						
						if items.Count > 0 then
							for i=0,items.Count-1 do
								if itemname == items[i].def.Name then
									count = items[i].Count
									if items[i].Count >= shuliang then
										shuoming = "[color=#9A32CD]充足[/color]"
										duanzao = duanzao + 1
									end
								end
							end
						end
						
						if duanzao >= v[1] then
							duanzaokaiqi = true
						end
						peifangshuoming = peifangshuoming..itemthingname.."    需求:[color=#A52A2A]"..shuliang.."[/color]    存量:[color=#CD853F]"..count.."[/color]    "..shuoming.."\n"
					end
				end
			end
			
			if wupin ~= nil then
				if duanzaokaiqi == true then
					CS.Wnd_Message.Show(nil, 2,
					function (s)
						if s == "1" then
						
							if selflist[it.ID.."gongzuo"] == true then
								world:ShowMsgBox("当前正在锻造物品，无法锻造新的物品，请等待当前物品锻造结束", xuanxiang[s+1])
								return false
							end
							
							selflist[it.ID.."gongzuo"] = true
							selflist[it.ID.."wuqi"] = wupin
							selflist[it.ID.."cailiao"] = cailiao
							
							if xiaohao ~= nil then
								for i=1,xiaohao[1] do
									local cailiao = xiaohao[2][i]
									local count = xiaohao[2][i+xiaohao[1]]
									
									local items =  it.Bag.m_lisItems
									for i=0,items.Count-1 do
										if cailiao == items[i].def.Name then
											if items[i].Count > count then
												items[i]:ChangeCount(items[i].Count-count)
											else
												ThingMgr:RemoveThing(items[i])
											end
										end
									end
								end
							end
							
						end
					end, true, xuanxiang[s+1], 0, 0,peifangshuoming.."\n[color=#698B22]物品充足，可以开启锻造，是否确定锻造？\n确定后将消耗对应材料并自动锻造物品[/color]")
					return false
				else
					local shuoming = "\n[color=#698B22]物品不充足，无法直接开启锻造[/color]"
					world:ShowMsgBox(peifangshuoming..shuoming, xuanxiang[s+1])
				end
			end
		end)
	end)
end






function tbThing:SuiJiWuPinHuiZi(name)

local fuwen = {
{15,"Item_fumo_suipian1"},
{8,"Item_fumo_suipian2"},
{4,"Item_fumo_suipian3"},
{2,"Item_fumo_suipian4"},
{1,"Item_fumo_suipian5"},
{15,"Item_fumo_qiling1"},
{8,"Item_fumo_qiling2"},
{4,"Item_fumo_qiling3"},
{1,"Item_fumo_qiling4"},
{15,"Item_fumo_chongzhu1"},
{9,"Item_fumo_chongzhu2"},
{6,"Item_fumo_chongzhu3"},
{3,"Item_fumo_chongzhu4"},
{1,"Item_fumo_chongzhu5"},
{20,"Item_fumo_fuwen1"},
{15,"Item_fumo_fuwen2"},
{9,"Item_fumo_fuwen3"},
{3,"Item_fumo_fuwen4"},
{1,"Item_fumo_fuwen5"},
{20,"Item_fumo_fuwen_pinzhi1"},
{15,"Item_fumo_fuwen_pinzhi2"},
{9,"Item_fumo_fuwen_pinzhi3"},
{3,"Item_fumo_fuwen_pinzhi4"},
{1,"Item_fumo_fuwen_pinzhi5"},
{8,"Item_fumo_fuwen_pinjie1"},
{8,"Item_fumo_fuwen_meiguan1"},
{15,"Item_fumo_fuwen_leijie1"},
{7,"Item_fumo_fuwen_leijie2"},
{4,"Item_fumo_fuwen_leijie3"},
{2,"Item_fumo_fuwen_leijie4"},
{1,"Item_fumo_fuwen_leijie5"},
{15,"Item_qianghua_suipian"..WorldLua:RandomInt(1,11)},
{15,"Item_fumo_fuwen_"..WorldLua:RandomInt(1,65)},

}
	local wupin = nil
	if name == "fuwen" then
		wupin = Lib:CountRateTable(fuwen, 1)
		wupin = fuwen[wupin][2]
	end
	
	return wupin

end


































