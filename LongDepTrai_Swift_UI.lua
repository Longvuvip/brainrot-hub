-- ✅ LongDepTrai Hub - Swift Edition UI ✅
if getgenv then getgenv().SecureMode = true end

-- 🔒 AntiBan Hook (Chặn kick + break)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local m = getnamecallmethod()
    if m == "Kick" or m == "BreakJoints" then return nil end
    return old(self, ...)
end)

-- 📦 Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- 💬 UI Setup
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "🌈 LongDepTrai Hub 🌈", HidePremium = false, SaveConfig = true, ConfigFolder = "LongDepTraiHub"})

-- 📌 Biến bật/tắt
getgenv().AutoSteal = false
getgenv().SpeedHack = false
getgenv().AutoLock = false

-- 🏠 Tìm Nhà Người Chơi
function getMyHouse()
    local houses = workspace:FindFirstChild("Houses")
    for _, house in pairs(houses:GetChildren()) do
        if house:FindFirstChild("Owner") and house.Owner.Value == LocalPlayer.Name then
            return house
        end
    end
end

-- 🐶 Steal Pet từ tất cả nhà
function stealPetsLoop()
    while getgenv().AutoSteal do
        for _, house in pairs(workspace.Houses:GetChildren()) do
            local Pet = house:FindFirstChild("Pet")
            if Pet and Pet:IsA("Model") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = Pet.PrimaryPart.CFrame
                fireproximityprompt(Pet.PrimaryPart:FindFirstChildWhichIsA("ProximityPrompt"))
                task.wait(0.3)
                local myHouse = getMyHouse()
                if myHouse then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = myHouse.Entrance.CFrame
                end
                task.wait(0.3)
            end
        end
        task.wait(0.2)
    end
end

-- 🛡️ Auto Lock Nhà
function autoLockLoop()
    while getgenv().AutoLock do
        local myHouse = getMyHouse()
        if myHouse then
            local btn = myHouse:FindFirstChild("LockButton", true)
            if btn then fireproximityprompt(btn) end
        end
        task.wait(2)
    end
end

-- ⚡ Speed Hack
RunService.Stepped:Connect(function()
    if getgenv().SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 65
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- 🎮 Tabs + Buttons
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})

MainTab:AddToggle({
    Name = "🐾 Auto Steal Pet",
    Default = false,
    Callback = function(v)
        getgenv().AutoSteal = v
        if v then
            stealPetsLoop()
        end
    end
})

MainTab:AddToggle({
    Name = "🔒 Auto Lock Nhà",
    Default = false,
    Callback = function(v)
        getgenv().AutoLock = v
        if v then
            autoLockLoop()
        end
    end
})

MainTab:AddToggle({
    Name = "⚡ Speed Hack",
    Default = false,
    Callback = function(v)
        getgenv().SpeedHack = v
    end
})

OrionLib:Init()