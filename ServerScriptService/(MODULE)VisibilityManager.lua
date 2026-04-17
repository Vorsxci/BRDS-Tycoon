-- VisibilityManager.lua (ModuleScript in ServerScriptService)

local VisibilityManager = {}

local buttonsFolder = workspace:WaitForChild("Tycoon"):WaitForChild("TycoonButtons")

-- ┌─────────────────────────────────────────────────────────────────┐
-- │  ADD any extra workspace folders you want scanned here.         │
-- └─────────────────────────────────────────────────────────────────┘
local EXTRA_FOLDERS = {
	workspace:WaitForChild("Tycoon"):WaitForChild("TycoonGenerators"),
	-- workspace:WaitForChild("TycoonMachines"),
}

local function getAllFolders()
	local folders = { buttonsFolder }
	for _, folder in ipairs(EXTRA_FOLDERS) do
		table.insert(folders, folder)
	end
	return folders
end

local function setPartState(part, visible)
	part.Transparency = visible and 0 or 1
	part.CanCollide   = visible
	part.CanTouch     = visible
	-- Anchored is intentionally not touched; Studio setting is preserved

	local billboard = part:FindFirstChild("CostBillboard")
	if billboard then
		billboard.Enabled = visible
	end
end

-- Works for both BaseParts and Models (including all nested children)
local function setObjectState(obj, visible)
	if obj:IsA("BasePart") then
		setPartState(obj, visible)
	elseif obj:IsA("Model") then
		for _, desc in ipairs(obj:GetDescendants()) do
			if desc:IsA("BasePart") then
				setPartState(desc, visible)
			elseif desc:IsA("Decal") or desc:IsA("Texture") then
				desc.Transparency = visible and 0 or 1
			elseif desc:IsA("ParticleEmitter") or desc:IsA("Trail") or desc:IsA("Beam") then
				desc.Enabled = visible
			elseif desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") then
				desc.Enabled = visible
			elseif desc:IsA("Script") then
				desc.Disabled = not visible  -- enable/disable scripts with visibility
			end
			-- SurfaceAppearance skipped intentionally: hiding the BasePart is sufficient
		end
	end
end

local function setupBillboard(part)
	local cost = part:FindFirstChild("Cost")
	if not cost then return end
	if part:FindFirstChild("CostBillboard") then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "CostBillboard"
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = false
	billboard.Parent = part

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 215, 0)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Text = "$" .. tostring(cost.Value)
	label.Parent = billboard
end

-- Hide anything with a prerequisite on startup, across all folders
for _, folder in ipairs(getAllFolders()) do
	for _, obj in ipairs(folder:GetChildren()) do
		if obj:IsA("BasePart") then
			setupBillboard(obj)
			if obj:FindFirstChild("RequiresButton") then
				setObjectState(obj, false)
			end
		elseif obj:IsA("Model") then
			if obj:FindFirstChild("RequiresButton") then
				setObjectState(obj, false)
			end
		end
	end
end

function VisibilityManager.syncAll(purchasedButtons)
	print("syncAll called with:")
	for k, v in pairs(purchasedButtons) do
		print(" ", k, v)
	end

	for _, folder in ipairs(getAllFolders()) do
		for _, obj in ipairs(folder:GetChildren()) do
			if obj:IsA("BasePart") or obj:IsA("Model") then
				local buttonId = obj:FindFirstChild("ButtonId")
				local req      = obj:FindFirstChild("RequiresButton")

				if buttonId and req then
					local prereqMet     = purchasedButtons[req.Value] == true
					local alreadyBought = purchasedButtons[buttonId.Value] == true
					setObjectState(obj, prereqMet and not alreadyBought)

				elseif buttonId then
					setObjectState(obj, not purchasedButtons[buttonId.Value])

				elseif req then
					setObjectState(obj, purchasedButtons[req.Value] == true)

				else
					setObjectState(obj, true)
				end
			end
		end
	end
end

return VisibilityManager
