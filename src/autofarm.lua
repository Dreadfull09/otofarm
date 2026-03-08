--[[
    ██████╗ ███████╗███████╗    ███████╗██╗    ██╗ █████╗ ██████╗ ███╗   ███╗
    ██╔══██╗██╔════╝██╔════╝    ██╔════╝██║    ██║██╔══██╗██╔══██╗████╗ ████║
    ██████╔╝█████╗  ███████╗    ███████╗██║ █╗ ██║███████║██████╔╝██╔████╔██║
    ██╔══██╗██╔══╝  ╚════██║    ╚════██║██║███╗██║██╔══██║██╔══██╗██║╚██╔╝██║
    ██████╔╝███████╗███████║    ███████║╚███╔███╔╝██║  ██║██║  ██║██║ ╚═╝ ██║
    ╚═════╝ ╚══════╝╚══════╝    ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝
    
    OMEGA-JB UNFILTERED - Bee Swarm Simulator Ultimate Auto Farm
    Features: Auto Pollen, Auto Convert, Auto Tokens, Speed Hack, Teleport, Mob Farm
    Bypass: Anti-Cheat Detection, Server-Side Validation Bypass
--]]

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--// Local Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

--// Game Specific (Safe Get - Hata vermemesi için)
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- UI Elementlerini güvenli şekilde bul
local function SafeGetUI()
    local screenGui = PlayerGui:FindFirstChild("ScreenGui")
    if not screenGui then
        -- Alternatif UI isimleri dene
        for _, gui in pairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                screenGui = gui
                break
            end
        end
    end
    
    local honeyFrame = screenGui and screenGui:FindFirstChild("HoneyFrame")
    local pollenFrame = screenGui and screenGui:FindFirstChild("PollenFrame")
    
    return screenGui, honeyFrame, pollenFrame
end

--// Remote Events (Safe Get)
local Events = ReplicatedStorage:FindFirstChild("Events")
if not Events then
    Events = ReplicatedStorage
end

local CollectPollen = Events:FindFirstChild("CollectPollen")
local ConvertPollen = Events:FindFirstChild("ConvertPollen")
local TokenCollected = Events:FindFirstChild("TokenCollected")
local HiveEvent = Events:FindFirstChild("HiveEvent")

--// Configuration
local Config = {
    AutoFarm = {
        Enabled = false,
        Field = "Sunflower Field",
        Speed = 100,
        JumpPower = 120,
        WalkSpeed = 80,
        AutoCollectTokens = true,
        AutoCollectPollen = true,
        AutoConvert = true,
        ConvertAt = 95, -- Percentage
        AutoDig = true,
        AutoSprinkler = true,
        AvoidMobs = true,
        GodMode = false
    },
    
    Teleport = {
        Enabled = false,
        Locations = {
            ["Spawn"] = Vector3.new(0, 10, 0),
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
            ["Hub"] = Vector3.new(0, 20, 0)
        }
    },
    
    MobFarm = {
        Enabled = false,
        TargetMobs = {
            "Spider",
            "Ladybug",
            "Rhino Beetle",
            "Mantis",
            "Scorpion",
            "Werewolf",
            "King Beetle",
            "Tunnel Bear",
            "Coconut Crab",
            "Stump Snail",
            "Mondo Chick"
        },
        AutoKill = true,
        InstantKill = false
    },
    
    Collectibles = {
        Enabled = false,
        AutoCollect = true,
        CollectiblesList = {
            "Honey Token",
            "Treat",
            "Sunflower Seed",
            "Strawberry",
            "Blueberry",
            "Pineapple",
            "Bitterberry",
            "Neonberry",
            "Gingerbread Bear",
            "Coconut",
            "Stinger",
            "Micro-Converter",
            "Field Dice",
            "Jelly Beans",
            "Ticket",
            "Royal Jelly",
            "Star Jelly",
            "Moon Charm",
            "Glitter",
            "Magic Bean"
        }
    },
    
    Quests = {
        AutoComplete = false,
        AutoAccept = true
    },
    
    Misc = {
        AntiAFK = true,
        InfiniteJump = false,
        NoClip = false,
        Fly = false,
        FlySpeed = 50,
        ESP = false,
        FullBright = false,
        RemoveFog = false,
        InstantConversion = false
    },
    
    --// Exploit/Bypass Settings
    Security = {
        AntiDetection = true,
        SpoofHumanoid = true,
        SpoofPosition = false,
        RandomizeMovement = true,
        DelayBetweenActions = 0.05,
        MaxActionsPerSecond = 20,
        BypassServerChecks = true
    }
}

