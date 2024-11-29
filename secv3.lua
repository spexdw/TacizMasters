local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local WhitelistLib = {}

function WhitelistLib:Start()
    local userId = Players.LocalPlayer.UserId
    local authorized = false
    local timer = 30
    
    local progressBar = MainRight:AddSlider('AuthTimer', {
        Text = 'Authorization Check',
        Default = 30,
        Min = 30,
        Max = 30,
        Rounding = 0,
        Compact = false
    })
    
    local statusLabel = MainRight:AddLabel('Status: Checking...')

    local function checkWhitelist()
        local success, result = pcall(function()
            return HttpService:GetAsync("https://raw.githubusercontent.com/spexdw/TacizMasters/refs/heads/main/whitelist.json")
        end)
        
        if success then
            local data = HttpService:JSONDecode(result)
            authorized = table.find(data.whitelistedUsers, userId) ~= nil
            
            if not authorized then
                Players.LocalPlayer:Kick("Authorization Required | discord.gg/veba | SpeXD")
            end
            
            statusLabel:SetText("Status: " .. (authorized and "Authorized" or "Unauthorized"))
            if authorized then
                progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            else
                progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
    end
    
    spawn(function()
        while wait(1) do
            timer = timer - 1
            if timer <= 0 then
                timer = 30
                checkWhitelist()
            end
            progressBar:SetValue(timer)
        end
    end)
    
    checkWhitelist()
end

return WhitelistLib
