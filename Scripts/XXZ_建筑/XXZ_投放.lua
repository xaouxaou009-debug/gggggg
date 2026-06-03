local TouFang = GameMain:GetMod("Lua_JianZhu_TouFang")
local selflist = selflist or {}


function TouFang:OnSave()
	return selflist
end


function TouFang:OnLoad(t)
	selflist = t or {}
end


function TouFang:OnInit()
end


function TouFang:OnEnter()
end

 
function TouFang:OnStep(dt)
end 






function TouFang.JianZhuYiChu(building)
	CS.Wnd_Message.Show(nil, 2,
		function (s)
		if s == "1" then
			ThingMgr:RemoveThing(building);
		end
	end, true, "拆除", 0, 0, "是否确定拆除这个建筑？\n拆除后建筑直接消失！");
end

local richanglist = 
{
{1,"Item_baoxiang_shenmi1",1},	--星宿
{3,"Item_baoxiang_shenmi2",1},	--升华
{2,"Item_baoxiang_shenmi3",1},	--启灵
{2,"Item_baoxiang_shenmi4",1},	--重铸
{8,"Item_baoxiang_shenmi5",1},	--未知
{7,"Item_baoxiang_shenmi6",1},	--天命
{12,"Item_baoxiang_shenmi7",1},	--强化
{5,"Item_baoxiang_shenmi8",1},	--淬炼
}


function TouFang:RiChangJiangLi(num,item)
	local num = num
	local item = item
	if item == nil then
		key = Map:GetRandomInLifeArea(4)
	else 
		key = item.Key
		num = num*item.Count
		ThingMgr:RemoveThing(item)
	end
	for i=1,(num or 1) do
		local radom = Lib:CountRateTable(richanglist, 1)
		local wupin = richanglist[radom][2]
		local count = richanglist[radom][3]
		if wupin ~= nil then
			wupin = ItemRandomMachine.RandomItem(wupin,nil,1,12,1,count)
			Map:DropItem(wupin, key, true, true, false, true, 0, false)
			world:PlayEffect(37, wupin.Key, 2)
		end
	end
	
end














