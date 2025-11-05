-- Dupe Hub v2.2 (Màu nền cũ)
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
	b.Size = UDim2.new(0.66, 0, 0, 46)
	b.BackgroundColor3 = Color3.fromRGB(114, 106, 240)
	b.Text = text
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 18
	b.AutoButtonColor = true
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

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = PG

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
body.Size = UDim2.new(1, -24, 1, -64)
body.Position = UDim2.new(0, 12, 0, 56)

local progress = Instance.new("Frame", frame)
progress.Visible = false
progress.Size = UDim2.new(1, 0, 0, 60)
progress.Position = UDim2.new(0, 0, 1, 0)
progress.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
Instance.new("UICorner", progress).CornerRadius = UDim.new(0, 12)

local percent = Instance.new("TextLabel", progress)
percent.BackgroundTransparency = 1
percent.Size = UDim2.new(1, -32, 0, 30)
percent.Position = UDim2.new(0, 16, 0, 15)
percent.Font = Enum.Font.GothamSemibold
percent.TextSize = 18
percent.TextColor3 = Color3.fromRGB(255, 255, 255)
percent.TextXAlignment = Enum.TextXAlignment.Left
percent.Text = "0%"

local pf = Instance.new("Frame", progress)
pf.Size = UDim2.new(0, 0, 0, 6)
pf.Position = UDim2.new(0, 16, 1, -14)
pf.BackgroundColor3 = Color3.fromRGB(70, 200, 90)
pf.BorderSizePixel = 0
Instance.new("UICorner", pf).CornerRadius = UDim.new(0, 6)

local btnDup2 = pill(body, "🧠 Duplicate")
btnDup2.Position = UDim2.new(0, 0, 0, 0)
pillColor(btnDup2, 114, 106, 240)
btnDup2.MouseButton1Click:Connect(function()
	progress.Visible = true
	for i = 1, 100 do
		percent.Text = i .. "%"
		pf.Size = UDim2.new(i / 100, -32, 0, 6)
		task.wait(0.1)
	end
	percent.Text = "Completed!"
	task.wait(0.8)
	progress.Visible = false
end)

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
	progress.Visible = visible and progress.Visible
end)

task.delay(8, function()
	frame.Visible = true
	panel.Visible = true
end)
