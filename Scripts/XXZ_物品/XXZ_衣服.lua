local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_yifu_1");



--目标合法检测 首先会通过magic的SelectTarget过滤，然后再通过这里过滤
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体

local ItemList =
{
{WPName="Item_yifu_tuzhi_tiangong",SYName="Item_shangyi_tiangong",XYName="Item_xiayi_tiangong",WPNum= 2000 },
{WPName="Item_yifu_tuzhi_tianqiao",SYName="Item_shangyi_tianqiao",XYName="Item_xiayi_tianqiao",WPNum= 2000 }, 
{WPName="Item_yifu_tuzhi_tianyuan",SYName="Item_shangyi_tianyuan",XYName="Item_xiayi_tianyuan",WPNum= 2000 }, 
{WPName="Item_yifu_tuzhi_tianling",SYName="Item_shangyi_tianling",XYName="Item_xiayi_tianling",WPNum= 5000 },
{WPName="Item_yifu_tuzhi_xuanjiu",SYName="Item_shangyi_xuanjiu",XYName="Item_xiayi_xuanjiu",WPNum= 5000 }, 
{WPName="Item_yifu_tuzhi_jiuzhuan",SYName="Item_shangyi_jiuzhuan",XYName="Item_xiayi_jiuzhuan",WPNum= 5000 }, 
{WPName="Item_yifu_tuzhi_bailian",SYName="Item_shangyi_bailian",XYName="Item_xiayi_bailian",WPNum= 5000 }, 
{WPName="Item_yifu_tuzhi_yuqing",SYName="Item_shangyi_yuqing",XYName="Item_xiayi_yuqing",WPNum= 10000 }, 
{WPName="Item_yifu_tuzhi_shangqing",SYName="Item_shangyi_shangqing",XYName="Item_xiayi_shangqing",WPNum= 10000 }, 
{WPName="Item_yifu_tuzhi_taiqing",SYName="Item_shangyi_taiqing",XYName="Item_xiayi_taiqing",WPNum= 10000 }, 
{WPName="Item_yifu_tuzhi_taiji",SYName="Item_shangyi_taiji",XYName="Item_xiayi_taiji",WPNum= 30000 }, 
{WPName="Item_yifu_tuzhi_wuji1",SYName="Item_shangyi_wuji1",XYName="Item_xiayi_wuji1",WPNum= 90000 }, 
{WPName="Item_yifu_tuzhi_wuji2",SYName="Item_shangyi_wuji2",XYName="Item_xiayi_wuji2",WPNum= 90000 }, 
{WPName="Item_yifu_tuzhi_wufa1",SYName="Item_shangyi_wufa1",XYName="Item_xiayi_wufa1",WPNum= 90000 }, 
{WPName="Item_yifu_tuzhi_wufa2",SYName="Item_shangyi_wufa2",XYName="Item_xiayi_wufa2",WPNum= 90000 }, 
};

local CailiaoList =
{
{WPName="Item_PurpleCloth",WPNum= 1 ,CLName= "紫布" },
{WPName="Item_CottonCloth",WPNum= 1 ,CLName= "花布"},
{WPName="Item_DeepBlueCloth",WPNum= 1 ,CLName= "靛蓝布" },
{WPName="Item_YellowCloth",WPNum= 1 ,CLName= "黄布"},
{WPName="Item_BlueCloth",WPNum= 1 ,CLName= "蓝布"},
{WPName="Item_RedCloth",WPNum= 1 ,CLName= "红布"},
{WPName="Item_WhiteCloth",WPNum= 1 ,CLName= "白布"},
{WPName="Item_BlackCloth",WPNum= 1 ,CLName= "黑布"},
{WPName="Item_RabbitLeather",WPNum= 2 ,CLName= "兔皮"},
{WPName="Item_WolfLeather",WPNum= 3 ,CLName= "狼皮"},
{WPName="Item_BoarLeather",WPNum= 4 ,CLName= "野猪皮"},
{WPName="Item_BearLeather",WPNum= 5 ,CLName= "熊皮"},
{WPName="Item_YaoLeather",WPNum= 30 ,CLName= "妖化的兽皮"},
{WPName="Item_FeiLeather",WPNum= 100 ,CLName= "蜚之皮"},
{WPName="Item_LuShuLeather",WPNum= 100 ,CLName= "鹿蜀之皮"},
{WPName="Item_YaoLeather1",WPNum= 100 ,CLName= "妖兽的韧皮"},
{WPName="Item_shoupi1",WPNum= 100 ,CLName= "百年蛟皮"},
{WPName="Item_yumao1",WPNum= 100 ,CLName= "灵鸦羽"},
{WPName="Item_shoupi2",WPNum= 200 ,CLName= "百年熊皮"},
{WPName="Item_yumao2",WPNum= 200 ,CLName= "苍鹊羽"},
{WPName="Item_shoupi3",WPNum= 500 ,CLName= "百年虎皮"},
{WPName="Item_yumao3",WPNum= 500 ,CLName= "玄雀羽"},
{WPName="Item_shoupi4",WPNum= 1000 ,CLName= "九尾狐皮"},
{WPName="Item_yumao4",WPNum= 1000 ,CLName= "朱鸟翎"},
{WPName="Item_shoupi5",WPNum= 3000 ,CLName= "玄龙鳞"},
{WPName="Item_yumao5",WPNum= 3000 ,CLName= "玄鸟翎"},
};



function tbMagic:TargetCheck(key, t)
	if (t.def.Item.Lable == g_emItemLable.Cloth) or (t.def.Item.Lable == g_emItemLable.Leather) then
		return true
	end
		return false
