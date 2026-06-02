
local Windows = GameMain:GetMod("Windows");--先注册一个新的MOD模块
local tbWindow = Windows:CreateWindow("XXZ_TiaoZhan");
local TiaoZhan = GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE")
local tbEvent = GameMain:GetMod("_Event");
local selflist = selflist or {}
function tbWindow:OnInit()
	self.window.contentPane =  UIPackage.CreateObject("XXZUI", "XXZTiaoZhan");--载入UI包里的窗口
	self.window.closeButton = self:GetChild("frame"):GetChild("n5");
	self:GetChild("frame").onClick:Add(tbWindow.OnClick)
	
	self.bnt1 = self:GetChild("bnt_1");
	self.bnt1.onClick:Add(tbWindow.OnClick);
	
	self.list = self:GetChild("list1");
	self.list.onClickItem:Add(tbWindow.ClickSelectTiaoZhan);
	self.list.onRightClickItem:Add(tbWindow.RightClickSelectTiaoZhan)
	self.jsicon = "ui://ybjkycintwcj36r"
	self.lable1 = self:GetChild("lable_1") 
	
	self.lablewx = self:GetChild("Lable_wx");
	
	self.lablery = self:GetChild("Lable_ry");
	self.rylist1 = self.lablery:GetChild("list1")
	self.rylist1.onClickItem:Add(tbWindow.ClickSelectItem);
	self.rylist1.onRightClickItem:Add(tbWindow.RightClickSelectItem)
	
	self.rylist2 = self:GetChild("Lable_ry"):GetChild("list2")
	self.rylist2.onChanged:Add(tbWindow.onSelected)
	self.rylist2.items = {"星宿符文","特殊符文","强化符文","附魔符文","兽皮翎羽","角色专属","造化圣物","妖灵内丹","五行灵丹","挑战灵丹"}
	self.rylist2.values = {"星宿符文","特殊符文","强化符文","附魔符文","兽皮翎羽","角色专属","造化圣物","妖灵内丹","五行灵丹","挑战灵丹"}
	
	self.window:Center();
	local a = self.window.position;
	self.window:SetPosition(a.x,100,a.x);
end
--GameMain:GetMod("Windows"):CreateWindow("XXZ_TiaoZhan"):Show()
--GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE"):GetJiSha(1,{true})
--GameMain:GetMod("Windows"):CreateWindow("XXZ_TiaoZhan"):Show()
--list 1对应Index 2强度 3 奖励 4前缀
function tbWindow.ClickSelectTiaoZhan(context)
	local self = context.data
	local list = {}
	list[1] = self.apexIndex
	list[2] = math.floor(2.33*self.apexIndex)
	list[3] = list[1]*list[2]
	list[4] = self.title
	local jishajl = "    首次击杀奖励额外的荣誉值："..list[3]
	if selflist["JiShaList"][self.apexIndex][1] == true then
		jishajl = "     首杀奖励已领取，击杀荣誉值："..list[2]
	end
	local lable1 = tbWindow:GetChild("lable_1")
	lable1.text = self.title.."    强度："..list[2].."级"..jishajl
end
function tbWindow.RightClickSelectTiaoZhan(context)
	local self = context.data
	local list = {}
	list[1] = self.apexIndex
	list[2] = math.floor(2.33*self.apexIndex)
	list[3] = list[1]*list[2]
	list[4] = self.title
	if selflist["MeiRiJiShu"] <= 0 then
		if selflist["MeiRiJiShu"] == -3 then
			world:ShowMsgBox("今日已经额外进行了3次挑战，请等待刷新", "妖灵击杀")
			return false
		end
		CS.Wnd_Message.Show(nil, 2,
		function (s)
			if s == "1" then	
				list[3] = 0
				world:EnterUILuaMode("XXZ_TiaoZhan_zhaohuan",list)
				tbWindow:Hide()
			end
		end, true, "妖灵召唤", 0, 0,"今日的挑战次数已用尽,是否继续开启挑战，超出次数的挑战不会获得荣誉值奖励")
		return false
	end
	if selflist["GWSXList"] == nil then
		CS.Wnd_Message.Show(nil, 2,
		function (s)
			if s == "1" then	
				world:EnterUILuaMode("XXZ_TiaoZhan_zhaohuan",list)
				selflist["MeiRiJiShu"] = selflist["MeiRiJiShu"] - 1
				tbWindow:Hide()
			end
		end, true, "妖灵召唤", 0, 0,"是否确实开启："..list[4].."\n挑战期间所有人员无法装备物品与激活符咒，请提前装备好\n每天可以挑战三次，今天剩余次数"..selflist["MeiRiJiShu"])
	else
		world:ShowMsgBox("当前正在进行挑战或妖灵未死，请击杀后再次召唤", "开启失败")
	end
end

