local Windows = GameMain:GetMod("Windows");--先注册一个新的MOD模块
local tbWindow = Windows:CreateWindow("XXZ_JianZhuCangKu")

local CangKuSeve = GameMain:GetMod("ThingHelper"):GetThing("XXZ_JianZhuCangKu_SEVE")
local tbEvent = GameMain:GetMod("_Event");
local selflist = selflist or {}


function tbWindow:OnInit()
	self.window.contentPane =  UIPackage.CreateObject("XXZUI", "XXZCangKu2");--载入UI包里的窗口
	self.window.closeButton = self:GetChild("frame"):GetChild("n5");
	self:GetChild("frame").tooltips = "[size=12][color=#00688B]点选仓库中的物品会直接全部取出[/color][/size]"
	self.BdName = self:GetChild("frame").title
	
	
	self.TextInput1 = self:GetChild("TextInput2");
	self.TextInput1.title = "查询"
	self.TextInput1.tooltips = "[size=12][color=#00688B]可以在此处输入文字来查询仓库中的物品[/color][/size]"
	
	self.list = self:GetChild("list1")
	self.list.onClickItem:Add(tbWindow.ClickSelectItem)
	
	self.bnt1 = self:GetChild("bnt_1");	
	self.bnt1.onClick:Add(tbWindow.OnClick);
	self.bnt1.onRightClick:Add(tbWindow.OnClick);
	
	self.window:Center();
	local a = self.window.position;
	self.window:SetPosition(a.x,100,a.x);
end

function tbWindow.ClickSelectItem(context)
	list = tbWindow:GetChild("list1")
	local name = context.data.apexIndex
	local building = tbWindow:GetBuilding()
	if context.sender.name == "list1" and building ~= nil then
		local items = building.Bag.m_lisItems
		local item = ThingMgr:FindThingByID(name)
		building.Bag:DropItem(item,0)
		tbWindow:OnShowUpdate()
	end
end

function tbWindow.OnClick(context)
	if context.sender.name == "bnt_1" then
		local countmax = selflist["countmax"]
		local xiaohao = 5888+countmax*5888
		local shuoming = "当前为开启第"..(countmax+1).."个格子，需要消耗点数"..xiaohao.."点"
		local dianshu = GameMain:GetMod("ZH_zhanghu"):AddLingNum()
		if dianshu < xiaohao then
			world:ShowMsgBox(shuoming.."\n超出了你拥有的修炼点，无法购买", "开启失败")
			return false
		end
		CS.Wnd_Message.Show(nil, 2,
		function (s)
			if s == "1" then	
				CangKuSeve:SetCountMax(1)
				GameMain:GetMod("ZH_zhanghu"):AddLingNum(-xiaohao)
				if WorldLua:CheckRate(0.03+(0.2/selflist["countmax"])) then
					CangKuSeve:SetCountMax(1)
					world:ShowMsgBox("你在开启仓库位的时候获得了神的祝福，额外开启了一个位置", "开启失败")
				end
				tbWindow:OnShowUpdate()
			end
		end, true, "仓库扩展", 0, 0,shuoming.."\n是否确定开启新的仓储位")
	end
end

function tbWindow:OnShowUpdate()

	local countmax = selflist["countmax"]+12
	self.bnt1.tooltips = "[size=12][color=#00688B]当前仓库可存储物品上限"..countmax.."种\n点击扩展消耗点数拓展仓库格数\n格数越多消耗点数越多\n所有特殊仓库格数共享[/color][/size]"
	
	
	self.list:RemoveChildrenToPool()
	
	if self.building ~= nil then
		self.bagcount = self.building.Bag.m_lisItems.Count
		local items = self.building.Bag.m_lisItems
		if items.Count > 0 then
			if self.text == nil or self.text == "查询" or string.len(self.text) == 0 then
				for i=0,items.Count-1 do
					local item = self.list:AddItemFromPool()
					local tname = items[i]
					item.icon = tname.def.TexPath
					item.title = tname:GetName()
					item.apexIndex = tname.ID
					self.list:SetChildIndex(item,i)
					item.onRollOver:Set(
					function() 
						self.showitem1 = true
						self.showitem2 = tname
					end
					);
					item.onRollOut:Set(
					function() 
						self.showitem1 = false
						self.showitem2 = nil
					end);
				end
			else
				for i=0,items.Count-1 do
					local tname = items[i]
					if string.find(tname.def.ThingName,self.text) then
						local item = self.list:AddItemFromPool()
						item.icon = tname.def.TexPath
						item.title = tname:GetName()
						item.apexIndex = tname.ID
						self.list:SetChildIndex(item,i)
						item.onRollOver:Set(
						function() 
							self.showitem1 = true
							self.showitem2 = tname
						end
						);
						item.onRollOut:Set(
						function() 
							self.showitem1 = false
							self.showitem2 = nil
						end);
					end
				end
			end
		end
		
	end
