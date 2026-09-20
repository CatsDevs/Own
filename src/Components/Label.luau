local Label = {}
Label.__index = Label

function Label.new(parent, theme, options)
    local self = setmetatable({}, Label)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = theme.MutedText
    label.Text = options.Text or "Label"
    label.Parent = parent
    self.Instance = label
    return self
end

function Label:SetText(text)
    self.Instance.Text = text
end

return Label
