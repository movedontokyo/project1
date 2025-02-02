--// Optimized Modern Professional UI Loader
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local function createProfessionalUILoader()
    local loaderGui = Instance.new("ScreenGui")
    loaderGui.Name = "ModernProfessionalUILoader"
    loaderGui.ResetOnSpawn = false
    loaderGui.Parent = CoreGui

    local loaderFrame = Instance.new("Frame")
    loaderFrame.Size = UDim2.new(0.35, 0, 0.2, 0)
    loaderFrame.Position = UDim2.new(0.325, 0, 0.4, 0)
    loaderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    loaderFrame.BackgroundTransparency = 0.1  -- Slightly adjusted for better performance
    loaderFrame.BorderSizePixel = 0
    loaderFrame.ClipsDescendants = true
    loaderFrame.Parent = loaderGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = loaderFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(60, 180, 220)
    UIStroke.Parent = loaderFrame

    local loaderText = Instance.new("TextLabel")
    loaderText.Size = UDim2.new(1, 0, 0.5, 0)
    loaderText.Position = UDim2.new(0, 0, 0.15, 0)
    loaderText.BackgroundTransparency = 1
    loaderText.Text = "Loading..."
    loaderText.Font = Enum.Font.GothamBlack
    loaderText.TextSize = 30
    loaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loaderText.TextStrokeTransparency = 0.3
    loaderText.TextScaled = true
    loaderText.Parent = loaderFrame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 0.15, 0)
    progressBar.Position = UDim2.new(0.05, 0, 0.75, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(60, 180, 220)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = loaderFrame

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 8)
    progressCorner.Parent = progressBar

    -- Optimized Tween
    local progressTween = TweenService:Create(progressBar, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.9, 0, 0.15, 0)})
    progressTween:Play()
    
    return loaderGui, loaderFrame, progressTween
end

-- Create and show the professional loader
local loaderGui, loaderFrame, progressTween = createProfessionalUILoader()

--// Cache
local loadstring, game, getgenv, setclipboard = loadstring, game, getgenv, setclipboard

--// Loaded check
if getgenv().Aimbot then return end

--// Load project1 (Raw)
loadstring(game:HttpGet("https://raw.githubusercontent.com/movedontokyo/project1/main/movedontokyo.LUA"))()

--// Variables
local Aimbot = getgenv().Aimbot
local Settings, FOVSettings, Functions = Aimbot.Settings, Aimbot.FOVSettings, Aimbot.Functions
local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Parts = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"}

--// ESP Variables
local ESPConfig = {
    Enabled = true,
    Tracers = true,
    Names = true,
    HealthBar = true,
    TeamColor = false,
    TracerColor = Color3.new(1, 1, 1),
    NameColor = Color3.new(1, 1, 1),
    HealthColor = Color3.new(0, 1, 0),
    HealthBackground = Color3.new(0.3, 0.3, 0.3),
    TextSize = 13,
    MaxDistance = 1000
}

local ESPFolder = {}
local Players = game:GetService("Players")

--// ESP Functions
local function CreateESP(Player)
    if ESPFolder[Player] then return end
    
    local Drawings = {
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        HealthBarOutline = Drawing.new("Line"),
        HealthBar = Drawing.new("Line")
    }
    
    ESPFolder[Player] = Drawings
    Drawings.Name.Size = ESPConfig.TextSize
    Drawings.Name.Center = true
    Drawings.Name.Outline = true
    Drawings.Tracer.Thickness = 1
    Drawings.HealthBar.Thickness = 2
    Drawings.HealthBarOutline.Thickness = 2
    
    return Drawings
end

local function UpdateESP()
    for Player, Drawings in pairs(ESPFolder) do
        if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = Player.Character.HumanoidRootPart
            local Position, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)
            
            if OnScreen and (RootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude < ESPConfig.MaxDistance then
                -- Tracer
                Drawings.Tracer.Visible = ESPConfig.Tracers
                if ESPConfig.Tracers then
                    Drawings.Tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y)
                    Drawings.Tracer.To = Vector2.new(Position.X, Position.Y)
                    Drawings.Tracer.Color = ESPConfig.TracerColor
                end

                -- Name
                Drawings.Name.Visible = ESPConfig.Names
                if ESPConfig.Names then
                    Drawings.Name.Position = Vector2.new(Position.X, Position.Y - 30)
                    Drawings.Name.Text = Player.Name
                    Drawings.Name.Color = ESPConfig.NameColor
                end

                -- Health Bar
                if ESPConfig.HealthBar then
                    local Health = Player.Character.Humanoid.Health / Player.Character.Humanoid.MaxHealth
                    Drawings.HealthBarOutline.Visible = true
                    Drawings.HealthBar.Visible = true
                    local Start = Vector2.new(Position.X - 50, Position.Y + 20)
                    Drawings.HealthBarOutline.From = Start
                    Drawings.HealthBarOutline.To = Start + Vector2.new(100, 0)
                    Drawings.HealthBarOutline.Color = ESPConfig.HealthBackground
                    Drawings.HealthBar.From = Start
                    Drawings.HealthBar.To = Start + Vector2.new(100 * Health, 0)
                    Drawings.HealthBar.Color = ESPConfig.HealthColor
                else
                    Drawings.HealthBarOutline.Visible = false
                    Drawings.HealthBar.Visible = false
                end
            else
                for _, Drawing in pairs(Drawings) do
                    Drawing.Visible = false
                end
            end
        else
            for _, Drawing in pairs(Drawings) do
                Drawing.Visible = false
            end
        end
    end
