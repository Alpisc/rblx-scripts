local success, result = pcall(function()
    local scriptUrl = "https://raw.githubusercontent.com/Alpisc/rbx-scripts/refs/heads/main/" .. game.PlaceId ..".lua"
    local scriptContent = game:HttpGet(scriptUrl)
    return loadstring(scriptContent)()
end)

if not success then
    warn("No script for this game found")
end
