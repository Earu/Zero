local EDITOR_URL = "https://pac-zero.github.io/Zero-Editor/"

local EDITOR = {}

function EDITOR:Init()
	local w, h = ScrW(), ScrH() / 2
	local editor = self

	self:SetSize(w, h)
	self:SetMinimumSize(w, 20)
	self:SetPos(0, h)
	self:MakePopup()
	self.btnMinim:Hide()
	self.btnMaxim:Hide()
	self.btnClose:Hide()

	self.CloseBtn = vgui.Create("DButton")
	self.CloseBtn:SetSize(25, 25)
	self.CloseBtn:SetPos(w - self.CloseBtn:GetWide(), h - self.CloseBtn:GetTall() + 5)
	self.CloseBtn:SetText("")

	function self.CloseBtn:DoClick()
		editor:Remove()
	end

	function self.CloseBtn:Paint(w, h)
		surface.SetDrawColor(150, 0, 0)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(255, 0, 0)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetTextColor(255, 0, 0)
		surface.SetFont("DermaDefault")
		local tw, th = surface.GetTextSize("x")
		surface.SetTextPos(w / 2 - tw / 2, h / 2 - th / 2)
		surface.DrawText("X")
	end

	self.HTML = self:Add("DHTML")
	self.HTML:OpenURL(EDITOR_URL)
	self.HTML:SetPos(0, 5)
	self.HTML:SetSize(self:GetWide(), self:GetTall() - 5)
end

function EDITOR:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 190)
	surface.DrawRect(0, 0, w, h)
end

function EDITOR:PerformLayout(w, h)
	local _, pos_y = self:GetPos()
	self.CloseBtn:SetPos(w - self.CloseBtn:GetWide(), pos_y - self.CloseBtn:GetTall())
	self.HTML:SetSize(w, h - 5)
end

function EDITOR:OnRemove()
	self.CloseBtn:Remove()
end

function EDITOR:Think()
	local mouse_y = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

	if self.Sizing then
		local y = mouse_y
		local cur_x, _ = self:GetPos()

		self:SetPos(cur_x, y)
		self:SetTall(ScrH() - y)
		self:SetCursor("sizens")

		if self:GetTall() <= 50 then
			self:SetPos(cur_x, ScrH() - 50)
			self:SetTall(50)
		end

		return
	end

	local _, screen_y = self:LocalToScreen(0, 0)
	if mouse_y >= screen_y and mouse_y < screen_y + 5 then
		self:SetCursor("sizens")
		return
	end

	self:SetCursor("arrow")
end

function EDITOR:OnMousePressed()
	local _, screen_y = self:LocalToScreen(0, 0)
	local mouse_y = gui.MouseY()
	if mouse_y >= screen_y and mouse_y < screen_y + 5 then
		self.Sizing = true
		self:MouseCapture(true)
	end
end

function EDITOR:OnMouseReleased()
	self.Sizing = nil
	self:MouseCapture(false)
end

vgui.Register("ZeroEditor", EDITOR, "DFrame")