end

--// Frame
Library.UnloadCallback = Functions.Exit
local MainFrame = Library:CreateWindow({
    Name = "obejict",
    Themeable = {
        Image = "7059346386",
        Info = "Made by @movedontokyo",
        Credit = false
    },
    Background = "",
    Theme = [[{"__Designer.Colors.section":"ADC7FF","__Designer.Colors.topGradient":"1B242F","__Designer.Settings.ShowHideKey":"Enum.KeyCode.RightShift","__Designer.Colors.otherElementText":"54637D","__Designer.Colors.hoveredOptionBottom":"38667D","__Designer.Background.ImageAssetID":"","__Designer.Colors.unhoveredOptionTop":"407495","__Designer.Colors.innerBorder":"2C4168","__Designer.Colors.unselectedOption":"4E6EA0","__Designer.Background.UseBackgroundImage":true,"__Designer.Files.WorkspaceFile":"obejict","__Designer.Colors.main":"23A0FF","__Designer.Colors.outerBorder":"162943","__Designer.Background.ImageColor":"FFFFFF","__Designer.Colors.tabText":"C9DFF1","__Designer.Colors.elementBorder":"111D26","__Designer.Colors.sectionBackground":"0E141C","__Designer.Colors.selectedOption":"558AC2","__Designer.Colors.background":"11182A","__Designer.Colors.bottomGradient":"202B42","__Designer.Background.ImageTransparency":95,"__Designer.Colors.hoveredOptionTop":"4885A0","__Designer.Colors.elementText":"7692B8","__Designer.Colors.unhoveredOptionBottom":"5471C4"}]]
})

--// Tabs
local SettingsTab = MainFrame:CreateTab({Name = "Settings"})
local FOVSettingsTab = MainFrame:CreateTab({Name = "FOV Settings"})
local FunctionsTab = MainFrame:CreateTab({Name = "Functions"})

--// Original Settings Sections (Preserved)
local Values = SettingsTab:CreateSection({Name = "Values"})
local Checks = SettingsTab:CreateSection({Name = "Checks"})
local ThirdPerson = SettingsTab:CreateSection({Name = "Third Person"})

--// Add original settings controls
Values:AddToggle({
    Name = "Enabled",
    Value = Settings.Enabled,
    Callback = function(New) Settings.Enabled = New end
}).Default = Settings.Enabled

Values:AddToggle({
    Name = "Toggle",
    Value = Settings.Toggle,
    Callback = function(New) Settings.Toggle = New end
}).Default = Settings.Toggle

Settings.LockPart = Parts[1]
Values:AddDropdown({
    Name = "Lock Part",
    Value = Parts[1],
    Callback = function(New) Settings.LockPart = New end,
    List = Parts
}).Default = Parts[1]

Values:AddTextbox({
    Name = "Hotkey",
    Value = Settings.TriggerKey,
    Callback = function(New) Settings.TriggerKey = New end
}).Default = Settings.TriggerKey

Values:AddSlider({
    Name = "Sensitivity",
    Value = Settings.Sensitivity,
    Callback = function(New) Settings.Sensitivity = New end,
    Min = 0,
    Max = 1,
    Decimals = 2
}).Default = Settings.Sensitivity

Checks:AddToggle({
    Name = "Team Check",
    Value = Settings.TeamCheck,
    Callback = function(New) Settings.TeamCheck = New end
}).Default = Settings.TeamCheck

Checks:AddToggle({
    Name = "Wall Check",
    Value = Settings.WallCheck,
    Callback = function(New) Settings.WallCheck = New end
}).Default = Settings.WallCheck

Checks:AddToggle({
    Name = "Alive Check",
    Value = Settings.AliveCheck,
    Callback = function(New) Settings.AliveCheck = New end
}).Default = Settings.AliveCheck

ThirdPerson:AddToggle({
    Name = "Enable Third Person",
    Value = Settings.ThirdPerson,
    Callback = function(New) Settings.ThirdPerson = New end
}).Default = Settings.ThirdPerson

ThirdPerson:AddSlider({
    Name = "Sensitivity",
    Value = Settings.ThirdPersonSensitivity,
    Callback = function(New) Settings.ThirdPersonSensitivity = New end,
    Min = 0.1,
    Max = 5,
    Decimals = 1
}).Default = Settings.ThirdPersonSensitivity

--// ESP Settings (Added as new section)
local ESPSettings = SettingsTab:CreateSection({Name = "ESP Settings"})

ESPSettings:AddToggle({
    Name = "ESP Enabled",
    Value = ESPConfig.Enabled,
    Callback = function(New) ESPConfig.Enabled = New end
})

ESPSettings:AddToggle({
    Name = "Tracers",
    Value = ESPConfig.Tracers,
    Callback = function(New) ESPConfig.Tracers = New end
})

