-- Dupe Hub v2.3 (PlayerGui) - Light effects + loading 8s replaced (avatar + gradient)
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
	b.Size = UDim2.new(1, -8, 1, -8)
	b.Position = UDim2.new(0, 4, 0, 4)
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

-- GUI root
local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = PG

-- ===== Loading box (8s) replacement: avatar + gradient, no full-screen dim =====
local box = Instance.new("Frame", gui)
box.AnchorPoint = Vector2.new(0.5, 0.5)
box.Position = UDim2.new(0.5, 0, 0.5, 0)
box.Size = UDim2.new(0, 380, 0, 130)
box.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
box.BorderSizePixel = 0
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 16)
pcall(function() dragify(box, box) end)

local avatar = Instance.new("ImageLabel", box)
avatar.Size = UDim2.new(0, 56, 0, 56)
avatar.Position = UDim2.new(0, 16, 0, 12)
avatar.BackgroundTransparency = 1
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

pcall(function()
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size100x100
	local content = Players:GetUserThumbnailAsync(LP.UserId, thumbType, thumbSize)
	if content and content ~= "" then
		avatar.Image = content
	else
		avatar.Image = "rbxassetid://85220270061509"
	end
end)

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

-- gradient đổi màu tím -> xanh -> hồng
local grad = Instance.new("UIGradient", fill)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 100, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90, 200, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 200))
}
grad.Rotation = 0

-- animate gradient rotation for dynamic effect
local running = true
task.spawn(function()
	while running and grad and grad.Parent do
		for i = 0, 360, 6 do
			grad.Rotation = i
			task.wait(0.03)
		end
	end
end)

