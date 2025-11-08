local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local PlayerGui = game.CoreGui

local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "NotificationSystem"
NotificationGui.Parent = PlayerGui
NotificationGui.ResetOnSpawn = false

local activeNotifications = {}
local notificationCount = 0

local NOTIFICATION_WIDTH = 320
local NOTIFICATION_HEIGHT = 85
local NOTIFICATION_SPACING = 12
local SLIDE_DISTANCE = 400
local ANIMATION_SPEED = 0.5

local function createNotification(title, content, duration)
    notificationCount = notificationCount + 1

    -- Main Frame
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "Notification_" .. notificationCount
    notificationFrame.Size = UDim2.new(0, NOTIFICATION_WIDTH, 0, NOTIFICATION_HEIGHT)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    notificationFrame.BackgroundTransparency = 0.05
    notificationFrame.BorderSizePixel = 0
    notificationFrame.Parent = NotificationGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notificationFrame

    -- Sky Blue Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 191, 255) -- Sky Blue
    stroke.Thickness = 2
    stroke.Transparency = 0
    stroke.Parent = notificationFrame

    -- Glow Effect
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 30, 1, 30)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    glow.ImageColor3 = Color3.fromRGB(0, 191, 255)
    glow.ImageTransparency = 0.7
    glow.ZIndex = notificationFrame.ZIndex - 1
    glow.Parent = notificationFrame

    -- Shadow
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, -4)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    shadow.ZIndex = notificationFrame.ZIndex - 2
    shadow.Parent = notificationFrame

    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow

    -- Icon Container (Optional decorative element)
    local iconFrame = Instance.new("Frame")
    iconFrame.Name = "IconFrame"
    iconFrame.Size = UDim2.new(0, 40, 0, 40)
    iconFrame.Position = UDim2.new(0, 12, 0, 12)
    iconFrame.BackgroundColor3 = Color3.fromRGB(0, 191, 255)
    iconFrame.BackgroundTransparency = 0.85
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = notificationFrame

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 8)
    iconCorner.Parent = iconFrame

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "✓"
    iconLabel.TextColor3 = Color3.fromRGB(0, 191, 255)
    iconLabel.TextSize = 22
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = iconFrame

    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -70, 0, 24)
    titleLabel.Position = UDim2.new(0, 60, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = notificationFrame

    -- Content Label
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.Size = UDim2.new(1, -70, 0, 20)
    contentLabel.Position = UDim2.new(0, 60, 0, 35)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    contentLabel.TextSize = 13
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextWrapped = true
    contentLabel.Parent = notificationFrame

    -- Progress Bar Container
    local progressContainer = Instance.new("Frame")
    progressContainer.Name = "ProgressContainer"
    progressContainer.Size = UDim2.new(1, -24, 0, 3)
    progressContainer.Position = UDim2.new(0, 12, 1, -10)
    progressContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    progressContainer.BackgroundTransparency = 0.3
    progressContainer.BorderSizePixel = 0
    progressContainer.Parent = notificationFrame

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(1, 0)
    progressCorner.Parent = progressContainer

    -- Progress Bar
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 191, 255)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressContainer

    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(1, 0)
    progressBarCorner.Parent = progressBar

    -- Progress Bar Glow
    local progressGlow = Instance.new("Frame")
    progressGlow.Size = UDim2.new(0.3, 0, 1, 0)
    progressGlow.Position = UDim2.new(0, 0, 0, 0)
    progressGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressGlow.BackgroundTransparency = 0.5
    progressGlow.BorderSizePixel = 0
    progressGlow.Parent = progressBar

    local progressGlowCorner = Instance.new("UICorner")
    progressGlowCorner.CornerRadius = UDim.new(1, 0)
    progressGlowCorner.Parent = progressGlow

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -38, 0, 8)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(180, 180, 200)
    closeButton.TextSize = 24
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = notificationFrame

    -- Close Button Hover Effect
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(255, 80, 80)
        }):Play()
    end)

    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(180, 180, 200)
        }):Play()
    end)

    local yPosition = (#activeNotifications * (NOTIFICATION_HEIGHT + NOTIFICATION_SPACING)) + 50
    notificationFrame.Position = UDim2.new(1, SLIDE_DISTANCE, 0, yPosition)
    table.insert(activeNotifications, notificationFrame)

    local function updatePositions()
        for i, notification in ipairs(activeNotifications) do
            local newY = ((i - 1) * (NOTIFICATION_HEIGHT + NOTIFICATION_SPACING)) + 50
            local tweenInfo = TweenInfo.new(ANIMATION_SPEED, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local tween = TweenService:Create(notification, tweenInfo, {
                Position = UDim2.new(1, -NOTIFICATION_WIDTH - 20, 0, newY)
            })
            tween:Play()
        end
    end

    -- Slide In Animation
    local slideInTween = TweenService:Create(notificationFrame, 
        TweenInfo.new(ANIMATION_SPEED, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -NOTIFICATION_WIDTH - 20, 0, yPosition)}
    )
    slideInTween:Play()

    -- Glow Pulse Animation
    local glowTween = TweenService:Create(glow,
        TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {ImageTransparency = 0.9}
    )
    glowTween:Play()

    local function removeNotification()
        for i, notification in ipairs(activeNotifications) do
            if notification == notificationFrame then
                table.remove(activeNotifications, i)
                break
            end
        end

        -- Fade out animation
        local fadeOutTween = TweenService:Create(notificationFrame,
            TweenInfo.new(ANIMATION_SPEED * 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        
        local strokeFadeTween = TweenService:Create(stroke,
            TweenInfo.new(ANIMATION_SPEED * 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Transparency = 1}
        )

        local slideOutTween = TweenService:Create(notificationFrame,
            TweenInfo.new(ANIMATION_SPEED, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {Position = UDim2.new(1, SLIDE_DISTANCE, 0, notificationFrame.Position.Y.Offset)}
        )

        fadeOutTween:Play()
        strokeFadeTween:Play()
        slideOutTween:Play()

        slideOutTween.Completed:Connect(function()
            glowTween:Cancel()
            notificationFrame:Destroy()
            updatePositions()
        end)
    end

    closeButton.MouseButton1Click:Connect(removeNotification)

    -- Progress Bar Animation
    if duration and duration > 0 then
        -- Animate progress bar shrinking
        local progressTween = TweenService:Create(progressBar,
            TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
            {Size = UDim2.new(0, 0, 1, 0)}
        )
        
        -- Animate glow moving across progress bar
        local glowMoveTween = TweenService:Create(progressGlow,
            TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
            {Position = UDim2.new(0.7, 0, 0, 0)}
        )

        progressTween:Play()
        glowMoveTween:Play()

        progressTween.Completed:Connect(function()
            if notificationFrame.Parent then
                removeNotification()
            end
        end)
    end
end

getgenv().Notify = function(options)
    local title = options.Title or "Notification"
    local content = options.Content or "No content provided"
    local duration = options.Duration or 5
    task.spawn(function()
        createNotification(title, content, duration)
    end)
end

-- Example Usage (Remove in production)
-- Notify({Title = "Success!", Content = "Modern notification system loaded", Duration = 5})
