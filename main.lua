local isRobbing = false


local isRobbing = false
local countdown = 0
local cooldownTimer = 0
local nearestStoreLocation = nil

function GetDistanceToCoords(x, y, z)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, x, y, z)
    return distance
end

Citizen.CreateThread(function()
    while true do
        if cooldownTimer > 0 then
            cooldownTimer = cooldownTimer - 1
            Citizen.Wait(1000)
        else
            local nearestStoreDistance = math.huge
            local nearestStoreLocation = nil

            for _, location in ipairs(Config.stores) do
                local distance = GetDistanceToCoords(location.x, location.y, location.z)
                if distance < nearestStoreDistance then
                    nearestStoreDistance = distance
                    nearestStoreLocation = location
                end
            end

            if nearestStoreDistance < 5.0 and not isRobbing then
                DisplayHelpText("Press ~INPUT_CONTEXT~ to start the robbery.")
                
                if IsControlJustReleased(0, 38) then
                    StartRobbery(nearestStoreLocation)
                end
                Citizen.Wait(0)
            elseif isRobbing then
                DisplayHelpText("Time remaining: " .. countdown .. " seconds")

                local distanceToCurrentRobberyLocation = GetDistanceToCoords(nearestStoreLocation.x, nearestStoreLocation.y, nearestStoreLocation.z)
                if IsPlayerDead(PlayerId()) or distanceToCurrentRobberyLocation > Config.maxDistance then
                    FailRobbery()
                end
                Citizen.Wait(0)
            else
                Citizen.Wait(1000) 
            end
        end
    end
end)


function StartRobbery()
    isRobbing = true
    countdown = Config.robberyTime
    TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-exclamation-circle"></i> {0} {1}</div>',
        args = { "Alert! ", "Robbery has started!" }
    })
    local nearestStoreDistance = math.huge
    local nearestStoreLocation = nil

    for _, location in ipairs(Config.stores) do
        local distance = GetDistanceToCoords(location.x, location.y, location.z)
        if distance < nearestStoreDistance then
            nearestStoreDistance = distance
            nearestStoreLocation = location
        end
    end
    local streetName, crossing = GetStreetNameAtCoord(nearestStoreLocation.x, nearestStoreLocation.y, nearestStoreLocation.z)
    local robberyLocationName = GetStreetNameFromHashKey(streetName)

local skillSets = {
    {'easy', 'easy', {areaSize = 900}},
    {'medium', 'medium', {areaSize = 1200}},
    {'hard', 'hard', {areaSize = 150}}
}

local randomIndex = math.random(1, #skillSets)

local randomSkillSet = skillSets[randomIndex]

local keys = {'w', 'a', 's', 'd', 'e', 'z', 'g'}

local randomKeyIndex = math.random(1, #keys)

local randomKey = keys[randomKeyIndex]

local success = lib.skillCheck(randomSkillSet, {randomKey})
            if not success then
        failminigame()
        return
    end



    TriggerServerEvent('zaps:storeRobberyStarted', robberyLocationName)

    
    Citizen.CreateThread(function()
        while countdown > 0 and isRobbing do
            Citizen.Wait(1000)
            countdown = countdown - 1
        end

        if countdown == 0 then
            EndRobbery()
        end
    end)
end

function EndRobbery()
    isRobbing = false
    cooldownTimer = Config.robberyCooldown

    TriggerServerEvent('zaps:payday', Config.rewardAmount)
    TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 255, 0, 0.6); border-radius: 3px;"><i class="fas fa-check-circle"></i> {0} {1}</div>',
        args = { "Success!", "Robbery complete! You've received $"..Config.rewardAmount }
    })
    
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function FailRobbery()
    isRobbing = false
    cooldownTimer = Config.robberyCooldown

    TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-exclamation-circle"></i> {0} {1}</div>',
        args = { "Alert!", "Robbery failed! You either died or moved too far from the location." }
    })
    end

function failminigame( )
    isRobbing = false

end
