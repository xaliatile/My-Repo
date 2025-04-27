local Players = game:GetService("Players")

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xaliatile/Uniware/refs/heads/main/rolibwaita_edit.lua"))()

if _G.Uniware then _G.Uniware:Remove() end

local version = "v1.12.1"

local keepUniware =true
local teleCheck = false
local DefaultKeybind = "LeftAlt"

local dir = makefolder("Uniware")

local function loadData()
    if isfolder("Uniware") and isfile("Uniware/config.Uni") then
        local config = readfile("Uniware/config.Uni")
        config = game:GetService("HttpService"):JSONDecode(config)

        keepUniware = config.keepUniware
        DefaultKeybind = config.DefaultKeybind
    else
        if isfolder("Uniware") == false then
            dir = makefolder("Uniware")
        end

        local config = writefile("Uniware/config.Uni", game:GetService("HttpService"):JSONEncode({
            ["keepUniware"] = tostring(keepUniware),
            ["DefaultKeybind"] = DefaultKeybind
        }))

        config = game:GetService("HttpService"):JSONDecode(readfile("Uniware/config.Uni"))

        keepUniware = config.keepUniware
        DefaultKeybind = config.DefaultKeybind
    end
end

local function saveData()
    local config = writefile("Uniware/config.Uni", game:GetService("HttpService"):JSONEncode({
        ["keepUniware"] = tostring(keepUniware),
        ["DefaultKeybind"] = DefaultKeybind
    }))
end

loadData()

Players.LocalPlayer.OnTeleport:Connect(function(State)
    saveData()

	if keepUniware and (not teleCheck) and queue_on_teleport then
		teleCheck = true
		queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/xaliatile/Uniware/refs/heads/main/Uniware.lua"))()')
    elseif keepUniware and (not teleCheck) and queueteleport then
        teleCheck = true
        queueteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/xaliatile/Uniware/refs/heads/main/Uniware.lua"))()')
	end
end)

Players.PlayerRemoving:Connect(function(Player)
    if Player == Players.LocalPlayer then
        saveData()

        return nil
    end
end)

local Window = lib:NewWindow({
    Name = "Uniware",
    Keybind = DefaultKeybind,
    UseCoreGui = true,
    PrintCredits = true
})

_G.Uniware = Window

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

local MiscellaneousTab = Window:NewTab({
    Name = "Miscellaneous",
    Icon = "rbxassetid://11419704343"
})

local MiscellaneousSection = MiscellaneousTab:NewSection({
    Name = "Miscellaneous",
    Description = "self explanatory.",
})

local UnD = MiscellaneousSection:NewToggle({
    Name = "Undetectable", 
    Description = "Makes it very difficult for anti-cheats to detect you.",
    CurrentState = true,
    Callback = function(value)

    end,
})

local SettingsTab = Window:NewTab({
    Name = "Settings",
    Icon = "rbxassetid://11293977610"
})

local SettingsSection = SettingsTab:NewSection({
    Name = "Settings",
    Description = "UI settings.",
})

local KeepUni = SettingsSection:NewToggle({
    Name = "Keep Uniware", 
    Description = "every time you serverhop or rejoin it will automatically reload for you.",
    CurrentState = keepUniware,
    Callback = function(value)
        if queueteleport or queue_on_teleport then
            keepUniware = value
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Notice",
				Text = "Your executor does not support: queue_on_teleport() cannot execute.",
                Duration = 3
			})
        end
    end,
})


local Keybinds = SettingsSection:NewDropdown({
    Name = "UI Keybinds",
    Description = "the keybinds to toggle the ui for.", 
    Choices = {"LeftControl", "LeftAlt", "LeftShift", "RightControl", "RightAlt", "RightShift"},
    CurrentState = "LeftAlt",
    Callback = function(value) 
        DefaultKeybind = value

        Window:Edit({
            Keybind = DefaultKeybind,
            Name = "Uniware"
        })
    end,
})
