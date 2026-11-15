print("GitHub 通道测试：拉取成功！")
print("正在尝试加载 Rayfield UI 库...")

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if success and Rayfield then
    print("UI 库加载成功，正在创建窗口...")
    
    local Window = Rayfield:CreateWindow({
        Name = "BTHB 测试面板",
        LoadingTitle = "加载中...",
        LoadingSubtitle = "GitHub 通道测试",
        Theme = "Default",
    })
    
    local Tab = Window:CreateTab("测试", "user")
    
    Tab:CreateButton({
        Name = "点击测试",
        Callback = function()
            print("按钮点击成功！说明脚本完全正常运行。")
        end,
    })
else
    print("UI 库加载失败，可能是你的网络屏蔽了 sirius.menu 域名。")
end
