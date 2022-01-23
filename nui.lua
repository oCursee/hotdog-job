Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
local menuShown = false













RegisterNUICallback("exit", function(data, cb)
    showHotdogMenu(false) 
end)


RegisterNUICallback("main", function(data, cb)
    showHotdogMenu(false)
    cb()
end)


function showHotdogMenu(bool)
    menuShown = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "hotdogMenu",
        status = bool,
    })
end
Citizen.CreateThread(function()
    while menuShown do
        Citizen.Wait(0)      
        DisableControlAction(0, 1, menuShown)
        DisableControlAction(0, 2, menuShown) 
        DisableControlAction(0, 142, menuShown) 
        DisableControlAction(0, 18, menuShown) 
        DisableControlAction(0, 322, menuShown) 
        DisableControlAction(0, 106, menuShown) 
    end
end)


