--[[
    OMEGA-JB Bee Swarm Simulator - Simple Auto Farm
    Basit ve stabil versiyon
--]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Config
local AutoFarmEnabled = false
local FarmSpeed = 100
local WalkSpeed = 80
local SelectedField = "Sunflower Field"
local ConvertAt = 95

-- Field Locations
local Fields = {
    ["Sunflower Field"] = Vector3.new(-150, 4, 180),
    ["Dandelion Field"] = Vector3.new(-50, 4, 120),
    ["Mushroom Field"] = Vector3.new(50, 4, 80),
    ["Blue Flower Field"] = Vector3.new(120, 4, 100),
    ["Clover Field"] = Vector3.new(180, 4, 150),
    ["Strawberry Field"] = Vector3.new(-200, 4, -50),
    ["Spider Field"] = Vector3.new(-100, 4, -100),
    ["Bamboo Field"] = Vector3.new(200, 4, -50),
    ["Pineapple Field"] = Vector3.new(300, 4, 50),
    ["Stump Field"] = Vector3.new(400, 4, 150),
    ["Cactus Field"] = Vector3.new(-300, 4, 100),
    ["Pumpkin Patch"] = Vector3.new(-250, 4, 200),
    ["Mountain Top"] = Vector3.new(100, 150, -200),
    ["Pepper Patch"] = Vector3.new(-400, 4, 150),
    ["Coconut Field"] = Vector3.new(500, 4, -100),
    ["Spawn"] = Vector3.new(0, 10, 0)
}

-- Utility Functions
local function Teleport(position)
    if typeof(position) == "Vector3" then
        HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

local function TweenTo(position, speed)
    speed = speed or FarmSpeed
    local distance = (HumanoidRootPart.Position - position).Magnitude
    local duration = distance / speed
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
    tween:Play()
    return tween
end

local function GetTokens()
    local tokens = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:find("Token") or obj.Name:find("token")) then
            table.insert(tokens, obj)
        end
    end
    return tokens
end

local function CollectTokens()
    local tokens = GetTokens()
    for _, token in pairs(tokens) do
        if token and token.Parent then
            local distance = (HumanoidRootPart.Position - token.Position).Magnitude
            if distance < 50 then
                TweenTo(token.Position, FarmSpeed * 2)
                wait(0.1)
            end
        end
    end
end

-- Auto Farm Function
local function AutoFarm()
    while AutoFarmEnabled do
        local fieldPos = Fields[SelectedField]
        if fieldPos then
            -- Go to field
            Teleport(fieldPos)
            wait(0.5)
            
            -- Move around field
            local offsets = {
                Vector3.new(10, 0, 0),
                Vector3.new(0, 0, 10),
                Vector3.new(-10, 0, 0),
                Vector3.new(0, 0, -10)
            }
            
            for _, offset in pairs(offsets) do
                if not AutoFarmEnabled then break end
                
                local targetPos = fieldPos + offset
                TweenTo(targetPos, FarmSpeed)
                wait(0.3)
                
                -- Collect tokens
                CollectTokens()
            end
        end
        wait(0.1)
    end
end

-- Create Simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OMEGA_JB_SIMPLE"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0, 10, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "OMEGA-JB BSS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Auto Farm Button
local FarmButton = Instance.new("TextButton")
FarmButton.Size = UDim2.new(0.9, 0, 0, 35)
FarmButton.Position = UDim2.new(0.05, 0, 0.15, 0)
FarmButton.Text = "Auto Farm: OFF"
FarmButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.Font = Enum.Font.SourceSansBold
FarmButton.TextSize = 16
FarmButton.Parent = MainFrame

FarmButton.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    if AutoFarmEnabled then
        FarmButton.Text = "Auto Farm: ON"
        FarmButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        spawn(AutoFarm)
    else
        FarmButton.Text = "Auto Farm: OFF"
        FarmButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- Field Dropdown
