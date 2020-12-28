-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = Tunnel.getInterface("vrp_coins")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('coins',function(source,args,rawCommand)
    local coins = src.getCoins()
    if coins then
        SetNuiFocus(true,true)
        SendNUIMessage({ openMenu = true, coins = coins })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY VEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("buyVehicle",function(data)
    if data ~= nil then
        local ucoins = src.giveVehicle(data)
        if ucoins then
            SendNUIMessage({ openMenu = true, coins = ucoins })
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--BUY VIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("buyVip",function(data)
    if data then
        local ucoins = src.giveItemVip(data.type,data.time)
        if ucoins then
            SendNUIMessage({ openMenu = true, coins = ucoins })
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--BUY ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("buyItem",function(data)
    if data then
        local ucoins = src.giveItem(data.item)
        if ucoins then
            SendNUIMessage({ openMenu = true, coins = ucoins })
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("shopClose",function(data)
	SetNuiFocus(false,false)
	SendNUIMessage({ openMenu = false })
end)
