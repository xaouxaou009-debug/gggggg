local BaoWu = GameMain:GetMod("XXZ_BaoWu_ShangXian")
local tbEvent = GameMain:GetMod("_Event");
local zhuangbeilist = {"Item_baowu_baguax1","Item_zhuanshu_lingpai_luxueqi","Item_zhuanshu_lingpai_biyao","Item_zhuanshu_lingpai_sunwukong","Item_zhuanshu_lingpai_lvbu","Item_zhuanshu_lingpai_libai","Item_zhuanshu_lingpai_guanyu","Item_zhuanshu_lingpai_yuji","Item_zhuanshu_lingpai_diaochan","Item_zhuanshu_lingpai_zixia","Item_zhuanshu_lingpai_houyi"}
local lingpailist = {"Item_zhuanshu_lingpai_luxueqi","Item_zhuanshu_lingpai_biyao","Item_zhuanshu_lingpai_sunwukong","Item_zhuanshu_lingpai_lvbu","Item_zhuanshu_lingpai_libai","Item_zhuanshu_lingpai_guanyu","Item_zhuanshu_lingpai_yuji","Item_zhuanshu_lingpai_diaochan","Item_zhuanshu_lingpai_zixia","Item_zhuanshu_lingpai_houyi"}

function BaoWu:OnSave()
end


function BaoWu:OnLoad(t)
end

function BaoWu:OnEnter()
	tbEvent:RegisterEvent(g_emEvent.EquipUpdate, BaoWu.OnEquipUpdate, "zhuangbei_baowu_shangxian")
end

function BaoWu.OnEquipUpdate(t,npc,obj)
	if t ~= "zhuangbei_baowu_shangxian" then
		return false
	end

	local action = obj[1];		-- 1装备，2激活，3卸下，4反激活
	local item = obj[0]
	local name = item.def.Name
		
	local jiance  = false
	
	for k,v in pairs(zhuangbeilist) do
		if name == v then
			jiance = true
		end
	end
	
	if action == 1 then 
		if jiance == true then
			local equiptype = CS.XiaWorld.g_emEquipType
			local equiptypes = {equiptype.Tool1,equiptype.Tool2,equiptype.Tool3,equiptype.Tool4,equiptype.Tool5,equiptype.Tool6}
			for i=1,6 do
				local items = npc.Equip:GetEquip(equiptypes[i])
				if items ~= nil and items ~= item then
					if items.def.Name == name then
						npc.Equip:UnEquipItem(items,true)
					end
				end
			end
			
			return false
		end
	
	elseif action == 3 then
		
		for i=1,#lingpailist do
			local modifier = npc.PropertyMgr:FindModifier("Modifier_zhuanshu_buff_"..i)
			if name == lingpailist[i] then
				if modifier ~= nil then
					modifier.Duration = 0.01
				end
			end
		end
		if world:GetFlag(item,6203) >= 1 then
			ThingMgr:RemoveThing(item)
		end
		if jiance == true then
			item.EquptData = nil
			return false
		end
	end
end














































