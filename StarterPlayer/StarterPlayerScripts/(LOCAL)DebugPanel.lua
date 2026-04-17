-- DebugPanel.lua (LocalScript in StarterPlayerScripts)
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService       = game:GetService("RunService")

if not RunService:IsStudio() then return end

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local debugRemote   = ReplicatedStorage:WaitForChild("DebugRemote")
local debugResponse = ReplicatedStorage:WaitForChild("DebugResponse")

-- Receive the registry layout from the server (only contains id/label/section/color/confirm)
local registryRemote = ReplicatedStorage:WaitForChild("DebugRegistry")
local layout = registryRemote:InvokeServer()

local COLORS = {
	green = { bg = Color3.fromRGB(13, 46, 26),  border = Color3.fromRGB(26, 92, 48),  text = Color3.fromRGB(74, 222, 128) },
	red   = { bg = Color3.fromRGB(46, 13, 13),  border = Color3.fromRGB(92, 26, 26),  text = Color3.fromRGB(248, 113, 113) },
	amber = { bg = Color3.fromRGB(46, 30, 10),  border = Color3.fromRGB(92, 58, 16),  text = Color3.fromRGB(251, 191, 36) },
}

-- Build GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DebugPanel"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "Panel"
frame.AutomaticSize = Enum.AutomaticSize.Y
frame.Size = UDim2.new(0, 240, 0, 0)
frame.Position = UDim2.new(0, 20, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(19, 19, 31)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = screenGui

local function addCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 8)
	c.Parent = parent
end
local function addStroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(46, 46, 80)
	s.Thickness = thickness or 1.5
	s.Parent = parent
end

addCorner(frame, 10)
addStroke(frame)

local frameList = Instance.new("UIListLayout")
frameList.SortOrder = Enum.SortOrder.LayoutOrder
frameList.Parent = frame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundTransparency = 1
header.LayoutOrder = 0
header.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "DEBUG PANEL"
titleLabel.TextColor3 = Color3.fromRGB(96, 96, 160)
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = 11
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0, 40, 0, 20)
keyLabel.Position = UDim2.new(1, -52, 0.5, -10)
keyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 52)
keyLabel.Text = "[C]"
keyLabel.TextColor3 = Color3.fromRGB(58, 58, 96)
keyLabel.Font = Enum.Font.Code
keyLabel.TextSize = 11
keyLabel.Parent = header
addCorner(keyLabel, 4)
addStroke(keyLabel, Color3.fromRGB(46, 46, 80), 1)

local headerDiv = Instance.new("Frame")
headerDiv.Size = UDim2.new(1, 0, 0, 1)
headerDiv.BackgroundColor3 = Color3.fromRGB(46, 46, 80)
headerDiv.BorderSizePixel = 0
headerDiv.LayoutOrder = 1
headerDiv.Parent = frame

-- Feedback bar
local feedbackFrame = Instance.new("Frame")
feedbackFrame.Size = UDim2.new(1, 0, 0, 30)
feedbackFrame.BackgroundTransparency = 1
feedbackFrame.LayoutOrder = 999
feedbackFrame.Parent = frame

local feedbackLabel = Instance.new("TextLabel")
feedbackLabel.Size = UDim2.new(1, -16, 1, 0)
feedbackLabel.Position = UDim2.new(0, 12, 0, 0)
feedbackLabel.BackgroundTransparency = 1
feedbackLabel.Text = "ready"
feedbackLabel.TextColor3 = Color3.fromRGB(74, 74, 128)
feedbackLabel.Font = Enum.Font.Code
feedbackLabel.TextSize = 11
feedbackLabel.TextXAlignment = Enum.TextXAlignment.Left
feedbackLabel.Parent = feedbackFrame

local function setFeedback(text, color)
	feedbackLabel.Text = text
	feedbackLabel.TextColor3 = color or Color3.fromRGB(74, 74, 128)
end

-- Build sections from layout
local sections = {}
local order = 2

