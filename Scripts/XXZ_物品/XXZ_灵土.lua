local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_zaohua_shuitu");



--目标合法检测 首先会通过magic的SelectTarget过滤，然后再通过这里过滤
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体

local ItemList =
{
{WPName="Item_zaohua_tu_1",JZName="Terrain_lingtu1",NAME="-金灵息壤-",WPNum= 1 }, 
{WPName="Item_zaohua_tu_2",JZName="Terrain_lingtu2",NAME="-木灵息壤-",WPNum= 1 }, 
{WPName="Item_zaohua_tu_3",JZName="Terrain_lingtu3",NAME="-水灵息壤-",WPNum= 1 }, 
{WPName="Item_zaohua_tu_4",JZName="Terrain_lingtu4",NAME="-火灵息壤-",WPNum= 1 }, 
{WPName="Item_zaohua_tu_5",JZName="Terrain_lingtu5",NAME="-土灵息壤-",WPNum= 1 }, 
{WPName="Item_zaohua_tu_6",JZName="Terrain_lingtu6",NAME="-元灵息壤-",WPNum= 1 }, 
{WPName="Item_zaohua_tu_7",JZName="Terrain_lingtu7",NAME="-混灵息壤-",WPNum= 1 }, 
{WPName="Item_zaohua_shui_1",JZName="Terrain_lingshui1",NAME="-金缈灵泉-",WPNum= 1 }, 
{WPName="Item_zaohua_shui_2",JZName="Terrain_lingshui2",NAME="-木缈灵泉-",WPNum= 1 }, 
{WPName="Item_zaohua_shui_3",JZName="Terrain_lingshui3",NAME="-水缈灵泉-",WPNum= 1 }, 
{WPName="Item_zaohua_shui_4",JZName="Terrain_lingshui4",NAME="-火缈灵泉-",WPNum= 1 }, 
{WPName="Item_zaohua_shui_5",JZName="Terrain_lingshui5",NAME="-土缈灵泉-",WPNum= 1 }, 
{WPName="Item_zaohua_shui_6",JZName="Terrain_lingshui6",NAME="-元缈灵泉-",WPNum= 1 }, 
{WPName="Item_zaohua_shui_7",JZName="Terrain_lingshui7",NAME="-混缈灵泉-",WPNum= 1 }, 
};


function tbMagic:TargetCheck(key, t)
	return true
end







function tbMagic:MagicEnter(IDs, IsThing)
	local key = IDs; 
	local me = self.bind
	local selfkey = me.Key
	local name = me.def.Name
	
	local dixing
	local mingzi
	for k,v in pairs(ItemList) do 
		if name == v.WPName then
			dixing = v.JZName
			mingzi = v.NAME
		end
	end
	
	if dixing == nil then
 		world:ShowStoryBox("造化地形失败", "失败")
		return false
	end
	
	local Q = "造化地形"	
	local W = "取消造化"
	world:ShowStoryBox("是否确定将所选位置地形改变为"..mingzi, "造化",{Q, W},
	function(s)
	if s == 0 then
		if me.Count > 1 then	
			me:ChangeCount(me.Count-1)
		else
			ThingMgr:RemoveThing(self.bind);
		end
		
		for i=0 ,key.Count-1 do
				world:FlyLineEffect(selfkey,key[i], 2,
				function(p)
					Map.Terrain:FullTerrain(key[i], dixing);
					world:PlayEffect(65, key[i], 0.5);
					return false
				end,nil,nil,nil,"Effect/gsq/Prefab/Fx_FaShu_03"
				)
		end
	else
		return false
	end
	end
	);
end

























