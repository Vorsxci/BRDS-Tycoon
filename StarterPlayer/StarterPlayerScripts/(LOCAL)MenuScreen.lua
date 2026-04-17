--Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local MenuMusic = game:GetService("SoundService"):FindFirstChild("risingTidesMusic")

-- Hide core gui while on start screen
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)

-- Re-hide core gui if character respawns while start screen is still up
player.CharacterAdded:Connect(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
end)

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StartScreen"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

--Play local music
MenuMusic:Play()


-- ========================
-- BACKGROUND
-- ========================
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(10, 6, 26)
bg.BorderSizePixel = 0
bg.Parent = screenGui

-- Gradient overlay
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 8, 48)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 6, 26)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 4, 18)),
})
gradient.Rotation = 135
gradient.Parent = bg



-- Stars
local rng = Random.new()
for i = 1, 80 do
	local star = Instance.new("Frame")
	local size = rng:NextInteger(1, 3)
	star.Size = UDim2.new(0, size, 0, size)
	star.Position = UDim2.new(rng:NextNumber(0, 1), 0, rng:NextNumber(0, 1), 0)
	star.BackgroundColor3 = Color3.fromRGB(220, 200, 255)
	star.BackgroundTransparency = rng:NextNumber(0.3, 0.8)
	star.BorderSizePixel = 0
	star.Parent = bg
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(1, 0)
	c.Parent = star

	-- Twinkle animation
	local delay = rng:NextNumber(0, 3)
	task.delay(delay, function()
		while star.Parent do
			TweenService:Create(star, TweenInfo.new(rng:NextNumber(1.5, 3), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = rng:NextNumber(0.6, 0.95),
			}):Play()
			task.wait(rng:NextNumber(1.5, 3))
		end
	end)
end

-- ========================
-- MAIN CONTENT FRAME
-- ========================
local content = Instance.new("Frame")
content.AnchorPoint = Vector2.new(0.5, 0.5)
content.Size = UDim2.new(0, 480, 0, 500)
content.Position = UDim2.new(0.5, 0, 0.5, 0)
content.BackgroundTransparency = 1
content.Parent = screenGui

-- ========================
-- LOGO / TITLE
-- ========================
local logoFrame = Instance.new("Frame")
logoFrame.AnchorPoint = Vector2.new(0.5, 0)
logoFrame.Size = UDim2.new(0, 120, 0, 120)
logoFrame.Position = UDim2.new(0.5, 0, 0, 0)
logoFrame.BackgroundColor3 = Color3.fromRGB(220, 180, 255)
logoFrame.BackgroundTransparency = 0.82
logoFrame.BorderSizePixel = 0
logoFrame.Parent = content
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 28)
logoCorner.Parent = logoFrame
local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(220, 180, 255)
logoStroke.Transparency = 0.55
logoStroke.Thickness = 2
logoStroke.Parent = logoFrame

local logoIcon = Instance.new("TextLabel")
logoIcon.Size = UDim2.new(1, 0, 1, 0)
logoIcon.BackgroundTransparency = 1
logoIcon.Text = "🌌"
logoIcon.TextSize = 52
logoIcon.Font = Enum.Font.GothamBold
logoIcon.Parent = logoFrame

-- Pulse the logo
local function pulseLogo()
	while logoFrame.Parent do
		TweenService:Create(logoFrame, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 0.72,
		}):Play()
		task.wait(1.8)
		TweenService:Create(logoFrame, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 0.88,
		}):Play()
		task.wait(1.8)
	end
end
task.spawn(pulseLogo)

