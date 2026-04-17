-- MaterialsPanel (LocalScript in StarterGui)
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local player      = Players.LocalPlayer
local playerGui   = player:WaitForChild("PlayerGui")
local getMaterials = ReplicatedStorage:WaitForChild("GetMaterials")

local ProductList = require(ReplicatedStorage:WaitForChild("ProductList"))

-- ========================
-- SCREEN GUI
-- ========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MaterialsPanel"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ========================
-- TOGGLE BUTTON
-- ========================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 44, 0, 44)
toggleBtn.Position = UDim2.new(0, 16, 0.5, -22)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "⚗"
toggleBtn.TextColor3 = Color3.fromRGB(200, 170, 255)
toggleBtn.TextSize = 22
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.AutoButtonColor = false
toggleBtn.ZIndex = 20
toggleBtn.Parent = screenGui
local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 12)
tbCorner.Parent = toggleBtn
local tbStroke = Instance.new("UIStroke")
tbStroke.Color = Color3.fromRGB(180, 140, 255)
tbStroke.Transparency = 0.5
tbStroke.Thickness = 1.5
tbStroke.Parent = toggleBtn

-- ========================
-- SIDE PANEL
-- ========================
local PANEL_WIDTH = 220
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, PANEL_WIDTH, 0, 340)
panel.Position = UDim2.new(0, -PANEL_WIDTH, 0.5, -170)
panel.BackgroundColor3 = Color3.fromRGB(18, 10, 40)
panel.BackgroundTransparency = 0.06
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.ZIndex = 15
panel.Parent = screenGui
local pCorner = Instance.new("UICorner")
pCorner.CornerRadius = UDim.new(0, 16)
pCorner.Parent = panel
local pStroke = Instance.new("UIStroke")
pStroke.Color = Color3.fromRGB(180, 140, 255)
pStroke.Transparency = 0.5
pStroke.Thickness = 1.5
pStroke.Parent = panel

-- Panel title
local panelTitle = Instance.new("TextLabel")
panelTitle.Size = UDim2.new(1, -16, 0, 44)
panelTitle.Position = UDim2.new(0, 16, 0, 0)
panelTitle.BackgroundTransparency = 1
panelTitle.Text = "⚗  Materials"
panelTitle.TextColor3 = Color3.fromRGB(220, 180, 255)
panelTitle.Font = Enum.Font.GothamBold
panelTitle.TextSize = 16
panelTitle.TextXAlignment = Enum.TextXAlignment.Left
panelTitle.ZIndex = 16
panelTitle.Parent = panel

local titleDivider = Instance.new("Frame")
titleDivider.Size = UDim2.new(1, -24, 0, 1)
titleDivider.Position = UDim2.new(0, 12, 0, 46)
titleDivider.BackgroundColor3 = Color3.fromRGB(180, 140, 255)
titleDivider.BackgroundTransparency = 0.7
titleDivider.BorderSizePixel = 0
titleDivider.ZIndex = 16
titleDivider.Parent = panel

-- Scrolling frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -52)
scrollFrame.Position = UDim2.new(0, 0, 0, 52)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(160, 120, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- auto set below
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ZIndex = 16
scrollFrame.Parent = panel

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingLeft = UDim.new(0, 12)
listPadding.PaddingRight = UDim.new(0, 12)
listPadding.PaddingTop = UDim.new(0, 6)
listPadding.Parent = scrollFrame

-- ========================
-- BUILD ROWS (one per material)
-- ========================
local rows = {} -- key -> { label, amountLabel }

for key, material in pairs(ProductList.Materials) do
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 36)
	row.BackgroundColor3 = Color3.fromRGB(40, 25, 80)
	row.BackgroundTransparency = 0.5
	row.BorderSizePixel = 0
	row.ZIndex = 17
	row.Parent = scrollFrame
	local rowCorner = Instance.new("UICorner")
	rowCorner.CornerRadius = UDim.new(0, 8)
	rowCorner.Parent = row

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = material.name
	nameLabel.TextColor3 = Color3.fromRGB(210, 185, 255)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 13
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.ZIndex = 18
	nameLabel.Parent = row

	local amountLabel = Instance.new("TextLabel")
	amountLabel.Size = UDim2.new(0.4, -10, 1, 0)
	amountLabel.Position = UDim2.new(0.6, 0, 0, 0)
	amountLabel.BackgroundTransparency = 1
	amountLabel.Text = "0"
	amountLabel.TextColor3 = Color3.fromRGB(180, 255, 200)
	amountLabel.Font = Enum.Font.GothamBold
	amountLabel.TextSize = 13
	amountLabel.TextXAlignment = Enum.TextXAlignment.Right
	amountLabel.ZIndex = 18
	amountLabel.Parent = row

	rows[key] = amountLabel
end

-- ========================
-- OPEN / CLOSE
-- ========================
local isOpen = false
local OPEN_X  = 70  -- pixels from left edge, next to toggle button
local CLOSE_X = -PANEL_WIDTH

local function setPanel(open, animated)
	isOpen = open
	local targetX = open and OPEN_X or CLOSE_X
	if animated then
		TweenService:Create(panel, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, targetX, 0.5, -170),
		}):Play()
	else
		panel.Position = UDim2.new(0, targetX, 0.5, -170)
	end
end

toggleBtn.MouseButton1Click:Connect(function()
	setPanel(not isOpen, true)
end)

-- ========================
-- POLL SERVER FOR AMOUNTS
-- ========================
local POLL_RATE = 2 -- seconds

local function refreshMaterials()
	local success, materials = pcall(function()
		return getMaterials:InvokeServer()
	end)
	if not success or not materials then return end
	for key, amountLabel in pairs(rows) do
		amountLabel.Text = tostring(materials[key] or 0)
	end
end

-- Initial fetch
refreshMaterials()

-- Poll on interval
task.spawn(function()
	while true do
		task.wait(POLL_RATE)
		refreshMaterials()
	end
end)
