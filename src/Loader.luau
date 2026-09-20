-- Own UI loader
-- Загружает отдельные модули библиотеки с GitHub.

local BASE = "https://raw.githubusercontent.com/CatsDevs/Own/main/src/"

local function loadModule(path)
    local source = game:HttpGet(BASE .. path)
    local chunk = loadstring(source)
    assert(chunk, "Own: failed to compile " .. path)
    return chunk()
end

local Own = {}
Own.Window = loadModule("Window.luau")
Own.Tab = loadModule("Tab.luau")
Own.Theme = loadModule("Services/Theme.luau")
Own.Animation = loadModule("Services/Animation.luau")
Own.Signal = loadModule("Utils/Signal.luau")

Own.Components = {
    Button = loadModule("Components/Button.luau"),
    Toggle = loadModule("Components/Toggle.luau"),
    Label = loadModule("Components/Label.luau"),
}

return Own
