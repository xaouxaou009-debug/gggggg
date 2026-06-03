local BaoWu = GameMain:GetMod("_FabaoHelper")
local lingpailist = {"Item_zhuanshu_lingpai_luxueqi","Item_zhuanshu_lingpai_biyao","Item_zhuanshu_lingpai_sunwukong","Item_zhuanshu_lingpai_lvbu","Item_zhuanshu_lingpai_libai","Item_zhuanshu_lingpai_guanyu","Item_zhuanshu_lingpai_yuji","Item_zhuanshu_lingpai_diaochan","Item_zhuanshu_lingpai_zixia","Item_zhuanshu_lingpai_houyi"}


function BaoWu:Onitone()
	local self = it
	local npc = ThingMgr:FindThingByID(self.EquipByWho)
	local xiufu,fangxiang = GameMain:GetMod("ThingHelper"):GetThing("Lua_baowu_baguayunyang"):GetZhuangTai(self)
	
	if self.Bind2Npc == 0 then
		CS.Wnd_Message.Show(nil, 2,
		function (s)
			if s == "1" then
				npc.Equip:UnEquipItem(self,true)
				local cmd = self:AddSimpleActionCommand(10, "dazuo", "认主", "MibaoChooses", 0, nil, 0, nil, "MibaoChoosesAction");
				if cmd ~= nil then
					cmd.BindNpc = npc.ID
					cmd.DisCheckAct = true
				end
			end
		end, true, "残卦认主", 0, 0,"[color=#FF0000]"..self:GetName().."   未认主，无法开启孕养与修复道痕，是否认主，确定认主成功后他人无法装备[/color]")
		return false
	end
	
	if xiufu == false then
		GameMain:GetMod("ThingHelper"):GetThing("Lua_baowu_baguayunyang"):YunYangKaiQi(self)
	else
		if fangxiang == nil then
			GameMain:GetMod("ThingHelper"):GetThing("Lua_baowu_baguayunyang"):JinJieFangXiang(self)
		else
			world:CastMagic(npc,'Magic_bagua_xiufu_jishi')
		end
	end
end

function BaoWu:ZhuanShuLingPai()
	local self = it
	local num = 0
	local kaiguan = "激活当前令牌对应的"
	local modifier = nil
	local npc = ThingMgr:FindThingByID(self.EquipByWho)
	if self.Bind2Npc == 0 then
		CS.Wnd_Message.Show(nil, 2,
		function (s)
			if s == "1" then
				npc.Equip:UnEquipItem(self,true)
				local cmd = self:AddSimpleActionCommand(10, "dazuo", "认主", "MibaoChooses", 0, nil, 0, nil, "MibaoChoosesAction");
				if cmd ~= nil then
					cmd.BindNpc = npc.ID
					cmd.DisCheckAct = true
				end
			end
		end, true, "专属模型", 0, 0,"[color=#FF0000]令牌："..self:GetName().."   未认主，无法激活，是否确定认主，认主后其他人将无法装备[/color]")
		return false
	end
	for i=1,#lingpailist do
		if self.def.Name == lingpailist[i] then
			num = i
		end
		local modifiers = npc.PropertyMgr:FindModifier("Modifier_zhuanshu_buff_"..i)
		if modifiers ~= nil then
			modifier = modifiers
			kaiguan = "关闭当前专属模型，或开启其他专属模型，开启当前"
		end
	end
	if num > 0 then
		CS.Wnd_Message.Show(nil, 2,
		function (s)
			if s == "1" then
				if modifier == nil then
					npc.LuaHelper:AddModifier("Modifier_zhuanshu_buff_"..num)
					--self:AddEquiptData(nil,0,0,0,0,g_emNpcSpecailFlag.None,"Modifier_zhuanshu_buff_"..num,false)
				end
				if modifier ~= nil then
					modifier.Duration = 0.01
					npc.LuaHelper:AddModifier("Modifier_zhuanshu_buff_"..num)
				end
			end
		end, true, "专属模型", 0, 0, "[color=#FF0000]每个专属模型自带专属的武器、法宝、装备、称号，开启后将变身为专属模型，一次只能开启一个专属模型,是否确定"..kaiguan.."专属模型[/color]")
	end
