local lp = game.Players.LocalPlayer
local tycoon = nil

for i,v in ipairs(game:GetService("Workspace").Tycoon.Tycoons:GetChildren()) do
    if v.Owner.Value == lp then
        tycoon = v
        break
    end
end

if tycoon == nil then
    warn("No tycoon detected! join a tycoon and reexecute")
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

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name 
local Window = Rayfield:CreateWindow({
    Name = gameName,
    LoadingTitle = "Welcome " .. lp.Name,
    LoadingSubtitle = gameName,
})

local MainTab = Window:CreateTab("Main")

local autoCollectMoney = MainTab:CreateToggle({
    Name = "Auto Collect Money",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoCollectMoney = Value
        tycoon.Essentials.CollectorParts.Metal.CanCollide = _G.autoCollectMoney
        while _G.autoCollectMoney do
            if tycoon.Essentials.CanCollect.Value then
                lp.Character.HumanoidRootPart.CFrame = tycoon.Essentials.CashCollector.CFrame
            end
            wait(5)
        end
    end,
})

local autoPurchaseButtons = MainTab:CreateToggle({
    Name = "Auto Purchase Buttons",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoPurchaseButtons = Value
        while _G.autoPurchaseButtons do
            for i,v in ipairs(tycoon.UnpurchasedButtons:GetChildren()) do
                if not _G.autoPurchaseButtons then break end
                pcall(function()
                    if v:IsA("Model") and v:FindFirstChild("Neon") then
                        if (v.Neon.Color == Color3.fromRGB(0, 255, 0) or v.Neon.Color == Color3.fromRGB(4, 175, 235)) and v.Price.Value <= lp.leaderstats.Cash.Value then
                            lp.Character.HumanoidRootPart.CFrame = v.Gradient.CFrame + Vector3.new(0, 5, 0)
                            wait(0.5)
                        end
                        if v.Neon.Color == Color3.fromRGB(255, 255, 0) then
                            if tonumber(string.split(v.Neon.UI.BillboardGui.Frame.Price.Text, " ")[1]) > lp.leaderstats.Rebirths.Value then
                                v:Destroy()
                            else
                                lp.Character.HumanoidRootPart.CFrame = v.Gradient.CFrame + Vector3.new(0, 5, 0)
                            end
                            wait(0.5)
                        end
                    end
                end)
                wait(0.1)
            end
        end
    end,
})

local autoRebirth = MainTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoRebirth = Value
        while _G.autoRebirth do
            if lp.PlayerGui.RebirthGui.RebirthButton.Visible and lp.leaderstats.Cash.Value >= 500000 then
                game:GetService("ReplicatedStorage"):WaitForChild("RebirthEVT"):FireServer()
                lp.PlayerGui.RebirthGui.RebirthButton.Visible = false
            end
            wait(5)
        end
    end,
})

local autoPumpOil = MainTab:CreateToggle({
    Name = "Auto Pump Oil",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoPumpOil = Value
        while _G.autoPumpOil do
            lp.Character.HumanoidRootPart.CFrame = tycoon.PurchasedObjects["Oil 1"].CB1.CFrame
            wait(0.2)
            fireproximityprompt(tycoon.PurchasedObjects["Oil 1"].CB1.DefaultExtractor)
            wait(4)
        end
    end,
})

local autoRepairLargeOil = MainTab:CreateToggle({
    Name = "Auto Repair Large Oil Rig",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoRepairLargeOil = Value
        while _G.autoRepairLargeOil do
            for i,v in ipairs(tycoon.PurchasedObjects:GetChildren()) do
                if not _G.autoRepairLargeOil then break end
                if string.find(v.Name, "Large Oil ") and v.Broken.Value then
                    while v.Broken.Value do
                        lp.Character.HumanoidRootPart.CFrame = v.ElectricalBox.Effect.CFrame + Vector3.new(0, 5, 0)
                        wait(0.1)
                        fireproximityprompt(v.ElectricalBox.Effect.OilExtractor)
                    end
                    wait(0.1)
                end
                wait(0.01)
            end
            wait(30)
        end
    end,
})

