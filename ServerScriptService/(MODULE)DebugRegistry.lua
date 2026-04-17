-- DebugRegistry.lua (ModuleScript in ServerScriptService)
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStore         = require(ServerScriptService:WaitForChild("DataStore"))
local VisibilityManager = require(ServerScriptService:WaitForChild("VisibilityManager"))

local DebugRegistry = {}

local moneyUpdated
task.spawn(function()
	moneyUpdated = ReplicatedStorage:WaitForChild("MoneyUpdated")
end)

DebugRegistry.Actions = {
	-- Economy
	{
		id      = "give_100",
		label   = "+$100",
		section = "Economy",
		color   = "green",
		handler = function(player, DataStore)
			local data = DataStore.getData(player.UserId)
			if not data then return false, "no data" end
			local new = (data.money or 0) + 100
			DataStore.update(player.UserId, { money = new })
			return true, ("Balance: $%d"):format(new)
		end,
	},
	{
		id      = "give_1000",
		label   = "+$1,000",
		section = "Economy",
		color   = "green",
		handler = function(player, DataStore)
			local data = DataStore.getData(player.UserId)
			if not data then return false, "no data" end
			local new = (data.money or 0) + 1000
			DataStore.update(player.UserId, { money = new })
			return true, ("Balance: $%d"):format(new)
		end,
	},
	{
		id      = "give_10000",
		label   = "+$10,000",
		section = "Economy",
		color   = "green",
		handler = function(player, DataStore)
			local data = DataStore.getData(player.UserId)
			if not data then return false, "no data" end
			local new = (data.money or 0) + 10000
			DataStore.update(player.UserId, { money = new })
			return true, ("Balance: $%d"):format(new)
		end,
	},
	{
		id      = "give_100000",
		label   = "+$100,000",
		section = "Economy",
		color   = "green",
		handler = function(player, DataStore)
			local data = DataStore.getData(player.UserId)
			if not data then return false, "no data" end
			local new = (data.money or 0) + 100000
			DataStore.update(player.UserId, { money = new })
			return true, ("Balance: $%d"):format(new)
		end,
	},

	-- Player
	{
		id      = "reset_data",
		label   = "Reset my data",
		section = "Player",
		color   = "red",
		confirm = true,
		handler = function(player, DataStore)
			local defaults = DataStore.DEFAULT_DATA

			DataStore.update(player.UserId, defaults)
			VisibilityManager.syncAll(defaults.buttons)
			-- MoneyUpdated is already fired by DataStore.update above
			-- since defaults includes money, no extra FireClient needed

			return true, ("Reset — balance: $%d"):format(defaults.money)
		end,
	},
}

return DebugRegistry
