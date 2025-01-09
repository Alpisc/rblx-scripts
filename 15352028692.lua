local lp = game.Players.LocalPlayer
local tycoon = game.Workspace.Player_Plots_F[lp.UserId .. "_Plot"]

if 	game.Workspace:FindFirstChild("Immersive_Ads_F") then 
	game.Workspace.Immersive_Ads_F:Destroy()
end
if tycoon:FindFirstChild("Gamepass_Buttons") then
	tycoon.Gamepass_Buttons:Destroy()
end
lp.PlayerScripts.Custom_Chat_Handle.Enabled = false
lp.PlayerScripts.Monetization_Prompt_Handle.Enabled = false

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
        while _G.autoCollectMoney do
            while not tycoon.Mailbox:FindFirstChild("Main_Censor") do
				wait(1)
			end
			lp.Character.HumanoidRootPart.CFrame = tycoon.Mailbox.Main_Censor.CFrame + Vector3.new(0,5,0)
			wait(1)
        end
    end,
})

local autoPurchaseButton = MainTab:CreateToggle({
    Name = "Auto Purchase Button",
    CurrentValue = false,
    Callback = function(Value)
        _G.autoPurchaseButton = Value
        while _G.autoPurchaseButton do
			for i,v in ipairs(tycoon.Builds_F.Buttons_F:GetChildren()) do
				if v:IsA("Model") and v:FindFirstChild("Button_P") and v.Button_P.BrickColor == BrickColor.new("Lime green") then
					lp.Character.HumanoidRootPart.CFrame = v.Touch_P.CFrame + Vector3.new(0,5,0)
					wait(0.1)
				end
				wait(0.1)
			end
        end
    end,
})