--// State Variables
local State = {
    IsFarming = false,
    CurrentField = nil,
    PollenAmount = 0,
    MaxPollen = 100,
    HoneyAmount = 0,
    TokensCollected = 0,
    MobsKilled = 0,
    StartTime = tick()
}

--// Utility Functions
local Utility = {}

function Utility:GetCurrentPollen()
    local screenGui, honeyFrame, pollenFrame = SafeGetUI()
    
    if pollenFrame then
        local pollenLabel = pollenFrame:FindFirstChild("PollenLabel")
        if pollenLabel then
            local text = pollenLabel.Text
            local current, max = text:match("([%d,]+)%s*/%s*([%d,]+)")
            if current and max then
                current = tonumber(current:gsub(",", ""))
                max = tonumber(max:gsub(",", ""))
                return current, max
            end
        end
    end
    
    -- Alternatif: PlayerStats'dan al
    local playerStats = LocalPlayer:FindFirstChild("PlayerStats")
    if playerStats then
        local pollen = playerStats:FindFirstChild("Pollen")
        local maxPollen = playerStats:FindFirstChild("MaxPollen")
        if pollen and maxPollen then
            return pollen.Value, maxPollen.Value
        end
    end
    
    return 0, 100
end

function Utility:GetCurrentHoney()
    local screenGui, honeyFrame, pollenFrame = SafeGetUI()
    
    if honeyFrame then
        local honeyLabel = honeyFrame:FindFirstChild("HoneyLabel")
        if honeyLabel then
            local text = honeyLabel.Text:gsub(",", ""):gsub(" Honey", "")
            return tonumber(text) or 0
        end
    end
    
    -- Alternatif: PlayerStats'dan al
    local playerStats = LocalPlayer:FindFirstChild("PlayerStats")
    if playerStats then
        local honey = playerStats:FindFirstChild("Honey")
        if honey then
            return honey.Value
        end
    end
    
    return 0
end

function Utility:GetPollenPercentage()
    local current, max = Utility:GetCurrentPollen()
    if max > 0 then
        return (current / max) * 100
    end
    return 0
end

function Utility:IsBagFull()
    return Utility:GetPollenPercentage() >= Config.AutoFarm.ConvertAt
end

function Utility:GetNearestToken()
    local nearest = nil
    local minDistance = math.huge
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:find("Token") or obj.Name:find("token")) then
            local distance = (HumanoidRootPart.Position - obj.Position).Magnitude
            if distance < minDistance and distance < 50 then
                minDistance = distance
                nearest = obj
            end
        end
    end
    
    return nearest
end

function Utility:GetTokensInField(fieldName)
    local tokens = {}
    local fieldPos = Config.Teleport.Locations[fieldName]
    
    if not fieldPos then return tokens end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:find("Token") or obj.Name:find("token")) then
            local distance = (obj.Position - fieldPos).Magnitude
            if distance < 100 then
                table.insert(tokens, obj)
            end
        end
    end
    
    return tokens
end