function tbWindow.ClickSelectItem(context)
	local name = context.data.name
	local wptable = GameMain:GetMod("ZH_zhanghu"):AddLingNum()
	if context.sender.name == "list1" then
		local tables = {nil,name,nil}
		local moeny = TiaoZhan:RongYuWuPin(tables)
		local tname = ThingMgr:GetDef(g_emThingType.Item,name)
		if selflist["RongYu"] < moeny then
			world:ShowMsgBox("兑换 "..tname.ThingName.." 需要荣誉值 "..moeny.." 点，当前持有荣誉值 "..selflist["RongYu"].." 点，无法兑换", "妖灵击杀")
			return false
		end
		CS.Wnd_Message.Show(nil, 2,
		function (s)
			if s == "1" then	
				GameMain:GetMod("XXZ_JianYiCangKu_SEVE"):CunChuCaiLiao(name,1)
				selflist["RongYu"] = selflist["RongYu"]-moeny
			end
		end, true, "物品兑换", 0, 0,"兑换物品："..tname.ThingName.."\n消耗荣誉："..moeny.."\n持有荣誉："..selflist["RongYu"].."\n是否确定兑换物品，确定后物品将直接存储到仓库")
		
	end
	
end
function tbWindow.RightClickSelectItem(context)
	local name = context.data.name
	local wptable = GameMain:GetMod("ZH_zhanghu"):AddLingNum()
	if context.sender.name == "list1" then
		local tables = {nil,name,nil}
		local moeny = TiaoZhan:RongYuWuPin(tables)
		local tname = ThingMgr:GetDef(g_emThingType.Item,name)
		if selflist["RongYu"] < moeny then
			world:ShowMsgBox("兑换 "..tname.ThingName.." 需要荣誉值 "..moeny.." 点，当前持有荣誉值 "..selflist["RongYu"].." 点，无法兑换", "妖灵击杀")
			return false
		end
		GameMain:GetMod("XXZ_JianYiCangKu_SEVE"):CunChuCaiLiao(name,1)
		selflist["RongYu"] = selflist["RongYu"]-moeny
	end
end

function tbWindow.OnClick(context)
	if context.sender.name == "frame" then
		tbWindow:GetChild("list1").selectedIndex = -1
	end
end
function tbWindow.onSelected(context)
	local rylist2 = tbWindow:GetChild("Lable_ry"):GetChild("list2")
	tbWindow:OnShowUpdate()
end

function tbWindow:OnShowUpdate()
	self.list:RemoveChildrenToPool()
	for i=1,#selflist["JiShaList"] do
		local item = self.list:AddItemFromPool();
		item.title = "挑战："..i.."阶"
		item.icon = self.jsicon
		item.tooltips = "阶数越高妖灵战力越强，技能冷却，伤害等都与强度挂钩，左键点击查看粗略强度，右键开启挑战"
		if selflist["JiShaList"][i][1] == false then
			item.icon = nil
		end
		item.apexIndex = i
	end
	self.rylist1:RemoveChildrenToPool()
	if self.lablery.visible == true then
		local tables = {self.rylist2.value,nil,nil}
		local sdlist = TiaoZhan:RongYuWuPin(tables)
		for i=1,#sdlist do
			local item = self.rylist1:AddItemFromPool()
			local tname = ThingMgr:GetDef(g_emThingType.Item,sdlist[i][1])
			item.icon = tname.TexPath
			item.title = tname.ThingName
			item.name = tname.Name
			item.tooltips = tname.Desc.."\n兑换需求："..sdlist[i][2].."点荣誉"
			item.tooltips = item.tooltips.."\n点击左键兑换，右键将不提示对话框直接兑换，物品发放至仓库"
		end
	end
end

function tbWindow:OnShown()
end

function tbWindow:OnUpdate(dt)
	if self.list.selectedIndex < 0 then
		self.lablewx.visible = false
		self.lablery.visible = true
		self.lablery.title = "荣誉值："..selflist["RongYu"]
		self.lable1.text = "击杀妖灵可以获得荣誉值奖励，荣誉值可以兑换顶级物品"
	else
		self.lablery.visible = false
		self.lablewx.visible = true
	end
	
end

function tbWindow:OnHide()

end

function TiaoZhan:OnInit()
	tbEvent:RegisterEvent(g_emEvent.DayChange, TiaoZhan.OnDayChange, "XXZ_YaoLingTiaoZhan_SEVE")
	tbEvent:RegisterEvent(g_emEvent.NpcDeath, TiaoZhan.OnNpcDeath, "XXZ_YaoLingTiaoZhan_SEVE");	
	tbEvent:RegisterEvent(g_emEvent.EquipUpdate, TiaoZhan.OnEquipUpdate, "XXZ_YaoLingTiaoZhan_SEVE")
end

function TiaoZhan.OnDayChange()
	selflist["MeiRiJiShu"] = 3
end

