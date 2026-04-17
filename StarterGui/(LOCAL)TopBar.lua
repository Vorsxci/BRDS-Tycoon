-- CosmicGUI (LocalScript in StarterPlayerScripts)
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player       = Players.LocalPlayer
local playerGui    = player:WaitForChild("PlayerGui")
local moneyUpdated = ReplicatedStorage:WaitForChild("MoneyUpdated")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CosmicGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(0.55, 0, 0, 36)
TopBar.Position = UDim2.new(0.5, 0, 0, 0)
TopBar.AnchorPoint = Vector2.new(0.5, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 5, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = TopBar

local PlanetLabel = Instance.new("TextLabel")
PlanetLabel.Size = UDim2.new(0, 200, 1, 0)
PlanetLabel.Position = UDim2.new(0, 10, 0, 0)
PlanetLabel.BackgroundTransparency = 1
PlanetLabel.Text = "🪐 Zephyria"
PlanetLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
PlanetLabel.Font = Enum.Font.GothamBold
PlanetLabel.TextSize = 14
PlanetLabel.TextXAlignment = Enum.TextXAlignment.Left
PlanetLabel.Parent = TopBar

local UptimeLabel = Instance.new("TextLabel")
UptimeLabel.Size = UDim2.new(0, 200, 1, 0)
UptimeLabel.Position = UDim2.new(0.35, 0, 0, 0)
UptimeLabel.BackgroundTransparency = 1
UptimeLabel.Text = "Uptime: 00:00:00"
UptimeLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
UptimeLabel.Font = Enum.Font.GothamBold
UptimeLabel.TextSize = 13
UptimeLabel.Parent = TopBar

local startTime = os.clock()
RunService.RenderStepped:Connect(function()
	local t = math.floor(os.clock() - startTime)
	local h = math.floor(t / 3600)
	local m = math.floor((t % 3600) / 60)
	local s = t % 60
	UptimeLabel.Text = string.format("Uptime: %02d:%02d:%02d", h, m, s)
end)

local MoneyLabel = Instance.new("TextLabel")
MoneyLabel.Size = UDim2.new(0, 200, 1, 0)
MoneyLabel.Position = UDim2.new(0.65, 0, 0, 0)
MoneyLabel.BackgroundTransparency = 1
MoneyLabel.Text = "$..."
MoneyLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
MoneyLabel.Font = Enum.Font.GothamBold
MoneyLabel.TextSize = 14
MoneyLabel.Parent = TopBar

moneyUpdated.OnClientEvent:Connect(function(amount)
	MoneyLabel.Text = "$" .. tostring(amount)
end)
