-- DataStore.lua (ModuleScript in ServerScriptService)

local Players             = game:GetService("Players")
local RunService          = game:GetService("RunService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ProductList = require(ReplicatedStorage:WaitForChild("ProductList"))
local ProfileStore        = require(ServerScriptService:WaitForChild("ProfileStore"))
local DataStore = {}

-- Automatically builds { IronOre = 0, Coal = 0, ... } from ProductList
local function buildDefaultMaterials()
	local defaults = {}
	for key in pairs(ProductList.Materials) do
		defaults[key] = 0
	end
	return defaults
end

local DEFAULT_DATA = {
	money       = 0,
	totalEarned = 0,
	materials   = buildDefaultMaterials(),
	upgrades    = {},
	buttons     = {},
	playtime    = 0,
	lastSeen    = 0,
}

local TycoonStore = ProfileStore.New("TycoonData_v1", DEFAULT_DATA)
local profiles    = {}

local moneyUpdated
task.spawn(function()
	moneyUpdated = ReplicatedStorage:WaitForChild("MoneyUpdated")
end)

function DataStore.load(player)
	local profile = TycoonStore:StartSessionAsync(tostring(player.UserId), {
		Cancel = function()
			return not player:IsDescendantOf(Players)
		end
	})

	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		profiles[player.UserId] = profile
		print(("[DataStore] Loaded profile for %s"):format(player.Name))
	else
		player:Kick("Your data could not be loaded. Please rejoin.")
	end
end

function DataStore.getData(userId)
	local profile = profiles[userId]
	return profile and profile.Data or nil
end

function DataStore.update(userId, changes)
	local profile = profiles[userId]
	if not profile then
		warn(("[DataStore] No profile for userId %d"):format(userId))
		return
	end
	for key, value in pairs(changes) do
		profile.Data[key] = value
	end
	if changes.money and moneyUpdated then
		local player = Players:GetPlayerByUserId(userId)
		if player then
			moneyUpdated:FireClient(player, changes.money)
		end
	end
end

function DataStore.getPurchasedButtons(userId)
	local data = DataStore.getData(userId)
	if not data then return {} end
	return data.buttons or {}
end

function DataStore.purchaseButton(userId, buttonId)
	local data = DataStore.getData(userId)
	if not data then
		warn(("[DataStore] No data for userId %d"):format(userId))
		return false
	end
	if data.buttons[buttonId] then
		return false
	end
	data.buttons[buttonId] = true
	print(("[DataStore] Button '%s' saved for userId %d"):format(buttonId, userId))
	return true
end

function DataStore.unload(userId)
	local profile = profiles[userId]
	if profile then
		profile:EndSession()
		profiles[userId] = nil
	end
end

-- Helper functions for the materials
function DataStore.getMaterials(userId)
	local data = DataStore.getData(userId)
	if not data then return {} end
	return data.materials
end

function DataStore.addMaterial(userId, materialKey, amount)
	local data = DataStore.getData(userId)
	if not data then
		warn(("[DataStore] No data for userId %d"):format(userId))
		return
	end
	data.materials[materialKey] = (data.materials[materialKey] or 0) + amount
end

function DataStore.removeMaterial(userId, materialKey, amount)
	local data = DataStore.getData(userId)
	if not data then
		warn(("[DataStore] No data for userId %d"):format(userId))
		return
	end
	local current = data.materials[materialKey] or 0
	if current < amount then
		warn(("[DataStore] Not enough %s for userId %d"):format(materialKey, userId))
		return false
	end
	data.materials[materialKey] = current - amount
	return true
end

Players.PlayerRemoving:Connect(function(player)
	DataStore.unload(player.UserId)
end)

game:BindToClose(function()
	if RunService:IsStudio() then return end
	for userId in pairs(profiles) do
		DataStore.unload(userId)
	end
end)

DataStore.DEFAULT_DATA = DEFAULT_DATA

return DataStore
