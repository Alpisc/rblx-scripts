local lp = game.Players.LocalPlayer
local tycoon = nil

for i,v in ipairs(game:GetService("Workspace").Tycoons:GetChildren()) do
    if v.Name ~= "CreateStorage" and v.TycoonOwner.Value == lp.Name then
        tycoon = v
        break
    end
end

if tycoon == nil then
    warn("No tycoon found! Claim a tycoon and run the script again!")
    return
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name 
local Window = Rayfield:CreateWindow({
    Name = gameName,
    LoadingTitle = "Welcome " .. lp.Name,
    LoadingSubtitle = gameName,
})

local MainTab = Window:CreateTab("Main")
local MiscTab = Window:CreateTab("Misc")

local autoShow = MainTab:CreateToggle({
    Name = "Auto Show",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoShowToggle = Value
        while _G.autoShowToggle do
            game:GetService("ReplicatedStorage").Events.ShowPromptConfirm:FireServer()
            wait(5)
            game:GetService("ReplicatedStorage").Events.TourComplete:FireServer(100)
            wait(60)
        end
    end,
})

local autoPurchaseButtons = MainTab:CreateToggle({
    Name = "Auto Purchase Money Buttons",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoPurchaseButtonsToggle = Value
        while _G.autoPurchaseButtonsToggle do
            for i,v in ipairs(tycoon.Purchases:GetChildren()) do
                if not _G.autoPurchaseButtonsToggle then return end
                if v:IsA("Part") and v.Transparency == 0 and v.Cost.Value <= lp.Data.Coins.Value then
                    lp.Character.HumanoidRootPart.CFrame = v.CFrame
                end
                wait(0.5)
            end
        end
    end,
})

local autoPurchaseFanButtons = MainTab:CreateToggle({
    Name = "Auto Purchase Fan Buttons",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoPurchaseFanButtonsToggle = Value
        while _G.autoPurchaseFanButtonsToggle do
            for i,v in ipairs(tycoon.FollowerAchievements:GetChildren()) do
                if not _G.autoPurchaseFanButtonsToggle then return end
                if v:IsA("Part") and v.Transparency == 0 and v.Cost.Value <= lp.leaderstats.Fans.Value then
                    lp.Character.HumanoidRootPart.CFrame = v.CFrame
                end
                wait(0.5)
            end
        end
    end,
})

local autoRestock = MainTab:CreateToggle({
    Name = "Auto Restock",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoRestockToggle = Value
        while _G.autoRestockToggle do
            for i,v in ipairs(tycoon.StaticItems:GetChildren()) do
                if string.find(v.Name, "Storage") and v.Storage.Cost.Text == "⚠️ Needs restock!" then
                    lp.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0,5,0)
                    wait(0.5)
                    fireproximityprompt(v.ProximityPrompt)
                    wait(0.1)
                end
            end
            wait(5)
        end
    end,
})

local autoClaimCurrency = MiscTab:CreateToggle({
    Name = "Auto Claim Currency",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoClaimCurrencyToggle = Value
        while _G.autoClaimCurrencyToggle do
            game:GetService("ReplicatedStorage").TemplateEvents.Rewards.Claim:FireServer("Currency")
            wait(60)
        end
    end,
})

local autoClaimRewards = MiscTab:CreateToggle({
    Name = "Auto Claim Rewards",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoClaimRewardsToggle = Value
        while _G.autoClaimRewardsToggle do
            for i=1,12 do
                game:GetService("ReplicatedStorage").TemplateEvents.Rewards.ClaimTimedReward:FireServer(i)
                wait(0.1)
            end
            wait(120)
        end
    end,
})

local autoRNG = MiscTab:CreateToggle({
    Name = "Auto Claim RNG",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoRNGToggle = Value
        while _G.autoRNGToggle do
            game:GetService("ReplicatedStorage").TemplateEvents.Rewards.RequestTimerRoll:InvokeServer(math.random(0,2))
            wait(60*6)
        end
    end,
})

local claimBadge = MiscTab:CreateButton({
    Name = "Claim Badge",
    Callback = function()
        local args = {
            [1] = 2142604845,
            [2] = true
        }
        game:GetService("ReplicatedStorage").BadgeRemotes.RewardBadge:FireServer(unpack(args))
    end,
 })