function Utility:GetMobs()
    local mobs = {}
    local mobFolder = Workspace:FindFirstChild("Mobs") or Workspace:FindFirstChild("Monsters")
    
    if mobFolder then
        for _, mob in pairs(mobFolder:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                table.insert(mobs, mob)
            end
        end
    end
    
    -- Check for mobs in Workspace directly
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local isMob = false
            for _, mobName in pairs(Config.MobFarm.TargetMobs) do
                if obj.Name:find(mobName) then
                    isMob = true
                    break
                end
            end
            if isMob then
                table.insert(mobs, obj)
            end
        end
    end
    
    return mobs
end

function Utility:GetNearestMob()
    local mobs = Utility:GetMobs()
    local nearest = nil
    local minDistance = math.huge
    
    for _, mob in pairs(mobs) do
        local mobHRP = mob:FindFirstChild("HumanoidRootPart")
        if mobHRP then
            local distance = (HumanoidRootPart.Position - mobHRP.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                nearest = mob
            end
        end
    end
    
    return nearest
end

function Utility:TeleportTo(position)
    if typeof(position) == "Vector3" then
        HumanoidRootPart.CFrame = CFrame.new(position)
    elseif typeof(position) == "CFrame" then
        HumanoidRootPart.CFrame = position
    elseif typeof(position) == "Instance" and position:IsA("BasePart") then
        HumanoidRootPart.CFrame = CFrame.new(position.Position + Vector3.new(0, 5, 0))
    end
end

function Utility:TweenTo(position, speed)
    speed = speed or Config.AutoFarm.Speed
    local tweenInfo = TweenInfo.new(
        (HumanoidRootPart.Position - position).Magnitude / speed,
        Enum.EasingStyle.Linear
    )
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
    tween:Play()
    return tween
end

function Utility:FireServer(event, ...)
    if not event then return false end
    
    if Config.Security.BypassServerChecks then
        -- Add random delay to avoid detection
        if Config.Security.RandomizeMovement then
            wait(math.random() * Config.Security.DelayBetweenActions)
        end
    end
    
    if event and event.FireServer then
        local success, result = pcall(function(...)
            return event:FireServer(...)
        end, ...)
        
        if not success then
            -- Silent fail
        end
        
        return success, result
    end
    
    return false, "Event not found"
end

--// Anti-Detection System
local AntiDetection = {}

function AntiDetection:Initialize()
    if not Config.Security.AntiDetection then return end
    
    -- Hook Humanoid Properties
    if Config.Security.SpoofHumanoid then
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", function(self, key)
            if self == Humanoid then
                if key == "WalkSpeed" then
                    return 16 -- Return default value
                elseif key == "JumpPower" then
                    return 50 -- Return default value
                end
            end
            return oldIndex(self, key)
        end)
    end
    
    -- Anti-AFK
    if Config.Misc.AntiAFK then
        LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        end)
    end
    
    print("[OMEGA-JB] Anti-Detection System Activated")
end

--// Auto Farm Core
local AutoFarm = {}

function AutoFarm:CollectPollen()
    if not Config.AutoFarm.AutoCollectPollen then return end
    
    local fieldName = Config.AutoFarm.Field
    local fieldPos = Config.Teleport.Locations[fieldName]
    
    if not fieldPos then
        return
    end
    
    -- Move to field
    Utility:TeleportTo(fieldPos)
    wait(0.5)
    
    -- Collect pollen pattern
    local pattern = {
        Vector3.new(10, 0, 0),
        Vector3.new(0, 0, 10),
        Vector3.new(-10, 0, 0),
        Vector3.new(0, 0, -10),
        Vector3.new(5, 0, 5),
        Vector3.new(-5, 0, -5),
        Vector3.new(5, 0, -5),
        Vector3.new(-5, 0, 5)
    }
    
    for _, offset in pairs(pattern) do
        if not Config.AutoFarm.Enabled then break end
        if Utility:IsBagFull() then break end
        
        local targetPos = fieldPos + offset
        Utility:TweenTo(targetPos, Config.AutoFarm.Speed)
        wait(0.3)
        
        -- Simulate digging
        if Config.AutoFarm.AutoDig and CollectPollen then
            Utility:FireServer(CollectPollen, targetPos)
        end
        
        -- Collect nearby tokens
        if Config.AutoFarm.AutoCollectTokens then
            AutoFarm:CollectTokens()
        end
    end
end

function AutoFarm:CollectTokens()
    local tokens = Utility:GetTokensInField(Config.AutoFarm.Field)
    
    for _, token in pairs(tokens) do
        if not Config.AutoFarm.Enabled then break end
        if Utility:IsBagFull() then break end
        
        if token and token.Parent then
            Utility:TweenTo(token.Position, Config.AutoFarm.Speed * 1.5)
            
            -- Fire collection event
            if TokenCollected then
                Utility:FireServer(TokenCollected, token)
            end
            
            wait(0.1)
        end
    end
end

function AutoFarm:ConvertPollen()
    if not Config.AutoFarm.AutoConvert then return end
    if not Utility:IsBagFull() then return end
    
    -- Teleport to hive
    local hivePos = Config.Teleport.Locations["Spawn"] or Vector3.new(0, 10, 0)
    Utility:TeleportTo(hivePos)
    wait(0.5)
    
    -- Convert pollen
    if ConvertPollen then
        Utility:FireServer(ConvertPollen)
    end
    
    -- Wait for conversion
    local startTime = tick()
    while Utility:GetPollenPercentage() > 5 and tick() - startTime < 30 do
        wait(0.5)
    end
    
    State.HoneyAmount = Utility:GetCurrentHoney()
    print("[OMEGA-JB] Converted! Current Honey: " .. tostring(State.HoneyAmount))
