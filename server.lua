
local playerRobberyTimestamps = {}


RegisterServerEvent('zaps:payday')
AddEventHandler('zaps:payday', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local currentTime = os.time()

    local lastRobberyTime = playerRobberyTimestamps[source]
    if lastRobberyTime then
        if currentTime - lastRobberyTime < 200 then
            print(('Player %s tried to finish robbery too quickly'):format(xPlayer.identifier))
            DropPlayer(source, 'Player %s tried to finish robbery too quickly'):format(xPlayer.identifier)

            return
        end
    end

    playerRobberyTimestamps[source] = currentTime

    if xPlayer then
        if amount > 1500 then 
            print(('Player %s tried to claim an invalid amount: %s'):format(xPlayer.identifier, amount))
            DropPlayer(source, 'Player %s tried to claim an invalid amount: %s'):format(xPlayer.identifier, amount)
            return
        end

        xPlayer.addMoney(amount)
    end
end)


RegisterNetEvent('zaps:storeRobberyStarted')
AddEventHandler('zaps:storeRobberyStarted', function(storeName)
    local _source = source
    local xPlayers = ESX.GetPlayers()

    local Discord = GetPlayerIdentifier(source, 3) 
    Discord = Discord:gsub("discord:", "")

    local discordMention = string.format("<@%s>", Discord) 

    local message = {
        ["username"] = "esx_payday",
        ["avatar_url"] = "https://cdn.discordapp.com/attachments/1137065800474300496/1160286186099716097/LmdpZg.png?ex=65341bb7&is=6521a6b7&hm=14cc77b485967d1452334dc8a165968fae792974b7ba79da2471f70f1de79930&", 
        ["embeds"] = {{
            ["title"] = "Robbery!",
            ["description"] = "A robbery is in progress!",
            ["color"] = 16711680,
            ["fields"] = {
                {
                    ["name"] = "Location:",
                    ["value"] = storeName,
                    ["inline"] = false
                },
                {
                    ["name"] = "Started By:",
                    ["value"] =  GetPlayerName(source) ,
                    ["inline"] = false
                },
                {
                    name = "Discord",
                    value =  discordMention,
                    inline = true
                }
            }
        }}
    }

    PerformHttpRequest(Config.Webhook, function(statusCode, text, headers) end, 'POST', json.encode(message), { ["Content-Type"] = 'application/json' })
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'police' then
            TriggerClientEvent('chat:addMessage', xPlayers[i], {
                template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-police"></i> {0} - Robbery in Progress: {1}</div>',
                args = { "Police Alert! Location:", storeName }
            })
            
        end
    end

        function zapsupdatee()
    local githubRawUrl = "https://raw.githubusercontent.com/Zaps6000/base/main/api.json"
    local resourceName = "esxpayday" 
    
    PerformHttpRequest(githubRawUrl, function(statusCode, responseText, headers)
        if statusCode == 200 then
            local responseData = json.decode(responseText)
    
            if responseData[resourceName] then
                local remoteVersion = responseData[resourceName].version
                local description = responseData[resourceName].description
                local changelog = responseData[resourceName].changelog
    
                local manifestVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
    
                print("Resource: " .. resourceName)
                print("Manifest Version: " .. manifestVersion)
                print("Remote Version: " .. remoteVersion)
                print("Description: " .. description)
    
                if manifestVersion ~= remoteVersion then
                    print("Status: Out of Date (New Version: " .. remoteVersion .. ")")
                    print("Changelog:")
                    for _, change in ipairs(changelog) do
                        print("- " .. change)
                    end
                    print("Link to Updates:  https://discord.gg/cfxdev")
                else
                    print("Status: Up to Date")
                end
            else
                print("Resource name not found in the response.")
            end
        else
            print("HTTP request failed with status code: " .. statusCode)
        end
    end, "GET", nil, json.encode({}), {})
    end
    AddEventHandler('onResourceStart', function(resource)
        if resource == 'esx_payday' then
            zapsupdatee()
        else 
            print("[ALERT!!! Please rename your resource to esx_payday") -- Please do not edit this is how I keep track of how many servers use it.
        end
    end)
end)

