
-- BETOx1 Custom Pulsed Micro-Booster
-- Mobile GUI | Power 1-100 | Interval 0.01-2.00

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local targetParent = gethui and gethui() or CoreGui

if targetParent:FindFirstChild("CustomMicroBoosterGUI") then
    targetParent.CustomMicroBoosterGUI:Destroy()
end

local isBoosterActive = false
local boostPower = 5
local boostInterval = 0.30

local function getVehicleOrRoot()
    local character = LocalPlayer.Character
    if not character then return nil end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.SeatPart then
        return humanoid.SeatPart
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function applyMicroImpulse()
    local targetPart = getVehicleOrRoot()

    if targetPart and targetPart:IsA("BasePart") then
        local lookVector = targetPart.CFrame.LookVector
        local currentVel = targetPart.AssemblyLinearVelocity

        targetPart.AssemblyLinearVelocity = Vector3.new(
            currentVel.X + lookVector.X * boostPower,
            currentVel.Y,
            currentVel.Z + lookVector.Z * boostPower
        )
    end
end

task.spawn(function()
    while true do
        if isBoosterActive then
            applyMicroImpulse()
        end
        task.wait(boostInterval)
    end
end)

local function makeDraggable(guiObject)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart

            guiObject.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomMicroBoosterGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = targetParent

-- Main button
local BoosterBtn = Instance.new("TextButton")
BoosterBtn.Name = "BoosterButton"
BoosterBtn.Parent = ScreenGui
BoosterBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
BoosterBtn.Position = UDim2.new(0.85, 0, 0.35, 0)
BoosterBtn.Size = UDim2.new(0, 60, 0, 60)
BoosterBtn.Text = "⚡\nOFF"
BoosterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BoosterBtn.TextScaled = true
BoosterBtn.Font = Enum.Font.SourceSansBold
BoosterBtn.Active = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 30)
MainCorner.Parent = BoosterBtn

makeDraggable(BoosterBtn)

-- Settings button
local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Name = "SettingsButton"
SettingsBtn.Parent = ScreenGui
SettingsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SettingsBtn.Position = UDim2.new(0.85, 0, 0.46, 0)
SettingsBtn.Size = UDim2.new(0, 45, 0, 45)
SettingsBtn.Text = "⚙️"
SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsBtn.TextScaled = true
SettingsBtn.Font = Enum.Font.SourceSansBold
SettingsBtn.Active = true

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 22)
SettingsCorner.Parent = SettingsBtn

makeDraggable(SettingsBtn)

-- Configuration panel
local ConfigFrame = Instance.new("Frame")
ConfigFrame.Name = "ConfigFrame"
ConfigFrame.Parent = ScreenGui
ConfigFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ConfigFrame.Position = UDim2.new(0.6, 0, 0.35, 0)
ConfigFrame.Size = UDim2.new(0, 210, 0, 160)
ConfigFrame.Visible = false
ConfigFrame.Active = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = ConfigFrame

makeDraggable(ConfigFrame)

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = ConfigFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0.05, 0)
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Text = "⚡ Micro-Booster"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

-- Power
local PowerLabel = Instance.new("TextLabel")
PowerLabel.Parent = ConfigFrame
PowerLabel.BackgroundTransparency = 1
PowerLabel.Position = UDim2.new(0.05, 0, 0.28, 0)
PowerLabel.Size = UDim2.new(0.9, 0, 0.15, 0)
PowerLabel.Text = "Power: " .. boostPower
PowerLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
PowerLabel.Font = Enum.Font.SourceSans
PowerLabel.TextSize = 14

local PowerMinus = Instance.new("TextButton")
PowerMinus.Parent = ConfigFrame
PowerMinus.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
PowerMinus.Position = UDim2.new(0.1, 0, 0.44, 0)
PowerMinus.Size = UDim2.new(0, 35, 0, 25)
PowerMinus.Text = "-1"
PowerMinus.TextColor3 = Color3.fromRGB(255, 255, 255)

local PowerPlus = Instance.new("TextButton")
PowerPlus.Parent = ConfigFrame
PowerPlus.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
PowerPlus.Position = UDim2.new(0.7, 0, 0.44, 0)
PowerPlus.Size = UDim2.new(0, 35, 0, 25)
PowerPlus.Text = "+1"
PowerPlus.TextColor3 = Color3.fromRGB(255, 255, 255)

PowerMinus.MouseButton1Click:Connect(function()
    boostPower = math.max(1, boostPower - 1)
    PowerLabel.Text = "Power: " .. boostPower
end)

PowerPlus.MouseButton1Click:Connect(function()
    boostPower = math.min(100, boostPower + 1)
    PowerLabel.Text = "Power: " .. boostPower
end)

-- Interval
local IntervalLabel = Instance.new("TextLabel")
IntervalLabel.Parent = ConfigFrame
IntervalLabel.BackgroundTransparency = 1
IntervalLabel.Position = UDim2.new(0.05, 0, 0.62, 0)
IntervalLabel.Size = UDim2.new(0.9, 0, 0.15, 0)
IntervalLabel.Text = "Interval: " .. string.format("%.2f", boostInterval) .. "s"
IntervalLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
IntervalLabel.Font = Enum.Font.SourceSans
IntervalLabel.TextSize = 14

local IntervalMinus = Instance.new("TextButton")
IntervalMinus.Parent = ConfigFrame
IntervalMinus.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
IntervalMinus.Position = UDim2.new(0.1, 0, 0.78, 0)
IntervalMinus.Size = UDim2.new(0, 40, 0, 25)
IntervalMinus.Text = "-0.01"
IntervalMinus.TextColor3 = Color3.fromRGB(255, 255, 255)

local IntervalPlus = Instance.new("TextButton")
IntervalPlus.Parent = ConfigFrame
IntervalPlus.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
IntervalPlus.Position = UDim2.new(0.7, 0, 0.78, 0)
IntervalPlus.Size = UDim2.new(0, 40, 0, 25)
IntervalPlus.Text = "+0.01"
IntervalPlus.TextColor3 = Color3.fromRGB(255, 255, 255)

IntervalMinus.MouseButton1Click:Connect(function()
    boostInterval = math.max(0.01, math.round((boostInterval - 0.01) * 100) / 100)
    IntervalLabel.Text = "Interval: " .. string.format("%.2f", boostInterval) .. "s"
end)

IntervalPlus.MouseButton1Click:Connect(function()
    boostInterval = math.min(2.00, math.round((boostInterval + 0.01) * 100) / 100)
    IntervalLabel.Text = "Interval: " .. string.format("%.2f", boostInterval) .. "s"
end)

-- ON/OFF
BoosterBtn.MouseButton1Click:Connect(function()
    isBoosterActive = not isBoosterActive

    if isBoosterActive then
        BoosterBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
        BoosterBtn.Text = "⚡\nON"
    else
        BoosterBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        BoosterBtn.Text = "⚡\nOFF"
    end
end)

-- Open settings
SettingsBtn.MouseButton1Click:Connect(function()
    ConfigFrame.Visible = not ConfigFrame.Visible
end)