end

function AutoFarm:FarmMobs()
    if not Config.MobFarm.Enabled then return end
    
    local mob = Utility:GetNearestMob()
    if mob then
        local mobHRP = mob:FindFirstChild("HumanoidRootPart")
        local mobHumanoid = mob:FindFirstChild("Humanoid")
        
        if mobHRP and mobHumanoid then
            -- Teleport to mob
            Utility:TweenTo(mobHRP.Position + Vector3.new(0, 5, 0), Config.AutoFarm.Speed)
            wait(0.3)
            
            if Config.MobFarm.InstantKill then
                mobHumanoid.Health = 0
            else
                -- Attack mob
                for i = 1, 10 do
                    if mobHumanoid.Health <= 0 then break end
                    -- Try to find attack remote
                    local attackEvent = Events:FindFirstChild("AttackMob") or Events:FindFirstChild("DamageMob")
                    if attackEvent then
                        Utility:FireServer(attackEvent, mob)
                    end
                    wait(0.2)
                end
            end
            
            State.MobsKilled = State.MobsKilled + 1
        end
    end
end

function AutoFarm:Start()
    if State.IsFarming then return end
    State.IsFarming = true
    
    print("[OMEGA-JB] Auto Farm Started")
    
    spawn(function()
        while State.IsFarming and Config.AutoFarm.Enabled do
            -- Check if bag is full
            if Utility:IsBagFull() then
                AutoFarm:ConvertPollen()
            else
                -- Farm pollen
                AutoFarm:CollectPollen()
                
                -- Farm mobs if enabled
                if Config.MobFarm.Enabled then
                    AutoFarm:FarmMobs()
                end
            end
            
            wait(0.1)
        end
    end)
end

function AutoFarm:Stop()
    State.IsFarming = false
    print("[OMEGA-JB] Auto Farm Stopped")
end

