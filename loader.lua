local success, result = pcall(function()
    local scriptUrl = "https://raw.githubusercontent.com/Alpisc/rblx-scripts/refs/heads/main/" .. game.PlaceId ..".lua"
    local scriptContent = game:HttpGet(scriptUrl)
    return loadstring(scriptContent)()
end)

if not success then
    warn("No script for this game found")
    return
end

if not _G.antiafk then
    _G.antiafk = true
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end
