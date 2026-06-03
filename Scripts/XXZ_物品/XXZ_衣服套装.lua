--妖兽BUFF

local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Lua_zhuangbei_yifu1");

local zhuangbeibuff = 
{
{sybuff= "Modifier_shangyi_tiangong",xybuff= "Modifier_xiayi_tiangong",tzbuff= "Modifier_taozhuang_tiangong",canshu= 0 ,tzming= "天工" },
{sybuff= "Modifier_shangyi_tianqiao",xybuff= "Modifier_xiayi_tianqiao",tzbuff= "Modifier_taozhuang_tianqiao",canshu= 0 ,tzming= "天巧" },
{sybuff= "Modifier_shangyi_tianyuan",xybuff= "Modifier_xiayi_tianyuan",tzbuff= "Modifier_taozhuang_tianyuan",canshu= 0 ,tzming= "天元" },
{sybuff= "Modifier_shangyi_tianling",xybuff= "Modifier_xiayi_tianling",tzbuff= "Modifier_taozhuang_tianling",canshu= 0 ,tzming= "天灵" },
{sybuff= "Modifier_shangyi_xuanjiu",xybuff= "Modifier_xiayi_xuanjiu",tzbuff= "Modifier_taozhuang_xuanjiu",canshu= 1 ,tzming= "玄九" },
{sybuff= "Modifier_shangyi_jiuzhuan",xybuff= "Modifier_xiayi_jiuzhuan",tzbuff= "Modifier_taozhuang_jiuzhuan",canshu= 1 ,tzming= "九转" },
{sybuff= "Modifier_shangyi_bailian",xybuff= "Modifier_xiayi_bailian",tzbuff= "Modifier_taozhuang_bailian",canshu= 1 ,tzming= "百炼" },
{sybuff= "Modifier_shangyi_yuqing",xybuff= "Modifier_xiayi_yuqing",tzbuff= "Modifier_taozhuang_yuqing",canshu= 1 ,tzming= "玉清" },
{sybuff= "Modifier_shangyi_shangqing",xybuff= "Modifier_xiayi_shangqing",tzbuff= "Modifier_taozhuang_shangqing",canshu= 1 ,tzming= "上清" },
{sybuff= "Modifier_shangyi_taiqing",xybuff= "Modifier_xiayi_taiqing",tzbuff= "Modifier_taozhuang_taiqing",canshu= 1 ,tzming= "太清" },
{sybuff= "Modifier_shangyi_taiji",xybuff= "Modifier_xiayi_taiji",tzbuff= "Modifier_taozhuang_taiji",canshu= 1 ,tzming= "太极" },
{sybuff= "Modifier_shangyi_wuji1",xybuff= "Modifier_xiayi_wuji1",tzbuff= "Modifier_taozhuang_wuji1",canshu= 1,tzming= "无极【战】"},
{sybuff= "Modifier_shangyi_wuji2",xybuff= "Modifier_xiayi_wuji2",tzbuff= "Modifier_taozhuang_wuji2",canshu= 1,tzming= "无极【御】"},
{sybuff= "Modifier_shangyi_wufa1",xybuff= "Modifier_xiayi_wufa1",tzbuff= "Modifier_taozhuang_wufa1",canshu= 1,tzming= "无法【炼】"},
{sybuff= "Modifier_shangyi_wufa2",xybuff= "Modifier_xiayi_wufa2",tzbuff= "Modifier_taozhuang_wufa2",canshu= 1,tzming= "无法【灵】"},
{sybuff= "",xybuff= "",tzbuff= "",canshu= 1},
{sybuff= "",xybuff= "",tzbuff= "",canshu= 1},







} 
 



function tbModifier:Enter(modifier, npc)

	local buffname = modifier.def.Name
	local xuqiubuff
	local TZbuff
	local TZming
	local canshu
	local TZjihuo = 0 

	for k,v in pairs(zhuangbeibuff) do
		if buffname == v.sybuff then
			xuqiubuff = v.xybuff
			TZbuff = v.tzbuff
			canshu = v.canshu
			TZming = v.tzming
		end
		if buffname == v.xybuff then
			xuqiubuff = v.sybuff
			TZbuff = v.tzbuff
			canshu = v.canshu
			TZming = v.tzming
		end
	end
	local bufflist = npc.PropertyMgr.m_lisModifiers
	
	for k,v in pairs(bufflist) do
		if xuqiubuff == v.def.Name then
			TZjihuo = 1
		end
	end
	
	if TZjihuo == 1 then
	if npc.IsDisciple and canshu == 0 then
		world:ShowMsgBox(npc:GetName().."装备了[color=#FF7F00] "..TZming.." [/color]套装，但是与装备不合，无法激活隐藏属性！！！", "激活失败")
		return false 
	end
	if not npc.IsDisciple and canshu == 1 then
		world:ShowMsgBox(npc:GetName().."装备了[color=#FF7F00] "..TZming.." [/color]套装，但是与装备不合，无法激活隐藏属性！！！", "激活失败")
		return false 
	end
	end
	
	if TZjihuo == 1 then
		npc:AddModifier(TZbuff)
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

	local buffname = modifier.def.Name
	local TZbuff
	
	for k,v in pairs(zhuangbeibuff) do
		if buffname == v.sybuff then
			TZbuff = v.tzbuff
		end
		if buffname == v.xybuff then
			TZbuff = v.tzbuff
		end
	end
	if TZbuff ~= nil then
		npc:RemoveModifier(TZbuff)
	end
	

end




--获取存档数据

function tbModifier:OnGetSaveData()

end



--载入存档数据

function tbModifier:OnLoadData(modifier, npc, tbData)

end




