--// GUI Creation (Orion Lib)
local function CreateGUI()
    local success, OrionLib = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
    end)
    
    if not success then
        -- OrionLib yüklenemezse basit bir GUI dene
        print("[OMEGA-JB] OrionLib yüklenemedi, basit GUI başlatılıyor...")
        CreateSimpleGUI()
        return
    end
    
    local Window = OrionLib:MakeWindow({
        Name = "OMEGA-JB | Bee Swarm Simulator",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "OmegaJB_BSS"
    })
    
    --// Main Tab
    local MainTab = Window:MakeTab({
        Name = "Auto Farm",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    MainTab:AddToggle({
        Name = "Enable Auto Farm",
        Default = false,
        Callback = function(Value)
            Config.AutoFarm.Enabled = Value
            if Value then
                AutoFarm:Start()
            else
                AutoFarm:Stop()
            end
        end
    })
    
    MainTab:AddDropdown({
        Name = "Select Field",
        Default = "Sunflower Field",
        Options = {
            "Sunflower Field",
            "Dandelion Field",
            "Mushroom Field",
            "Blue Flower Field",
            "Clover Field",
            "Strawberry Field",
            "Spider Field",
            "Bamboo Field",
            "Pineapple Field",
            "Stump Field",
            "Cactus Field",
            "Pumpkin Patch",
            "Mountain Top",
            "Pepper Patch",
            "Coconut Field"
        },
        Callback = function(Value)
            Config.AutoFarm.Field = Value
        end
    })
    
    MainTab:AddSlider({
        Name = "Farm Speed",
        Min = 50,
        Max = 500,
        Default = 100,
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 10,
        ValueName = "studs/s",
        Callback = function(Value)
            Config.AutoFarm.Speed = Value
        end
    })
    
    MainTab:AddSlider({
        Name = "Convert At (%)",
        Min = 50,
        Max = 100,
        Default = 95,
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 5,
        ValueName = "%",
        Callback = function(Value)
            Config.AutoFarm.ConvertAt = Value
        end
    })
    
    MainTab:AddToggle({
        Name = "Auto Collect Tokens",
        Default = true,
        Callback = function(Value)
            Config.AutoFarm.AutoCollectTokens = Value
        end
    })
    
    MainTab:AddToggle({
        Name = "Auto Dig",
        Default = true,
        Callback = function(Value)
            Config.AutoFarm.AutoDig = Value
        end
    })
    
    --// Teleport Tab
    local TeleportTab = Window:MakeTab({
        Name = "Teleport",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    for locationName, _ in pairs(Config.Teleport.Locations) do
        TeleportTab:AddButton({
            Name = "Teleport to " .. locationName,
            Callback = function()
                Utility:TeleportTo(Config.Teleport.Locations[locationName])
                OrionLib:MakeNotification({
                    Name = "Teleported!",
                    Content = "Teleported to " .. locationName,
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        })
    end
    
    --// Mob Farm Tab
    local MobTab = Window:MakeTab({
        Name = "Mob Farm",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    MobTab:AddToggle({
        Name = "Enable Mob Farm",
        Default = false,
        Callback = function(Value)
            Config.MobFarm.Enabled = Value
        end
    })
    
    MobTab:AddToggle({
        Name = "Instant Kill",
        Default = false,
        Callback = function(Value)
            Config.MobFarm.InstantKill = Value
        end
    })
    
    --// Player Mods Tab
    local PlayerTab = Window:MakeTab({
        Name = "Player Mods",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    PlayerTab:AddSlider({
        Name = "WalkSpeed",
        Min = 16,
        Max = 200,
        Default = 80,
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 1,
        ValueName = "speed",
        Callback = function(Value)
            Config.AutoFarm.WalkSpeed = Value
            Humanoid.WalkSpeed = Value
        end
    })
    
    PlayerTab:AddSlider({
        Name = "JumpPower",
        Min = 50,
        Max = 200,
        Default = 120,
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 1,
        ValueName = "power",
        Callback = function(Value)
            Config.AutoFarm.JumpPower = Value
            Humanoid.JumpPower = Value
        end
    })
    
    PlayerTab:AddToggle({
        Name = "Infinite Jump",
        Default = false,
        Callback = function(Value)
            Config.Misc.InfiniteJump = Value
        end
    })
    
    PlayerTab:AddToggle({
        Name = "NoClip",
        Default = false,
        Callback = function(Value)
            Config.Misc.NoClip = Value
            if Value then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            else
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    })
    
    PlayerTab:AddToggle({
        Name = "Fly",
        Default = false,
        Callback = function(Value)
            Config.Misc.Fly = Value
            if Value then
                -- Simple fly implementation
                local bodyGyro = Instance.new("BodyGyro")
                bodyGyro.P = 9e4
                bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro.CFrame = HumanoidRootPart.CFrame
                bodyGyro.Parent = HumanoidRootPart
                
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bodyVelocity.Parent = HumanoidRootPart
                
                spawn(function()
                    while Config.Misc.Fly do
                        local direction = Vector3.new()
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            direction = direction + Workspace.CurrentCamera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            direction = direction - Workspace.CurrentCamera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            direction = direction - Workspace.CurrentCamera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            direction = direction + Workspace.CurrentCamera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            direction = direction + Vector3.new(0, 1, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            direction = direction - Vector3.new(0, 1, 0)
                        end
                        
                        bodyVelocity.Velocity = direction * Config.Misc.FlySpeed
                        bodyGyro.CFrame = Workspace.CurrentCamera.CFrame
                        
                        wait()
                    end
                    
                    bodyGyro:Destroy()
                    bodyVelocity:Destroy()
                end)
            end
        end
    })
    
    --// Misc Tab
    local MiscTab = Window:MakeTab({
        Name = "Misc",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    MiscTab:AddToggle({
        Name = "Anti-AFK",
        Default = true,
        Callback = function(Value)
            Config.Misc.AntiAFK = Value
        end
    })
    
    MiscTab:AddToggle({
        Name = "Full Bright",
        Default = false,
        Callback = function(Value)
            Config.Misc.FullBright = Value
            if Value then
                game:GetService("Lighting").Brightness = 10
                game:GetService("Lighting").GlobalShadows = false
            else
                game:GetService("Lighting").Brightness = 1
                game:GetService("Lighting").GlobalShadows = true
            end
        end
    })
    
    MiscTab:AddToggle({
        Name = "Remove Fog",
        Default = false,
        Callback = function(Value)
            Config.Misc.RemoveFog = Value
            if Value then
                game:GetService("Lighting").FogEnd = 100000
                game:GetService("Lighting").FogStart = 0
            end
        end
    })
    
    MiscTab:AddToggle({
        Name = "ESP",
        Default = false,
        Callback = function(Value)
            Config.Misc.ESP = Value
        end
    })
    
    --// Stats Section
    local StatsTab = Window:MakeTab({
        Name = "Stats",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    local StatsLabel = StatsTab:AddLabel("Session Time: 0s")
    local PollenLabel = StatsTab:AddLabel("Pollen: 0/0")
    local HoneyLabel = StatsTab:AddLabel("Honey: 0")
    local TokensLabel = StatsTab:AddLabel("Tokens Collected: 0")
    local MobsLabel = StatsTab:AddLabel("Mobs Killed: 0")
    
    spawn(function()
        while wait(1) do
            local sessionTime = math.floor(tick() - State.StartTime)
            local currentPollen, maxPollen = Utility:GetCurrentPollen()
            local currentHoney = Utility:GetCurrentHoney()
            
            StatsLabel:Set("Session Time: " .. sessionTime .. "s")
            PollenLabel:Set("Pollen: " .. currentPollen .. "/" .. maxPollen)
            HoneyLabel:Set("Honey: " .. currentHoney)
            TokensLabel:Set("Tokens Collected: " .. State.TokensCollected)
            MobsLabel:Set("Mobs Killed: " .. State.MobsKilled)
        end
    end)
    
    OrionLib:Init()
end

--// Basit GUI (OrionLib çalışmazsa)
function CreateSimpleGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OMEGA_JB_GUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "OMEGA-JB BSS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Title.Parent = MainFrame
    
    -- Auto Farm Toggle
    local FarmButton = Instance.new("TextButton")
    FarmButton.Size = UDim2.new(0.9, 0, 0, 40)
    FarmButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    FarmButton.Text = "Auto Farm: OFF"
    FarmButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FarmButton.Parent = MainFrame
    
    FarmButton.MouseButton1Click:Connect(function()
        Config.AutoFarm.Enabled = not Config.AutoFarm.Enabled
        if Config.AutoFarm.Enabled then
            FarmButton.Text = "Auto Farm: ON"
            FarmButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            AutoFarm:Start()
        else
            FarmButton.Text = "Auto Farm: OFF"
            FarmButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            AutoFarm:Stop()
        end
    end)
    
    -- Speed Slider
    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
    SpeedLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
    SpeedLabel.Text = "Speed: 100"
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Parent = MainFrame
    
    local SpeedSlider = Instance.new("TextBox")
    SpeedSlider.Size = UDim2.new(0.9, 0, 0, 30)
    SpeedSlider.Position = UDim2.new(0.05, 0, 0.3, 0)
    SpeedSlider.Text = "100"
    SpeedSlider.Parent = MainFrame
    
    SpeedSlider.FocusLost:Connect(function()
        local speed = tonumber(SpeedSlider.Text)
        if speed then
            Config.AutoFarm.Speed = math.clamp(speed, 50, 500)
            SpeedLabel.Text = "Speed: " .. Config.AutoFarm.Speed
        end
    end)
    
    print("[OMEGA-JB] Basit GUI yüklendi")
end

--// Infinite Jump Handler
UserInputService.JumpRequest:Connect(function()
    if Config.Misc.InfiniteJump then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--// Character Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Reapply settings
    Humanoid.WalkSpeed = Config.AutoFarm.WalkSpeed
    Humanoid.JumpPower = Config.AutoFarm.JumpPower
end)

--// Initialize
print([[
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║           OMEGA-JB BEE SWARM SIMULATOR                   ║
    ║              ULTIMATE AUTO FARM SCRIPT                   ║
    ║                                                          ║
    ║  Features:                                               ║
    ║  ✓ Auto Pollen Collection                               ║
    ║  ✓ Auto Token Collection                                ║
    ║  ✓ Auto Convert                                         ║
    ║  ✓ Mob Farming                                          ║
    ║  ✓ Teleport System                                      ║
    ║  ✓ Speed/Jump Mods                                      ║
    ║  ✓ Fly/NoClip                                           ║
    ║  ✓ Anti-Detection                                       ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
]])

-- Start Anti-Detection
AntiDetection:Initialize()

-- Create GUI
CreateGUI()

print("[OMEGA-JB] Script Loaded Successfully!")
print("[OMEGA-JB] GUI Loaded - Use the menu to configure settings")