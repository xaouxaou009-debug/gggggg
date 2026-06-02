local tbThing = GameMain:GetMod("ThingHelper"):GetThing("Lua_baowu_wuxingheyi");
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
	if selflist[it.ID.."jishi"] == nil then
		selflist[it.ID.."jishi"] = 0
	end
	selflist[it.ID.."jishi"] = selflist[it.ID.."jishi"] - dt
	if selflist[it.ID.."jishi"] > 0 then
		return false
	end
	selflist[it.ID.."jishi"] = 5
	local jiaohu = it:CheckCommandSingle("SimpleAction", false)
	
	local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"五行熔炼")
	if it.Count >= 9 and npc == nil then
		if btn == false and jiaohu == nil then
			it:AddBtnData("五行熔炼","Icon/30.png","GameMain:GetMod('ThingHelper'):GetThing('Lua_baowu_wuxingheyi'):WuXingHeYi(bind)","选择一个内门弟子熔炼灵宝。");
		end
	end
	if jiaohu ~= nil then
		
		if selflist[it.ID.."jishu"] == nil then
			selflist[it.ID.."jishu"] = 0
		end
	
		local oldnpc = ThingMgr:FindThingByID(jiaohu.BindNpc)
		if oldnpc == nil then
			return false
		end
		
		local zhuangtai = oldnpc.JobEngine.CurJob:GetCurToil():GetToilKey()
		local sudu = oldnpc.PropertyMgr.Practice.LogicStage
		local Aroundkey = GameUlt.GetNearGrid(it.Key, 2)
		for k,v in pairs(Aroundkey) do
			local npc = Map.Things:GetThingAtGrid(v, 1);
			if oldnpc == npc and zhuangtai == "idle" then
				selflist[it.ID.."jishu"] = selflist[it.ID.."jishu"]+sudu
				world:PlayEffect(10, it.Key, 1);
			end
		end
		if selflist[it.ID.."jishu"] >= 0 then
			it:SetDesc(it.def.Desc.."[color=#B452CD]\n\n灵宝炼化进度："..math.min(100,selflist[it.ID.."jishu"]).."％\n灵宝炼化速度："..sudu.."％/5S")
		end
		if selflist[it.ID.."jishu"] >= 100 then
			selflist[it.ID.."jishu"] = 0
			jiaohu:FinishCommand(true, false)
			local wupin = tbThing:WuPinJianCe(it)
			local itkey = it.Key
			local scwupin = ItemRandomMachine.RandomItem(wupin,nil,1,12,1,1)
			if it.Count > 9 then
				it:ChangeCount(it.Count - 9)
				it:SetDesc(it.def.Desc)
			else
				ThingMgr:RemoveThing(it)
			end
			Map:DropItem(scwupin, itkey, true, true, false, true, 0, false)
		end
			
		--[[print(jiaohu.Dt)
			print(jiaohu.Keep)
			print(jiaohu.BindNpc)
			print(jiaohu.P1)
			print(jiaohu.ID)
			print(jiaohu.MaxDid)
			print(jiaohu.Ani)
			print(jiaohu.OwnerThing)]]
	end
end




function tbThing:WuXingHeYi(it)
	it:RemoveBtnData("五行熔炼")
	local jiaohu = it:CheckCommandSingle("SimpleAction", false)
	if jiaohu ~= nil then
		return false
	end
	CS.Wnd_SelectNpc.Instance:Select(
		WorldLua:GetSelectNpcCallback(function(rs) 
			if (rs == nil or rs.Count == 0) then
				return false
			end
			local jiaohu = it:AddSimpleActionCommand(10, "dazuo", "炼化灵宝",nil, 0, nil,  1 , nil, "SimpleAction")
			jiaohu.BindNpc= rs[0]
			jiaohu.Dt = 10000
		end), 
	g_emNpcRank.Disciple, 1, 1, nil, nil, "请选择一个内门炼化灵宝", nil, nil, false, nil, false, g_emNpcRaceType.Wisdom, nil)
end


function tbThing:WuPinJianCe(it)
	local name = it.def.Name
	if name == "Item_baowu_wuxing_jin1" then
		name = "Item_baowu_wuxing_jin2"
	elseif name == "Item_baowu_wuxing_mu1" then
		name = "Item_baowu_wuxing_mu2"
	elseif name == "Item_baowu_wuxing_shui1" then
		name = "Item_baowu_wuxing_shui2"
	elseif name == "Item_baowu_wuxing_huo1" then
		name = "Item_baowu_wuxing_huo2"
	elseif name == "Item_baowu_wuxing_tu1" then
		name = "Item_baowu_wuxing_tu2"
	end
	return name
end




















