-- GiveMaterial (Script inside generator in TycoonTemplate)
local RunService          = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local Sounds              = game:GetService("SoundService")

local DataStore   = require(ServerScriptService:WaitForChild("DataStore"))
local TycoonOwner = require(ServerScriptService:WaitForChild("TycoonOwner"))

-- ┌─────────────────────────────────────────────────────────────────┐
-- │  Configure per generator                                         │
-- └─────────────────────────────────────────────────────────────────┘
local MATERIAL_KEY = "IronOre"  -- must match a key in ProductList.Materials
local AMOUNT       = 10         -- amount to give per interval
local INTERVAL     = 5          -- seconds between each give
-- └─────────────────────────────────────────────────────────────────┘

local elapsed = 0

RunService.Heartbeat:Connect(function(dt)
	elapsed += dt
	if elapsed < INTERVAL then return end
	elapsed = 0

	local ownerUserId = TycoonOwner.getUserId()
	if not ownerUserId then return end -- tycoon not initialized yet

	DataStore.addMaterial(ownerUserId, MATERIAL_KEY, AMOUNT)
	print(("[GiveMaterial] +%d %s"):format(AMOUNT, MATERIAL_KEY))

	local sound = Sounds:FindFirstChild("ItemTeleportSound")
	if sound then sound:Play() end
end)
