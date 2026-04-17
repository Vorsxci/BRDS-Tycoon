-- TycoonOwner (ModuleScript in ServerScriptService)
local TycoonOwner = {}

local ownerUserId = nil
local ownerPlayer = nil

function TycoonOwner.set(player)
	ownerUserId = player.UserId
	ownerPlayer = player
	print(("[TycoonOwner] Owner set to %s (%d)"):format(player.Name, player.UserId))
end

function TycoonOwner.getUserId()
	return ownerUserId
end

function TycoonOwner.getPlayer()
	return ownerPlayer
end

function TycoonOwner.isOwner(player)
	return player.UserId == ownerUserId
end

return TycoonOwner