for _, action in ipairs(layout) do
	if not sections[action.section] then
		sections[action.section] = true

		local secDiv = Instance.new("Frame")
		secDiv.Size = UDim2.new(1, 0, 0, 1)
		secDiv.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
		secDiv.BorderSizePixel = 0
		secDiv.LayoutOrder = order
		secDiv.Parent = frame
		order += 1

		local secFrame = Instance.new("Frame")
		secFrame.AutomaticSize = Enum.AutomaticSize.Y
		secFrame.Size = UDim2.new(1, 0, 0, 0)
		secFrame.BackgroundTransparency = 1
		secFrame.LayoutOrder = order
		secFrame.Parent = frame
		order += 1

		local secPad = Instance.new("UIPadding")
		secPad.PaddingTop    = UDim.new(0, 10)
		secPad.PaddingBottom = UDim.new(0, 10)
		secPad.PaddingLeft   = UDim.new(0, 12)
		secPad.PaddingRight  = UDim.new(0, 12)
		secPad.Parent = secFrame

		local secList = Instance.new("UIListLayout")
		secList.SortOrder = Enum.SortOrder.LayoutOrder
		secList.Padding = UDim.new(0, 6)
		secList.Parent = secFrame

		local secTitle = Instance.new("TextLabel")
		secTitle.Size = UDim2.new(1, 0, 0, 16)
		secTitle.BackgroundTransparency = 1
		secTitle.Text = action.section:upper()
		secTitle.TextColor3 = Color3.fromRGB(74, 74, 128)
		secTitle.Font = Enum.Font.Code
		secTitle.TextSize = 10
		secTitle.TextXAlignment = Enum.TextXAlignment.Left
		secTitle.LayoutOrder = 0
		secTitle.Parent = secFrame

		-- Row container for this section's buttons
		local rowFrame = Instance.new("Frame")
		rowFrame.AutomaticSize = Enum.AutomaticSize.Y
		rowFrame.Size = UDim2.new(1, 0, 0, 0)
		rowFrame.BackgroundTransparency = 1
		rowFrame.LayoutOrder = 1
		rowFrame.Parent = secFrame

		local rowLayout = Instance.new("UIGridLayout")
		rowLayout.CellSize = UDim2.new(0, 100, 0, 30)
		rowLayout.CellPadding = UDim2.new(0, 6, 0, 6)
		rowLayout.FillDirectionMaxCells = 2
		rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
		rowLayout.Parent = rowFrame

		sections[action.section] = rowFrame
	end
end

-- Reset sections tracker and do a second pass to place buttons
sections = {}
order = 2

local confirmState = {}  -- tracks which buttons are in "confirm" mode

for _, action in ipairs(layout) do
	local rowFrame
	if sections[action.section] then
		rowFrame = sections[action.section]
	else
		-- find it (already created above; this second pass re-uses the frames)
		-- We'll store them differently — let's rebuild section lookup by scanning frame children
		for _, child in ipairs(frame:GetChildren()) do
			if child:IsA("Frame") and child.LayoutOrder > 1 and child.LayoutOrder < 999 then
				for _, sc in ipairs(child:GetChildren()) do
					if sc:IsA("TextLabel") and sc.Text == action.section:upper() then
						for _, rc in ipairs(child:GetChildren()) do
							if rc:IsA("Frame") then
								rowFrame = rc
								sections[action.section] = rc
								break
							end
						end
					end
				end
			end
		end
	end

	if rowFrame then
		local col = COLORS[action.color] or COLORS.green
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 30)
		btn.BackgroundColor3 = col.bg
		btn.BorderSizePixel = 0
		btn.Text = action.label
		btn.TextColor3 = col.text
		btn.Font = Enum.Font.Code
		btn.TextSize = 12
		btn.AutoButtonColor = false
		btn.Parent = rowFrame
		addCorner(btn, 5)
		addStroke(btn, col.border, 1)

		btn.MouseEnter:Connect(function() btn.BackgroundTransparency = 0.3 end)
		btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 0 end)

		btn.MouseButton1Click:Connect(function()
			if action.confirm then
				if not confirmState[action.id] then
					confirmState[action.id] = true
					btn.Text = "Confirm?"
					btn.TextColor3 = COLORS.amber.text
					btn.BackgroundColor3 = COLORS.amber.bg
					task.delay(3, function()
						if confirmState[action.id] then
							confirmState[action.id] = false
							btn.Text = action.label
							btn.TextColor3 = col.text
							btn.BackgroundColor3 = col.bg
						end
					end)
					return
				else
					confirmState[action.id] = false
					btn.Text = action.label
					btn.TextColor3 = col.text
					btn.BackgroundColor3 = col.bg
				end
			end

			setFeedback("...", Color3.fromRGB(74, 74, 128))
			debugRemote:FireServer(action.id)
		end)
	end
end

-- Listen for responses
debugResponse.OnClientEvent:Connect(function(success, message)
	if success then
		setFeedback(message, Color3.fromRGB(74, 222, 128))
	else
		setFeedback("Error: " .. tostring(message), Color3.fromRGB(248, 113, 113))
	end
end)

-- Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.C then
		frame.Visible = not frame.Visible
	end
end)
