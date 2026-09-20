local Tab = {}
Tab.__index = Tab

function Tab.new(window, name)
    local self = setmetatable({ Window = window, Name = name, Components = {} }, Tab)

    local container = Instance.new("ScrollingFrame")
    container.Name = name
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Size = UDim2.fromScale(1, 1)
    container.ScrollBarThickness = 3
    container.CanvasSize = UDim2.new()
    container.Parent = window.Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
    end)

    self.Container = container
    return self
end

function Tab:AddComponent(component)
    local object = component.new(self.Container, self.Window.Theme)
    table.insert(self.Components, object)
    return object
end

function Tab:CreateButton(options)
    local Button = loadstring(game:HttpGet("https://raw.githubusercontent.com/CatsDevs/Own/main/src/Components/Button.luau"))()
    options = options or {}
    local object = Button.new(self.Container, self.Window.Theme, options)
    table.insert(self.Components, object)
    return object
end

function Tab:CreateToggle(options)
    local Toggle = loadstring(game:HttpGet("https://raw.githubusercontent.com/CatsDevs/Own/main/src/Components/Toggle.luau"))()
    options = options or {}
    local object = Toggle.new(self.Container, self.Window.Theme, options)
    table.insert(self.Components, object)
    return object
end

function Tab:CreateLabel(options)
    local Label = loadstring(game:HttpGet("https://raw.githubusercontent.com/CatsDevs/Own/main/src/Components/Label.luau"))()
    options = options or {}
    local object = Label.new(self.Container, self.Window.Theme, options)
    table.insert(self.Components, object)
    return object
end

return Tab
