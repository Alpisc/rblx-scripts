local lp = game.Players.LocalPlayer

local function getTycoonPlot()
    for _,v in ipairs(game:GetService("Workspace").Tycoons:GetChildren()) do
        for _2,v2 in ipairs(v:GetChildren()) do
            for _3,v3 in ipairs(v2:GetChildren()) do
                if v3:FindFirstChild("Collectors") and v3.Collectors.Collector.CollectorGui.MainFrame.Title.Text == lp.Name .. "'s Mansion" then
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

_G.moneyClaimCooldown = 3
_G.autoCollectMoney = false

_G.autoPurchaseCooldown = 1
_G.autoPurchaseButtons = false

_G.useTeleport = false

local function parsePrice(str)
    str = str:gsub("%$", "")
    local suffix = str:sub(-1)
    local numStr = (suffix == "K" or suffix == "M") and str:sub(1, -2) or str
    local num = tonumber(numStr)
    return num and (suffix == "K" and num * 1e3 or suffix == "M" and num * 1e6 or num)
end

local function teleport(part, forceLegacy)
    forceLegacy = forceLegacy or false
    if _G.useTeleport or forceLegacy then
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

local autoLetter = MainTab:CreateToggle({
    Name = "Pick up Letters",
    Value = _G.autoLetter,
    Callback = function(Value)
        _G.autoLetter = Value
        while _G.autoLetter do
            for i,v in ipairs(game.Workspace:GetChildren()) do
                if v:FindFirstChild("Letter") and _G.autoLetter then
                    teleport(v.Letter, true)
                    wait(0.5)
                end
            end
            wait(4)
        end
    end,
})

local moneyClaimCooldown = MainTab:CreateInput({
    Name = "Money Claim Delay (in seconds)",
    CurrentValue = _G.moneyClaimCooldown,
    PlaceholderText = "Money Claim Delay",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        _G.moneyClaimCooldown = tonumber(Text)
    end,
})

local autoCollectMoney = MainTab:CreateToggle({
    Name = "Auto Collect Money",
    CurrentValue = _G.autoCollectMoney,
    Callback = function(Value)
        _G.autoCollectMoney = Value
        while _G.autoCollectMoney do
            if tycoon:FindFirstChild("Collectors"):FindFirstChild("Collector") then
                teleport(tycoon.Collectors.Collector.Touch)
                wait(_G.moneyClaimCooldown)
            else 
                tycoon = getTycoonPlot()
            end
            wait(0.1)
        end
    end,
})

local autoPurchaseCooldown = MainTab:CreateInput({
    Name = "Purchase Delay (in seconds)",
    CurrentValue = _G.autoPurchaseCooldown,
    PlaceholderText = "Purchase Delay",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        _G.autoPurchaseCooldown = tonumber(Text)
    end,
})

local autoPurchaseButtons = MainTab:CreateToggle({
    Name = "Auto Purchase Buttons",
    CurrentValue = _G.autoPurchaseButtons,
    Callback = function(Value)
        _G.autoPurchaseButtons = Value
        while _G.autoPurchaseButtons do
            if tycoon:FindFirstChild("Buttons") then
                for i,v in ipairs(tycoon.Buttons:GetChildren()) do
                    if parsePrice(v.ButtonGui.Value.MainFrame.ItemPrice.Text) <= lp.leaderstats.Money.Value then
                        teleport(v.Touch)
                        wait(autoPurchaseCooldown)
                    end
                end
            else
                tycoon = getTycoonPlot()
            end
            wait(0.1)
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