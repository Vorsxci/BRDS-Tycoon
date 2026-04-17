-- ButtonTouched.lua (Script, child of each button part)
local Players             = game:GetService("Players")
local TweenService        = game:GetService("TweenService")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStore           = require(ServerScriptService:WaitForChild("DataStore"))
local VisibilityManager   = require(ServerScriptService:WaitForChild("VisibilityManager"))
local TycoonOwner         = require(ServerScriptService:WaitForChild("TycoonOwner"))
local Sounds              = game:GetService("SoundService")

local part          = script.Parent
local buttonIdValue = part:FindFirstChild("ButtonId")
local costValue     = part:FindFirstChild("Cost")

if not buttonIdValue then
	warn("No ButtonId StringValue found on " .. part.Name)
	return
end
if not costValue then
	warn("No Cost NumberValue found on " .. part.Name)
	return
end

local originalColor = part.Color
local debounce      = false
local flashDebounce = false

local function flashRed()
	if flashDebounce then return end
	flashDebounce = true
	local flashIn  = TweenService:Create(part, TweenInfo.new(0.3), { Color = Color3.fromRGB(255, 0, 0) })
	local flashOut = TweenService:Create(part, TweenInfo.new(0.6), { Color = originalColor })
	flashIn:Play()
	flashIn.Completed:Connect(function()
		flashOut:Play()
		flashOut.Completed:Connect(function()
			flashDebounce = false
		end)
	end)
end

part.Touched:Connect(function(hit)
	if debounce then return end
	local character = hit.Parent
	local humanoid  = character:FindFirstChild("Humanoid")
	if not humanoid then return end
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end

	-- Always use owner's data
	local ownerUserId = TycoonOwner.getUserId()
	if not ownerUserId then return end
	local data = DataStore.getData(ownerUserId)
	if not data then return end

	if data.money < costValue.Value then
		flashRed()
		return
	end

	local moneyBefore = data.money
	debounce = true
	print("Touched " .. buttonIdValue.Value)

	DataStore.update(ownerUserId, { money = moneyBefore - costValue.Value })
	local success = DataStore.purchaseButton(ownerUserId, buttonIdValue.Value)

	if not success then
		DataStore.update(ownerUserId, { money = moneyBefore })
		local failSound = Sounds:FindFirstChild("ButtonFailure")
		if failSound then failSound:Play() end
		debounce = false
		return
	else
		local successSound = Sounds:FindFirstChild("ButtonSuccess")
		if successSound then successSound:Play() end
	end

	data = DataStore.getData(ownerUserId)
	VisibilityManager.syncAll(data.buttons)
	debounce = false
end)