-- Game title
local title = Instance.new("TextLabel")
title.AnchorPoint = Vector2.new(0.5, 0)
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0.5, 0, 0, 136)
title.BackgroundTransparency = 1
title.Text = "we dont have a name yet"
title.TextColor3 = Color3.fromRGB(235, 210, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 48
title.Parent = content

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.AnchorPoint = Vector2.new(0.5, 0)
subtitle.Size = UDim2.new(1, 0, 0, 28)
subtitle.Position = UDim2.new(0.5, 0, 0, 196)
subtitle.BackgroundTransparency = 1
subtitle.Text = "An adventure beyond the stars"
subtitle.TextColor3 = Color3.fromRGB(180, 150, 255)
subtitle.TextTransparency = 0.2
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 16
subtitle.Parent = content

-- Divider
local divider = Instance.new("Frame")
divider.AnchorPoint = Vector2.new(0.5, 0)
divider.Size = UDim2.new(0, 200, 0, 1)
divider.Position = UDim2.new(0.5, 0, 0, 238)
divider.BackgroundColor3 = Color3.fromRGB(220, 180, 255)
divider.BackgroundTransparency = 0.7
divider.BorderSizePixel = 0
divider.Parent = content

-- ========================
-- BUTTON HELPER
-- ========================
local function makeButton(yPos, text, isPrimary)
	local btn = Instance.new("TextButton")
	btn.AnchorPoint = Vector2.new(0.5, 0)
	btn.Size = UDim2.new(0, 280, 0, 52)
	btn.Position = UDim2.new(0.5, 0, 0, yPos)
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.AutoButtonColor = false
	btn.Text = text
	btn.Parent = content

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 16)
	btnCorner.Parent = btn

	if isPrimary then
		btn.BackgroundColor3 = Color3.fromRGB(160, 100, 255)
		btn.BackgroundTransparency = 0
		btn.TextColor3 = Color3.fromRGB(255, 245, 255)
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(220, 180, 255)
		stroke.Transparency = 0.4
		stroke.Thickness = 2
		stroke.Parent = btn
	else
		btn.BackgroundColor3 = Color3.fromRGB(220, 180, 255)
		btn.BackgroundTransparency = 0.88
		btn.TextColor3 = Color3.fromRGB(210, 180, 255)
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(220, 180, 255)
		stroke.Transparency = 0.65
		stroke.Thickness = 1.5
		stroke.Parent = btn
	end

	-- Hover
	btn.MouseEnter:Connect(function()
		if isPrimary then
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(185, 130, 255),
				Size = UDim2.new(0, 290, 0, 52),
			}):Play()
		else
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundTransparency = 0.75,
				Size = UDim2.new(0, 290, 0, 52),
			}):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if isPrimary then
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(160, 100, 255),
				Size = UDim2.new(0, 280, 0, 52),
			}):Play()
		else
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundTransparency = 0.88,
				Size = UDim2.new(0, 280, 0, 52),
			}):Play()
		end
	end)
	-- Click press effect
	btn.MouseButton1Down:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.08), {
			Size = UDim2.new(0, 272, 0, 48),
		}):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Back), {
			Size = UDim2.new(0, 280, 0, 52),
		}):Play()
	end)

	return btn
end

-- ========================
-- BUTTONS
-- ========================
local playBtn     = makeButton(258, "▶  PLAY", true)
local settingsBtn = makeButton(324, "⚙  Settings", false)
local creditsBtn  = makeButton(390, "★  Credits", false)

-- ========================
-- VERSION / FOOTER
-- ========================
local version = Instance.new("TextLabel")
version.AnchorPoint = Vector2.new(0.5, 1)
version.Size = UDim2.new(1, 0, 0, 24)
version.Position = UDim2.new(0.5, 0, 1, -12)
version.BackgroundTransparency = 1
version.Text = "v1.0.0  •  Made with ♥ in Roblox Studio"
version.TextColor3 = Color3.fromRGB(140, 110, 200)
version.TextTransparency = 0.4
version.Font = Enum.Font.Gotham
version.TextSize = 12
version.Parent = screenGui

-- ========================
-- SETTINGS PANEL
-- ========================
local settingsPanel = Instance.new("Frame")
settingsPanel.AnchorPoint = Vector2.new(0.5, 0.5)
settingsPanel.Size = UDim2.new(0, 420, 0, 320)
settingsPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
settingsPanel.BackgroundColor3 = Color3.fromRGB(18, 10, 40)
settingsPanel.BackgroundTransparency = 0.05
settingsPanel.BorderSizePixel = 0
settingsPanel.Visible = false
settingsPanel.ZIndex = 10
settingsPanel.Parent = screenGui
local spCorner = Instance.new("UICorner")
spCorner.CornerRadius = UDim.new(0, 24)
spCorner.Parent = settingsPanel
local spStroke = Instance.new("UIStroke")
spStroke.Color = Color3.fromRGB(220, 180, 255)
spStroke.Transparency = 0.6
spStroke.Thickness = 1.5
spStroke.Parent = settingsPanel

local spTitle = Instance.new("TextLabel")
spTitle.Size = UDim2.new(1, -60, 0, 50)
spTitle.Position = UDim2.new(0, 24, 0, 0)
spTitle.BackgroundTransparency = 1
spTitle.Text = "⚙  Settings"
spTitle.TextColor3 = Color3.fromRGB(220, 180, 255)
spTitle.Font = Enum.Font.GothamBold
spTitle.TextSize = 20
spTitle.TextXAlignment = Enum.TextXAlignment.Left
spTitle.ZIndex = 10
spTitle.Parent = settingsPanel

local spDivider = Instance.new("Frame")
spDivider.Size = UDim2.new(1, -48, 0, 1)
spDivider.Position = UDim2.new(0, 24, 0, 52)
spDivider.BackgroundColor3 = Color3.fromRGB(220, 180, 255)
spDivider.BackgroundTransparency = 0.75
spDivider.BorderSizePixel = 0
spDivider.ZIndex = 10
spDivider.Parent = settingsPanel

