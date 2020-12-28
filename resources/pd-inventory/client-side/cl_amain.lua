Proxy = module("vrp","lib/Proxy")
Tunnel = module("vrp","lib/Tunnel")
vRP = Proxy.getInterface("vRP")
vrpServer = Tunnel.getInterface("pd-inventory")

vrpClient = {}
Tunnel.bindInterface("pd-inventory",vrpClient)
------------------------------------------------------------------------------------------------------------------------------------------------------
-- Variáveis ( NÃO ALTERAR )
------------------------------------------------------------------------------------------------------------------------------------------------------

isInInventory = false
gridZone      = 0
canOpen       = true

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Threads
------------------------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function() -- Open Inventory (K)
    while true do
        Citizen.Wait(0)
        
        if IsControlJustPressed(1,243) and GetEntityHealth(PlayerPedId()) > 101 and canOpen then
            openInventory()
        end

        if IsControlJustPressed(0, 10) and GetEntityHealth(PlayerPedId()) > 101 and canOpen then
            local vehicle = vRP.getNearestVehicle(5)
			if vehicle then
                local coordPed = GetEntityCoords(PlayerPedId())
                local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(vehicle,0.0,3.0,0.5))
                local x2,y2,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(vehicle,0.0,-3.0,0.5))
				if not vRP.isHandcuffed() and not vRP.isInVehicle() then
					if GetDistanceBetweenCoords(coordPed.x,coordPed.y,coordPed.z,x,y,z) < 2.0 or GetDistanceBetweenCoords(coordPed.x,coordPed.y,coordPed.z,x2,y2,z2) < 2.0 then
						openTrunk()
					end
				end
			end
        end

    end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Funções
------------------------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler("onResourceStop",function()
	if GetCurrentResourceName() then
        closeInventory()
	end
end)

RegisterNetEvent('debug:nui')
AddEventHandler('debug:nui', function()
    SetNuiFocus(false, false)
end)

-- Functions
function openIdentity()
    local name,firstname,id,age,reg,phone,cash,bank,paypal,tax,job,vipName,vipTime,coins = vrpServer.getIdentity()

    local bjob = "Nenhum"
    local bvipName = "Nenhum"

    if job ~= "" then
        bjob = job
    end

    if vipName ~= "" then
        bvipName = vipName
    end
                
    SendNUIMessage({ action = "setIdentity", name = name, firstname = firstname, id = id, age = age, reg = reg, phone = phone, cash = cash, bank = bank, paypal = paypal, tax = tax, job = bjob, vipName = bvipName, vipTime = vipTime, coins = coins })
end

function openInventory()
    local weight,data,drop,max = vrpServer.getInv(gridZone)
    TriggerEvent("vrp_sound:source","zipperopen",0.1)
    
    openIdentity()
    SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
    SendNUIMessage({ action = "setItems", itemList = data })
    
    SendNUIMessage({ action = "setSecondText", text = 'drop-' .. gridZone })
    SendNUIMessage({ action = "setSecondItems", itemSList = drop })
    
    isInInventory = true
    SendNUIMessage({ action = "display", type = "drop" })
    SetNuiFocus(true, true)
    
    vRP._playAnim(true, {"pickup_object","putdown_low"}, false)
    Citizen.Wait(1000)
    vRP.stopAnim("one")
end


function updateDrop()
    local _,_,drop = vrpServer.getInv(gridZone)

    SendNUIMessage({ action = "setSecondText", text = 'drop-' .. gridZone })
    SendNUIMessage({ action = "setSecondItems", itemSList = drop })
end

function closeInventory()
    isInInventory = false

    SendNUIMessage({ action = "hide" })
    SetNuiFocus(false, false)
    vrpServer.closeTrunkChests()
    vrpServer.closeVaults()
    vrpServer.closeStaticChests()
end

function updateInventory()
    local weight,data,_,max = vrpServer.getInv(gridZone)
    
    openIdentity()
    SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
    SendNUIMessage({ action = "setItems", itemList = data })
end

RegisterNetEvent("b03461cc:pd-inventory:equipAmmo")
AddEventHandler("b03461cc:pd-inventory:equipAmmo", function(ammo)
    if lastWeapon then
        AddAmmoToPed(PlayerPedId(), lastWeapon, ammo)
    end
end)

RegisterNetEvent('b03461cc:pd-inventory:equipWeapon')
AddEventHandler('b03461cc:pd-inventory:equipWeapon', function(weapon)
    local weapon = GetHashKey(string.upper(weapon))
    
    if not HasPedGotWeapon(PlayerPedId(), weapon) then
        GiveWeaponToPed(PlayerPedId(), weapon, 0, false, false)
        -- TriggerEvent('Notify', 'aviso', '<b>Unequipped</b>')
    end
end)

RegisterNetEvent('b03461cc:pd-inventory:unequipWeapon')
AddEventHandler('b03461cc:pd-inventory:unequipWeapon', function()
    RemoveAllPedWeapons(PlayerPedId(), true)
    TriggerServerEvent("b03461cc:pd-inventory:saveAmmo", GetAmmoInPedWeapon(PlayerPedId(), lastWeapon))
    TriggerEvent('Notify', 'aviso', '<b>Unequipped</b>')
    gotWeapon = false
    lastWeapon = nil
end)

RegisterNetEvent("b03461cc:pd-inventory:updateInventory")
AddEventHandler("b03461cc:pd-inventory:updateInventory",function()
    if isInInventory then
        updateInventory()
    end
end)

--AddEventHandler("cancelando",function(status)
  --  canOpen = not status
--end)

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Callbacks
------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("NUIFocusOff", function()
    closeInventory()
end)

RegisterNUICallback("UseItem", function(data, cb)

    if type(data.number) == "number" and math.floor(data.number) == data.number then      
        TriggerServerEvent("b03461cc:pd-inventory:useItem", data.data.item, data.number)
    end
    
    closeInventory()
end)

function table_to_string(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..table_to_string(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the result
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return "{"..result.."}"
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Zonas
------------------------------------------------------------------------------------------------------------------------------------------------------

local deltas = {
    vector2(-1, -1),
    vector2(-1, 0),
    vector2(-1, 1),
    vector2(0, -1),
    vector2(1, -1),
    vector2(1, 0),
    vector2(1, 1),
    vector2(0, 1),
}

local function getGridChunk(x)
    return math.floor((x + 8192) / 128)
end

local function toChannel(v)
    return (v.x << 8) | v.y
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local coords = GetEntityCoords(PlayerPedId())
        local gz = vector2(getGridChunk(coords.x), getGridChunk(coords.y))
        gridZone = toChannel(gz)
        
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLONEPLATES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('cloneplates')
AddEventHandler('cloneplates',function(index)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(vehicle) then
		SetVehicleNumberPlateText(vehicle,index)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEANCHOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('vehicleanchor')
AddEventHandler('vehicleanchor',function(index)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	FreezeEntityPosition(vehicle,index)
end)