-- Dupe Hub v2.4 (PlayerGui): viền sáng động + màu chạy + hiệu ứng glow pulse quanh nút Duplicate
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local GUI_NAME = "Dupe_Hub_Roblox"
local old = PG:FindFirstChild(GUI_NAME)
if old then old:Destroy() end

-- ========== Hàm tiện ích ==========
local function pill(parent, text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -8, 1, -8)
	b.Position = UDim2.new(0, 4, 0, 4)
	b.BackgroundColor3 = Color3.fromRGB(114, 106, 240)
	b.Text = text
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 18
	b.AutoButtonColor = true
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
	local s = Instance.new("UIStroke", b)
	s.Thickness = 1.6
	s.Color = Color3.fromRGB(255, 255, 255)
	s.Transparency = 0.3
	return b, s
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

-- ========== GUI chính ==========
local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = PG

-- Màn hình loading
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

local title = Instance.new("TextLabel", box)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 24, 0, 24)
title.Size = UDim2.new(1, -48, 0, 28)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Loading Dupe Hub..."

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

-- ========== Khung chính ==========
local frame = Instance.new("Frame", gui)
frame.Visible = false
frame.Size = UDim2.new(0, 400, 0, 150)
frame.Position = UDim2.new(0.5, -200, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

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
body.Size = UDim2.new(1, -32, 0, 60)
body.Position = UDim2.new(0, 16, 0, 64)

-- ========== Nút Duplicate ==========
local btnDup2, stroke = pill(body, "🧠 Duplicate")

-- Hiệu ứng viền sáng đổi màu
task.spawn(function()
	while btnDup2 do
		for _, c in ipairs({
			Color3.fromRGB(70, 200, 255),
			Color3.fromRGB(100, 255, 180),
			Color3.fromRGB(255, 200, 90),
			Color3.fromRGB(180, 120, 255)
		}) do
			if not stroke then break end
			TweenService:Create(stroke, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Color = c}):Play()
			task.wait(0.6)
		end
	end
end)

-- Hiệu ứng gradient chạy
local grad = Instance.new("UIGradient", btnDup2)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 200, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 80, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 200, 255))
}
task.spawn(function()
	while grad do
		for i = 0, 360, 5 do
			grad.Rotation = i
			task.wait(0.05)
		end
	end
end)

-- 🌟 Hiệu ứng glow pulse (sáng dần rồi mờ dần)
task.spawn(function()
	while btnDup2 do
		TweenService:Create(stroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0}):Play()
		task.wait(1.2)
		TweenService:Create(stroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 0.7}):Play()
		task.wait(1.2)
	end
end)

-- Khi nhấn vào nút
btnDup2.MouseButton1Click:Connect(function()
	pillColor(btnDup2, 70, 200, 90)
	local m = Instance.new("TextLabel", gui)
	m.Size = UDim2.new(0, 300, 0, 50)
	m.AnchorPoint = Vector2.new(0.5, 0.5)
	m.Position = UDim2.new(0.5, 0, 0.5, 0)
	m.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	m.TextColor3 = Color3.fromRGB(255, 255, 255)
	m.Font = Enum.Font.GothamBold
	m.Text = "Duplicating... (20s)"
	m.TextSize = 20
	Instance.new("UICorner", m).CornerRadius = UDim.new(0, 12)
	wait(20)
	m.Text = "✅ Duplicate Success!"
	wait(1.5)
	m:Destroy()
end)

-- Panel thu gọn
local panel = Instance.new("ImageButton", gui)
panel.Visible = false
panel.Size = UDim2.new(0, 64, 0, 64)
panel.AnchorPoint = Vector2.new(1, 1)
panel.Position = UDim2.new(1, -16, 1, -16)
panel.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
panel.Image = "rbxassetid://85220270061509"
Instance.new("UICorner", panel).CornerRadius = UDim.new(1, 0)
dragify(panel, panel)
local visible = true
panel.MouseButton1Click:Connect(function()
	visible = not visible
	frame.Visible = visible
end)

-- Delay hiện Hub
task.delay(8, function()
	bg:Destroy()
	box:Destroy()
	frame.Visible = true
	panel.Visible = true
end)
