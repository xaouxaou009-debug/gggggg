local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_wupin_hecheng");
local ItemList = 
{
{XYName="Item_Wood",HCName="Item_LingWood",XYNum= 100 ,HCThingName= "灵木" }, --依次为原材料、合成后物品、需要数量、合成物品说明
}


function tbMagic:TargetCheck(key, t)
	return true
end





function tbMagic:MagicEnter(IDs, IsThing)
	local XYNum = nil
	local XYName = nil
	local HCName = nil
	local HCThingName = nil
	local targetId = IDs[0];
	local target = ThingMgr:FindThingByID(targetId);
	local count = target.Count		--所选物品熟练
	local name = target:GetName()	--所选物品名字
	local targetkey = target.Key	--所选物品Key
	local diejiashu = target.def.MaxStack	--所选物品叠加上限
	
	for k,v in pairs(ItemList) do		--遍历合成表，如果所选物品可以合成，将支持合成
		if target.def.Name == v.XYName then
			HCName = v.HCName
			XYNum = v.XYNum
			HCThingName = v.HCThingName
		end
	end
	if HCName == nil then		--物品不在表中
		world:ShowStoryBox(name.."不在合成列表中，无法合成此物品","合成失败")
	else
		if XYNum > count then	--物品数量不足
			world:ShowStoryBox(name.." 数量不足，无法合成高级物品","合成失败")
			return false
		end
	end
			
			
	if HCName ~= nil then
		local HCSL1 = count/XYNum
		local HCSL2 = math.floor(HCSL1)
	
		local Q = "取消生成"
		local W = nil
		local E = nil
		
		if HCSL2 >= 1 then
			W = "合成一个"
		end
		if HCSL2 >= 2 then
			E = "合成全部"
		end
		
		world:ShowStoryBox("请选择合成物品数量!\n\n合成物品：[color=#FF0000]"..HCThingName.."[/color]\n合成消耗：[color=#FF0000]"..name.."[/color]\n物品数量：[color=#FF0000]"..count.."[/color]\n消耗数量：[color=#FF0000]"..XYNum.."/个[/color]\n","合成", {Q, W, E}, 
		function(s)
			if s == 0 then
				return false
			end
			
			local wupincount
			local xiaohao
			if s ~= 0 then
				if s == 1 then
					wupincount = 1	
					xiaohao = XYNum	
				elseif s == 2 then
					wupincount = HCSL2
					xiaohao = XYNum*HCSL2
				end
				
			end
			
			local zhengshu = wupincount/diejiashu
			local yushu = zhengshu-math.floor(zhengshu)
			local xunhuan = math.floor(zhengshu)
			
			world:FlyLineEffect(self.bind.Key, targetkey, 2,
			function(p)
			if count > xiaohao then
				target:ChangeCount(count - xiaohao)
			else
				ThingMgr:RemoveThing(target);
			end
			if diejiashu >= wupincount then
					scwupin = ThingMgr:AddItemThing(0,HCName,nil)
					Map:DropItem(scwupin, targetkey);
					local scwupinkey = scwupin.Key
					world:FlyLineEffect(targetkey, scwupinkey, 1,
					function(p)
					world:PlayEffect(13, scwupin.Key, 1);
					end);
					scwupin:ChangeCount(wupincount)
			else		
			
				if zhengshu >= 1 then 
					for i = 1, xunhuan do
						scwupin = ThingMgr:AddItemThing(0,wupin,nil)
						Map:DropItem(scwupin, targetkey);
						local scwupinkey = scwupin.Key
						world:FlyLineEffect(targetkey, scwupinkey, 1,
						function(p)
						world:PlayEffect(13, scwupin.Key, 1);
						end);
						scwupin:ChangeCount(diejiashu)
					end
				end
				if yushu ~= 0 then 
					scwupin = ThingMgr:AddItemThing(0,wupin,nil)
					Map:DropItem(scwupin, targetkey);
					local scwupinkey = scwupin.Key
					world:FlyLineEffect(targetkey, scwupinkey, 1,
					function(p)
					world:PlayEffect(13, scwupinkey, 1);
					end);
					scwupin:ChangeCount(wupincount-xunhuan*diejiashu)
				end 
				
			end 
			end
			);
			
		return false
		end
		);
	end
end











