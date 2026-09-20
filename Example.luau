local Own = loadstring(game:HttpGet("https://raw.githubusercontent.com/CatsDevs/Own/main/src/Loader.luau"))()

local Window = Own.Window.new({
    Title = "Own UI",
    Name = "OwnDemo",
})

local Main = Window:CreateTab("Main")

Main:CreateLabel({ Text = "Модульная GUI-библиотека" })
Main:CreateButton({
    Name = "Click me",
    Callback = function()
        print("Own: clicked")
    end,
})

Main:CreateToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(value)
        print("Enabled:", value)
    end,
})
