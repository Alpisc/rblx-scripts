local lp = game.Players.LocalPlayer

local tycoon = nil

for _,v in ipairs(game:GetService("Workspace").Tycoons:GetChildren()) do
    if v.Values.Owner.Value == lp then
        tycoon = v.Tycoon
        break
    end
end

if tycoon == nil then
    warn("No tycoon found! Claim a tycoon and run the script again!")
    return
end

_G.autoPurchase = false
_G.autoCollectMoney = false

_G.purchaseCooldown = 0.5
_G.moneyClaimCooldown = 3

pcall(function()
    tycoon.GoldifyButtons:Destroy()
    tycoon.DiamondifyButtons:Destroy()
end)

local function parsePrice(str)
    str = str:gsub("%$", "")
    local suffix = str:sub(-1)
    local numStr = (suffix == "K" or suffix == "M") and str:sub(1, -2) or str
    local num = tonumber(numStr)
    return num and (suffix == "K" and num * 1e3 or suffix == "M" and num * 1e6 or num)
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name 
local Window = Rayfield:CreateWindow({
    Name = gameName,
    LoadingTitle = "Welcome " .. lp.Name,
    LoadingSubtitle = gameName,
})

local MainTab = Window:CreateTab("Main")

local moneyClaimCooldown = MainTab:CreateInput({
    Name = "Money Claim Delay (in seconds)",
    CurrentValue = 10,
    PlaceholderText = "Money Claim Delay",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        _G.moneyClaimCooldown = tonumber(Text)
    end,
})

local autoCollectMoney = MainTab:CreateToggle({
    Name = "Auto Collect Money",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoCollectMoney = Value
        while _G.autoCollectMoney do
            for _,v in ipairs(tycoon:GetChildren()) do
                if v:IsA("Model") and _G.autoCollectMoney then
                    for _2,v2 in v.Collectors:GetChildren() do
                        if v2:IsA("Model") and _G.autoCollectMoney then
                            --lp.Character.HumanoidRootPart.CFrame = v2.ZonePart.CFrame + Vector3.new(0,10,0)
                            firetouchinterest(lp.Character.HumanoidRootPart, v2.ZonePart, 0)
                            wait(0.1)
                            firetouchinterest(lp.Character.HumanoidRootPart, v2.ZonePart, 1)
                            wait(1)
                            break
                        end
                    end
                end
            end
            wait(_G.moneyClaimCooldown)
        end
    end,
})

local purchaseCooldown = MainTab:CreateInput({
    Name = "Purchase Delay (in seconds)",
    CurrentValue = 0.5,
    PlaceholderText = "Purchase Delay",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        _G.purchaseCooldown = tonumber(Text)
    end,
})

local autoPurchase = MainTab:CreateToggle({
    Name = "Auto Purchase",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoPurchase = Value
        while _G.autoPurchase do
            for _,v in ipairs(tycoon:GetChildren()) do
                if v:IsA("Model") then
                    for _2,v2 in ipairs(v.Buttons:GetChildren()) do
                        
                        local count = 0

                        for _, model in ipairs(v.Buttons:GetChildren()) do
                            if model:IsA("Model") and #model:GetChildren() == 0 then
                                count = count + 1
                            end
                        end

                        if count ~= 0 then
                            lp.Character.HumanoidRootPart.CFrame = game.Workspace.GuideArrow.Attachment0.CFrame 
                        end

                        if v2:FindFirstChild("Press") and parsePrice(v2.Press.Info.Price.TextLabel.Text) <= game.Players.LocalPlayer.leaderstats.Money.Value and _G.autoPurchase then
                            --lp.Character.HumanoidRootPart.CFrame = v2.Press.CFrame + Vector3.new(0,5,0)
                            firetouchinterest(lp.Character.HumanoidRootPart, v2.Press, 0)
                            wait(0.1)
                            firetouchinterest(lp.Character.HumanoidRootPart, v2.Press, 1)
                            wait(_G.purchaseCooldown)
                        end
                        wait(0.1)
                    end
                end
            end
        end
    end,
})