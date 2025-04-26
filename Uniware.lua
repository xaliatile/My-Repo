local Players = game:GetService("Players")

local lib = loadstring(game:HttpGet("https://codeberg.org/Blukez/rolibwaita/raw/branch/master/Source.lua"))()

local canUseGethui = true
local keepUniware = true
local teleCheck = false
local DefaultKeybind = "LeftAlt"

Players.LocalPlayer.OnTeleport:Connect(function(State)
	if keepUniware and (not teleCheck) and queue_on_teleport then
		teleCheck = true
		queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/xaliatile/Uniware/refs/heads/main/Uniware.lua"))()')
    elseif keepUniware and (not teleCheck) and queueteleport then
        teleCheck = true
        queueteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/xaliatile/Uniware/refs/heads/main/Uniware.lua"))()')
	end
end)

if gethui then
   canUseGethui = true
else
   canUseGethui = false
end

local Window = lib:NewWindow({
    Name = "Uniware",
    Keybind = DefaultKeybind,
    UseCoreGui = canUseGethui,
    PrintCredits = true
})

local UniversalTab = Window:NewTab({
    Name = "Universal",
    Icon = "rbxassetid://11293979388"
})

local UniversalSection = UniversalTab:NewSection({
    Name = "Universal Options",
    Description = "Has options and features for universal use",
})

local Executor = UniversalSection:NewTextBox({
    Name = "Executor",
    PlaceholderText = "Enter code *requires loadstring*",
    Text = "",
    Trigger = "FocusLost",
    Callback = function(value)
        local func, err = loadstring(value)

        local success, result = pcall(function()
            assert(func, err)()
        end)

        if not success then
            game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Notification",
				Text = "Callback Error",
                Button1 = "Okay",
                Duration = 1000
			})
        end
    end,
})

local UnD = UniversalSection:NewToggle({
    Name = "Undetectable", 
    Description = "Makes it very difficult for anti-cheats to detect you.",
    CurrentState = true,
    Callback = function(value)

    end,
})

local KeepUni = UniversalSection:NewToggle({
    Name = "Keep Uni", 
    Description = "every time you serverhop or rejoin it will automatically load for you.",
    CurrentState = true,
    Callback = function(value)
        if queueteleport or queue_on_teleport then
            keepUniware = value
            print(keepUniware)
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Notice",
				Text = "Your executor does not support: queue_on_teleport() cannot execute.",
                Duration = 3
			})
        end
    end,
})

local MiscellaneousTab = Window:NewTab({
    Name = "Miscellaneous",
    Icon = "rbxassetid://11419704343"
})
