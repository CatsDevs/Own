local Theme = {}

Theme.Default = {
    Background = Color3.fromRGB(18, 18, 22),
    Surface = Color3.fromRGB(25, 25, 31),
    Accent = Color3.fromRGB(120, 90, 255),
    Text = Color3.fromRGB(240, 240, 245),
    MutedText = Color3.fromRGB(155, 155, 165),
}

function Theme.Resolve(custom)
    local result = table.clone(Theme.Default)
    for key, value in pairs(custom or {}) do
        result[key] = value
    end
    return result
end

return Theme
