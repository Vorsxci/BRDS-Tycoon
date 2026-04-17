-- TeleportHandler (Script in ServerScriptService)
local TeleportService   = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TYCOON_PLACE_ID = 124591267666080

local requestTeleport = Instance.new("RemoteEvent")
requestTeleport.Name = "RequestTeleport"
requestTeleport.Parent = ReplicatedStorage

requestTeleport.OnServerEvent:Connect(function(player)
	local success, result = pcall(function()
		local reservedCode = TeleportService:ReserveServer(TYCOON_PLACE_ID)
		TeleportService:TeleportToPrivateServer(TYCOON_PLACE_ID, reservedCode, { player })
	end)

	if not success then
		warn(("[TeleportHandler] Teleport failed for %s: %s"):format(player.Name, result))
	end
end)