end



function BaoWu:ZhuangBeiShengCheng(npc,list)
	if not npc.IsDisciple then
		return false
	end
	local jingjie = npc.PropertyMgr.Practice.LogicStage
	npc.Equip:UnEquipItem(CS.XiaWorld.g_emEquipType.AtkFabao,true)
	npc.Equip:UnEquipItem(CS.XiaWorld.g_emEquipType.Weapon,true)
	npc.Equip:UnEquipItem(CS.XiaWorld.g_emEquipType.Clothes,true)
	npc.Equip:UnEquipItem(CS.XiaWorld.g_emEquipType.Trousers,true)
	local FBName = ThingMgr:AddItemThing(0,list[1],nil) 
	local WQName = ThingMgr:AddItemThing(0,list[2],nil) 
	local SYName = ThingMgr:AddItemThing(0,list[3],nil) 
	local XYName = ThingMgr:AddItemThing(0,list[4],nil)
	local stuff = ThingMgr:GetDef(2, "Item_zhaunshu_bupi1")
	SYName:InheritDataFromMade(stuff,0,0)
	XYName:InheritDataFromMade(stuff,0,0)
	if FBName.FabaoAcriveData ~= nil then
		FBName = FBName:ActiveFabaoEmbryo()
	end
	FBName:BindItem2Npc(npc)
	local zhuangbei = {FBName,WQName,SYName,XYName}
	for i=1,#zhuangbei do
		world:SetFlag(zhuangbei[i],6203,1)
		zhuangbei[i].Author= "[color=#FF0000]专属装备[/color]"
		zhuangbei[i]:SetDesc(SYName:GetDesc().."\n[color=#CD8500]专属装备不可卸下[/color]")
		zhuangbei[i]:SetQuality(1.2)
		zhuangbei[i]:SetName("[color=#FF0000]专属 · [/color]"..zhuangbei[i].def.ThingName)
		npc:EquipItem(zhuangbei[i])
	end
	FBName:SetName(list[5])
	return false
end

function BaoWu:ZhuangBeiYiChu(npc,modname)
	local fabao = npc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.AtkFabao)
	local wuqi = npc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.Weapon)
	local yifu = npc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.Clothes)
	local kuzi = npc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.Trousers)
	local zhuangbei ={fabao,wuqi,yifu,kuzi}
	for i=1,#zhuangbei do
		if zhuangbei[i] ~= nil then
			if world:GetFlag(zhuangbei[i],6203) > 0 then
				ThingMgr:RemoveThing(zhuangbei[i])
			end
		end
	end
	
	local npcMod = npc.NpcMods
	if npcMod ~= nil and modname ~= nil then
		for i=0,npcMod.Count-1 do
			local ModName = npcMod[i]	--寻找模型
			if ModName == modname then
				npc:RemoveNpcModPath(ModName)
			end
		end
	end
	if npc.view ~= nil then
		npc.view.needUpdateMod = true;
	end
end

function BaoWu:WuPin(item)
	local SpecialAbility = item.def.Item.Fabao.SpecialAbility
	
	if item ~= nil then
		item:InitFabao(12,item.def,item.def.Name,item:GetName(),g_emItemLable.Other,100,nil,g_emElementKind.None,false)
		return false
	end
	for i=0,SpecialAbility.Count-1 do
		print(SpecialAbility[i])
		if SpecialAbility[i].Kind == CS.XiaWorld.g_emFabaoSpecialAbility.Sync_AddFlag[5] then
			print(1)
		elseif SpecialAbility[i].Kind == CS.XiaWorld.g_emFabaoSpecialAbility.Sync_AddEquptData then
			print(2)
		elseif SpecialAbility[i].Kind == CS.XiaWorld.g_emFabaoSpecialAbility.Sync_AddEquptDataModifier then
			print(3)
		else
			
		end
	end
end












































