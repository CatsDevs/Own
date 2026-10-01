local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Welcome = {}
Welcome.__index = Welcome

local function getRightShoulder(model)
    local upperTorso = model:FindFirstChild("UpperTorso")
    if upperTorso then
        return upperTorso:FindFirstChild("RightShoulder")
    end

    local torso = model:FindFirstChild("Torso")
    if torso then
        return torso:FindFirstChild("Right Shoulder")
    end

    return nil
end

function Welcome.new(parent, theme, options)
    options = options or {}

    local player = Players.LocalPlayer

    local card = Instance.new("Frame")
    card.Name = "Welcome"
    card.BackgroundColor3 = theme.Surface
    card.BorderSizePixel = 0
    card.Size = UDim2.new(1, 0, 0, options.Height or 96)
    card.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(14, 12)
    title.Size = UDim2.new(1, -126, 0, 28)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = theme.Text
    title.Text = options.Text or ("Добро пожаловать, " .. player.DisplayName)
    title.Parent = card

    local subtitle = Instance.new("TextLabel")
    subtitle.BackgroundTransparency = 1
    subtitle.Position = UDim2.fromOffset(14, 42)
    subtitle.Size = UDim2.new(1, -126, 0, 34)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 12
    subtitle.TextWrapped = true
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.TextYAlignment = Enum.TextYAlignment.Top
    subtitle.TextColor3 = theme.MutedText
    subtitle.Text = options.Subtitle or "Рады видеть тебя в Own UI"
    subtitle.Parent = card

    local viewport = Instance.new("ViewportFrame")
    viewport.Name = "PlayerPreview"
    viewport.Size = UDim2.fromOffset(82, 82)
    viewport.Position = UDim2.new(1, -90, 0, 7)
    viewport.BackgroundColor3 = theme.Background
    viewport.BorderSizePixel = 0
    viewport.Ambient = Color3.fromRGB(200, 200, 200)
    viewport.LightColor = Color3.fromRGB(255, 255, 255)
    viewport.LightDirection = Vector3.new(-1, -1, -1)
    viewport.Parent = card

    local viewportCorner = Instance.new("UICorner")
    viewportCorner.CornerRadius = UDim.new(0, 10)
    viewportCorner.Parent = viewport

    local camera = Instance.new("Camera")
    camera.Parent = viewport
    viewport.CurrentCamera = camera

    local character = player.Character or player.CharacterAdded:Wait()
    character.Archivable = true

    local clone = character:Clone()
    clone.Name = "PreviewCharacter"

    for _, item in ipairs(clone:GetDescendants()) do
        if item:IsA("Script") or item:IsA("LocalScript") or item:IsA("ModuleScript") then
            item:Destroy()
        elseif item:IsA("BasePart") then
            item.CanCollide = false
            item.Anchored = false
        end
    end

    local worldModel = Instance.new("WorldModel")
    worldModel.Parent = viewport
    clone.Parent = worldModel

    local humanoid = clone:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    local root = clone:FindFirstChild("HumanoidRootPart")
    if root then
        root.Anchored = true
        clone:PivotTo(CFrame.new(0, -2.5, 0) * CFrame.Angles(0, math.rad(180), 0))
    end

    local head = clone:FindFirstChild("Head")
    if head then
        camera.CFrame = CFrame.new(
            head.Position + Vector3.new(0, 0.4, 6),
            head.Position + Vector3.new(0, 0.4, 0)
        )
    else
        camera.CFrame = CFrame.new(0, 0, 6)
    end

    local shoulder = getRightShoulder(clone)
    local baseTransform = shoulder and shoulder.Transform

    local connection
    if shoulder and baseTransform then
        connection = RunService.RenderStepped:Connect(function()
            if not card.Parent then
                connection:Disconnect()
                return
            end

            local wave = math.sin(os.clock() * 4) * 0.35 + 0.35
            shoulder.Transform = baseTransform * CFrame.Angles(math.rad(-45) * wave, 0, math.rad(18) * wave)
        end)
    end

    return setmetatable({
        Frame = card,
        Viewport = viewport,
        Model = clone,
        Connection = connection,
    }, Welcome)
end

function Welcome:Destroy()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end

    if self.Frame then
        self.Frame:Destroy()
    end
end

return Welcome
