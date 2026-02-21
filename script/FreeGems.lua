function HookTimerVariable()
    task.spawn(function()
        local targetFound = false
        
        while not targetFound do
            local gcList = getgc() 

            for _, func in pairs(gcList) do
                if type(func) == "function" and islclosure(func) then
                    local info = debug.getinfo(func)

                    if info.source and string.find(info.source, "AutoReconnect.c") then
                        
                        local upvalues = debug.getupvalues(func)
                        for index, value in pairs(upvalues) do

                            if type(value) == "number" then
                                targetFound = true

                                local connection
                                connection = RunService.Heartbeat:Connect(function()
                                    if func then
                                        debug.setupvalue(func, index, 0)
                                    else
                                        if connection then connection:Disconnect() end
                                    end
                                end)
                            end

                            if typeof(value) == "Instance" and (value:IsA("TextLabel") or value:IsA("Frame")) then
                                value.Visible = false
                                value:GetPropertyChangedSignal("Visible"):Connect(function()
                                    value.Visible = false
                                end)
                            end
                        end
                    end
                end
            end
            
            if targetFound then break end
            task.wait(2)
        end
    end)
end
HookTimerVariable()