ESPSettings:AddToggle({
    Name = "Names",
    Value = ESPConfig.Names,
    Callback = function(New) ESPConfig.Names = New end
})

ESPSettings:AddToggle({
    Name = "Health Bar",
    Value = ESPConfig.HealthBar,
    Callback = function(New) ESPConfig.HealthBar = New end
})

ESPSettings:AddColorpicker({
    Name = "Tracer Color",
    Value = ESPConfig.TracerColor,
    Callback = function(New) ESPConfig.TracerColor = New end
})

ESPSettings:AddColorpicker({
    Name = "Name Color",
    Value = ESPConfig.NameColor,
    Callback = function(New) ESPConfig.NameColor = New end
})

ESPSettings:AddColorpicker({
    Name = "Health Color",
    Value = ESPConfig.HealthColor,
    Callback = function(New) ESPConfig.HealthColor = New end
})

ESPSettings:AddSlider({
    Name = "Max Distance",
    Value = ESPConfig.MaxDistance,
    Min = 0,
    Max = 5000,
    Callback = function(New) ESPConfig.MaxDistance = New end
})

--// Player Handling
Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function() CreateESP(Player) end)
end)

Players.PlayerRemoving:Connect(function(Player)
    if ESPFolder[Player] then
        for _, Drawing in pairs(ESPFolder[Player]) do
            Drawing:Remove()
        end
        ESPFolder[Player] = nil
    end
end)

--// Initialize ESP
for _, Player in pairs(Players:GetPlayers()) do
    if Player ~= Players.LocalPlayer then
        CreateESP(Player)
    end
end

--// ESP Update Loop
game:GetService("RunService").Heartbeat:Connect(function()
    if ESPConfig.Enabled then
        UpdateESP()
    else
        for _, Drawings in pairs(ESPFolder) do
            for _, Drawing in pairs(Drawings) do
                Drawing.Visible = false
            end
        end
    end
end)

--// Original FOV Settings
local FOV_Values = FOVSettingsTab:CreateSection({Name = "Values"})
local FOV_Appearance = FOVSettingsTab:CreateSection({Name = "Appearance"})

FOV_Values:AddToggle({
    Name = "Enabled",
    Value = FOVSettings.Enabled,
    Callback = function(New) FOVSettings.Enabled = New end
}).Default = FOVSettings.Enabled

FOV_Values:AddToggle({
    Name = "Visible",
    Value = FOVSettings.Visible,
    Callback = function(New) FOVSettings.Visible = New end
}).Default = FOVSettings.Visible

FOV_Values:AddSlider({
    Name = "Amount",
    Value = FOVSettings.Amount,
    Callback = function(New) FOVSettings.Amount = New end,
    Min = 10,
    Max = 300
}).Default = FOVSettings.Amount

FOV_Appearance:AddToggle({
    Name = "Filled",
    Value = FOVSettings.Filled,
    Callback = function(New) FOVSettings.Filled = New end
}).Default = FOVSettings.Filled

FOV_Appearance:AddSlider({
    Name = "Transparency",
    Value = FOVSettings.Transparency,
    Callback = function(New) FOVSettings.Transparency = New end,
    Min = 0,
    Max = 1,
    Decimal = 1
}).Default = FOVSettings.Transparency

FOV_Appearance:AddSlider({
    Name = "Sides",
    Value = FOVSettings.Sides,
    Callback = function(New) FOVSettings.Sides = New end,
    Min = 3,
    Max = 60
}).Default = FOVSettings.Sides

FOV_Appearance:AddSlider({
    Name = "Thickness",
    Value = FOVSettings.Thickness,
    Callback = function(New) FOVSettings.Thickness = New end,
    Min = 1,
    Max = 50
}).Default = FOVSettings.Thickness

FOV_Appearance:AddColorpicker({
    Name = "Color",
    Value = FOVSettings.Color,
    Callback = function(New) FOVSettings.Color = New end
}).Default = FOVSettings.Color

FOV_Appearance:AddColorpicker({
    Name = "Locked Color",
    Value = FOVSettings.LockedColor,
    Callback = function(New) FOVSettings.LockedColor = New end
}).Default = FOVSettings.LockedColor

--// Original Functions Section
local FunctionsSection = FunctionsTab:CreateSection({Name = "Functions"})

FunctionsSection:AddButton({
    Name = "Reset Settings",
    Callback = function()
        Functions.ResetSettings()
        Library.ResetAll()
    end
})

FunctionsSection:AddButton({
    Name = "Restart",
    Callback = Functions.Restart
})

FunctionsSection:AddButton({
    Name = "Exit",
    Callback = function()
        Functions:Exit()
        Library.Unload()
    end
})

FunctionsSection:AddButton({
    Name = "Discord User Page",
    Callback = function()
        setclipboard("@movedontokyo")
    end
})

-- Remove loader after delay efficiently
task.spawn(function()
    task.wait(3)  -- More efficient wait
    local fadeTween = TweenService:Create(loaderFrame, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    fadeTween:Play()
    fadeTween.Completed:Wait()
    loaderGui:Destroy()
end)
