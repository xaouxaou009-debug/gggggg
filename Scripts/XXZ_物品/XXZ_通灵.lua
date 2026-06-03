local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_suipian_fuyu");



--目标合法检测 首先会通过magic的SelectTarget过滤，然后再通过这里过滤
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体

local ItemList =
{
{Name="Item_wuqi_yiji_dao1",tName="Item_wuqi_erji_dao2",WPNum= 1 }, 
{Name="Item_wuqi_yiji_qiang1",tName="Item_wuqi_erji_qiang2",WPNum= 1 }, 
{Name="Item_wuqi_yiji_jian1",tName="Item_wuqi_erji_jian2",WPNum= 1 }, 
{Name="Item_wuqi_yiji_chui1",tName="Item_wuqi_erji_chui2",WPNum= 1 }, 
{Name="Item_wuqi_yiji_huan1",tName="Item_wuqi_erji_huan2",WPNum= 1 }, 
{Name="Item_wuqi_yiji_gong1",tName="Item_wuqi_erji_gong2",WPNum= 1 },
{Name="Item_wuqi_erji_gong2",tName="Item_wuqi_sanji_jian1",WPNum= 1 }, 
{Name="Item_wuqi_erji_huan2",tName="Item_wuqi_sanji_jian1",WPNum= 1 }, 
{Name="Item_wuqi_erji_chui2",tName="Item_wuqi_sanji_jian1",WPNum= 1 }, 
{Name="Item_wuqi_erji_jian2",tName="Item_wuqi_sanji_jian1",WPNum= 1 }, 
{Name="Item_wuqi_erji_qiang2",tName="Item_wuqi_sanji_jian1",WPNum= 1 }, 
{Name="Item_wuqi_erji_dao2",tName="Item_wuqi_sanji_jian1",WPNum= 1 }, 
};

local Item_tuzhi1 ={"Item_yifu_tuzhi_xuanjiu","Item_yifu_tuzhi_jiuzhuan","Item_yifu_tuzhi_bailian","Item_yifu_tuzhi_tianling"}
local Item_tuzhi2 ={"Item_yifu_tuzhi_yuqing","Item_yifu_tuzhi_shangqing","Item_yifu_tuzhi_taiqing","Item_yifu_tuzhi_tianling"}
local Item_tuzhi3 ={"Item_yifu_tuzhi_taiji"}
local Item_tuzhi4 ={"Item_yifu_tuzhi_wuji1","Item_yifu_tuzhi_wuji2","Item_yifu_tuzhi_wufa1","Item_yifu_tuzhi_wufa2"}
local ItemList_tuzhi =
{
{Name="Item_yifu_tuzhi_tiangong",tName= Item_tuzhi1,WPNum= 1 }, 
{Name="Item_yifu_tuzhi_tianqiao",tName=Item_tuzhi1,WPNum= 1 }, 
{Name="Item_yifu_tuzhi_tianyuan",tName=Item_tuzhi1,WPNum= 1 }, 
{Name="Item_yifu_tuzhi_tianling",tName=Item_tuzhi2,WPNum= 1 }, 
{Name="Item_yifu_tuzhi_xuanjiu",tName=Item_tuzhi2,WPNum= 1 }, 
{Name="Item_yifu_tuzhi_jiuzhuan",tName=Item_tuzhi2,WPNum= 1 }, 
{Name="Item_yifu_tuzhi_bailian",tName=Item_tuzhi2,WPNum= 1 }, 
{Name="Item_yifu_tuzhi_yuqing",tName=Item_tuzhi3,WPNum= 1 }, 
{Name="Item_yifu_tuzhi_shangqing",tName=Item_tuzhi3,WPNum= 1 }, 
{Name="Item_yifu_tuzhi_taiqing",tName=Item_tuzhi3,WPNum= 1 }, 
{Name="Item_yifu_tuzhi_taiji",tName=Item_tuzhi4,WPNum= 1 }, 
};


local NoUplist ={"Item_wuqi_sanji_jian1","Item_wuqi_lingjian_1","Item_wuqi_lingjian_2","Item_wuqi_lingjian_3","Item_wuqi_lingjian_4","Item_wuqi_lingjian_5","Item_wuqi_wuxingjian1","Item_wuqi_wuxingjian2"};


function tbMagic:TargetCheck(key, t)
	return true
end