end







function tbMagic:MagicEnter(IDs, IsThing)
	local targetId = IDs[0];
	local target = ThingMgr:FindThingByID(targetId);
	local count = target.Count
	local selfkey = self.bind.Key
	local rate = self.bind.Rate
	local rate2 = self.bind.def.Rate
	local targetkey = target.Key
	local name = self.bind.def.Name
	local name2 = target.def.Name
	
	local shangyi
	local xiayi
	local xuqiu
	local jiben
	local npcname 
	for k,v in pairs(ItemList) do 
		if name == v.WPName then
			shangyi = v.SYName
			xiayi = v.XYName
			jiben = v.WPNum
			xuqiu = v.WPNum*(rate2/rate)
		end
	end
	
	for k,v in pairs(CailiaoList) do 
		if name2 == v.WPName then
			jiazhi = v.WPNum
			cailiao = v.WPName
			mingzi = v.CLName
		end
	end
	
	local wcbl = self.bind.LingV/xuqiu				--已转化比例
	local xiaohao = math.ceil(xuqiu/jiazhi)     --需求总数量
	local nengliang = count*jiazhi				--转化能量数

	local xiaohao2 = math.floor(((1-wcbl)*xuqiu)/jiazhi)  --剩余需求数量
	
	if xiaohao2 == 0 then
		xiaohao2 = 1
	end


	if count < xiaohao2 and count < xiaohao then 
			local Q = "确定转化"
			local W = "取消转化"
			world:ShowStoryBox("\n材料不足以转化为衣物，是否将材料转化为能量，等待下次继续转化\n基础需求能量："..jiben.."\n目前需求能量："..xuqiu.."\n剩余需求能量："..xuqiu-self.bind.LingV.."\n总共需求数量："..xiaohao2.."\n品阶消耗加成："..(math.floor(rate2/rate*100)/100).."\n本次能量价值："..nengliang.."", "转化失败",{Q, W},
			function(s)
				if s == 0   then
					world:FlyLineEffect(targetkey,selfkey, 1,
					function(p)
					ThingMgr:RemoveThing(target)
					self.bind:AddLing(nengliang)
					world:PlayEffect(2, selfkey, 1);
					end
					)
					return false
				elseif s == 1   then
					return false
				end
			end
			);
	end

	if wcbl == 0 and count >= xiaohao then
		local Q = "转化上衣"  
		local W = "转化下衣"
		local R = "取消转化"
			world:ShowStoryBox("材料充足，可以转化为衣物，请选择转化部位\n基础需求能量："..jiben.."\n目前需求能量："..xuqiu.."\n品阶消耗加成："..(math.floor(rate2/rate*100)/100).."\n物品能量转换："..jiazhi.."\n物品消耗数量："..xiaohao.."\n材料赋予："..mingzi, "转化",{Q, W, R},
			function(s)
				if count > xiaohao then
				target:ChangeCount(count - xiaohao)
				else
				ThingMgr:RemoveThing(target);
				end
				
				local dzhys				--待转化部位
				if s == 0   then
					dzhys = shangyi
				elseif s == 1   then
					dzhys = xiayi
				elseif s == 2   then
					return false
				end
					ThingMgr:RemoveThing(self.bind);
					stuff = ThingMgr:GetDef(2, target.def.Name)   --物品原材料
					local scwupin = ThingMgr:AddItemThing(0,dzhys,nil) 
					world:FlyLineEffect(targetkey,selfkey, 1,
					function(p)
						Map:DropItem(scwupin, selfkey);
						world:PlayEffect(13, scwupin.Key, 1);
						scwupin:InheritDataFromMade(stuff,0,0)
						scwupin:SetQuality(WorldLua:RandomFloat(0.7,1))
					end
					);
			end
			);
	end 
	
	
	
	if wcbl ~= 0 then 
		if count >= xiaohao2 and wcbl < 1 then
			local Q = "转化上衣"
			local W = "转化下衣"
			local E = "取消转化"
			world:ShowStoryBox("本次材料足以补充剩余所需能量，可以转化为衣物，请选择转化部位，由于卷轴积攒分次能量，不继承所选材料属性，将赋予天女织，提升基础护盾加成\n基础需求能量："..jiben.."\n目前需求能量："..xuqiu.."\n剩余需求能量："..xuqiu-self.bind.LingV.."\n转化消耗数量："..xiaohao2.."\n物品材料赋予：天女织", "转化",{Q, W, E},
			function(s)
				if count > xiaohao2 then
				target:ChangeCount(count - xiaohao2)
				else
				ThingMgr:RemoveThing(target);
				end
				local dzhys				--待转化部位
				if s == 0 then
					dzhys = shangyi
				elseif s == 1 then
					dzhys = xiayi
				elseif s == 2 then
					return false
				end
					ThingMgr:RemoveThing(self.bind);
					stuff = ThingMgr:GetDef(2, "Item_tiannv_bupi")   --物品原材料
					local scwupin = ThingMgr:AddItemThing(0,dzhys,nil) 
					world:FlyLineEffect(targetkey,selfkey, 1,
					function(p)
						Map:DropItem(scwupin, selfkey);
						world:PlayEffect(13, scwupin.Key, 1);
						scwupin:InheritDataFromMade(stuff,0,0)
						scwupin:SetQuality(WorldLua:RandomFloat(0.4,0.8))
					end
					);
			end
			);
		end
	end
	
	
	
	
	
	
	
	
	
	
	























end

























