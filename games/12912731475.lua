local lp = game.Players.LocalPlayer

local function getTycoonPlot()
    for _,v in ipairs(game:GetService("Workspace").Tycoons:GetChildren()) do
        for _2,v2 in ipairs(v:GetChildren()) do
            for _3,v3 in ipairs(v3:GetChildren()) do
                if v3.Collectors.Collector.CollectorGui.MainFrame.Title.Text == lp.Name .. "'s Mansion" then
                    return v3
                end
            end
        end
    end
    return nil
end

local tycoon = getTycoonPlot()

if tycoon == nil then
    warn("No tycoon found! Claim a tycoon and run the script again!")
    return
end

_G.useTeleport = false

local function parsePrice(str)
    str = str:gsub("%$", "")
    local suffix = str:sub(-1)
    local numStr = (suffix == "K" or suffix == "M") and str:sub(1, -2) or str
    local num = tonumber(numStr)
    return num and (suffix == "K" and num * 1e3 or suffix == "M" and num * 1e6 or num)
end

local function teleport(part)
    if _G.useTeleport then
        lp.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0,10,0)
    else
        firetouchinterest(lp.Character.HumanoidRootPart, part, 0)
        wait(0.1)
        firetouchinterest(lp.Character.HumanoidRootPart, part, 1)
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name 
local Window = Rayfield:CreateWindow({
    Name = gameName,
    LoadingTitle = "Welcome " .. lp.Name,
    LoadingSubtitle = gameName,
})

local MainTab = Window:CreateTab("Main")

local autoLetter = MainTab:CreateButton({
    Name = "Pick up Letters",
    Callback = function()
        for i,v in ipairs(game.Workspace:GetChildren()) do
            if v:FindFirstChild("Letter") and _G. then
                teleport(v.Letter)
                wait(0.5)
            end
        end
    end,
})

local SettingsTab = Window:CreateTab("Settings")

local useTeleportSetting = SettingsTab:CreateToggle({
    Name = "Use Teleport instead of FireTouchInterest",
    CurrentValue = _G.useTeleport,
    Callback = function(Value)
        _G.useTeleport = Value
    end,
})