ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local ox_inventory = exports.ox_inventory
  
  

local Hdstash = {
    id = 'employeeHdStash',
    label = 'Hotdog Stash',
    slots = 2,
    weight = 100000,
    owner = 'char1:license'
}

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        Wait(0)
        exports.ox_inventory:RegisterStash(Hdstash.id, Hdstash.label, Hdstash.slots, Hdstash.weight, Hdstash.owner)
    end
end)


RegisterServerEvent('restock')
AddEventHandler('restock', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local moneyHd = ox_inventory:GetItem(source, 'money')
    print(xPlayer)
    if moneyHd.count >= 1500 then
        ox_inventory:RemoveItem(source, 'money', 1500)
        ox_inventory:AddItem(source, 'hotdog', 50)
        ox_inventory:AddItem(source, 'sprite', 50)
    end
end)


ESX.RegisterServerCallback('checkMo', function(source, cb)
    local moneyHd = ox_inventory:GetItem(source, 'money')
    if moneyHd.count >= 1500 then
        cb(true)
    else
        TriggerClientEvent('notification', source, 'You do not have enough money.', 2)
        cb(false)
    end
 end)