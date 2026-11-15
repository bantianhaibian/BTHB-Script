print("GitHub 通道测试：拉取成功！")
print("正在尝试加载备用 GitHub UI 库...")

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/Rayfield/main/source.lua'))()
end)

if success and Rayfield then
    print("UI 库加载成功！准备创建窗口...")
    
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
    print("UI 库加载仍然失败，错误信息:", Rayfield)
end
