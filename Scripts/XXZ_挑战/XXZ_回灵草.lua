local tbThing = GameMain:GetMod("ThingHelper"):GetThing("Lua_Plant_shu_yaoshou_1");
local selflist = selflist or {}


function tbThing:OnInit()
end

 
function tbThing:OnStep(dt)
	local plant = self.it
	
	if selflist[plant.ID.."jishi"] == nil then
		selflist[plant.ID.."jishi"] = 0
	end
	
	selflist[plant.ID.."jishi"] = selflist[plant.ID.."jishi"]-dt
	
	if selflist[plant.ID.."jishi"] < 0 then
		selflist[plant.ID.."jishi"] = 10
		local gwsxlist = GameMain:GetMod("XXZ_YaoLingTiaoZhan_SEVE"):GetGWSXList() or {nil,10}
		local Aroundkey = GameUlt.GetNearGrid(plant.Key, 5)
		for k,v in pairs(Aroundkey) do
			local npcs = Map.Things:GetNpcByKey(v);
			if npcs ~= nil then
				for i = 0, npcs.Count-1,1 do
					local npc = npcs[i];
					if npc.IsDisciple and npc.IsPlayerThing and npc.IsDeath == false then
						local linglibi = npc.LingV/npc:GetProperty("NpcLingMaxValue")
						if linglibi > 0.05 then 
							local jingjie = npc.PropertyMgr.Practice.LogicStage
							local lingcost = npc:GetProperty("NpcLingMaxValue")*0.001*gwsxlist[2]
							npc:AddLing(-lingcost)
							npc:AddModifier("Modifier_yaoshou_huilingcao")
							plant:AddLing(lingcost)
						end
					end
				end
			end
		end
	end
end
	
	
	
	
	
	
	
	
	
	
	
















