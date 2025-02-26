local lp = game.Players.LocalPlayer

local function getTycoonPlot()
    for _,v in ipairs(game:GetService("Workspace").Tycoons:GetChildren()) do
        for _2,v2 in ipairs(v:GetChildren()) do
            for _3,v3 in ipairs(v2:GetChildren()) do
                if v3:FindFirstChild("Collectors") and string.sub(v3.Collectors.Collector.CollectorGui.MainFrame.Title.Text, 1, #lp.Name) == lp.Name then
                    if v3:FindFirstChild("GlobalButtons") then
                        v3.GlobalButtons:Destroy()
                    end
                    if v3:FindFirstChild("GoldifyButtons") then
                        v3.GoldifyButtons:Destroy()
                    end
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

lp.PlayerGui.ShopGui.Enabled = false

_G.moneyClaimCooldown = 3
_G.autoCollectMoney = false

_G.autoPurchaseCooldown = 1
_G.autoPurchaseButtons = false

_G.autoNextMansion = false

_G.useTeleport = false

local function parsePrice(str)
    str = str:gsub("[$,]", "")
    return tonumber(str)
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
                if _G.autoLetter and v:FindFirstChild("Letter") then
                    teleport(v.Letter, true)
                    wait(0.5)
                end
            end
            wait(5)
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
            if _G.autoCollectMoney and tycoon and tycoon:FindFirstChild("Collectors"):FindFirstChild("Collector") then
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
            if tycoon and tycoon:FindFirstChild("Buttons") then
                for i,v in ipairs(tycoon.Buttons:GetChildren()) do
                    if _G.autoPurchaseButtons and v:FindFirstChild("ButtonGui") and parsePrice(v.ButtonGui.Value.MainFrame.ItemPrice.Text) <= lp.leaderstats.Money.Value then
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

local autoNextMansion = MainTab:CreateToggle({
    Name = "Auto Next Mansion",
    CurrentValue = _G.autoNextMansion,
    Callback = function(Value)
        _G.autoNextMansion = Value
        while _G.autoNextMansion do
            for i,v in ipairs(lp.PlayerGui.MansionSelectorGui.Frame.ScrollingFrame:GetChildren()) do
                if _G.autoNextMansion and v:IsA("Frame") and v:FindFirstChild("Cost") and v.PurchaseButton.Visible and parsePrice(v.Cost.Text) <= lp.leaderstats.Money.Value then
                    game:GetService("ReplicatedStorage").__remotes.TycoonService.PurchaseTycoon:FireServer(v.Name)
                    wait(1)
                    game:GetService("ReplicatedStorage").__remotes.TycoonService.SwitchMansion:FireServer(v.Name)
                    wait(5)
                    tycoon = getTycoonPlot()
                end
            end
            wait(60)
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