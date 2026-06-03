local tbMagic = GameMain:GetMod("MagicHelper"):GetMagic("Lua_bagua_xiufu_jishi");
local selflist = {}




function tbMagic:TargetCheck(key, t)
	tbMagic:BaGuaGet(self.bind)
	local name = GameMain:GetMod("ThingHelper"):GetThing("Lua_baowu_baguayunyang"):XiuFuWuPinJianCe(selflist["baguaid"])
	if name == t.def.Name then
		return	true
	end
end


function tbMagic:MagicEnter(IDs, IsThing)
	selflist["targetid"] = IDs[0]
end

function tbMagic:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束 duration:已持续时间
	self:SetProgress(duration/self.magic.Param1);
	if duration >= self.magic.Param1 then
		local target = ThingMgr:FindThingByID(selflist["targetid"])
		if target.Count > 1 then	
			target:ChangeCount(target.Count-1)
		else
			ThingMgr:RemoveThing(target);
		end	
		return 1	
	end
	return 0
end

function tbMagic:MagicLeave(success)
	if success == true then
	print(self.bind)
	end
end

function tbMagic:BaGuaGet(npc)
	local equiptype = CS.XiaWorld.g_emEquipType
	local equiptypes = {equiptype.Tool1,equiptype.Tool2,equiptype.Tool3,equiptype.Tool4,equiptype.Tool5,equiptype.Tool6}
	for i=1,6 do
		local item = npc.Equip:GetEquip(equiptypes[i])
		if item ~= nil then
			if item.def.Name == "Item_baowu_baguax1" then
				selflist["baguaid"] = item.ID
			end
		end
	end
end









