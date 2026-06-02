local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_zhongzhi_lingshi");



--目标合法检测 首先会通过magic的SelectTarget过滤，然后再通过这里过滤
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体
local LingZhongList = {
{ZWName="Plant_lingshi_jin1",CCName="Plant_lingshizhong_jin1"}, 
{ZWName="Plant_lingshi_mu1",CCName="Plant_lingshizhong_mu1"}, 
{ZWName="Plant_lingshi_shui1",CCName="Plant_lingshizhong_shui1"}, 
{ZWName="Plant_lingshi_huo1",CCName="Plant_lingshizhong_huo1"}, 
{ZWName="Plant_lingshi_tu1",CCName="Plant_lingshizhong_tu1"}, 
{ZWName="Plant_lingshi_yuan1",CCName="Plant_lingshizhong_yuan1"}, 
{ZWName="Plant_lingshi_hun1",CCName="Plant_lingshizhong_hun1"}, 
};


function tbMagic:TargetCheck(key, t)
	return true
end







function tbMagic:MagicEnter(IDs, IsThing)
	local key = IDs; 
	for k,v in pairs(LingZhongList) do 
		if self.bind.def.Name == v.ZWName then
			for i=0 ,key.Count-1 do
				local Things = Map.Things;
				local oldbuilding = Things:GetThingAtGrid(key[i], 4);
				local oldplant = Things:GetThingAtGrid(key[i], 3);
				local olditem = Things:GetThingAtGrid(key[i], 2)
				local oldnpc = Things:GetThingAtGrid(key[i], 1)
			
				if oldbuilding == nil and oldplant == nil then
					world:FlyLineEffect(self.bind.Key,key[i], 0.5,
					function(p)
						world:PlayEffect(13, key[i], 0.5);
						plant = ThingMgr:AddPlantThing(key[i],v.CCName, nil)
						plant:ChangeBeauty(self.bind.Beauty)
						plant.Rate = math.min(self.bind.Rate+3,12)
					end)
				end
			end
		end
	end
end

