function tbMagic:MagicEnter(IDs, IsThing)
	local targetId = IDs[0]
	local target = ThingMgr:FindThingByID(targetId)
	local targetkey = target.Key
	local selfkey = self.bind.Key
	local lable = target.def.Item.Lable
	local count = self.bind.Count
	local tName				--待生成物品
	local TZlist			--图纸检索池
	local CanUp				--图纸检索池
	
	if self.bind.def.Name == "Item_zawu_suipian1" then
	
		local name = target.def.Name
		for k,v in pairs(ItemList) do 
			if name == v.Name then
				tName = v.tName
				CanUp = v.WPNum
			end
		end
		
		for k,v in pairs(ItemList_tuzhi) do 
			if name == v.Name then
				TZlist = v.tName 
				CanUp = v.WPNum
			end
		end
		
		if TZlist ~= nil then
			local XZ = world:RandomInt(1, #TZlist+1) --图纸池ROLL
			tName = TZlist[XZ] 
		end
		
		local Q = "升华物品"
		local W = "取消使用"
		world:ShowStoryBox("[color=#FF0000]是否使用升华石，可以提升物品品阶，如果是特殊物品有几率极限升华,升华为同系列更高等级的物品[/color]","升华", {Q, W}, 
			function(s)
				if s == 0 then
				
					local rate = target.Rate
					if rate < 12 then
					
						if count > 1 then
						self.bind:ChangeCount(count - 1)
						else
						ThingMgr:RemoveThing(self.bind);
						end
						
						world:FlyLineEffect(selfkey, targetkey, 1,
						function(p)
						if lable == g_emItemLable.Weapon or TZlist ~= nil then
						
							if CanUp == 1 then
								if WorldLua:CheckRate(0.05+rate/120) then
									ThingMgr:RemoveThing(target)
									local wuqi = ThingMgr:AddItemThing(0,tName,nil)
									Map:DropItem(wuqi,targetkey);
									wuqi.Rate=target.Rate
									wuqi:ChangeBeauty(target.Beauty)
									wuqi:SetQuality(target:GetQuality())
									wuqi.Author= "[color=#FF7F00]升华[/color]"
									local sxlist = target.EquptData or nil
									if sxlist ~= nil then
										for k,v in pairs(sxlist) do
											wuqi:AddEquiptData(v.name,v.addv,v.addp);
										end
									end
									world:PlayEffect(13, wuqi.Key, 2);
									world:ShowMsgBox("极限升华！！[color=#FF7F00] "..target:GetName().." [/color]升华成了[color=#FF7F00]"..wuqi:GetName().." [/color]，并完美继承原武器附魔品质等", "极限升华")
									return false
								else
									if WorldLua:CheckRate(1.5/rate) then
											target:SoulCrystalYouPowerUp(0,1,1);
											world:PlayEffect(10, targetkey, 2);
											world:ShowMsgBox("升华成功！！[color=#FF7F00] "..target:GetName().." [/color]品阶提升了一阶", "升华成功")
											return false
									else
										if WorldLua:CheckRate(0.2) and rate > 1 then
										target:SoulCrystalYouPowerUp(0,1,-1);
										world:ShowMsgBox("[color=#FF7F00] "..target:GetName().." [/color]升华失败，由于灵气涣散，物品品阶降低。", "升华失败")
										return false
										end
										if WorldLua:CheckRate(0.1) then
										ThingMgr:RemoveThing(target)
										world:ShowMsgBox("[color=#FF7F00] "..target:GetName().." [/color]升华失败，导致灵力四溢，物品被损坏。", "升华失败")
										return false
										end
										world:ShowMsgBox("品阶升华失败！！[color=#FF7F00] "..target:GetName().." [/color]没有发生任何变化", "升华失败")
										return false
									end
								end
							end
							
							if CanUp == nil then 
								if WorldLua:CheckRate(1.5/rate) then
										target:SoulCrystalYouPowerUp(0,1,1);
										world:PlayEffect(10, targetkey, 2);
										world:ShowMsgBox("升华成功！！[color=#FF7F00] "..target:GetName().." [/color]品阶提升了一阶", "升华成功")
										return false
								else
									local NoUpwupin = nil
									for k,v in pairs(NoUplist) do
										if name == v then
											NoUpwupin = v
										end
									end
									if WorldLua:CheckRate(0.08+rate/100) and NoUpwupin == nil then
										ThingMgr:RemoveThing(target)
										local WP = {"Item_wuqi_yiji_gong1","Item_wuqi_yiji_dao1","Item_wuqi_yiji_qiang1","Item_wuqi_yiji_jian1","Item_wuqi_yiji_chui1","Item_wuqi_yiji_huan1"}	
										local XZ = world:RandomInt(1, #WP+1)
										local wuqi = ThingMgr:AddItemThing(0,WP[XZ],nil)
										Map:DropItem(wuqi,targetkey);
										wuqi.Rate=target.Rate
										wuqi:ChangeBeauty(target.Beauty)
										wuqi:SetQuality(target:GetQuality())
										wuqi.Author= "[color=#FF7F00]升华[/color]"
										local sxlist = target.EquptData or nil
										if sxlist ~= nil then
										for k,v in pairs(sxlist) do
											wuqi:AddEquiptData(v.name,v.addv,v.addp);
										end
										end
										world:PlayEffect(13, wuqi.Key, 2);
										world:ShowMsgBox("极限升华！！[color=#FF7F00] "..target:GetName().." [/color]升华成了[color=#FF7F00]"..wuqi:GetName().." [/color]，并完美继承原武器附魔品质等", "升华成功")
										return false
									else
										if WorldLua:CheckRate(0.18) and rate > 1 then
										target:SoulCrystalYouPowerUp(0,1,-1);
										world:ShowMsgBox("[color=#FF7F00] "..target:GetName().." [/color]升华失败，由于灵气涣散，物品品阶降低。", "升华失败")
										return false
										end
										if WorldLua:CheckRate(0.12) then
										ThingMgr:RemoveThing(target)
										world:ShowMsgBox("[color=#FF7F00] "..target:GetName().." [/color]升华失败，导致灵力四溢，物品被损坏。", "升华失败")
										return false
										end
										world:ShowMsgBox("品阶升华失败！！[color=#FF7F00] "..target:GetName().." [/color]没有发生任何变化", "升华失败")
										return false
									end
								end
							end
						else
							world:ShowMsgBox("此类物品暂时不开放升华，等待后续添加", "升华失败")
							return false
						end
						end)
					
					else
						world:ShowMsgBox("物品品阶已经达到最大，无法升华", "升华失败")
						return false
					end
					
				elseif s == 1 then
					return "取消升华物品"
				end
			end
			)
		
	end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
end

























