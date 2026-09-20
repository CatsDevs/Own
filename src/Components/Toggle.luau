local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, theme, options)
    local self = setmetatable({ Value = options.Default == true, Callback = options.Callback or function() end }, Toggle)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = theme.Surface
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.TextColor3 = theme.Text
    button.Text = (options.Name or "Toggle") .. ": " .. tostring(self.Value)
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent = button

    button.Activated:Connect(function()
        self:Set(not self.Value)
    end)

    self.Instance = button
    return self
end

function Toggle:Set(value)
    self.Value = value == true
    self.Instance.Text = self.Instance.Text:match("^[^:]+") .. ": " .. tostring(self.Value)
    self.Callback(self.Value)
end

return Toggle
