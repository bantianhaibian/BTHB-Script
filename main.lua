-- BTHB-Script | 圣奥里 (San Aurie) 核心版
if getgenv().BTHB_Loaded then return end
getgenv().BTHB_Loaded = true

-- 使用测试成功的 GitHub 备用 UI 库
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/Rayfield/main/source.lua'))()
local Window = Rayfield:CreateWindow({
    Name = "BTHB-Script | 圣奥里",
    LoadingTitle = "正在注入...",
    LoadingSubtitle = "by BTHB",
    Theme = "Default",
    ConfigurationSaving = { Enabled = true, FolderName = "BTHB_Config", FileName = "SanAurie" },
})

local LocalPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- ==========================================
-- Tab 1: 玩家属性
-- ==========================================
local PlayerTab = Window:CreateTab("玩家属性", "user")

PlayerTab:CreateSlider({
    Name = "行走速度 (WalkSpeed)", Range = {16, 200}, Increment = 1, Suffix = " studs", CurrentValue = 16,
    Callback = function(v) 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
            LocalPlayer.Character.Humanoid.WalkSpeed = v 
        end 
    end,
})

PlayerTab:CreateSlider({
    Name = "跳跃高度 (JumpPower)", Range = {50, 300}, Increment = 10, Suffix = " power", CurrentValue = 50,
    Callback = function(v) 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
            LocalPlayer.Character.Humanoid.JumpPower = v 
        end 
    end,
})

PlayerTab:CreateToggle({
    Name = "无限跳跃", CurrentValue = false,
    Callback = function(v) getgenv().InfJump = v end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- ==========================================
-- Tab 2: 战斗
-- ==========================================
local CombatTab = Window:CreateTab("战斗", "crosshair")

CombatTab:CreateToggle({
    Name = "Aimbot (锁头)", CurrentValue = false, 
    Callback = function(v) getgenv().Aimbot = v end,
})

CombatTab:CreateSlider({
    Name = "瞄准范围 (FOV)", Range = {50, 800}, Increment = 50, CurrentValue = 300, 
    Callback = function(v) getgenv().AimFOV = v end,
})

CombatTab:CreateDropdown({
    Name = "瞄准部位", Options = {"头部", "躯干"}, CurrentOption = {"头部"}, 
    Callback = function(v) getgenv().AimPart = v[1] end,
})

RunService.RenderStepped:Connect(function()
    if getgenv().Aimbot then
        local closest, shortestDist = nil, getgenv().AimFOV or 300
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local target = p.Character:FindFirstChild("Head")
                if getgenv().AimPart == "躯干" then 
                    target = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso") 
                end
                
                if target then
                    local pos, onScreen = Camera:WorldToViewportPoint(target.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortestDist then 
                            shortestDist, closest = dist, target 
                        end
                    end
                end
            end
        end
        
        if closest then 
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position) 
        end
    end
end)

-- ==========================================
-- Tab 3: 视觉 (ESP)
-- ==========================================
local VisualTab = Window:CreateTab("视觉", "eye")

VisualTab:CreateToggle({
    Name = "玩家 ESP (方框透视)", CurrentValue = false,
    Callback = function(v) 
        getgenv().ESP = v
        if not v and getgenv().ESPDrawings then
            for _, d in pairs(getgenv().ESPDrawings) do d:Remove() end
            getgenv().ESPDrawings = {}
        end
    end,
})

task.spawn(function()
    while task.wait(0.5) do
        if getgenv().ESP and Drawing then
            getgenv().ESPDrawings = getgenv().ESPDrawings or {}
            
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local root = p.Character.HumanoidRootPart
                    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    
                    if onScreen then
                        if not getgenv().ESPDrawings[p.Name] then
                            local box = Drawing.new("Square")
                            box.Thickness, box.Color, box.Filled = 1, Color3.fromRGB(255, 0, 0), false
                            getgenv().ESPDrawings[p.Name] = box
                        end
                        
                        local box = getgenv().ESPDrawings[p.Name]
                        local sp = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
                        local size = 150 / pos.Z
                        box.Size = Vector2.new(size, size * 2)
                        box.Position = Vector2.new(sp.X - size / 2, sp.Y - size)
                        box.Visible = true
                    else
                        if getgenv().ESPDrawings[p.Name] then 
                            getgenv().ESPDrawings[p.Name].Visible = false 
                        end
                    end
                end
            end
        end
    end
end)
