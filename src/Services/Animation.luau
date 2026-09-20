local TweenService = game:GetService("TweenService")

local Animation = {}

function Animation.Tween(instance, properties, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

return Animation