--world:GetSelectThing().PropertyMgr.BodyData:Kill("", false)
function TiaoZhan.OnNpcDeath(t,npc,obj)
	if string.find(npc.Race.Name,"Race_yaoshou_") then
		local jiance = TiaoZhan:YaoLingJianCe()
		if selflist["GWSXList"] ~= nil and jiance ==  true and npc.Camp == g_emFightCamp.Enemy then
			local list = selflist["GWSXList"]
			selflist["GWSXList"] = nil 
			TiaoZhan:DropItem(list[3],npc)
			if selflist["JiShaList"][list[1]][1] == false then
				TiaoZhan:GetJiSha(list[1],{true})
				if list[3] > 0 then
					selflist["RongYu"] = selflist["RongYu"]+list[3]
					world:ShowMsgBox("恭喜你首次击杀"..list[4].."\n获得额外的荣誉值奖励"..list[3].."\n获得荣誉值奖励"..list[2].."\n开启了更高一阶的挑战", "高级解锁")
					return false
				end
				world:ShowMsgBox("成功击杀"..list[4].."\n超出次数的挑战无法获得荣誉值奖励", "妖灵击杀")
			elseif selflist["JiShaList"][list[1]][1] == true then
				if list[3] > 0 then
					selflist["RongYu"] = selflist["RongYu"]+list[2]
					world:ShowMsgBox("成功击杀"..list[4].."\n获得荣誉值奖励"..list[2], "妖灵击杀")
				end
				world:ShowMsgBox("成功击杀"..list[4].."\n超出次数的挑战无法获得荣誉值奖励", "妖灵击杀")
			end
		end
	end
end


function TiaoZhan.OnEquipUpdate(t,npc,obj)
	if selflist["GWSXList"] ~= nil then
		local action = obj[1];		-- 1装备，2激活，3卸下，4反激活
		local item = obj[0]
		if action == 1 then
			local itype = npc:CheckEquipCell(item)
			npc.Equip:UnEquipItem(item,true)
			world:ShowMsgBox("挑战期间无法装备物品， "..item:GetName().."  已被打落", "属性激活")
		elseif action == 2 then
			local gtype = CS.XiaWorld.g_emEquipType
			local fulist = {gtype.Fu1,gtype.Fu2,gtype.Fu3,gtype.Fu4,gtype.Fu5,gtype.Fu6}
			for k,v in pairs(fulist) do
				local equip = npc.Equip:GetEquip(v)
				if equip == item then
					npc.Equip:CloseItemthing(item,v, false, false)
					world:ShowMsgBox("挑战期间无法激活物品， "..item:GetName().."  已被反激活，请在结束后再次手动激活", "属性激活")
				end
			end
		end
	end
end
function TiaoZhan:DropItem(num)
	local dropnum = math.floor(WorldLua:RandomInt(num*0.5,num*1.5))
end


function TiaoZhan:OnSave()
	return selflist
end


function TiaoZhan:OnLoad(t)
	selflist = t or {}
end

function TiaoZhan:OnStep(dt)
	if selflist["JiShaList"] == nil then
		selflist["JiShaList"] = {{false}}
	end
	if selflist["MeiRiJiShu"] == nil then
		selflist["MeiRiJiShu"] = 3
	end
	if selflist["RongYu"] == nil then
		selflist["RongYu"] = 0
	end
end

	
function TiaoZhan:GetGWSXList(text)
	if text == 0 then
		selflist["GWSXList"] = nil
	end
	return selflist["GWSXList"]
end

function TiaoZhan:GetJiSha(num,list)
	if num~= nil and list ~= nil then
		selflist["JiShaList"][num] = list
		local jscount = 0
		for i=1,#selflist["JiShaList"] do 
			if selflist["JiShaList"][i][1] then
				jscount = jscount+1
			end
		end
		if jscount == #selflist["JiShaList"] then
			table.insert(selflist["JiShaList"],{false})
		end
	end
	return selflist["JiShaList"][num]
end
--GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE"):ZengJiaCiShu(10)
function TiaoZhan:ZengJiaCiShu(num)
	if num ~= nil then
		selflist["MeiRiJiShu"] = selflist["MeiRiJiShu"] + num
	end
