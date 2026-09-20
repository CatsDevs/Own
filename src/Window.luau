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
    local defaultWidth = options.Width or 520
    local defaultHeight = options.Height or 360

    frame.Size = UDim2.fromOffset(defaultWidth, defaultHeight)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = theme.Background
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    -- Верхняя панель.
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundTransparency = 1
    titleBar.Size = UDim2.new(1, 0, 0, 42)
    titleBar.Parent = frame

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -112, 1, 0)
    title.Position = UDim2.fromOffset(12, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = theme.Text
    title.Text = options.Title or "Own UI"
    title.Parent = titleBar

    local function makeTopButton(name, text, x)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.fromOffset(30, 26)
        button.Position = UDim2.new(1, x, 0, 8)
        button.AnchorPoint = Vector2.new(1, 0)
        button.BackgroundColor3 = theme.Secondary
        button.BorderSizePixel = 0
        button.Text = text
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.TextColor3 = theme.Text
        button.AutoButtonColor = true
        button.Parent = titleBar

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button

        return button
    end

    local closeButton = makeTopButton("Close", "×", -8)
    local minimizeButton = makeTopButton("Minimize", "−", -44)

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.fromOffset(12, 52)
    content.Size = UDim2.new(1, -24, 1, -64)
    content.Parent = frame

    -- Ручка изменения размера.
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Size = UDim2.fromOffset(18, 18)
    resizeHandle.Position = UDim2.new(1, -18, 1, -18)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Text = "◢"
    resizeHandle.Font = Enum.Font.GothamBold
    resizeHandle.TextSize = 12
    resizeHandle.TextColor3 = theme.Text
    resizeHandle.Parent = frame

    local object = setmetatable({
        Gui = gui,
        Frame = frame,
        Content = content,
        Theme = theme,
        Tabs = {},
        Minimized = false,
        Closed = false,
        Size = Vector2.new(defaultWidth, defaultHeight),
        MinSize = Vector2.new(options.MinWidth or 320, options.MinHeight or 220),
    }, Window)

    -- Перетаскивание окна за верхнюю панель.
    local dragging = false
    local dragStart
    local startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            and input.Target ~= closeButton
            and input.Target ~= minimizeButton then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
        end
    end)

    -- Сворачивание / разворачивание.
    local normalSize = UDim2.fromOffset(defaultWidth, defaultHeight)
    local minimizedSize = UDim2.fromOffset(defaultWidth, 42)

    minimizeButton.MouseButton1Click:Connect(function()
        object.Minimized = not object.Minimized

        if object.Minimized then
            minimizeButton.Text = "+"
            content.Visible = false
            resizeHandle.Visible = false
            Animation.Tween(frame, {Size = minimizedSize}, 0.2)
        else
            minimizeButton.Text = "−"
            content.Visible = true
            resizeHandle.Visible = true
            Animation.Tween(frame, {Size = normalSize}, 0.2)
        end
    end)

    -- Закрытие.
    closeButton.MouseButton1Click:Connect(function()
        object.Closed = true
        gui:Destroy()
    end)

    -- Изменение размера за угол.
    local resizing = false
    local resizeStart
    local resizeSize

    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            resizeSize = Vector2.new(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = math.max(object.MinSize.X, resizeSize.X + delta.X)
            local newHeight = math.max(object.MinSize.Y, resizeSize.Y + delta.Y)

            object.Size = Vector2.new(newWidth, newHeight)
            frame.Size = UDim2.fromOffset(newWidth, newHeight)
            normalSize = frame.Size
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
    self.Closed = true
    self.Gui:Destroy()
end

function Window:Minimize()
    if not self.Minimized then
        self.Frame.Size = UDim2.fromOffset(self.Frame.AbsoluteSize.X, 42)
        self.Content.Visible = false
        self.Minimized = true
    end
end

function Window:Restore()
    if self.Minimized then
        self.Frame.Size = UDim2.fromOffset(self.Size.X, self.Size.Y)
        self.Content.Visible = true
        self.Minimized = false
    end
end

return Window
