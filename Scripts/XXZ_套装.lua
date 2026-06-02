local YSlist = GameMain:GetMod("XXZ_yaoshoulist")
local tbEvent = GameMain:GetMod("_Event");

local WQlist ={
{ZBname= "Item_wuqi_yiji_gong1" ,JC = 0.5 ,XS = 0 },
{ZBname= "Item_wuqi_yiji_dao1" ,JC = 0.5 ,XS = 0 },
{ZBname= "Item_wuqi_yiji_qiang1" ,JC = 0.5 ,XS = 0 },
{ZBname= "Item_wuqi_yiji_jian1" ,JC = 0.5 ,XS = 0 },
{ZBname= "Item_wuqi_yiji_chui1" ,JC = 0.5 ,XS = 0 },
{ZBname= "Item_wuqi_yiji_huan1" ,JC = 0.5 ,XS = 0 },
{ZBname= "Item_wuqi_erji_gong2" ,JC = 0.8 ,XS = 0 },
{ZBname= "Item_wuqi_erji_dao2" ,JC = 0.8 ,XS = 0 },
{ZBname= "Item_wuqi_erji_qiang2" ,JC = 0.8 ,XS = 0 },
{ZBname= "Item_wuqi_erji_jian2" ,JC = 0.8 ,XS = 0 },
{ZBname= "Item_wuqi_erji_chui2" ,JC = 0.8 ,XS = 0 },
{ZBname= "Item_wuqi_erji_huan2" ,JC = 0.8 ,XS = 0 },
{ZBname= "Item_wuqi_sanji_jian1" ,JC = 1.2 ,XS = 0},

{ZBname= "Item_wuqi_lingjian_1" ,JC = 0.5 ,XS = 1 },
{ZBname= "Item_wuqi_lingjian_2" ,JC = 0.5 ,XS = 1 },
{ZBname= "Item_wuqi_lingjian_3" ,JC = 0.5 ,XS = 1 },
{ZBname= "Item_wuqi_lingjian_4" ,JC = 0.5 ,XS = 1 },
{ZBname= "Item_wuqi_lingjian_5" ,JC = 0.5 ,XS = 1 },
{ZBname= "Item_wuqi_wuxingjian1" ,JC = 1 ,XS = 1 },
{ZBname= "Item_wuqi_wuxingjian2" ,JC = 2 ,XS = 1 },
}

local YFlist ={
{SYname= "Item_shangyi_tiangong" ,XYname= "Item_xiayi_tiangong" ,JC = 0.5 ,XS = 0 },
{SYname= "Item_shangyi_tianqiao" ,XYname= "Item_xiayi_tianqiao" ,JC = 0.5 ,XS = 0 },
{SYname= "Item_shangyi_tianyuan" ,XYname= "Item_xiayi_tianyuan" ,JC = 0.5 ,XS = 0 },
{SYname= "Item_shangyi_tianling" ,XYname= "Item_xiayi_tianling" ,JC = 1 ,XS = 0 },

{SYname= "Item_shangyi_xuanjiu" ,XYname= "Item_xiayi_xuanjiu" ,JC = 0.5 ,XS = 1 },
{SYname= "Item_shangyi_jiuzhuan" ,XYname= "Item_xiayi_jiuzhuan" ,JC = 0.5 ,XS = 1 },
{SYname= "Item_shangyi_bailian" ,XYname= "Item_xiayi_bailian" ,JC = 0.5 ,XS = 1 },
{SYname= "Item_shangyi_yuqing" ,XYname= "Item_xiayi_yuqing" ,JC = 0.8 ,XS = 1 },
{SYname= "Item_shangyi_taiqing" ,XYname= "Item_xiayi_taiqing" ,JC = 0.8 ,XS = 1 },
{SYname= "Item_shangyi_shangqing" ,XYname= "Item_xiayi_shangqing" ,JC = 0.8 ,XS = 1 },
{SYname= "Item_shangyi_taiji" ,XYname= "Item_xiayi_taiji" ,JC = 1.2 ,XS = 1 },

{SYname= "Item_shangyi_wuji1" ,XYname= "Item_xiayi_wuji1" ,JC = 2 ,XS = 1 },
{SYname= "Item_shangyi_wuji2" ,XYname= "Item_xiayi_wuji2" ,JC = 2 ,XS = 1 },
{SYname= "Item_shangyi_wufa1" ,XYname= "Item_xiayi_wufa1" ,JC = 2 ,XS = 1 },
{SYname= "Item_shangyi_wufa2" ,XYname= "Item_xiayi_wufa2" ,JC = 2 ,XS = 1 },
}

