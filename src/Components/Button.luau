local Button = {}
Button.__index = Button

function Button.new(parent, theme, options)
    local self = setmetatable({ Callback = options.Callback or function() end }, Button)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = theme.Surface
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.TextColor3 = theme.Text
    button.Text = options.Name or "Button"
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent = button

    button.Activated:Connect(function()
        self.Callback()
    end)

    self.Instance = button
    return self
end

function Button:SetText(text)
    self.Instance.Text = text
end

return Button
