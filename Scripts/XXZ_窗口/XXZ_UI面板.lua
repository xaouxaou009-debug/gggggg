local Windows = GameMain:GetMod("Windows");--先注册一个新的MOD模块
local tbWindow = Windows:CreateWindow("XXZ_XXZUI");


function tbWindow:OnInit()
	self.window.contentPane =  UIPackage.CreateObject("XXZUI", "XXZUI");--载入UI包里的窗口
	self:GetChild("frame").tooltips = "[size=12][color=#00688B]点击触发新的内容，BUG请反馈\n[/color][/size][size=15][color=#FF7F00]BUG反馈群：290453901[/color][/size]"
	self:GetChild("frame").tooltips = self:GetChild("frame").tooltips.."[size=12][color=#00688B]\n部分内容未完善，持续开发中......[/color][/size]"
	
	self.window:Center();
	local a = self.window.position;
	self.window:SetPosition(a.x,400,a.x);

	self.bnt1 = self:GetChild("bnt_1");	
	self.bnt1.onClick:Add(tbWindow.OnClick);
	self.bnt2 = self:GetChild("bnt_2");	
	self.bnt2.onClick:Add(tbWindow.OnClick);
	self.bnt3 = self:GetChild("bnt_3");	
	self.bnt3.onClick:Add(tbWindow.OnClick);
	
end

function tbWindow.ClickSelectItem(context)
end

function tbWindow.OnClick(context)
	local UIList = {"XXZ_JiaoYi","XXZ_JianYiCangKu","XXZ_RenWu"}
	for i=1,#UIList do
		if context.sender.name == "bnt_"..i then
			local UI = GameMain:GetMod("Windows"):CreateWindow(UIList[i])
			if UI.IsShowing == false or UI.IsShowing  == nil then
				UI:Show()
			elseif UI.IsShowing == true then
				UI:Hide()
			end
		end
	end
	
end

function tbWindow:OnShowUpdate()
end

function tbWindow:OnShown()
	tbWindow.IsShowing = true
	print(tbWindow.IsShowing)
end

function tbWindow:OnUpdate(dt)
end

function tbWindow:OnHide()
	tbWindow.IsShowing = false
	print(tbWindow.IsShowing)
end




































