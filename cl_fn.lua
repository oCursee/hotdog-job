local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX              = nil
local PlayerData = {}




Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)
Citizen.CreateThread(function()
  while true do
     -- Citizen.Wait(1800)
      Citizen.Wait(0)
      if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
          isHot = true
      else
        isHot = false
      end
      
  end
end)


local propStand = {
GetHashKey('prop_hotdogstand_01')
}

exports.qtarget:AddTargetModel(propStand, {
	options = {
		{
			event = "BeginMaking_Hotdogs",
			icon = "fas fa-hotdog",
			label = "Open Worker Stash",    
		},
    {
			event = "attachCart",
			icon = "fas fa-hands",
			label = "Grab the cart",    
		},
	},
	distance = 2,
  job = "hotdeal",
 
})
exports.qtarget:AddTargetModel(propStand, {
	options = {
		{
			event = "ViewMenu",
			icon = "fab fa-elementor",
			label = "View Menu",    
		},
    
	},
	distance = 2,
 
})

exports.qtarget:AddBoxZone("Hotdog", vector3(39.1666, -1005.7460, 29.4810), 1.45, 1.35, {
	name="Hotdog",
	heading=11.0,
	debugPoly=false,
	minZ=27.77834,
	maxZ=32.87834,
	}, {
		options = {
			{
				event = "createThing",
				icon = "fas fa-sign-in-alt",
				label = "Start Working",
				job = 'hotdeal',
			},
      {
				event = "restockCl",
				icon = "fas fa-shopping-basket",
				label = "Restock Your Cart($1500)",
				job = 'hotdeal',
			},
		},
		distance = 2.5
})

AddEventHandler('restockCl', function ()
  ESX.TriggerServerCallback('checkMo', function(cb)
    if cb then
      exports.rprogress:Custom({
        Duration = 30000,
         Label = "Grabbing the stock",
         Animation = {
          scenario = "PROP_HUMAN_BUM_BIN", -- https://pastebin.com/6mrYTdQv
          animationDictionary = "", -- https://alexguirre.github.io/animations-list/
      },
         DisableControls = {Player = true,},
         onComplete = function(cancelled)
          TriggerServerEvent('restock', PlayerPedId())
        end   
    })       
    end   
  end)
end)

AddEventHandler('createThing', function ()
  if isHot then
    if DoesEntityExist(hotDogStand) then
      TriggerEvent('notification', 'You already have a stand out.', 2)
    else
      hotDogStand =  CreateObject('prop_hotdogstand_01', 38.9213, -999.8909, 28.3451, true, true, true)
    end
    
  else
    TriggerEvent('notification', 'You do not have the correct job', 2)
  end
end)
RegisterCommand('detachCart', function()
  DetachEntity(hotDogStand, true, true)
  ClearPedTasks(PlayerPedId())
  end)
  
AddEventHandler('attachCart', function ()
  if isHot then
    playAnim('anim@mp_ferris_wheel', 'idle_a_player_one')
  --hotDogStand =  CreateObject('prop_hotdogstand_01', 38.9213, -999.8909, 28.3451, true, true, true)
  AttachEntityToEntity(hotDogStand, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 11816), 1.029, 1.628, -0.201, 270.0, 190.0, 450.0, false, false, true, false, false, true)
  else
    TriggerEvent('notification', 'You do not have the correct job', 2)
  end
end)
AddEventHandler('ViewMenu', function ()
  showHotdogMenu(not menuShown)
end)

          
AddEventHandler('onResourceStop', function(resourceName)
 DeleteEntity(hotDogStand)
end)

AddEventHandler('BeginMaking_Hotdogs', function ()
  exports.ox_inventory:openInventory('stash', {id='employeeHdStash'})
end)




--[[
AddEventHandler('onResourceStart', function()
  playAnim('anim@mp_ferris_wheel', 'idle_a_player_one')
  hotDogStand =  CreateObject('prop_hotdogstand_01', 38.9213, -999.8909, 28.3451, true, true, true)
  AttachEntityToEntity(hotDogStand, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 11816), 1.029, 1.628, -0.201, 270.0, 190.0, 450.0, false, false, true, false, false, true)     
 end)
--]]



function playAnim(animDict, animName)
  RequestAnimDict(animDict)
  while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
  TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, -1, 49, 1, false, false, false)
  RemoveAnimDict(animDict)
end
