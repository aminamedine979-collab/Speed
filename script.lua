-- خدمات روبلوكس
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- المتغيرات الأساسية
local DefaultSpeed = 16
local TargetSpeed = DefaultSpeed

-- إنشاء الشاشة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedAndBoostGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- النافذة الرئيسية (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 210, 0, 215)
MainFrame.Position = UDim2.new(0.5, -105, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- العنوان
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 25)
Title.Position = UDim2.new(0, 10, 0, 2)
Title.BackgroundTransparency = 1
Title.Text = "Speed & FPS Boost"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- زر التصغير/التكبير (-)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 25, 0, 25)
ToggleButton.Position = UDim2.new(1, -28, 0, 2)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Text = "-"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = MainFrame

-- مربع إدخال السرعة
local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0.85, 0, 0, 26)
SpeedInput.Position = UDim2.new(0.075, 0, 0.14, 0)
SpeedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.PlaceholderText = "Enter Speed (e.g. 50)"
SpeedInput.Text = ""
SpeedInput.TextSize = 12
SpeedInput.Font = Enum.Font.SourceSans
SpeedInput.Parent = MainFrame
Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0, 5)

-- زر Apply
local ApplyButton = Instance.new("TextButton")
ApplyButton.Size = UDim2.new(0.85, 0, 0, 26)
ApplyButton.Position = UDim2.new(0.075, 0, 0.28, 0)
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.Text = "Apply Speed"
ApplyButton.TextSize = 13
ApplyButton.Font = Enum.Font.SourceSansBold
ApplyButton.Parent = MainFrame
Instance.new("UICorner", ApplyButton).CornerRadius = UDim.new(0, 5)

-- زر Stop Speed
local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0.85, 0, 0, 26)
StopButton.Position = UDim2.new(0.075, 0, 0.42, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Text = "Stop Speed"
StopButton.TextSize = 13
StopButton.Font = Enum.Font.SourceSansBold
StopButton.Parent = MainFrame
Instance.new("UICorner", StopButton).CornerRadius = UDim.new(0, 5)

-- خط فاصل
local Line = Instance.new("Frame")
Line.Size = UDim2.new(0.85, 0, 0, 1)
Line.Position = UDim2.new(0.075, 0, 0.57, 0)
Line.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- زر Start Flags (تفعيل الـ Boost)
local StartFlagsBtn = Instance.new("TextButton")
StartFlagsBtn.Size = UDim2.new(0.85, 0, 0, 26)
StartFlagsBtn.Position = UDim2.new(0.075, 0, 0.62, 0)
StartFlagsBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
StartFlagsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartFlagsBtn.Text = "Start Flags (Boost)"
StartFlagsBtn.TextSize = 13
StartFlagsBtn.Font = Enum.Font.SourceSansBold
StartFlagsBtn.Parent = MainFrame
Instance.new("UICorner", StartFlagsBtn).CornerRadius = UDim.new(0, 5)

-- زر Stop Flags (إلغاء الـ Boost)
local StopFlagsBtn = Instance.new("TextButton")
StopFlagsBtn.Size = UDim2.new(0.85, 0, 0, 26)
StopFlagsBtn.Position = UDim2.new(0.075, 0, 0.76, 0)
StopFlagsBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 30)
StopFlagsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopFlagsBtn.Text = "Stop Flags (Reset)"
StopFlagsBtn.TextSize = 13
StopFlagsBtn.Font = Enum.Font.SourceSansBold
StopFlagsBtn.Parent = MainFrame
Instance.new("UICorner", StopFlagsBtn).CornerRadius = UDim.new(0, 5)

-------------------------------------------------
-- منطق السرعة (Speed Logic)
-------------------------------------------------
local function setCharacterSpeed(speedValue)
    TargetSpeed = speedValue
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = TargetSpeed
    end
end

ApplyButton.MouseButton1Click:Connect(function()
    local num = tonumber(SpeedInput.Text)
    if num then setCharacterSpeed(num) end
end)

StopButton.MouseButton1Click:Connect(function()
    SpeedInput.Text = ""
    setCharacterSpeed(DefaultSpeed)
end)

local function setupCharacter(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = TargetSpeed
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if humanoid.WalkSpeed ~= TargetSpeed then
            humanoid.WalkSpeed = TargetSpeed
        end
    end)
end

if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

-------------------------------------------------
-- منطق الجرافيكس والـ Boost (Flags Logic)
-------------------------------------------------
local originalGlobalShadows = Lighting.GlobalShadows

StartFlagsBtn.MouseButton1Click:Connect(function()
    -- إلغاء الظلال والعشب وتقليل جودة المواد
    Lighting.GlobalShadows = false
    if Terrain then sethiddenproperty(Terrain, "Decoration", false) end
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        end
    end
end)

StopFlagsBtn.MouseButton1Click:Connect(function()
    -- استعادة الظلال وتفعيل التأثيرات مجدداً
    Lighting.GlobalShadows = originalGlobalShadows
    if Terrain then sethiddenproperty(Terrain, "Decoration", true) end
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = true
        end
    end
end)

-------------------------------------------------
-- التصغير والتكبير
-------------------------------------------------
local isMinimized = false

ToggleButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 30, 0, 30)
        SpeedInput.Visible = false
        ApplyButton.Visible = false
        StopButton.Visible = false
        Line.Visible = false
        StartFlagsBtn.Visible = false
        StopFlagsBtn.Visible = false
        Title.Visible = false
        ToggleButton.Position = UDim2.new(0, 0, 0, 0)
        ToggleButton.Size = UDim2.new(1, 0, 1, 0)
        ToggleButton.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 210, 0, 215)
        SpeedInput.Visible = true
        ApplyButton.Visible = true
        StopButton.Visible = true
        Line.Visible = true
        StartFlagsBtn.Visible = true
        StopFlagsBtn.Visible = true
        Title.Visible = true
        ToggleButton.Position = UDim2.new(1, -28, 0, 2)
        ToggleButton.Size = UDim2.new(0, 25, 0, 25)
        ToggleButton.Text = "-"
    end
end)
