local XXZEvent = GameMain:GetMod("XXZEvent_jiangli_shichang")
local tbEvent = GameMain:GetMod("_Event");


XXZMOD = XXZMOD or {}


function XXZEvent:OnSave()
end


function XXZEvent:OnLoad(t)
end


function XXZEvent:OnInit()
	local UI = GameMain:GetMod("Windows"):CreateWindow("XXZ_XXZUI")
	print(CS.XiaWorld.GameWatch.Instance.Mode)
	if CS.GameMain.Instance.FightMap == false and World.GameMode ~= CS.XiaWorld.g_emGameMode.Build then
		if UI.IsShowing == false or UI.IsShowing == nil then
			GameMain:GetMod("Windows"):CreateWindow("XXZ_XXZUI"):Show()
		end
	elseif CS.GameMain.Instance.FightMap == true and World.GameMode ~= CS.XiaWorld.g_emGameMode.Build then
		if UI.IsShowing == true then
			GameMain:GetMod("Windows"):CreateWindow("XXZ_XXZUI"):Hide()
		end
	end
end


function XXZEvent:OnEnter()
	tbEvent:RegisterEvent(g_emEvent.SelectNpc, XXZEvent.OnSelectNpc, "XXZEvent_jiangli_shichang");	
	tbEvent:RegisterEvent(g_emEvent.NpcDeath, XXZEvent.OnNpcDeath, "XXZEvent_jiangli_shichang");	
	tbEvent:RegisterEvent(g_emEvent.DayChange, XXZEvent.OnDayChange, "XXZEvent_jiangli_shichang");	
	tbEvent:RegisterEvent(g_emEvent.NpcSleepBeDisturbed, XXZEvent.OnSleepBeDisturbed, "XXZEvent_jiangli_shichang");
	tbEvent:RegisterEvent(g_emEvent.ThingUpdate, XXZEvent.OnThingUpdateData, "XXZEvent_jiangli_shichang");
	tbEvent:RegisterEvent(g_emEvent.WarehouseItemChange, XXZEvent.OnWarehouseItemChange, "XXZEvent_jiangli_shichang");
	tbEvent:RegisterEvent(g_emEvent.SelectItem, XXZEvent.OnSelectItem, "XXZEvent_jiangli_shichang");
	tbEvent:RegisterEvent(g_emEvent.SelectPlant, XXZEvent.OnSelectPlant, "XXZEvent_jiangli_shichang");
	tbEvent:RegisterEvent(g_emEvent.SelectBuilding, XXZEvent.OnSelectBuilding, "XXZEvent_jiangli_shichang");
	
end

 
function XXZEvent:OnStep(dt)

end 

function XXZEvent.OnDayChange(t,obj)
end



function XXZEvent.OnSelectNpc(t,npc,obj)
end

function XXZEvent.OnSelectItem(t,item)
end


function XXZEvent.OnSelectPlant(t,npc)
	
end

function XXZEvent.OnSelectBuilding(t,npc)
	
end



function XXZEvent.OnNpcDeath(t,npc,obj)
end



function XXZEvent.OnWarehouseItemChange(t,sender,obj)
end

function XXZEvent.OnThingUpdateData(t,obj)
end

function XXZEvent.OnSleepBeDisturbed(t,npc,obj)
end























