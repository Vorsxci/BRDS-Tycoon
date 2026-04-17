-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HoverBar"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui



-- Bar (pill shape, bottom center)
local bar = Instance.new("Frame")
bar.Name = "Bar"
bar.AnchorPoint = Vector2.new(0.5, 1)
bar.Size = UDim2.new(0, 160, 0, 14)
bar.Position = UDim2.new(0.5, 0, 1, -48)
bar.BackgroundColor3 = Color3.fromRGB(28, 16, 54)
bar.BackgroundTransparency = 0.12
bar.BorderSizePixel = 0
bar.ClipsDescendants = true
bar.Parent = screenGui

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = bar

local barStroke = Instance.new("UIStroke")
barStroke.Color = Color3.fromRGB(220, 180, 255)
barStroke.Transparency = 0.78
barStroke.Thickness = 1.5
barStroke.Parent = bar

-- MENU label
local menuLabel = Instance.new("TextLabel")
menuLabel.Size = UDim2.new(1, 0, 1, 0)
menuLabel.BackgroundTransparency = 1
menuLabel.Text = "MENU"
menuLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
menuLabel.TextTransparency = 0.55
menuLabel.Font = Enum.Font.GothamBold
menuLabel.TextSize = 9
menuLabel.Parent = bar

-- Hint label (below bar)
local hint = Instance.new("TextLabel")
hint.AnchorPoint = Vector2.new(0.5, 0)
hint.Size = UDim2.new(0, 300, 0, 20)
hint.Position = UDim2.new(0.5, 0, 1, -28)
hint.BackgroundTransparency = 1
hint.Text = "Hover the bar to open"
hint.TextColor3 = Color3.fromRGB(180, 150, 255)
hint.TextTransparency = 0.55
hint.Font = Enum.Font.GothamBold
hint.TextSize = 12
hint.Parent = screenGui

-- Button data
local buttonData = {
	{ icon = "⚙", label = "Settings" },
	{ icon = "🎒", label = "Inventory" },
	{ icon = "🎟", label = "Codes" },
	{ icon = "🛒", label = "Store" },
}

local NUM_BUTTONS = #buttonData
local BTN_WIDTH = 72
local BTN_SPACING = 8
local EXPANDED_WIDTH = NUM_BUTTONS * BTN_WIDTH + (NUM_BUTTONS - 1) * BTN_SPACING + 24
local EXPANDED_HEIGHT = 64

local btnObjects = {}

for i, data in ipairs(buttonData) do
	-- Position each button manually, centered inside the expanded bar
	local totalW = NUM_BUTTONS * BTN_WIDTH + (NUM_BUTTONS - 1) * BTN_SPACING
	local startX = (EXPANDED_WIDTH - totalW) / 2
	local xPos = startX + (i - 1) * (BTN_WIDTH + BTN_SPACING)

	local btn = Instance.new("TextButton")
	btn.Name = data.label
	btn.Size = UDim2.new(0, BTN_WIDTH, 0, 52)
	btn.Position = UDim2.new(0, xPos, 0.5, -26)
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = bar

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = btn

	local iconLabel = Instance.new("TextLabel")
	iconLabel.Size = UDim2.new(1, 0, 0, 26)
	iconLabel.Position = UDim2.new(0, 0, 0, 6)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Text = data.icon
	iconLabel.TextSize = 20
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	iconLabel.TextTransparency = 1
	iconLabel.Parent = btn

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0, 14)
	textLabel.Position = UDim2.new(0, 0, 1, -16)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = data.label
	textLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
	textLabel.TextTransparency = 1
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 10
	textLabel.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundTransparency = 0.82,
			BackgroundColor3 = Color3.fromRGB(220, 180, 255),
		}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundTransparency = 1,
		}):Play()
	end)

	table.insert(btnObjects, { btn = btn, icon = iconLabel, label = textLabel })
end

-- Expand / Collapse
local expanded = false
local expandInfo   = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local collapseInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local fadeIn  = TweenInfo.new(0.18, Enum.EasingStyle.Quad)
local fadeOut = TweenInfo.new(0.12, Enum.EasingStyle.Quad)

local function expand()
	if expanded then return end
	expanded = true

	TweenService:Create(bar, expandInfo, {
		Size = UDim2.new(0, EXPANDED_WIDTH, 0, EXPANDED_HEIGHT),
	}):Play()
	barCorner.CornerRadius = UDim.new(0, 20)

	TweenService:Create(menuLabel, fadeOut, { TextTransparency = 1 }):Play()

	for i, obj in ipairs(btnObjects) do
		task.delay(0.05 * i, function()
			TweenService:Create(obj.icon,  fadeIn, { TextTransparency = 0 }):Play()
			TweenService:Create(obj.label, fadeIn, { TextTransparency = 0.25 }):Play()
		end)
	end
end

local function collapse()
	if not expanded then return end
	expanded = false

	for _, obj in ipairs(btnObjects) do
		TweenService:Create(obj.icon,  fadeOut, { TextTransparency = 1 }):Play()
		TweenService:Create(obj.label, fadeOut, { TextTransparency = 1 }):Play()
	end

	task.delay(0.08, function()
		TweenService:Create(bar, collapseInfo, {
			Size = UDim2.new(0, 160, 0, 14),
		}):Play()
		barCorner.CornerRadius = UDim.new(1, 0)
		TweenService:Create(menuLabel, fadeIn, { TextTransparency = 0.55 }):Play()
	end)
end

bar.MouseEnter:Connect(expand)
bar.MouseLeave:Connect(collapse)