end

function tbWindow:OnShown()
	tbWindow.IsShowing = true
end

function tbWindow:OnUpdate(dt)
	if self.text ~= self.TextInput1.title then
		self.text = self.TextInput1.title
		tbWindow:OnShowUpdate()
	end
	if self.BdName ~= self:GetChild("frame").title then
		self.BdName = self:GetChild("frame").title
		if self.building ~= nil then
			self.building:SetName(self.BdName)
		end
	end
	if self.bagcount ~= self.building.Bag.m_lisItems.Count then
		tbWindow:OnShowUpdate()
	end
	if self.showitem1 == true then
		CS.Wnd_TipPopPanel.Instance.contentPane.visible = true;
		CS.Wnd_TipPopPanel.Instance:ShowOrUpdate(self.showitem2) 
	else
		CS.Wnd_TipPopPanel.Instance.contentPane.visible = false; 
	end
end

function tbWindow:OnHide()
	tbWindow.IsShowing = false
end
function tbWindow:BntBuilding(building)
	self.building = building
end

function tbWindow:GetBuilding()
	return self.building 
end







function CangKuSeve:OnInit()
	tbEvent:RegisterEvent(g_emEvent.DayChange, CangKuSeve.OnDayChange, "XXZ_JianZhuCangKu_SEVE")
end

function CangKuSeve:OnGetSaveData()
	return selflist
end


function CangKuSeve:OnLoadData(tbData)
	selflist = tbData
end

function CangKuSeve:OnStep(dt)
	local it = self.it
	local id = self.it.ID
	if selflist["countmax"] == nil then
		selflist["countmax"] = 0
	end
	
	local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"存储物品");
	if btn == false then
		it:AddBtnData("存储物品","Icon/13.png","GameMain:GetMod('ThingHelper'):GetThing('XXZ_JianZhuCangKu_SEVE'):CunChuWuPin(bind)","选择物品存储到仓库中，每个物品上限为一且不可叠加，可以存储有特殊属性的物品且取出时不会发生变化");
	end
	local btn = GameMain:GetMod("XXZ_xiuxianzhuanluatable"):GetBtn(it,"查看仓库");
	if btn == false then
		it:AddBtnData("查看仓库","Icon/13.png","GameMain:GetMod('ThingHelper'):GetThing('XXZ_JianZhuCangKu_SEVE'):ChakanCangKu(bind)","选择物品存储到仓库中，每个物品上限为一且不可叠加，可以存储有特殊属性的物品且取出时不会发生变化");
	end
end 

function CangKuSeve:CunChuWuPin(building)
	local count = building.Bag.m_lisItems.Count 
	local countmax = 12+selflist["countmax"]
	
	if countmax <= count  then
		world:ShowMsgBox(building:GetName().."存储物品达到上限，无法继续存储\n当前存储上限"..countmax.."\n你可以升级仓库，来存储更多的物品", "存储失败")
		return false
	end
	world:EnterUILuaMode("XXZ_JianZhuCangKu_CunChu",building,itemid)
end 

function CangKuSeve:ChakanCangKu(building)
	tbWindow:BntBuilding(building)
	if tbWindow.IsShowing == true then
		tbWindow:Hide()
	end
	tbWindow:Show()
end 
function CangKuSeve:SetCountMax(num)
	if num ~= nil then
		selflist["countmax"] = selflist["countmax"]+num
	end
	return selflist["countmax"]
end




























