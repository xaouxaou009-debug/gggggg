local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_zawu_yaoshi");



--目标合法检测 首先会通过magic的SelectTarget过滤，然后再通过这里过滤
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体

local ItemList =
{
{WPName="Item_zhongzi_lingshi1",JZName="Plant_lingshi_jin1",NAME="-金灵石种-",WPNum= 1 }, 
};


function tbMagic:TargetCheck(key, t)
	return false
end







function tbMagic:MagicEnter(IDs, IsThing)
	key = IDs[0]; 
	me = self.bind
	name = me.def.Name
	
	for k,v in pairs(ItemList) do 
		if name == v.WPName then
			zhongzhi = v.JZName
			mingzi = NAME
		end
	end
	
	if zhongzhi == nil then
 		world:ShowStoryBox("种植失败", "种植")
		return nil
	end
	
	Q = "确定种植"	W = "取消种植"
	world:FlyLineEffect(me.Key,key, 0.5,
	function(p)

		world:ShowStoryBox("是否确定种植", "种植",{Q, W},
 
		function(s)
			if s == 0 then
			world:PlayEffect(2, key, 6);
				if me.Count > 1 then	
				me:ChangeCount(me.Count-1)
				else
				ThingMgr:RemoveThing(self.bind);
				end
				bd = ThingMgr:AddPlantThing(key,zhongzhi, nil)
				return "种植成功"
			else
				return "取消种植"
			end
		end
		);
	end
	);

end

