local FieldLabel = Instance.new("TextLabel")
FieldLabel.Size = UDim2.new(0.9, 0, 0, 20)
FieldLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
FieldLabel.Text = "Select Field:"
FieldLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FieldLabel.BackgroundTransparency = 1
FieldLabel.Font = Enum.Font.SourceSans
FieldLabel.TextSize = 14
FieldLabel.Parent = MainFrame

local FieldButton = Instance.new("TextButton")
FieldButton.Size = UDim2.new(0.9, 0, 0, 30)
FieldButton.Position = UDim2.new(0.05, 0, 0.38, 0)
FieldButton.Text = SelectedField
FieldButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
FieldButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FieldButton.Parent = MainFrame

local fieldNames = {}
for name, _ in pairs(Fields) do
    table.insert(fieldNames, name)
end

local currentFieldIndex = 1
FieldButton.MouseButton1Click:Connect(function()
    currentFieldIndex = currentFieldIndex + 1
    if currentFieldIndex > #fieldNames then
        currentFieldIndex = 1
    end
    SelectedField = fieldNames[currentFieldIndex]
    FieldButton.Text = SelectedField
end)

-- Speed Slider
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
SpeedLabel.Text = "Speed: " .. FarmSpeed
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 14
SpeedLabel.Parent = MainFrame

local SpeedMinus = Instance.new("TextButton")
SpeedMinus.Size = UDim2.new(0.2, 0, 0, 30)
SpeedMinus.Position = UDim2.new(0.05, 0, 0.63, 0)
SpeedMinus.Text = "-"
SpeedMinus.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SpeedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedMinus.Font = Enum.Font.SourceSansBold
SpeedMinus.TextSize = 20
SpeedMinus.Parent = MainFrame

local SpeedPlus = Instance.new("TextButton")
SpeedPlus.Size = UDim2.new(0.2, 0, 0, 30)
SpeedPlus.Position = UDim2.new(0.75, 0, 0.63, 0)
SpeedPlus.Text = "+"
SpeedPlus.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SpeedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedPlus.Font = Enum.Font.SourceSansBold
SpeedPlus.TextSize = 20
SpeedPlus.Parent = MainFrame

SpeedMinus.MouseButton1Click:Connect(function()
    FarmSpeed = math.max(50, FarmSpeed - 10)
    SpeedLabel.Text = "Speed: " .. FarmSpeed
end)

SpeedPlus.MouseButton1Click:Connect(function()
    FarmSpeed = math.min(500, FarmSpeed + 10)
    SpeedLabel.Text = "Speed: " .. FarmSpeed
end)

-- Walk Speed
local WalkSpeedButton = Instance.new("TextButton")
WalkSpeedButton.Size = UDim2.new(0.9, 0, 0, 30)
WalkSpeedButton.Position = UDim2.new(0.05, 0, 0.78, 0)
WalkSpeedButton.Text = "WalkSpeed: " .. WalkSpeed
WalkSpeedButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
WalkSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedButton.Parent = MainFrame

WalkSpeedButton.MouseButton1Click:Connect(function()
    if WalkSpeed == 80 then
        WalkSpeed = 120
    elseif WalkSpeed == 120 then
        WalkSpeed = 16
    else
        WalkSpeed = 80
    end
    Humanoid.WalkSpeed = WalkSpeed
    WalkSpeedButton.Text = "WalkSpeed: " .. WalkSpeed
end)

-- Teleport to Spawn
local SpawnButton = Instance.new("TextButton")
SpawnButton.Size = UDim2.new(0.9, 0, 0, 30)
SpawnButton.Position = UDim2.new(0.05, 0, 0.88, 0)
SpawnButton.Text = "Teleport to Spawn"
SpawnButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
SpawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnButton.Parent = MainFrame

SpawnButton.MouseButton1Click:Connect(function()
    Teleport(Fields["Spawn"])
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid.WalkSpeed = WalkSpeed
end)

print("[OMEGA-JB] Simple Auto Farm Loaded!")
print("[OMEGA-JB] GUI aktif - Sürükle-bırak ile hareket ettirebilirsin")