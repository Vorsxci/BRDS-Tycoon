-- DebugHandler.lua (Script in ServerScriptService)
local Players             = game:GetService("Players")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local RunService          = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local DataStore      = require(ServerScriptService:WaitForChild("DataStore"))
local DebugRegistry  = require(ServerScriptService:WaitForChild("DebugRegistry"))

-- Security: add your UserId(s) here to allow in live game too
local ALLOWED_USER_IDS = {
	-- e.g. 123456789,
}

local function isAllowed(player)
	return RunService:IsStudio() or ALLOWED_USER_IDS[player.UserId]
end

-- Build a lookup table from the registry
local actionMap = {}
for _, action in ipairs(DebugRegistry.Actions) do
	actionMap[action.id] = action
end

-- Build the client-safe layout (strip handler functions)
local clientLayout = {}
for _, action in ipairs(DebugRegistry.Actions) do
	table.insert(clientLayout, {
		id      = action.id,
		label   = action.label,
		section = action.section,
		color   = action.color,
		confirm = action.confirm,
	})
end

-- RemoteFunction: send layout to client on request
local registryRemote = Instance.new("RemoteFunction")
registryRemote.Name = "DebugRegistry"
registryRemote.Parent = ReplicatedStorage

registryRemote.OnServerInvoke = function(player)
	if not isAllowed(player) then return {} end
	return clientLayout
end

-- RemoteEvent: fire an action
local debugRemote = Instance.new("RemoteEvent")
debugRemote.Name = "DebugRemote"
debugRemote.Parent = ReplicatedStorage

-- RemoteEvent: send result back to client
local debugResponse = Instance.new("RemoteEvent")
debugResponse.Name = "DebugResponse"
debugResponse.Parent = ReplicatedStorage

debugRemote.OnServerEvent:Connect(function(player, actionId)
	if not isAllowed(player) then
		warn(("[Debug] Unauthorized from %s"):format(player.Name))
		return
	end

	local action = actionMap[actionId]
	if not action then
		warn(("[Debug] Unknown actionId '%s' from %s"):format(tostring(actionId), player.Name))
		debugResponse:FireClient(player, false, "unknown action")
		return
	end

	local ok, msg = action.handler(player, DataStore)
	print(("[Debug] %s ran '%s' → %s"):format(player.Name, actionId, tostring(msg)))
	debugResponse:FireClient(player, ok, msg)
end)
