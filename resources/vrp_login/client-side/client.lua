local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "garagem01" then
		vRP.teleport(56.75,-879.64,30.36)
	elseif data == "garagem02" then
		vRP.teleport(318.82,2622.06,44.47)
	elseif data == "garagem03" then
		vRP.teleport(-772.81,5596.25,33.48)
	elseif data == "aeroporto" then
		vRP.teleport(-1027.65,-2493.39,13.85)
	elseif data == "metro" then
		vRP.teleport(-206.11,-1013.50,30.13)
	elseif data == "praca" then
		vRP.teleport(209.57,-929.45,30.7)
	end
	ToggleActionMenu()
	TriggerEvent("ToogleBackCharacter")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOOGLE LOGIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('vrp:ToogleLoginMenu')
AddEventHandler('vrp:ToogleLoginMenu',function()
	if GetEntityHealth(PlayerPedId()) <= 101 then
		TriggerEvent("ToogleBackCharacter")
	else
		ToggleActionMenu()
	end
end)