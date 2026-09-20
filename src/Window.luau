local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/CatsDevs/Own/main/src/Services/Theme.luau"))()
local Animation = loadstring(game:HttpGet("https://raw.githubusercontent.com/CatsDevs/Own/main/src/Services/Animation.luau"))()

local Window = {}
Window.__index = Window

function Window.new(options)
    options = options or {}
    local theme = Theme.Resolve(options.Theme)

    local gui = Instance.new("ScreenGui")
    gui.Name = options.Name or "OwnUI"
    gui.ResetOnSpawn = false
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(options.Width or 520, options.Height or 360)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = theme.Background
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -24, 0, 42)
    title.Position = UDim2.fromOffset(12, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = theme.Text
    title.Text = options.Title or "Own UI"
    title.Parent = frame

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.fromOffset(12, 52)
    content.Size = UDim2.new(1, -24, 1, -64)
    content.Parent = frame

    local object = setmetatable({ Gui = gui, Frame = frame, Content = content, Theme = theme, Tabs = {} }, Window)

    local dragging, dragStart, startPos
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
        end
    end)

    return object
end

function Window:CreateTab(name)
    local Tab = loadstring(game:HttpGet("https://raw.githubusercontent.com/CatsDevs/Own/main/src/Tab.luau"))()
    local tab = Tab.new(self, name)
    table.insert(self.Tabs, tab)
    return tab
end

function Window:Destroy()
    self.Gui:Destroy()
end

return Window
