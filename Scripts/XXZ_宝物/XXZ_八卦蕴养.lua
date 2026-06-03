local tbThing = GameMain:GetMod("ThingHelper"):GetThing("Lua_baowu_baguayunyang");
local selflist = selflist or {}
local it

function tbThing:OnInit()
end

function tbThing:OnGetSaveData()
	return selflist
end



function tbThing:OnLoadData(tbData)
	selflist = tbData or {}
end

function tbThing:OnStep(dt)
	it = self.it
	
	if it.Bind2Npc == 0 then
		local oldnpc = ThingMgr:FindThingByID(it.EquipByWho)
		it:SetName("未激活的"..it.def.ThingName)
		it:SetDesc(it.def.Desc.."\n[color=#FF6347]未认主，物品未激活[/color]")
	end
	
	if selflist["jishi"..it.ID] == nil then
		selflist["jishi"..it.ID] = 0
	end
	selflist["jishi"..it.ID] = selflist["jishi"..it.ID]+dt
	if selflist["jishi"..it.ID] < 5 then
		return false
	end
	selflist["jishi"..it.ID] = 0

	if selflist["yunyang"..it.ID] == nil and selflist["xiufu"..it.ID] == nil then
		selflist["yunyang"..it.ID] = 0
		selflist["xiufu"..it.ID] = false
	end
	
	if selflist["xiufu"..it.ID] == false then
		tbThing:YunYangXiTong(it)
	elseif selflist["xiufu"..it.ID] == true then
		tbThing:CanGuaXiuFu(it)
	end
	
end

function tbThing:YunYangKaiQi(it)
	local shuoming = ""
	local caozuo
	if selflist["lingqi"..it.ID] == nil then
		selflist["lingqi"..it.ID] = false
	end
	if selflist["lingqi"..it.ID] == false then
		shuoming = "开启"
		caozuo = true
	else
		shuoming = "关闭"
		caozuo = false
	end
	CS.Wnd_Message.Show(nil, 2,
	function (s)
		if s == "1" then
			selflist["lingqi"..it.ID] = caozuo
		end
	end, true, "取出法宝", 0, 0, "[color=#FF0000]是否确定"..shuoming.."孕养\n开启状态会抽取绑定者的灵气孕养自身灵性\n关闭状态不会消耗灵气孕养灵物[/color]")
end

function tbThing:YunYangXiTong(it)
	
	local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"残卦孕养")
	if selflist["yunyang"..it.ID] < 100 and it.EquipByWho ~= 0 and btn == false then
		it:AddBtnData("残卦孕养","Icon/29.png","GameMain:GetMod('ThingHelper'):GetThing('Lua_baowu_baguayunyang'):CanGuaYunYang(bind)","八卦碎片已齐，需以长时间蕴养孕养方可以消弭灵物道痕");
	end
	if it.EquipByWho == 0 then
		it:SetDesc(it.def.Desc)
		if selflist["yunyang"..it.ID] > 0 then
			it:SetDesc(string.format(it.def.Desc.."\n[color=#436EEE]当前未被装备，孕养停止\n已孕养灵性：%s％[/color]",math.min(selflist["yunyang"..it.ID],100)))
		end
		return false
	end
	if it.EquipByWho ~= 0 then
		local oldnpc = ThingMgr:FindThingByID(it.EquipByWho)
		if oldnpc.IsDisciple == false then
			it:SetDesc(it.def.Desc.."\n[color=#FF6347]外门弟子无法孕养残卦[/color]")
			return false
		end
		if selflist["lingqi"..it.ID] == nil or selflist["lingqi"..it.ID] == false then
			it:SetDesc(it.def.Desc.."\n[color=#FF6347]已关闭灵物孕养，孕养停止[/color]")
			return false
		end
		local lingdown = math.min(10000,math.floor(oldnpc.LingV/100))
		if oldnpc.LingV < lingdown then
			it:SetDesc(it.def.Desc.."\n[color=#FF6347]当前宿主灵力不足，孕养停止[/color]")
			return false
		end
		
		oldnpc:AddLing(-lingdown)
		selflist["yunyang"..it.ID] = selflist["yunyang"..it.ID]+lingdown/100000+100
		it:SetName("孕养中的"..it.def.ThingName)
		it:SetDesc(string.format(it.def.Desc.."\n[color=#436EEE]孕养中，持续消耗宿主灵气值\n孕养灵性：%s％[/color]",math.min(selflist["yunyang"..it.ID],100)))
		if selflist["yunyang"..it.ID] >= 100 then
			it:RemoveBtnData("残卦孕养")
			it:SetName("充满灵性的"..it.def.ThingName)
			it:SetDesc(it.def.Desc.."\n[color=#FF6347]宝物灵性圆满，可以开启晋阶放向了[/color]")
			selflist["yunyang"..it.ID] = 0
			selflist["xiufu"..it.ID] = true
		end
	end
end

