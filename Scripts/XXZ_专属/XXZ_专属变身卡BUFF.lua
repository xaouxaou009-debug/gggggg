
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Lua_Modifier_zhuanshu_bianshenka");

local BianShen = {
{BuffName = "Modifier_zhuanshu_bianshen_luxueqi" ,Mod = "Mod/Npc/LXQ/LXQ.FBX" ,CHName = "[color=#7FFFD4]天琊神女•陆雪琪[/color]"},
{BuffName = "Modifier_zhuanshu_bianshen_biyao" ,Mod = "Mod/Npc/BY/BY.FBX" ,CHName = "[color=#66CD00]碧瑶仙子•碧瑶[/color]"},
{BuffName = "Modifier_zhuanshu_bianshen_lvbu" ,Mod = "Mod/Npc/LvBu/LvBu.FBX" ,CHName = "[color=#FFD700]不败战神•吕布[/color]"},
{BuffName = "Modifier_zhuanshu_bianshen_wukong" ,Mod = "Mod/Npc/SunWuKong/SunWuKong.FBX" ,CHName = "[color=#FF8C00]齐天大圣•孙悟空[/color]"},
{BuffName = "Modifier_zhuanshu_bianshen_libai" ,Mod = "Mod/Npc/LiBai/LiBai.FBX" ,CHName = "[color=#EE2C2C]青莲谪仙•李白[/color]"},
{BuffName = "Modifier_zhuanshu_bianshen_diaochan" ,Mod = "Mod/Npc/DiaoChan/DiaoChan.FBX" ,CHName = "[color=#BA55D3]闭月仙子•貂蝉[/color]"},
{BuffName = "Modifier_zhuanshu_bianshen_yuji" ,Mod = "Mod/Npc/YuJi/YuJi.FBX" ,CHName = "[color=#458B74]死生契阔•虞姬[/color]"},
{BuffName = "Modifier_zhuanshu_bianshen_guanyu" ,Mod = "Mod/Npc/GuanYu/GuanYu.FBX" ,CHName = "[color=#C0FF3E]忠义无双•关羽[/color]"},
{BuffName = "Modifier_zhuanshu_bianshen_zixia" ,Mod = "Mod/Npc/ZiXia/ZiXia.FBX" ,CHName = "[color=#BF3EFF]紫霞仙子•紫霞[/color]"},
{BuffName = "Modifier_zhuanshu_bianshen_houyi" ,Mod = "Mod/Npc/HouYi/HouYi.FBX" ,CHName = "[color=#FF4500]箭射九日•后羿[/color]"},
}


function tbModifier:Enter(modifier, npc)
	
	for k,v in pairs(BianShen) do 
		if modifier.def.Name == v.BuffName then
			npc:AddNpcModPath(v.Mod)	--更换模型
			npc.LuaHelper:AddTitle(v.CHName,npc:GetName().."获得"..v.CHName.."变身卡的加持\n幻化成了"..v.CHName.."的模样",4)
			modifier.Desc = npc:GetName().."获得"..v.CHName.."变身卡的加持\n幻化成了"..v.CHName.."的模样"
			world:ShowMsgBox(npc:GetName().."幻化成了"..v.CHName.."的模样\n模型持续期间获得专属称号\n[size=12][color=#40E0D0]本模型由【Marshal丿游少】制作[/color]", "外形幻化")
		end
	end
	if npc.view ~= nil then
		npc.view.needUpdateMod = true;
	end
end


--modifier step
function tbModifier:Step(modifier, npc, dt)

end



--层数更新

function tbModifier:UpdateStack(modifier, npc, add)
end



--离开modifier

function tbModifier:Leave(modifier, npc)

	for k,v in pairs(BianShen) do 
		if modifier.def.Name == v.BuffName then
			npc:RemoveNpcModPath(v.Mod)
			npc:RemoveTitleByName(v.CHName)
		end
	end
	if npc.view ~= nil then
		npc.view.needUpdateMod = true;
	end
end




--获取存档数据

function tbModifier:OnGetSaveData()
end



--载入存档数据

function tbModifier:OnLoadData(modifier, npc, tbData)
end




























