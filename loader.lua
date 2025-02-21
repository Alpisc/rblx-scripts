local success = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Alpisc/rblx-scripts/refs/heads/main/games/" .. game.PlaceId ..".lua"))()
end)

if not success then
    warn("No script for " .. game.PlaceId .. " found")
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