end
function TiaoZhan:ZhaoHuan(list,key)
	
	if key == nil then
		key = Map:GetRandomInLifeArea(4)
	end
	local yaoshoulist =
{"Race_yaoshou_tu1","Race_yaoshou_lang1","Race_yaoshou_she1","Race_yaoshou_zhu1","Race_yaoshou_xiong1","Race_yaoshou_wa1","Race_yaoshou_gui1","Race_yaoshou_longye1","Race_yaoshou_longzhou1","Race_yaoshou_longe1","Race_yaoshou_longshan1","Race_yaoshou_fei1","Race_yaoshou_lushu1"}
	local yaoshou = yaoshoulist[world:RandomInt(1, #yaoshoulist+1)]
	local enpc = NpcMgr:CreateEliteEnemy(yaoshou ,key , World.map , 0,-1,-1);			
	enpc.LuaHelper:ModifierProperty("ToleranceTMin",-500*list[2])
	enpc.LuaHelper:ModifierProperty("ToleranceTMax",500*list[2])	
	enpc.LuaHelper:ModifierProperty("ComfyTMin",-500*list[2])
	enpc.LuaHelper:ModifierProperty("ComfyTMax",500*list[2])
	enpc.LuaHelper:ModifierProperty("MaxAge",200*list[2])
	enpc.LuaHelper:ModifierProperty("NpcFight_BaseHitChance",1)
	enpc.LuaHelper:ModifierProperty("NpcFight_BaseDodgeChance",0.5)
	if list ~= nil then
		selflist["GWSXList"] = list
		if list[4] ~= nil then
			enpc:SetName(list[4]..enpc:GetName())
		end
	end
	TiaoZhan:ZhanLiFuYu(enpc)
	enpc:AddModifier("Modifier_yaoshou_jianglin",1,false, 1,10000)
end

function TiaoZhan:YaoLingJianCe()
	for k,v in pairs(Map.Things.m_lisNpcs) do
		if v.Camp == g_emFightCamp.Enemy and v.IsEliteEnemy  and string.find(v.Race.Name,"Race_yaoshou_") and v.IsDeath == false then
			return false
		end
	end
	return true
end

function TiaoZhan:ZhanLiFuYu(enpc)
		world:SetRandomSeed();
		local sxlist = {}	--npc属性表
		sxlist["ling"] = 0
		sxlist["jingjie"] = 0
		sxlist["fabao"] = 0
		sxlist["fashu"] = 0
		sxlist["fabaonum"] = 0
		sxlist["fabaoling"] = 0
		sxlist["hudun1"] = 0
		sxlist["hudun2"] = 0
		
			
		for k,v in pairs(Map.Things.m_lisNpcs) do
			if v.Camp == g_emFightCamp.Player and v.IsDisciple and v.Race.RaceType == g_emNpcRaceType.Wisdom then
				local nQ = v:GetProperty("NpcLingMaxValue")						--获取灵力
				local nW = v.PropertyMgr.Practice.LogicStage					--获取境界
				local nE = v:GetProperty("NpcFight_FabaoPowerAddP")				--获取法宝伤害
				local nR = v:GetProperty("NpcFight_SpellPowerAddP")				--获取法术伤害
				local nT = v:GetProperty("NpcFight_FabaoNum")					--获取法宝位数
				local nY = v:GetProperty("NpcFight_FabaoMaxLingAddP")			--获取法宝灵力
				local nU = v:GetProperty("NpcFight_ShieldConversionRateAddP")	--获取护盾加成
				local nI = v:GetProperty("NpcFight_ShieldConversionRate")		--获取护盾加值
				sxlist["ling"] = (sxlist["ling"]+nQ)/2
				sxlist["jingjie"] = (sxlist["jingjie"] + nW)/2
				sxlist["fabao"] = (sxlist["fabao"] + nE)/2
				sxlist["fashu"] = (sxlist["fashu"] + nR)/2
				sxlist["fabaonum"] = (sxlist["fabaonum"] + nT)/2
				sxlist["fabaoling"] = (sxlist["fabaoling"] + nY)/2
				sxlist["hudun1"] = (sxlist["hudun1"] + nU)/2
				sxlist["hudun2"] = (sxlist["hudun2"] + nI)/2
			end
		end
		if enpc ~= nil and selflist["GWSXList"] ~= nil then
			--MessageMgr:AddChainEventMessage(6289,-1,SchoolMgr.Name.."与此日进行了一次"..selflist["GuaiWuCH"].."挑战，召唤出了强大的妖灵："..enpc:GetName() , enpc.Key,0,nil,"挑战开启")
			local qiangdu = selflist["GWSXList"][2]
			local jingjie = enpc.PropertyMgr.Practice.LogicStage
			
			enpc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldResistanceToJin",math.min(0.1+qiangdu/200,0.95));
			enpc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldResistanceToMu",math.min(0.1+qiangdu/200,0.95));
			enpc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldResistanceToShui",math.min(0.1+qiangdu/200,0.95));
			enpc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldResistanceToHuo",math.min(0.1+qiangdu/200,0.95));
			enpc.PropertyMgr:SetPropertyOverwrite("NpcFight_ShieldResistanceToTu",math.min(0.1+qiangdu/200,0.95));
					
			local eling = enpc:GetProperty("YaoShou_BaseLing")						--妖兽灵力获取
			local egongji = enpc:GetProperty("YaoShou_BaseAttack")					--妖兽攻击获取
			local efabao = enpc:GetProperty("NpcFight_FabaoPowerAddP")				--法宝伤害获取
			local efashu = enpc:GetProperty("NpcFight_SpellPowerAddP")				--法术伤害获取
			local ehudun1 = enpc:GetProperty("NpcFight_ShieldConversionRateAddP")	--护盾获取
			local ehudun2 = enpc:GetProperty("NpcFight_ShieldConversionRate")		--护盾获取
			
			enpc.LuaHelper:ModifierProperty("YaoShou_BaseLing",sxlist["ling"]*(1.5+qiangdu/50))
			enpc.LuaHelper:ModifierProperty("YaoShou_BaseAttack",qiangdu)
			enpc.LuaHelper:ModifierProperty("NpcFight_FabaoPowerAddP",sxlist["fabao"]*(1+qiangdu/100))
			enpc.LuaHelper:ModifierProperty("NpcFight_SpellPowerAddP",sxlist["fashu"]*(1+qiangdu/100))
			enpc.LuaHelper:ModifierProperty("NpcFight_ShieldConversionRateAddP",0,sxlist["hudun1"]*(0.5+qiangdu/100))
			enpc.LuaHelper:ModifierProperty("NpcFight_ShieldConversionRate",sxlist["hudun2"]*(0.5+qiangdu/100))
			
			enpc:AddLing(enpc:GetProperty("YaoShou_BaseLing")-enpc.LingV)
		end
end
	
function TiaoZhan:DropItem(num,npc)
	local list = TiaoZhan:DropItemList(num)
	if npc ~= nil and num ~= nil then
		for k,v in pairs(list) do
			local check = v[1]*(1+num/50)
			local tname = ThingMgr:GetDef(g_emThingType.Item,v[2])
			if WorldLua:CheckRate(check) and tname then
				local count = 0
				if v[3] <= 0 then
					count = math.abs(v[3])
				else
					count = math.floor(math.max(1,v[3]*(1+num/15)))
				end
				print(count)
				npc.LuaHelper:DropAwardItem(v[2],count,"",-1,1)
			end
		end
	end
	
end



function TiaoZhan:RongYuWuPin(tables)
	local list = {
	{"星宿符文","Item_fumo_fuwen_dong1",1500},
	{"星宿符文","Item_fumo_fuwen_dong2",1500},
	{"星宿符文","Item_fumo_fuwen_dong3",1500},
	{"星宿符文","Item_fumo_fuwen_dong4",1500},
	{"星宿符文","Item_fumo_fuwen_dong5",1500},
	{"星宿符文","Item_fumo_fuwen_dong6",1500},
	{"星宿符文","Item_fumo_fuwen_dong7",1500},
	{"星宿符文","Item_fumo_fuwen_nan1",1500},
	{"星宿符文","Item_fumo_fuwen_nan2",1500},
	{"星宿符文","Item_fumo_fuwen_nan3",1500},
	{"星宿符文","Item_fumo_fuwen_nan4",1500},
	{"星宿符文","Item_fumo_fuwen_nan5",1500},
	{"星宿符文","Item_fumo_fuwen_nan6",1500},
	{"星宿符文","Item_fumo_fuwen_nan7",1500},
	{"星宿符文","Item_fumo_fuwen_xi1",1500},
	{"星宿符文","Item_fumo_fuwen_xi2",1500},
	{"星宿符文","Item_fumo_fuwen_xi3",1500},
	{"星宿符文","Item_fumo_fuwen_xi4",1500},
	{"星宿符文","Item_fumo_fuwen_xi5",1500},
	{"星宿符文","Item_fumo_fuwen_xi6",1500},
	{"星宿符文","Item_fumo_fuwen_xi7",1500},
	{"星宿符文","Item_fumo_fuwen_bei1",1500},
	{"星宿符文","Item_fumo_fuwen_bei2",1500},
	{"星宿符文","Item_fumo_fuwen_bei3",1500},
	{"星宿符文","Item_fumo_fuwen_bei4",1500},
	{"星宿符文","Item_fumo_fuwen_bei5",1500},
	{"星宿符文","Item_fumo_fuwen_bei6",1500},
	{"星宿符文","Item_fumo_fuwen_bei7",1500},
	{"特殊符文","Item_fumo_qiling1",50},
	{"特殊符文","Item_fumo_qiling2",100},
	{"特殊符文","Item_fumo_qiling3",200},
	{"特殊符文","Item_fumo_qiling4",500},
	{"特殊符文","Item_fumo_chongzhu1",10},
	{"特殊符文","Item_fumo_chongzhu2",20},
	{"特殊符文","Item_fumo_chongzhu3",30},
	{"特殊符文","Item_fumo_chongzhu4",50},
	{"特殊符文","Item_fumo_chongzhu5",50},
	{"特殊符文","Item_fumo_fuwen_pinzhi1",10},
	{"特殊符文","Item_fumo_fuwen_pinzhi2",20},
	{"特殊符文","Item_fumo_fuwen_pinzhi3",50},
	{"特殊符文","Item_fumo_fuwen_pinzhi4",100},
	{"特殊符文","Item_fumo_fuwen_pinzhi5",200},
	{"特殊符文","Item_fumo_fuwen_leijie1",10},
	{"特殊符文","Item_fumo_fuwen_leijie2",20},
	{"特殊符文","Item_fumo_fuwen_leijie3",50},
	{"特殊符文","Item_fumo_fuwen_leijie4",100},
	{"特殊符文","Item_fumo_fuwen_leijie5",200},
	{"特殊符文","Item_fumo_fuwen_pinjie1",200},
	{"特殊符文","Item_fumo_fuwen_meiguan1",100},
	{"强化符文","Item_fumo_suipian1",10},
	{"强化符文","Item_fumo_suipian2",20},
	{"强化符文","Item_fumo_suipian3",35},
	{"强化符文","Item_fumo_suipian4",55},
	{"强化符文","Item_fumo_suipian5",80},
	{"强化符文","Item_fumo_suipian6",110},
	{"强化符文","Item_fumo_suipian7",150},
	{"强化符文","Item_fumo_suipian8",200},
	{"强化符文","Item_fumo_suipian9",260},
	{"强化符文","Item_fumo_suipian10",350},
	{"强化符文","Item_qianghua_suipian1",20},
	{"强化符文","Item_qianghua_suipian2",16},
	{"强化符文","Item_qianghua_suipian3",13},
	{"强化符文","Item_qianghua_suipian4",10},
	{"强化符文","Item_qianghua_suipian5",10},
	{"强化符文","Item_qianghua_suipian6",10},
	{"强化符文","Item_qianghua_suipian7",10},
	{"强化符文","Item_qianghua_suipian8",10},
	{"强化符文","Item_qianghua_suipian9",10},
	{"强化符文","Item_qianghua_suipian10",10},
	{"附魔符文","Item_fumo_fuwen_1",100},
	{"附魔符文","Item_fumo_fuwen_2",100},
	{"附魔符文","Item_fumo_fuwen_3",100},
	{"附魔符文","Item_fumo_fuwen_4",100},
	{"附魔符文","Item_fumo_fuwen_5",100},
	{"附魔符文","Item_fumo_fuwen_6",100},
	{"附魔符文","Item_fumo_fuwen_7",100},
	{"附魔符文","Item_fumo_fuwen_8",100},
	{"附魔符文","Item_fumo_fuwen_9",100},
	{"附魔符文","Item_fumo_fuwen_10",100},
	{"附魔符文","Item_fumo_fuwen_11",100},
	{"附魔符文","Item_fumo_fuwen_12",100},
	{"附魔符文","Item_fumo_fuwen_13",100},
	{"附魔符文","Item_fumo_fuwen_14",100},
	{"附魔符文","Item_fumo_fuwen_15",100},
	{"附魔符文","Item_fumo_fuwen_16",100},
	{"附魔符文","Item_fumo_fuwen_17",100},
	{"附魔符文","Item_fumo_fuwen_18",100},
	{"附魔符文","Item_fumo_fuwen_19",100},
	{"附魔符文","Item_fumo_fuwen_20",100},
	{"附魔符文","Item_fumo_fuwen_21",100},
	{"附魔符文","Item_fumo_fuwen_22",100},
	{"附魔符文","Item_fumo_fuwen_23",100},
	{"附魔符文","Item_fumo_fuwen_24",100},
	{"附魔符文","Item_fumo_fuwen_25",100},
	{"附魔符文","Item_fumo_fuwen_26",100},
	{"附魔符文","Item_fumo_fuwen_27",100},
	{"附魔符文","Item_fumo_fuwen_28",100},
	{"附魔符文","Item_fumo_fuwen_29",100},
	{"附魔符文","Item_fumo_fuwen_30",100},
	{"附魔符文","Item_fumo_fuwen_31",100},
	{"附魔符文","Item_fumo_fuwen_32",100},
	{"附魔符文","Item_fumo_fuwen_33",100},
	{"附魔符文","Item_fumo_fuwen_34",100},
	{"附魔符文","Item_fumo_fuwen_35",100},
	{"附魔符文","Item_fumo_fuwen_36",100},
	{"附魔符文","Item_fumo_fuwen_37",100},
	{"附魔符文","Item_fumo_fuwen_38",100},
	{"附魔符文","Item_fumo_fuwen_39",100},
	{"附魔符文","Item_fumo_fuwen_40",100},
	{"附魔符文","Item_fumo_fuwen_41",100},
	{"附魔符文","Item_fumo_fuwen_42",100},
	{"附魔符文","Item_fumo_fuwen_43",100},
	{"附魔符文","Item_fumo_fuwen_44",100},
	{"附魔符文","Item_fumo_fuwen_45",100},
	{"附魔符文","Item_fumo_fuwen_46",100},
	{"附魔符文","Item_fumo_fuwen_47",100},
	{"附魔符文","Item_fumo_fuwen_48",100},
	{"附魔符文","Item_fumo_fuwen_49",100},
	{"附魔符文","Item_fumo_fuwen_50",100},
	{"附魔符文","Item_fumo_fuwen_51",100},
	{"附魔符文","Item_fumo_fuwen_52",100},
	{"附魔符文","Item_fumo_fuwen_53",100},
	{"附魔符文","Item_fumo_fuwen_54",100},
	{"附魔符文","Item_fumo_fuwen_55",100},
	{"附魔符文","Item_fumo_fuwen_56",100},
	{"附魔符文","Item_fumo_fuwen_57",100},
	{"附魔符文","Item_fumo_fuwen_58",100},
	{"附魔符文","Item_fumo_fuwen_59",100},
	{"附魔符文","Item_fumo_fuwen_60",100},
	{"附魔符文","Item_fumo_fuwen_61",100},
	{"附魔符文","Item_fumo_fuwen_62",100},
	{"附魔符文","Item_fumo_fuwen_63",100},
	{"附魔符文","Item_fumo_fuwen_64",100},
	
	
	{"兽皮翎羽","Item_shoupi1",100},
	{"兽皮翎羽","Item_shoupi2",200},
	{"兽皮翎羽","Item_shoupi3",500},
	{"兽皮翎羽","Item_shoupi4",1000},
	{"兽皮翎羽","Item_shoupi5",2000},
	{"兽皮翎羽","Item_yumao1",100},
	{"兽皮翎羽","Item_yumao2",200},
	{"兽皮翎羽","Item_yumao3",500},
	{"兽皮翎羽","Item_yumao4",1000},
	{"兽皮翎羽","Item_yumao5",2000},
	
	{"角色专属","Item_zhuanshu_lingpai_luxueqi",10000},
	{"角色专属","Item_zhuanshu_lingpai_biyao",10000},
	{"角色专属","Item_zhuanshu_lingpai_sunwukong",10000},
	{"角色专属","Item_zhuanshu_lingpai_lvbu",10000},
	{"角色专属","Item_zhuanshu_lingpai_libai",10000},
	{"角色专属","Item_zhuanshu_lingpai_guanyu",10000},
	{"角色专属","Item_zhuanshu_lingpai_yuji",10000},
	{"角色专属","Item_zhuanshu_lingpai_diaochan",10000},
	{"角色专属","Item_zhuanshu_lingpai_zixia",10000},
	
	{"造化圣物","Item_zhuanshu_bianshen_1",2},
	{"造化圣物","Item_jinghua_jiejing1",10},
	{"造化圣物","Item_zhiwu_jingping_1",1000},
	{"造化圣物","Item_zaohua_tu_1",100},
	{"造化圣物","Item_zaohua_tu_2",100},
	{"造化圣物","Item_zaohua_tu_3",100},
	{"造化圣物","Item_zaohua_tu_4",100},
	{"造化圣物","Item_zaohua_tu_5",100},
	{"造化圣物","Item_zaohua_tu_6",100},
	{"造化圣物","Item_zaohua_tu_7",100},
	{"造化圣物","Item_zaohua_shui_1",100},
	{"造化圣物","Item_zaohua_shui_2",100},
	{"造化圣物","Item_zaohua_shui_3",100},
	{"造化圣物","Item_zaohua_shui_4",100},
	{"造化圣物","Item_zaohua_shui_5",100},
	{"造化圣物","Item_zaohua_shui_6",100},
	{"造化圣物","Item_zaohua_shui_7",100},
	
	{"妖灵内丹","Item_yaoshou_neidan1",200},
	{"妖灵内丹","Item_yaoshou_neidan2",200},
	{"妖灵内丹","Item_yaoshou_neidan3",200},
	{"妖灵内丹","Item_yaoshou_neidan4",200},
	{"妖灵内丹","Item_yaoshou_neidan5",150},
	{"妖灵内丹","Item_yaoshou_neidan6",150},
	{"妖灵内丹","Item_yaoshou_neidan7",150},
	{"妖灵内丹","Item_yaoshou_neidan8",150},
	{"妖灵内丹","Item_yaoshou_neidan9",150},
	{"妖灵内丹","Item_yaoshou_neidan10",150},
	{"妖灵内丹","Item_yaoshou_neidan11",150},
	{"妖灵内丹","Item_yaoshou_neidan12",150},
	{"妖灵内丹","Item_yaoshou_neidan13",240},
	{"妖灵内丹","Item_yaoshou_neidan14",240},
	{"妖灵内丹","Item_yaoshou_neidan15",240},
	{"妖灵内丹","Item_lingshui_1",20},
	{"妖灵内丹","Item_lingshui_2",50},
	{"妖灵内丹","Item_lingshui_3",100},
	
	{"五行灵丹","Item_dan_shuxing_jin1",20},
	{"五行灵丹","Item_dan_shuxing_mu1",20},
	{"五行灵丹","Item_dan_shuxing_shui1",20},
	{"五行灵丹","Item_dan_shuxing_huo1",20},
	{"五行灵丹","Item_dan_shuxing_tu1",20},
	{"五行灵丹","Item_dan_shuxing_jin2",50},
	{"五行灵丹","Item_dan_shuxing_mu2",50},
	{"五行灵丹","Item_dan_shuxing_shui2",50},
	{"五行灵丹","Item_dan_shuxing_huo2",50},
	{"五行灵丹","Item_dan_shuxing_tu2",50},
	{"五行灵丹","Item_dan_shuxing_wuxing1",90},
	{"五行灵丹","Item_dan_shuxing_wuxing2",170},
	{"五行灵丹","Item_dan_lingli_lingli1",10},
	{"五行灵丹","Item_dan_lingli_lingli2",20},
	{"五行灵丹","Item_dan_lingli_lingli3",30},
	{"五行灵丹","Item_dan_lingli_lingli4",40},
	{"五行灵丹","Item_dan_lingli_lingli5",49},
	
	{"挑战灵丹","Item_Dan_yongjiu_fabao",30},
	{"挑战灵丹","Item_Dan_yongjiu_fashu",30},
	{"挑战灵丹","Item_Dan_yongjiu_hudun",25},
	{"挑战灵丹","Item_Dan_yongjiu_xuexi",20},
	{"挑战灵丹","Item_Dan_yongjiu_lilian",10},
	{"挑战灵丹","Item_Dan_yongjiu_xiulian",10},
	{"挑战灵丹","Item_Dan_yongjiu_gongzuo",8},
	{"挑战灵丹","Item_Dan_yongjiu_yidong",5},
	{"挑战灵丹","Item_Dan_yongjiu_shouming",5},
	{"挑战灵丹","Item_Dan_yongjiu_tianqian",10},
	{"挑战灵丹","Item_Dan_yongjiu_daohang",10},
	{"挑战灵丹","Item_Dan_yongjiu_canwu",50},
	{"挑战灵丹","Item_Dan_xianshi_xiulian",10},
	{"挑战灵丹","Item_Dan_xianshi_shanghai",10},
	{"挑战灵丹","Item_Dan_xianshi_fangyu",10},
	{"挑战灵丹","Item_Dan_xianshi_lianbao",10},
	{"挑战灵丹","Item_Dan_xianshi_liandan",10},
	}

	if tables ~= nil then
		if tables[1] ~= nil then
			local wplist = {}
			for k,v in pairs(list) do
				if v[1] == tables[1] then
					table.insert(wplist,{v[2],v[3]})
				end
			end
			return wplist
		elseif tables[2] ~= nil then
			for k,v in pairs(list) do
				if v[2] == tables[2] then
					return v[3]
				end
			end
		end
	end


	return list

end


-- GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE"):DropItemList(num)
function TiaoZhan:DropItemList(num)
	local num = num or 1
	local yaodan = "Item_yaoshou_neidan"..WorldLua:RandomInt(1,16)
	local lingguo = {"Item_lingguo_jin","Item_lingguo_mu","Item_lingguo_shui","Item_lingguo_huo","Item_lingguo_tu"}
	local lingguo = lingguo[WorldLua:RandomInt(1,#lingguo+1)]
	local pimao = {"Item_shoupi","Item_yumao"}
	local pimao = pimao[WorldLua:RandomInt(1,#pimao+1)]
	local lingshi = {"Item_lingshi_jin","Item_lingshi_mu","Item_lingshi_shui","Item_lingshi_huo","Item_lingshi_tu","Item_lingshi_yuan","Item_lingshi_hun"}
	local lingshi = lingshi[WorldLua:RandomInt(1,#lingshi+1)]
	
	local fmfw = "Item_fumo_fuwen_"..WorldLua:RandomInt(1,65)
	local qhfw = "Item_qianghua_suipian"..WorldLua:RandomInt(1,11)
	local tsfw = "Item_fumo_suipian"..WorldLua:RandomInt(1,math.floor(math.min(11,1+num/10)))
	
	local qlfw = "Item_fumo_qiling"..WorldLua:RandomInt(1,math.floor(math.min(5,1+num/30)))
	local czfw = "Item_fumo_chongzhu"..WorldLua:RandomInt(1,math.floor(math.min(6,1+num/20)))
	local pzfw = "Item_fumo_fuwen_pinzhi"..WorldLua:RandomInt(1,math.floor(math.min(6,1+num/20)))
	local ljfw = "Item_fumo_fuwen_leijie"..WorldLua:RandomInt(1,math.floor(math.min(6,1+num/20)))
	local sxfw = {"Item_fumo_fuwen_dong","Item_fumo_fuwen_xi","Item_fumo_fuwen_nan","Item_fumo_fuwen_bei"}
	local sxfw = sxfw[WorldLua:RandomInt(1,#sxfw+1)]..WorldLua:RandomInt(1,8)
	
	local droplist = {
	{ 1 , "Item_lingshi_canpian" , 5 },
	{ 0.3 , fmfw , -1 },
	{ 0.3 , qhfw , 0.1 },
	{ 0.1 , tsfw , 0.1 },
	{ 0.1 , czfw , -1 },
	{ 0.1 , pzfw , -1 },
	{ 0.1 , ljfw , -1 },
	{ 0.05 , qlfw , -1 },
	{ 0.005 , sxfw , -1 },
	{ 0.05 , "Item_SoulCrystalYou" , 0.2 },
	{ 0.05 , "Item_SoulCrystalLing" , 0.2 },
	{ 0.05 , "Item_SoulCrystalNing" , 0.2 },
	{ 0.05 , "Item_Yao_BoarMeat" , 0.3 },
	{ 0.1 , "Item_lingshui_1" , 0.5 },
	{ 0.05 , "Item_lingshui_2" , 0.2 },
	{ 0.02 , "Item_lingshui_3" , 0.1 },
	{ 0.01 , yaodan , -1 },
	{ 0.03 , pimao.."1" , 0.05 },
	{ 0.01 , pimao.."2" , 0.02 },
	{ 0.005 , pimao.."3" , 0.01 },
	{ 0.002 , pimao.."4" , -1 },
	{ 0.001 , pimao.."5" , -1 },
	{ 0.4 , lingguo.."1" , 0.4 },
	{ 0.3 , lingguo.."2" , 0.3 },
	{ 0.2 , lingguo.."3" , 0.2 },
	{ 0.1 , lingguo.."4" , 0.1 },
	{ 0.07 , lingguo.."5" , 0.05 },
	{ 0.03 , lingguo.."6" , 0.02 },
	{ 0.01 , lingguo.."7" , 0.01 },
	{ 0.008 , lingguo.."8" , -1 },
	{ 0.005 , lingguo.."9" , -1 },
	{ 0.002 , lingguo.."10" , -1 },
	{ 0.001 , lingguo.."11" , -1 },
	{ 0.05 , lingshi.."1" , 0.4 },
	{ 0.02 , lingshi.."2" , 0.3 },
	{ 0.01 , lingshi.."3" , 0.2 },
	{ 0.005 , lingshi.."4" , 0.1 },
	{ 0.005 , lingshi.."5" , 0.5 },
	{ 0.002 , lingshi.."6" , 0.02 },
	{ 0.001 , lingshi.."7" , -1 },
	{ 0.0008 , lingshi.."8" , -1 },
	{ 0.0005 , lingshi.."9" , -1 },
	{ 0.0001 , lingshi.."10" , -1 },
	{ 0.0001 , lingshi.."11" , -1 },
	}
	return droplist
end



































































































































