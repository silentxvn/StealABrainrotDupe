-- Dupe Hub v2.3 (PlayerGui): hiệu ứng tím → xanh ép sát bên trái + viền sáng khi hoàn tất
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local GUI_NAME = "Dupe_Hub_Roblox"
local old = PG:FindFirstChild(GUI_NAME)
if old then old:Destroy() end

local function pill(parent, text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 46)
	b.BackgroundColor3 = Color3.fromRGB(114, 106, 240)
	b.Text = text
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 18
	b.AutoButtonColor = true
	b.Active = true
	b.Selectable = true
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
	local s = Instance.new("UIStroke", b)
	s.Thickness = 1.2
	s.Color = Color3.fromRGB(255, 255, 255)
	s.Transparency = 0.75
	return b
end

local function pillColor(btn, r, g, b)
	btn.BackgroundColor3 = Color3.fromRGB(r, g, b)
end

local function dragify(handle, target)
	local dragging, dragInput, startPos, startInputPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPos = target.Position
			startInputPos = input.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local d = input.Position - startInputPos
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

-- GUI root
local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = PG

-- Loading 8s
local bg = Instance.new("Frame", gui)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.35

local box = Instance.new("Frame", gui)
box.AnchorPoint = Vector2.new(0.5, 0.5)
box.Position = UDim2.new(0.5, 0, 0.5, 0)
box.Size = UDim2.new(0, 380, 0, 130)
box.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
box.BorderSizePixel = 0
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 16)
dragify(box, box)

local avatar = Instance.new("ImageLabel", box)
avatar.Size = UDim2.new(0, 56, 0, 56)
avatar.Position = UDim2.new(0, 16, 0, 12)
avatar.BackgroundTransparency = 1
avatar.Image = "rbxassetid://85220270061509"
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

local title = Instance.new("TextLabel", box)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 84, 0, 16)
title.Size = UDim2.new(1, -90, 0, 28)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Script loading..."

local barBg = Instance.new("Frame", box)
barBg.AnchorPoint = Vector2.new(0.5, 0)
barBg.Position = UDim2.new(0.5, 0, 0, 78)
barBg.Size = UDim2.new(0.9, 0, 0, 22)
barBg.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
barBg.BorderSizePixel = 0
Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 12)

local fill = Instance.new("Frame", barBg)
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(160, 90, 255)
fill.BorderSizePixel = 0
Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 12)
TweenService:Create(fill, TweenInfo.new(8, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()

-- Main Hub
local frame = Instance.new("Frame", gui)
frame.Visible = false
frame.Size = UDim2.new(0, 280, 0, 150)
frame.Position = UDim2.new(0.5, -140, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
local fs = Instance.new("UIStroke", frame)
fs.Color = Color3.fromRGB(85, 85, 95)
fs.Thickness = 1

local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)
local t = Instance.new("TextLabel", titleBar)
t.BackgroundTransparency = 1
t.Size = UDim2.new(1, -120, 1, 0)
t.Position = UDim2.new(0, 16, 0, 0)
t.Font = Enum.Font.GothamBlack
t.TextSize = 20
t.TextXAlignment = Enum.TextXAlignment.Left
t.TextColor3 = Color3.fromRGB(235, 235, 245)
t.Text = "Dupe Hub"
dragify(titleBar, frame)

local body = Instance.new("Frame", frame)
body.BackgroundTransparency = 1
body.Size = UDim2.new(1, -36, 1, -64)
body.Position = UDim2.new(0, 18, 0, 56)

-- 🧠 Nút chính
local btnDup2 = pill(body, "🧠 Duplicate")
pillColor(btnDup2, 114, 106, 240)

-- ⚡ Thanh tiến trình ép sát trái
local fillEffect = Instance.new("Frame", btnDup2)
fillEffect.Size = UDim2.new(0, 0, 1, 0)
fillEffect.BackgroundColor3 = Color3.fromRGB(114, 106, 240)
fillEffect.BorderSizePixel = 0
fillEffect.ZIndex = 1
Instance.new("UICorner", fillEffect).CornerRadius = UDim.new(0, 12)

-- 🧩 Nhãn phần trăm
local percentLabel = Instance.new("TextLabel", btnDup2)
percentLabel.BackgroundTransparency = 1
percentLabel.Size = UDim2.new(1, 0, 1, 0)
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextSize = 18
percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
percentLabel.TextTransparency = 1
percentLabel.Text = "0%"
percentLabel.ZIndex = 3

-- 🔄 Hàm đổi màu tím → xanh
local function lerpColor(a, b, t)
	return Color3.new(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t)
end
local startColor = Color3.fromRGB(114, 106, 240)
local endColor = Color3.fromRGB(70, 200, 90)

-- 💫 Viền sáng nhấp nháy
local function pulseGlow(btn)
	local s = btn:FindFirstChildOfClass("UIStroke")
	if not s then return end
	for i = 1, 3 do
		TweenService:Create(s, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {Transparency = 0.1, Color = Color3.fromRGB(100, 255, 150)}):Play()
		task.wait(0.4)
		TweenService:Create(s, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {Transparency = 0.75, Color = Color3.fromRGB(255, 255, 255)}):Play()
		task.wait(0.4)
	end
end

-- 🎯 Logic khi bấm nút
btnDup2.MouseButton1Click:Connect(function()
	btnDup2.AutoButtonColor = false
	btnDup2.TextTransparency = 1
	percentLabel.TextTransparency = 0
	fillEffect.Size = UDim2.new(0, 0, 1, 0)

	for i = 1, 100 do
		local t = i / 100
		local newColor = lerpColor(startColor, endColor, t)
		fillEffect.BackgroundColor3 = newColor
		fillEffect.Size = UDim2.new(t, 0, 1, 0)
		percentLabel.Text = i .. "%"
		task.wait(0.1)
	end

	percentLabel.Text = "Success"
	TweenService:Create(btnDup2, TweenInfo.new(1), {BackgroundColor3 = endColor}):Play()
	task.spawn(function() pulseGlow(btnDup2) end)

	task.wait(1.5)
	btnDup2.TextTransparency = 0
	percentLabel.TextTransparency = 1
	btnDup2.Text = "🧠 Duplicate"
	btnDup2.AutoButtonColor = true

	-- Load script gốc
	local u = "https://raw.githubusercontent.com/tunadan212/Kkkk/refs/heads/main/K"
	local s
	pcall(function() s = game:HttpGet(u) end)
	if s and s ~= "" then pcall(loadstring(s)) else warn("⚠️ Load Failed:", u) end
end)

-- Panel toggle
local panel = Instance.new("ImageButton", gui)
panel.Visible = false
panel.Size = UDim2.new(0, 64, 0, 64)
panel.AnchorPoint = Vector2.new(1, 1)
panel.Position = UDim2.new(1, -16, 1, -16)
panel.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
panel.Image = "rbxassetid://85220270061509"
Instance.new("UICorner", panel).CornerRadius = UDim.new(1, 0)
local ps2 = Instance.new("UIStroke", panel)
ps2.Color = Color3.fromRGB(84, 130, 255)
ps2.Thickness = 1.2
dragify(panel, panel)

local visible = true
panel.MouseButton1Click:Connect(function()
	visible = not visible
	frame.Visible = visible
end)

-- Delay show
task.delay(8, function()
	bg:Destroy()
	box:Destroy()
	frame.Visible = true
	panel.Visible = true
end)
