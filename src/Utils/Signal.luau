local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({ _listeners = {} }, Signal)
end

function Signal:Connect(callback)
    local connection = { Connected = true }
    table.insert(self._listeners, { callback = callback, connection = connection })

    function connection:Disconnect()
        self.Connected = false
    end

    return connection
end

function Signal:Fire(...)
    for _, item in ipairs(self._listeners) do
        if item.connection.Connected then
            task.spawn(item.callback, ...)
        end
    end
end

return Signal
