-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local hora = 09
local minuto = 00
local currentweather = "EXTRASUNNY"
local lastWeather = currentweather
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEWEATHER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_vsync:updateWeather")
AddEventHandler("vrp_vsync:updateWeather",function(NewWeather)
	currentweather = NewWeather
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONWEATHER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if lastWeather ~= currentweather then
			lastWeather = currentweather
			SetWeatherTypeOverTime(currentweather,45.0)
			Citizen.Wait(15000)
		end
		ClearOverrideWeather()
		ClearWeatherTypePersist()
		SetWeatherTypePersist(lastWeather)
		SetWeatherTypeNow(lastWeather)
		SetWeatherTypeNowPersist(lastWeather)
		Citizen.Wait(100)
		if lastWeather == "XMAS" then
			SetForceVehicleTrails(true)
			SetForcePedFootstepsTracks(true)
		else
			SetForceVehicleTrails(false)
			SetForcePedFootstepsTracks(false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWNED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerSpawned",function()
	TriggerServerEvent("vrp_vsync:requestSync")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_vsync:syncTimers")
AddEventHandler("vrp_vsync:syncTimers",function(timer)
	hora = timer[2]
	minuto = timer[1]
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NETWORKCLOCK
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		NetworkOverrideClockTime(hora,minuto,00)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGAR BOLA DE NEVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("snowball")
AddEventHandler("snowball",function()
	local ped = PlayerPedId()
	if IsNextWeatherType("XMAS") then
		if not IsPlayerFreeAiming(ped) and not IsPedSwimming(ped) and not IsPedSwimmingUnderWater(ped) and not IsPedRagdoll(ped) and not IsPedFalling(ped) and not IsPedRunning(ped) and not IsPedSprinting(ped) and GetInteriorFromEntity(ped) == 0 and not IsPedShooting(ped) and not IsPedUsingAnyScenario(ped) and not IsPedInCover(ped,0) then
			vRP._playAnim(false,{"anim@mp_snowball","pickup_snowball"},false)
			Citizen.Wait(1950)
			GiveWeaponToPed(ped,GetHashKey("WEAPON_SNOWBALL"),2,false,true)
		end
	end
end)