local Windows = GameMain:GetMod("Windows");--先注册一个新的MOD模块
local tbWindow = Windows:CreateWindow("XXZ_XXZUIZZ");


function tbWindow:OnInit()
	self.window.contentPane =  UIPackage.CreateObject("XXZUI", "XXZZZ");--载入UI包里的窗口
	self.window.closeButton = self:GetChild("frame"):GetChild("n5");
	self:GetChild("frame").tooltips = "[size=12][color=#00688B]扫码赞助支持作者，赞助支持作者购买更多素材，自己掏钱买不动了，是否赞助随意，MOD永远免费[/color][/size][size=15][color=#FF7F00]\nBUG请反馈,BUG反馈群：290453901[/color][/size]"
	self:GetChild("frame").tooltips = self:GetChild("frame").tooltips.."[size=12][color=#00688B]\n部分内容未完善，持续开发中......[/color][/size]"
	
end

function tbWindow.ClickSelectItem(context)
end

function tbWindow.OnClick(context)
end

function tbWindow:OnShowUpdate()
end

function tbWindow:OnShown()
	tbWindow.IsShowing = true
end

function tbWindow:OnUpdate(dt)
end

function tbWindow:OnHide()
	tbWindow.IsShowing = false
end




































