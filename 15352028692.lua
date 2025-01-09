local moneyCollectWait = 1
local buttonTeleportWait = .2

local lp = game.Players.LocalPlayer
local tycoon = game.Workspace.Player_Plots_F[lp.UserId .. "_Plot"]

if 	game.Workspace:FindFirstChild("Immersive_Ads_F") then 
	game.Workspace.Immersive_Ads_F:Destroy()

end
    lp.PlayerScripts.Custom_Chat_Handle.Enabled = false
    lp.PlayerScripts.Monetization_Prompt_Handle.Enabled = false
	tycoon.Gamepass_Buttons:Destroy()

while _G.Enabled do
	while not tycoon.Mailbox:FindFirstChild("Main_Censor") do
		wait(1)
	end
	lp.Character.HumanoidRootPart.CFrame = tycoon.Mailbox.Main_Censor.CFrame + Vector3.new(0,5,0)
	wait(moneyCollectWait)
	for i,v in ipairs(tycoon.Builds_F.Buttons_F:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Button_P") and v.Button_P.BrickColor == BrickColor.new("Lime green") then
			lp.Character.HumanoidRootPart.CFrame = v.Touch_P.CFrame + Vector3.new(0,5,0)
			wait(buttonTeleportWait)
		end
	end
end