-- Loader for materials in side panel
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStore   = require(ServerScriptService:WaitForChild("DataStore"))
local TycoonOwner = require(ServerScriptService:WaitForChild("TycoonOwner"))

local getMaterials = Instance.new("RemoteFunction")
getMaterials.Name = "GetMaterials"
getMaterials.Parent = ReplicatedStorage

getMaterials.OnServerInvoke = function(player)
	local ownerUserId = TycoonOwner.getUserId()
	if not ownerUserId then return {} end
	local data = DataStore.getData(ownerUserId)
	if not data then return {} end
	return data.materials
end
