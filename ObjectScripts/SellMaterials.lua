-- SellMaterials (Script, child of sell pad part)
local Players             = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")

local DataStore   = require(ServerScriptService:WaitForChild("DataStore"))
local TycoonOwner = require(ServerScriptService:WaitForChild("TycoonOwner"))
local ProductList = require(ReplicatedStorage:WaitForChild("ProductList"))
local Sounds      = game:GetService("SoundService")

local part     = script.Parent
local debounce = false
local SELL_COOLDOWN = 1 -- seconds between sells

part.Touched:Connect(function(hit)
	if debounce then return end
	local character = hit.Parent
	local humanoid  = character:FindFirstChild("Humanoid")
	if not humanoid then return end
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end

	local ownerUserId = TycoonOwner.getUserId()
	if not ownerUserId then return end

	local data = DataStore.getData(ownerUserId)
	if not data then return end

	-- Calculate total sell value and check if player has anything to sell
	local totalValue = 0
	local hasMaterials = false

	for key, material in pairs(ProductList.Materials) do
		local amount = data.materials[key] or 0
		if amount > 0 then
			hasMaterials = true
			totalValue += amount * material.SellValue
		end
	end

	if not hasMaterials then return end

	debounce = true

	-- Zero out all materials
	for key in pairs(ProductList.Materials) do
		data.materials[key] = 0
	end

	-- Add the money
	DataStore.update(ownerUserId, { money = data.money + totalValue })

	print(("[SellMaterials] Sold all materials for $%d"):format(totalValue))

	local sellSound = Sounds:FindFirstChild("SellSound")
	if sellSound then sellSound:Play() end

	task.wait(SELL_COOLDOWN)
	debounce = false
end)
