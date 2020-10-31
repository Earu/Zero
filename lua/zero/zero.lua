local Zero = _G.Zero or {}
_G.Zero = Zero

local TAG = "Zero"

list.Set("DesktopWindows", "Zero", {
	title = "Zero",
	icon = "zero/logo.png",
	init = function()
		if not CLIENT then return end
		Zero:CreateEditor()
	end
})

if SERVER then
	resource.AddFile("materials/zero/logo.png")
end

if CLIENT then
	include("zero/client/vgui/editor.lua")

	function Zero:CreateEditor()
		if IsValid(self.Editor) then return end
		self.Editor = vgui.Create("ZeroEditor")
	end

	Zero.NextToggle = 0
	function Zero:ToggleEditor()
		if not IsValid(self.Editor) then return end
		if CurTime() >= Zero.NextToggle then
			self.Editor:SetVisible(not self.Editor:IsVisible())
			Zero.NextToggle = CurTime() + 0.25
		end
	end

	hook.Add("PreRender", TAG, function()
		if (input.IsKeyDown(KEY_LCONTROL) or input.IsKeyDown(KEY_RCONTROL)) and input.IsKeyDown(KEY_E) then
			Zero:ToggleEditor()
		end
	end)

	hook.Add("CalcView", TAG, function(ply, pos, angles, fov)
		if not IsValid(self.Editor) then return end
		return {
			origin = pos - ((angles:Forward() * ply:GetModelScale() * 100) + Vector(0, 0, ply:OBBMaxs().z)),
			angles = angles,
			fov = fov,
			drawviewer = true
		}
	end)
end