-- Settings rows
local settingRows = {
	{ label = "Music", default = true },
	{ label = "Sound Effects", default = true },
	{ label = "Reduced Motion", default = false },
}

for i, row in ipairs(settingRows) do
	local rowFrame = Instance.new("Frame")
	rowFrame.Size = UDim2.new(1, -48, 0, 44)
	rowFrame.Position = UDim2.new(0, 24, 0, 52 + (i - 1) * 52 + 16)
	rowFrame.BackgroundTransparency = 1
	rowFrame.ZIndex = 10
	rowFrame.Parent = settingsPanel

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = row.label
	label.TextColor3 = Color3.fromRGB(210, 190, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 15
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 10
	label.Parent = rowFrame

	local togBg = Instance.new("TextButton")
	togBg.AnchorPoint = Vector2.new(1, 0.5)
	togBg.Size = UDim2.new(0, 52, 0, 28)
	togBg.Position = UDim2.new(1, 0, 0.5, 0)
	togBg.BorderSizePixel = 0
	togBg.Text = ""
	togBg.AutoButtonColor = false
	togBg.ZIndex = 10
	togBg.Parent = rowFrame
	local togCorner = Instance.new("UICorner")
	togCorner.CornerRadius = UDim.new(1, 0)
	togCorner.Parent = togBg

	local togKnob = Instance.new("Frame")
	togKnob.AnchorPoint = Vector2.new(0, 0.5)
	togKnob.Size = UDim2.new(0, 22, 0, 22)
	togKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	togKnob.BorderSizePixel = 0
	togKnob.ZIndex = 11
	togKnob.Parent = togBg
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = togKnob

	local on = row.default
	local function updateToggle(animated)
		local targetColor = on and Color3.fromRGB(160, 100, 255) or Color3.fromRGB(60, 40, 90)
		local targetX = on and UDim2.new(0, 27, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
		if animated then
			TweenService:Create(togBg, TweenInfo.new(0.2), { BackgroundColor3 = targetColor }):Play()
			TweenService:Create(togKnob, TweenInfo.new(0.2, Enum.EasingStyle.Back), { Position = targetX }):Play()
		else
			togBg.BackgroundColor3 = targetColor
			togKnob.Position = targetX
		end
	end
	updateToggle(false)

	togBg.MouseButton1Click:Connect(function()
		on = not on
		updateToggle(true)
	end)
end

-- Close button for settings
local spClose = Instance.new("TextButton")
spClose.AnchorPoint = Vector2.new(1, 0)
spClose.Size = UDim2.new(0, 36, 0, 36)
spClose.Position = UDim2.new(1, -14, 0, 10)
spClose.BackgroundColor3 = Color3.fromRGB(220, 180, 255)
spClose.BackgroundTransparency = 0.82
spClose.Text = "✕"
spClose.TextColor3 = Color3.fromRGB(220, 180, 255)
spClose.Font = Enum.Font.GothamBold
spClose.TextSize = 16
spClose.BorderSizePixel = 0
spClose.ZIndex = 11
spClose.Parent = settingsPanel
local spCloseCorner = Instance.new("UICorner")
spCloseCorner.CornerRadius = UDim.new(1, 0)
spCloseCorner.Parent = spClose

-- ========================
-- CREDITS PANEL
-- ========================
local creditsPanel = Instance.new("Frame")
creditsPanel.AnchorPoint = Vector2.new(0.5, 0.5)
creditsPanel.Size = UDim2.new(0, 420, 0, 280)
creditsPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
creditsPanel.BackgroundColor3 = Color3.fromRGB(18, 10, 40)
creditsPanel.BackgroundTransparency = 0.05
creditsPanel.BorderSizePixel = 0
creditsPanel.Visible = false
creditsPanel.ZIndex = 10
creditsPanel.Parent = screenGui
local cpCorner = Instance.new("UICorner")
cpCorner.CornerRadius = UDim.new(0, 24)
cpCorner.Parent = creditsPanel
local cpStroke = Instance.new("UIStroke")
cpStroke.Color = Color3.fromRGB(220, 180, 255)
cpStroke.Transparency = 0.6
cpStroke.Thickness = 1.5
cpStroke.Parent = creditsPanel

local cpTitle = Instance.new("TextLabel")
cpTitle.Size = UDim2.new(1, -60, 0, 50)
cpTitle.Position = UDim2.new(0, 24, 0, 0)
cpTitle.BackgroundTransparency = 1
cpTitle.Text = "★  Credits"
cpTitle.TextColor3 = Color3.fromRGB(220, 180, 255)
cpTitle.Font = Enum.Font.GothamBold
cpTitle.TextSize = 20
cpTitle.TextXAlignment = Enum.TextXAlignment.Left
cpTitle.ZIndex = 10
cpTitle.Parent = creditsPanel

local cpDivider = Instance.new("Frame")
cpDivider.Size = UDim2.new(1, -48, 0, 1)
cpDivider.Position = UDim2.new(0, 24, 0, 52)
cpDivider.BackgroundColor3 = Color3.fromRGB(220, 180, 255)
cpDivider.BackgroundTransparency = 0.75
cpDivider.BorderSizePixel = 0
cpDivider.ZIndex = 10
cpDivider.Parent = creditsPanel

local creditLines = {
	{ role = "Game Design",    name = "Omnii" },
	{ role = "Scripting",      name = "Gabe, James, Riley" },
	{ role = "Building",       name = "Alec" },
	{ role = "UI / Art",       name = "observedattic92, Zek" },
	{ role = "Music / SFX",    name = "crycket13" },
}

for i, line in ipairs(creditLines) do
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -48, 0, 36)
	row.Position = UDim2.new(0, 24, 0, 56 + (i - 1) * 40)
	row.BackgroundTransparency = 1
	row.ZIndex = 10
	row.Parent = creditsPanel

	local roleLabel = Instance.new("TextLabel")
	roleLabel.Size = UDim2.new(0.5, 0, 1, 0)
	roleLabel.BackgroundTransparency = 1
	roleLabel.Text = line.role
	roleLabel.TextColor3 = Color3.fromRGB(160, 130, 220)
	roleLabel.Font = Enum.Font.Gotham
	roleLabel.TextSize = 14
	roleLabel.TextXAlignment = Enum.TextXAlignment.Left
	roleLabel.ZIndex = 10
	roleLabel.Parent = row

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
	nameLabel.Position = UDim2.new(0.5, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = line.name
	nameLabel.TextColor3 = Color3.fromRGB(220, 190, 255)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Right
	nameLabel.ZIndex = 10
	nameLabel.Parent = row
end

local cpClose = Instance.new("TextButton")
cpClose.AnchorPoint = Vector2.new(1, 0)
cpClose.Size = UDim2.new(0, 36, 0, 36)
cpClose.Position = UDim2.new(1, -14, 0, 10)
cpClose.BackgroundColor3 = Color3.fromRGB(220, 180, 255)
cpClose.BackgroundTransparency = 0.82
cpClose.Text = "✕"
cpClose.TextColor3 = Color3.fromRGB(220, 180, 255)
cpClose.Font = Enum.Font.GothamBold
cpClose.TextSize = 16
cpClose.BorderSizePixel = 0
cpClose.ZIndex = 11
cpClose.Parent = creditsPanel
local cpCloseCorner = Instance.new("UICorner")
cpCloseCorner.CornerRadius = UDim.new(1, 0)
cpCloseCorner.Parent = cpClose

-- ========================
-- PANEL OPEN / CLOSE
-- ========================
local function openPanel(panel)
	panel.Visible = true
	panel.BackgroundTransparency = 1
	panel.Position = UDim2.new(0.5, 0, 0.42, 0)
	TweenService:Create(panel, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.05,
		Position = UDim2.new(0.5, 0, 0.5, 0),
	}):Play()
end

local function closePanel(panel)
	TweenService:Create(panel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.55, 0),
	}):Play()
	task.delay(0.22, function()
		panel.Visible = false
	end)
end

settingsBtn.MouseButton1Click:Connect(function() openPanel(settingsPanel) end)
creditsBtn.MouseButton1Click:Connect(function() openPanel(creditsPanel) end)
spClose.MouseButton1Click:Connect(function() closePanel(settingsPanel) end)
cpClose.MouseButton1Click:Connect(function() closePanel(creditsPanel) end)

-- ========================
-- PLAY BUTTON — fade out and start
-- ========================
local function onPlay()
	local cover = Instance.new("Frame")
	cover.Size = UDim2.new(1, 0, 1, 0)
	cover.BackgroundColor3 = Color3.fromRGB(6, 4, 18)
	cover.BackgroundTransparency = 1
	cover.BorderSizePixel = 0
	cover.ZIndex = 100
	cover.Parent = screenGui

	TweenService:Create(cover, TweenInfo.new(0.9, Enum.EasingStyle.Quad), {
		BackgroundTransparency = 0,
	}):Play()

	task.wait(0.95)

	MenuMusic:Stop()

	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	ReplicatedStorage:WaitForChild("RequestTeleport"):FireServer()
end

playBtn.MouseButton1Click:Connect(onPlay)
