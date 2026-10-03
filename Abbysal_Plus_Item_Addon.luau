Groupboxes.General_Item = Tabs.General:AddLeftGroupbox("Item")

local function CreateFishLight()
	local Existing = LocalPlayer.Backpack:FindFirstChild("FishLight") or (Character and Character:FindFirstChild("FishLight"))
	if Existing then
		Functions.Notify({Title = "FishLight is already in your inventory."})
		return
	end

	local Tool = Instance.new("Tool")
	Tool.Name = "FishLight"
	Tool.RequiresHandle = true
	Tool.CanBeDropped = false
	Tool.ToolTip = "A bright, long-range flashlight."

	local Handle = Instance.new("Part")
	Handle.Name = "Handle"
	Handle.Size = Vector3.new(0.35, 0.35, 1.2)
	Handle.Transparency = 1
	Handle.CanCollide = false
	Handle.CanTouch = false
	Handle.CanQuery = false
	Handle.Massless = true
	Handle.Parent = Tool

	local Light = Instance.new("SpotLight")
	Light.Name = "FishLight"
	Light.Brightness = 12
	Light.Range = 150
	Light.Angle = 180
	Light.Shadows = false
	Light.Enabled = false
	Light.Parent = Handle

	Tool.Activated:Connect(function()
		Light.Enabled = not Light.Enabled
	end)

	Tool.Equipped:Connect(function()
		Light.Enabled = true
	end)

	Tool.Unequipped:Connect(function()
		Light.Enabled = false
	end)

	Tool.Parent = LocalPlayer.Backpack
	Functions.Notify({Title = "FishLight given."})
end

local function CreateHealFish()
	local Existing = LocalPlayer.Backpack:FindFirstChild("HealFish") or (Character and Character:FindFirstChild("HealFish"))
	if Existing then
		Functions.Notify({Title = "HealFish is already in your inventory."})
		return
	end

	local Tool = Instance.new("Tool")
	Tool.Name = "HealFish"
	Tool.RequiresHandle = true
	Tool.CanBeDropped = false
	Tool.ToolTip = "Restores your health to full."

	local Handle = Instance.new("Part")
	Handle.Name = "Handle"
	Handle.Size = Vector3.new(0.6, 0.6, 0.6)
	Handle.Transparency = 1
	Handle.CanCollide = false
	Handle.CanTouch = false
	Handle.CanQuery = false
	Handle.Massless = true
	Handle.Parent = Tool

	Tool.Activated:Connect(function()
		local CurrentCharacter = LocalPlayer.Character
		local CurrentHumanoid = CurrentCharacter and CurrentCharacter:FindFirstChildOfClass("Humanoid")
		if CurrentHumanoid and CurrentHumanoid.Health > 0 then
			CurrentHumanoid.Health = CurrentHumanoid.MaxHealth
			Functions.Notify({Title = "Health restored to full."})
			Tool:Destroy()
		end
	end)

	Tool.Parent = LocalPlayer.Backpack
	Functions.Notify({Title = "HealFish given."})
end

Groupboxes.General_Item:AddButton({
	Text = "Give FishLight",
	Tooltip = "Gives a bright, long-range flashlight that illuminates a very wide area.",
	Func = CreateFishLight
})

Groupboxes.General_Item:AddButton({
	Text = "Give HealFish",
	Tooltip = "Gives an item that restores your health to full when used.",
	Func = CreateHealFish
})
