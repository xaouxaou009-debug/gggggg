local tbThing = GameMain:GetMod("ThingHelper"):GetThing("Lua_baowu_baguaheyi");
local selflist = selflist or {}
local it

function tbThing:OnInit()
end

function tbThing:OnGetSaveData()
end



function tbThing:OnLoadData(tbData)
end

function tbThing:OnStep(dt)
	it = self.it
	
	tbThing:WuPinJianCe(it)
	local count = 0
	for i=1,8 do
		local oldit = ThingMgr:FindThingByID(selflist[i])
		if oldit == nil then
			return false
		end
		if string.find(oldit.def.Name,"Item_baowu_bagua") then
			count = count+1
		end
	end
	local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"八卦合一")
	if count == 8 then
		if btn == false then
			it:AddBtnData("八卦合一","Icon/29.png","GameMain:GetMod('ThingHelper'):GetThing('Lua_baowu_baguaheyi'):BaGuaHeYi(bind)","八卦残片齐聚，召唤地图上的其他碎片合而为一");
		end
	else
		it:RemoveBtnData("八卦合一")
	end
end



function tbThing:WuPinJianCe(it)
	local name = it.def.Name
	for i=1,8 do
		if name == "Item_baowu_bagua"..i then
			selflist[i] = it.ID
		end
	end
end

function tbThing:BaGuaHeYi(it)
	it:RemoveBtnData("八卦合一")
	local count = 0
	local itkey = it.Key
	for i=1,8 do
		local oldit = ThingMgr:FindThingByID(selflist[i])
		if oldit == nil then
			return false
		end
		if string.find(oldit.def.Name,"Item_baowu_bagua") then
			count = count+1
		end
	end
	if count == 8 then
		CS.Wnd_Message.Show(nil, 2,
		function (s)
			if s == "1" then
				for i=1,8 do
					oldit = ThingMgr:FindThingByID(selflist[i])
					Map:DropItem(oldit, itkey, true, true, false, true, 0, false)
					local olditkey = oldit.Key
					if oldit.def.Name ~= it.def.Name then
						ThingMgr:RemoveThing(oldit)
						selflist[i] = nil
						world:FlyLineEffect(olditkey,itkey, 1,
						function(p)
							ThingMgr:RemoveThing(it)
							if count ~= 0 then
								local scwupin = ItemRandomMachine.RandomItem("Item_baowu_baguax1",nil,1,12,1,1)
								Map:DropItem(scwupin, itkey, true, true, false, true, 0, false)
								count = 0
							end
						end,nil,nil,nil,"Effect/A/Prefabs/Projectiles/Earth/EarthProjectileTiny")
					end
				end
			end
		end, true, "八卦熔炼", 0, 0, "是否确定熔炼八卦，确定后将随机选取地图上八种八卦合而为一")
	end
end
















