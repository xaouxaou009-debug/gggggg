local BXKQ = GameMain:GetMod("XXZEvent_baoxiang_kaiqi1")
local shenghualist = 
{
{80,"Item_fumo_suipian1"},
{55,"Item_fumo_suipian2"},
{45,"Item_fumo_suipian3"},
{35,"Item_fumo_suipian4"},
{25,"Item_fumo_suipian5"},
{16,"Item_fumo_suipian6"},
{8,"Item_fumo_suipian7"},
{4,"Item_fumo_suipian8"},
{2,"Item_fumo_suipian9"},
{1,"Item_fumo_suipian10"},
}
local qilinglist = 
{
{10,"Item_fumo_qiling1"},
{4,"Item_fumo_qiling2"},
{2,"Item_fumo_qiling3"},
{1,"Item_fumo_qiling4"},
}
local chongzhulist = 
{
{15,"Item_fumo_chongzhu1"},
{12,"Item_fumo_chongzhu2"},
{9,"Item_fumo_chongzhu3"},
{3,"Item_fumo_chongzhu4"},
{1,"Item_fumo_chongzhu5"},
}
local weizhilist = 
{
{15,"Item_fumo_fuwen1"},
{12,"Item_fumo_fuwen2"},
{9,"Item_fumo_fuwen3"},
{3,"Item_fumo_fuwen4"},
{1,"Item_fumo_fuwen5"},
}
local pinzhipinjielist = 
{
{15,"Item_fumo_fuwen_pinzhi1"},
{10,"Item_fumo_fuwen_pinzhi2"},
{7,"Item_fumo_fuwen_pinzhi3"},
{4,"Item_fumo_fuwen_pinzhi4"},
{2,"Item_fumo_fuwen_pinzhi5"},
{8,"Item_fumo_fuwen_pinjie1"},
{8,"Item_fumo_fuwen_meiguan1"},
{10,"Item_fumo_fuwen_leijie1"},
{7,"Item_fumo_fuwen_leijie2"},
{4,"Item_fumo_fuwen_leijie3"},
{2,"Item_fumo_fuwen_leijie4"},
{1,"Item_fumo_fuwen_leijie5"},
}


function BXKQ:KaiQi(item)
	local name = item.def.Name
	local count = item.Count
	local key = item.Key
	local num = 1
	
	ThingMgr:RemoveThing(item);
	for i=1,count do
		if name == "Item_baoxiang_shenmi1" then
			wupin = {"Item_fumo_fuwen_dong","Item_fumo_fuwen_xi","Item_fumo_fuwen_nan","Item_fumo_fuwen_bei"}
			wupin = wupin[WorldLua:RandomInt(1,#wupin+1)]
			wupin = wupin..WorldLua:RandomInt(1,8)
		end
		if name == "Item_baoxiang_shenmi2" then
			wupin = Lib:CountRateTable(shenghualist, 1)
			wupin = shenghualist[wupin][2]
		end
		if name == "Item_baoxiang_shenmi3" then
			wupin = Lib:CountRateTable(qilinglist, 1)
			wupin = qilinglist[wupin][2]
		end
		if name == "Item_baoxiang_shenmi4" then
			wupin = Lib:CountRateTable(chongzhulist, 1)
			wupin = chongzhulist[wupin][2]
		end
		if name == "Item_baoxiang_shenmi5" then
			wupin = Lib:CountRateTable(weizhilist, 1)
			wupin = weizhilist[wupin][2]
		end
		if name == "Item_baoxiang_shenmi6" then
			wupin = "Item_fumo_fuwen_"..WorldLua:RandomInt(1,65)
		end
		if name == "Item_baoxiang_shenmi7" then
			wupin = "Item_qianghua_suipian"..WorldLua:RandomInt(1,11)
			num = 3
		end
		if name == "Item_baoxiang_shenmi8" then
			wupin = Lib:CountRateTable(pinzhipinjielist, 1)
			wupin = pinzhipinjielist[wupin][2]
		end
		if wupin ~= nil then
			wupin = ItemRandomMachine.RandomItem(wupin,nil,1,12,1,num)
			Map:DropItem(wupin, key, true, true, false, true, 0, false)
		end
	end
end