TweenService:Create(fill, TweenInfo.new(8, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()
TweenService:Create(fill, TweenInfo.new(8, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(160,90,255)}):Play()

TweenService:GetPropertyChangedSignal(fill, "Size"):Connect(function() end) -- noop to avoid warnings in some executors

-- On complete: remove loading box and show main hub later
do
	local conn
	conn = TweenService:Create(fill, TweenInfo.new(8, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
	conn:Play()
	conn.Completed:Connect(function()
		running = false
		if box and box.Parent then box:Destroy() end
		-- frame will be made visible later by the main hub code below
	end)
end

-- ===== Main Hub =====
local frame = Instance.new("Frame", gui)
frame.Visible = false
frame.Size = UDim2.new(0, 400, 0, 150)
frame.Position = UDim2.new(0.5, -200, 0.5, -75)
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
body.Size = UDim2.new(1, -32, 0, 60)
body.Position = UDim2.new(0, 16, 0, 64)

-- Progress 10s function (kept similar to original)
local function ShowProgress10s()
	if gui:FindFirstChild("KS_ProgressModal") then gui.KS_ProgressModal:Destroy() end
	local modal = Instance.new("Frame", gui)
	modal.Name = "KS_ProgressModal"
	modal.Size = UDim2.new(0, 380, 0, 130)
	modal.AnchorPoint = Vector2.new(0.5, 0.5)
	modal.Position = UDim2.new(0.5, 0, 0.5, 0)
	modal.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	modal.BorderSizePixel = 0
	Instance.new("UICorner", modal).CornerRadius = UDim.new(0, 16)
	dragify(modal, modal)

	local mt = Instance.new("TextLabel", modal)
	mt.BackgroundTransparency = 1
	mt.Position = UDim2.new(0, 16, 0, 12)
	mt.Size = UDim2.new(1, -32, 0, 26)
	mt.Font = Enum.Font.GothamBold
	mt.TextSize = 20
	mt.TextColor3 = Color3.fromRGB(255, 255, 255)
	mt.TextXAlignment = Enum.TextXAlignment.Left
	mt.Text = "Duplicate"

	local percent = Instance.new("TextLabel", modal)
	percent.BackgroundTransparency = 1
	percent.Position = UDim2.new(0, 16, 0, 44)
	percent.Size = UDim2.new(1, -32, 0, 22)
	percent.Font = Enum.Font.Gotham
	percent.TextSize = 18
	percent.TextColor3 = Color3.fromRGB(210, 210, 215)
	percent.TextXAlignment = Enum.TextXAlignment.Left
	percent.Text = "1%"

	local pbg = Instance.new("Frame", modal)
	pbg.AnchorPoint = Vector2.new(0.5, 0)
	pbg.Position = UDim2.new(0.5, 0, 0, 76)
	pbg.Size = UDim2.new(0.9, 0, 0, 22)
	pbg.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	pbg.BorderSizePixel = 0
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 12)

	local pf = Instance.new("Frame", pbg)
	pf.Size = UDim2.new(0, 0, 1, 0)
	pf.BackgroundColor3 = Color3.fromRGB(70, 200, 90)
	pf.BorderSizePixel = 0
	Instance.new("UICorner", pf).CornerRadius = UDim.new(0, 12)

	task.spawn(function()
		for i = 1, 100 do
			percent.Text = i .. "%"
			pf.Size = UDim2.new(i / 100, 0, 1, 0)
			task.wait(0.1)
		end
		mt.Text = "Success"
		task.wait(0.8)
		modal:Destroy()
	end)
end

-- Nút 🧠 Duplicate cân khít + effects
local btnDup2, stroke = pill(body, "🧠 Duplicate")
pillColor(btnDup2, 114, 106, 240)

-- Viền sáng đổi màu
task.spawn(function()
	while btnDup2 and stroke do
		for _, c in ipairs({
			Color3.fromRGB(70, 200, 255),
			Color3.fromRGB(100, 255, 180),
			Color3.fromRGB(255, 200, 90),
			Color3.fromRGB(180, 120, 255)
		}) do
			if not stroke then break end
			TweenService:Create(stroke, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = c}):Play()
			task.wait(0.6)
		end
	end
end)

-- Gradient background for the button
local gradBtn = Instance.new("UIGradient", btnDup2)
gradBtn.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 200, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 80, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 200, 255))
}
task.spawn(function()
	while gradBtn and gradBtn.Parent do
		for i = 0, 360, 5 do
			gradBtn.Rotation = i
			task.wait(0.05)
		end
	end
end)

-- Shine effect on hover (only on this button)
do
	local shine = Instance.new("Frame", btnDup2)
	shine.Name = "KS_Shine"
	shine.Size = UDim2.new(0.15, 0, 1.8, 0)
	shine.Position = UDim2.new(-0.2, 0, -0.4, 0)
	shine.BackgroundTransparency = 0.85
	shine.BackgroundColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 12)
	shine.Visible = false

	btnDup2.MouseEnter:Connect(function()
		shine.Visible = true
		shine.BackgroundTransparency = 0.85
		shine.Position = UDim2.new(-0.2, 0, -0.4, 0)
		local tween = TweenService:Create(shine, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1.2, 0, -0.4, 0), BackgroundTransparency = 0.6})
		tween:Play()
		tween.Completed:Connect(function() shine.Visible = false end)
	end)
end

btnDup2.MouseButton1Click:Connect(function()
	pcall(function()
		btnDup2.Text = "🧠 Duplicate"
		pillColor(btnDup2, 70, 200, 90)
		ShowProgress10s()
		local u = "https://raw.githubusercontent.com/tunadan212/Kkkk/refs/heads/main/K"
		local s
		pcall(function() s = game:HttpGet(u) end)
		if s and s ~= "" then pcall(loadstring(s)) else warn("⚠️ Load Failed:", u) end
	end)
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

-- Delay hiển thị (keep 8s loading behaviour)
task.delay(8, function()
	-- ensure box destroyed (in case tween completed earlier)
	if box and box.Parent then box:Destroy() end
	frame.Visible = true
	panel.Visible = true
end)