function tbThing:CanGuaYunYang(it)
	it:RemoveBtnData("残卦孕养")
	CS.Wnd_SelectNpc.Instance:Select(
		WorldLua:GetSelectNpcCallback(function(rs) 
			if (rs == nil or rs.Count == 0) then
				return false
			end
			local npc = ThingMgr:FindThingByID(rs[0])
			if it.Bind2Npc == 0 then
				world:ShowMsgBox(it:GetName().."还没有认主\n"..npc:GetName().."无法孕养此物", "孕养失败")
				return false
			end
			if rs[0] ~= it.Bind2Npc then
				world:ShowMsgBox(npc:GetName().."不是"..it:GetName().."的主人，无法孕养此物", "孕养失败")
				return false
			end
			npc:AddCommand("EquipItem",it)
		end), 
	g_emNpcRank.Normal, 1, 1, nil, nil, "请选择一个内门孕养灵物", nil, nil, false, nil, false, g_emNpcRaceType.Wisdom, nil)
end

function tbThing:CanGuaXiuFu(it)
	if selflist["fangxiang"..it.ID] == nil then
		local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"残卦晋阶")
		if btn == false then
			it:AddBtnData("残卦晋阶","Icon/29.png","GameMain:GetMod('ThingHelper'):GetThing('Lua_baowu_baguayunyang'):JinJieFangXiang(bind)","八卦碎片已齐，需以长时间蕴养孕养方可以消弭灵物道痕");
		end
		return false
	end
	if it.EquipByWho == 0 then
		it:SetDesc(it.def.Desc.."\n[color=#FF6347]不在装备状态下，无法修复道痕[/color]")
		return false
	end
end

function tbThing:GetZhuangTai(it)
	return selflist["xiufu"..it.ID],selflist["fangxiang"..it.ID]
end



function tbThing:JinJieFangXiang(it)
	it:RemoveBtnData("残卦晋阶")
	local fangxiang = {"kongbao","lingfa","dunshou","xiuling","tianxin","danling","yunbao"}
	local xuanxiang = {"控宝","灵法","盾守","修灵","天心","丹灵","蕴宝"}
	local shuoming = "[color=#A0522D]残灵卦灵性孕养圆满，请选择残卦晋阶方向，不同的方向将影响晋阶后的八卦加成！[/color]"
	local shuoming = shuoming.."[color=#363636]\n控宝 控宝者，控宝操物，威力无穷      [/color][color=#BF3EFF][size=12] 此方向大幅增加法宝能力      [/size][/color][color=#4F94CD][size=10]晋阶消耗法宝类物品[/size][/color]"
	local shuoming = shuoming.."[color=#363636]\n灵法 灵法者，万法随心，法破万千      [/color][color=#BF3EFF][size=12] 此方向大幅增加术法能力      [/size][/color][color=#4F94CD][size=10]晋阶消耗灵石类物品[/size][/color]"
	local shuoming = shuoming.."[color=#363636]\n盾守 盾守者，水火不浸，万法不侵      [/color][color=#BF3EFF][size=12] 此方向大幅增加护盾能力      [/size][/color][color=#4F94CD][size=10]晋阶消耗鳞羽类物品[/size][/color]"
	local shuoming = shuoming.."[color=#363636]\n修灵 修灵者，修神以灵，悟道以形      [/color][color=#BF3EFF][size=12] 此方向大幅增加修行能力      [/size][/color][color=#4F94CD][size=10]晋阶消耗符咒类物品[/size][/color]"
	local shuoming = shuoming.."[color=#363636]\n天心 天心者，抱元守心，万法归一      [/color][color=#BF3EFF][size=12] 此方向大幅增加历劫能力      [/size][/color][color=#4F94CD][size=10]晋阶消耗地宝类物品[/size][/color]"
	local shuoming = shuoming.."[color=#363636]\n丹灵 丹灵者，食气吞灵，丹者为先      [/color][color=#BF3EFF][size=12] 此方向大幅增加丹术能力      [/size][/color][color=#4F94CD][size=10]晋阶消耗丹药类物品[/size][/color]"
	local shuoming = shuoming.."[color=#363636]\n蕴宝 蕴宝者，万物有灵，化凡为宝      [/color][color=#BF3EFF][size=12] 此方向大幅增加炼宝能力      [/size][/color][color=#4F94CD][size=10]晋阶消耗天材类物品[/size][/color]"
	
	world:ShowStoryBox(shuoming,"灵卦晋阶", xuanxiang, 
	function(s)
		selflist["fangxiang"..it.ID] = fangxiang[s+1]
		it:SetName(xuanxiang[s+1].."-"..it.def.ThingName)
		it:SetDesc(it.def.Desc)
		world:ShowMsgBox("已确定"..it:GetName().."的晋阶方向，请按照残卦需求的物品修复残卦道痕", "晋阶方向")
	end)
end


function tbThing:XiuFuWuPinJianCe(id)
	if selflist["fangxiang"..id] ~= nil then
		print(selflist["wupinid"..it.ID])
	end
	return "FightFaBao"
end



function tbThing:XiuFuWuPinTable(id)
	local list = {"FightFaBao"},{"Item_lingshi"},{"Item_shoupi","Item_yumao"}
	
	local fangxiang = {"kongbao","lingfa","dunshou","xiuling","tianxin","danling","yunbao"}
	for i=1,#fangxiang do
		if selflist["fangxiang"..id] == fangxiang[i] then
		end
	end
end





















































































































































































































































































































































































































































































































































































































































































































































