return function(Fluent, Config)

    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    local mobileSize = Config.MobileSize or UDim2.fromOffset(380,290)
    local pcSize = Config.PcSize or UDim2.fromOffset(580,460)

    local chosenSize = isMobile and mobileSize or pcSize
    local tabWidth = isMobile and 90 or 160

    -- aplica tamanho
    Fluent.Options.TabWidth = tabWidth

    task.defer(function()
        local window = Fluent.Window
        if not window then return end

        window.Root.Size = chosenSize

        if isMobile then
            window.Root.AnchorPoint = Vector2.new(0.5,0.5)
            window.Root.Position = UDim2.new(0.5,0,0.5,0)
        end
    end)

    -- MINIMIZE BALL
    if isMobile and Config.MinimizeButton then

        local ballGui = Instance.new("ScreenGui")
        ballGui.Name = "MobileMinimizeBall"
        ballGui.Enabled = false
        ballGui.ResetOnSpawn = false
        ballGui.Parent = player.PlayerGui

        local button = Instance.new("ImageButton")
        button.Size = UDim2.fromOffset(Config.MinimizeButton.Size, Config.MinimizeButton.Size)
        button.Position = UDim2.new(0,15,0.5,-30)
        button.BackgroundColor3 = Color3.fromRGB(25,25,25)
        button.Image = Config.MinimizeButton.Image
        button.Parent = ballGui

        Instance.new("UICorner", button).CornerRadius = UDim.new(1,0)

        local stroke = Instance.new("UIStroke", button)
        stroke.Color = Color3.fromRGB(170,0,255)
        stroke.Thickness = 2

        local window = Fluent.Window

        button.MouseButton1Click:Connect(function()
            window.Root.Visible = true
            ballGui.Enabled = false
        end)

        window.Root:GetPropertyChangedSignal("Visible"):Connect(function()
            if window.Root.Visible == false then
                ballGui.Enabled = true
            end
        end)

        -- DRAG
        local dragging, dragStart, startPos

        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = button.Position
            end
        end)

        button.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                button.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)

        button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

    end

end