function YSlist:DDKQ()
	PlacesMgr:UnLockPlace("Place_qingyunshan", 0, true)
	PlacesMgr:UnLockPlace("Place_qingyunshan1", 0, true)
	PlacesMgr:UnLockPlace("Place_qingyunshan2", 0, true)
	PlacesMgr:UnLockPlace("Place_qingyunshan3", 0, true)
	PlacesMgr:UnLockPlace("Place_youmingjian", 0, true)
	PlacesMgr:UnLockPlace("Place_youmingjian1", 0, true)
	PlacesMgr:UnLockPlace("Place_youmingjian2", 0, true)
	PlacesMgr:UnLockPlace("Place_youmingjian3", 0, true)
	PlacesMgr:UnLockPlace("Place_youmingjian4", 0, true)
	PlacesMgr:UnLockPlace("Place_youmingjian5", 0, true)
end


function YSlist:OnEnter()
	tbEvent:RegisterEvent(g_emEvent.EquipUpdate, YSlist.OnEquipUpdate, "zhuangbei_taozhuang_jihuo");	--
end

function YSlist.OnEquipUpdate(t,npc,obj)
	if t ~= "zhuangbei_taozhuang_jihuo" then
		return false
	end
	
	local npc = npc;
	if npc.Camp ~= g_emFightCamp.Player then
		return
	end
	local action = obj[1];		-- 1装备，2激活，3卸下，4反激活
	local item = obj[0]
	local wuqihq = npc.Equip:GetWeapon()
	local shangyihq = npc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.Clothes)
	local xiayihq = npc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.Trousers)
	
	if action == 1 then 
	
		if wuqihq ~= nil and shangyihq ~= nil and xiayihq ~= nil then		--套装激活
			local wuqi = wuqihq.def.Name
			local shangyi = shangyihq.def.Name
			local xiayi = xiayihq.def.Name
			local wuqijc
			local yifujc
			local wuqixs
			local yifuxs
			for k,v in pairs(WQlist) do 
				if wuqi == v.ZBname then
					wuqijc = v.JC
					wuqixs = v.XS
				end
			end
			for k,v in pairs(YFlist) do 
				if shangyi == v.SYname and xiayi == v.XYname then
					yifujc = v.JC
					yifuxs = v.XS
				end
			end
			if wuqixs == 0 and yifuxs == 0 and npc.IsDisciple then
				world:ShowMsgBox(npc:GetName().."并不是外门弟子，[color=#FF7F00]外门套装[/color] 隐藏属性无法激活！！！", "激活失败")
				return false 
			end
			if wuqixs == 1 and yifuxs == 1 and not npc.IsDisciple then
				world:ShowMsgBox(npc:GetName().."并不是内门弟子，[color=#FF7F00]仙道灵韵[/color] 隐藏属性无法激活！！！", "激活失败")
				return false 
			end
			
			if (wuqixs == 1 and yifuxs == 1) or (wuqixs == 0 and yifuxs == 0) then
				local pinzhi = (wuqihq:GetQuality()+shangyihq:GetQuality()+xiayihq:GetQuality())/6
				local pinjie = (wuqihq.Rate+shangyihq.Rate+xiayihq.Rate)/36
				local beauty = (wuqihq.Beauty+shangyihq.Beauty+xiayihq.Beauty)/240
				local zhiliang = (wuqihq:GetQualityEquipValue()+shangyihq:GetQualityEquipValue()+xiayihq:GetQualityEquipValue())/6
				local jiacheng = pinzhi+pinjie+beauty+zhiliang
			
			
				if npc.IsDisciple then
					local beishu = npc.PropertyMgr.Practice.LogicStage or 12
					world:ShowMsgBox(npc:GetName().."装备了[color=#FF7F00]仙道灵韵[/color]套装，激活专属属性！！！", "属性激活")
					npc:AddModifier("Modifier_zhuangbei_taozhuang_neimen1",jiacheng*beishu/10)
				end
			
				if not npc.IsDisciple then
					local beishu = npc.PropertyMgr.Physique
					world:ShowMsgBox(npc:GetName().."装备了[color=#FF7F00]天道酬勤[/color]套装，激活专属属性！！！", "属性激活")
					npc:AddModifier("Modifier_zhuangbei_taozhuang_waimen1",jiacheng*beishu/10)
				end
			end
		end
		
	elseif action == 3 then 
	
		local wuqijiancha = 0
		for k,v in pairs(WQlist) do 
			if wuqihq == v.ZBname then
				wuqijiancha = 1
			end
		end
	
		if wuqijiancha == 0 or shangyihq == nil or xiayihq == nil then
			npc:RemoveModifier("Modifier_zhuangbei_taozhuang_waimen1")
			npc:RemoveModifier("Modifier_zhuangbei_taozhuang_neimen1")
		end 
	end
	
end


















