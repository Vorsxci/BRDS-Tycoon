-- DataReset.lua (Script in ServerScriptService)
-- DELETE THIS SCRIPT after running it once!

local DataStoreService = game:GetService("DataStoreService")
local Players          = game:GetService("Players")

local mainStore    = DataStoreService:GetDataStore("TycoonData_v1")
local sessionStore = DataStoreService:GetDataStore("SessionLocks_v1")

Players.PlayerAdded:Connect(function(player)
	local key = tostring(player.UserId)
	mainStore:RemoveAsync(key)
	sessionStore:RemoveAsync(key)
	print("Reset data for " .. player.Name)
end)
