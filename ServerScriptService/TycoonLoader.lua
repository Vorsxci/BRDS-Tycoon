-- TycoonLoader (Script in ServerScriptService)
local Players             = game:GetService("Players")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataStore         = require(ServerScriptService:WaitForChild("DataStore"))
local VisibilityManager = require(ServerScriptService:WaitForChild("VisibilityManager"))
local TycoonOwner       = require(ServerScriptService:WaitForChild("TycoonOwner"))

local moneyUpdated      = ReplicatedStorage:WaitForChild("MoneyUpdated")
local DATA_LOAD_TIMEOUT = 10

local function loadTycoonForPlayer(player)
	-- First player in is the owner
	if TycoonOwner.getUserId() == nil then
		TycoonOwner.set(player)
	end

	DataStore.load(player)

	local data
	local elapsed = 0
	repeat
		data = DataStore.getData(player.UserId)
		if not data then
			task.wait(0.1)
			elapsed += 0.1
		end
	until data or elapsed >= DATA_LOAD_TIMEOUT

	if not data then
		warn(("[TycoonLoader] Timed out waiting for data for %s"):format(player.Name))
		return
	end

	-- Always sync using the owner's data
	local ownerData = DataStore.getData(TycoonOwner.getUserId())
	if ownerData then
		VisibilityManager.syncAll(ownerData.buttons)
	end

	-- Only send money update to the owner
	if TycoonOwner.isOwner(player) then
		moneyUpdated:FireClient(player, data.money)
	end

	print(("[TycoonLoader] Loaded for %s"):format(player.Name))
end

Players.PlayerAdded:Connect(function(player)
	task.spawn(loadTycoonForPlayer, player)
end)

Players.PlayerRemoving:Connect(function(player)
	if TycoonOwner.isOwner(player) then
		print("[TycoonLoader] Owner left, shutting down server")
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player then
				p:Kick("The tycoon owner has left.")
			end
		end
	end
end)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(loadTycoonForPlayer, player)
end
