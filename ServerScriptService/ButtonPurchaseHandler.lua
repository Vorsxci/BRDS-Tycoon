-- ButtonPurchaseHandler (Script in ServerScriptService)
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataStore         = require(ServerScriptService:WaitForChild("DataStore"))
local VisibilityManager = require(ServerScriptService:WaitForChild("VisibilityManager"))
local TycoonOwner       = require(ServerScriptService:WaitForChild("TycoonOwner"))

local buttonPurchased = ReplicatedStorage:WaitForChild("ButtonPurchased")

buttonPurchased.OnServerEvent:Connect(function(player, buttonId)
	if typeof(buttonId) ~= "string" or buttonId == "" then
		warn("Invalid buttonId from " .. player.Name)
		return
	end

	local ownerUserId = TycoonOwner.getUserId()
	if not ownerUserId then
		warn("No tycoon owner set yet")
		return
	end

	local success = DataStore.purchaseButton(ownerUserId, buttonId)
	if not success then return end

	local data = DataStore.getData(ownerUserId)
	VisibilityManager.syncAll(data.buttons)

	buttonPurchased:FireClient(player, buttonId)
end)
