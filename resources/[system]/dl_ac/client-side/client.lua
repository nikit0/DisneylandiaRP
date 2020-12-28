-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("dl_ac")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local CheckCam = false
local AlreadyTriggered = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- AC THREAD ARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
-- 	while true do
--         local armour = GetPedArmour(PlayerPedId())
--         if IsPlayerPlaying(PlayerId()) and armour >= 1 and AlreadyTriggered == false then
--             vSERVER.AntiCheaterMenu("Armour",armour)
--             AlreadyTriggered = true
-- 		end
--         Citizen.Wait(30000)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AC THREAD MENU
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        if IsPlayerPlaying(PlayerId()) and not IsPauseMenuActive() and not IsPedInAnyVehicle(PlayerPedId(),true) and IsMinimapRendering() then
            vSERVER.AntiCheaterMenu("Menu")
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET DAMAGE MODIFIER FROM WEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local damage = GetPlayerWeaponDamageModifier(PlayerId())
        if damage > 1.0 and AlreadyTriggered == false then
            vSERVER.AntiCheater("Modifier",damage)
            AlreadyTriggered = true
        end
        Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FORBIDDEN CLIENT EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
local ForbiddenClientEvents = {
    "ambulancier:selfRespawn",
    "bank:transfer",
    "esx_ambulancejob:revive",
    "esx-qalle-jail:openJailMenu",
    "esx_jailer:wysylandoo",
    "esx_society:openBossMenu",
    "esx:spawnVehicle",
    "esx_status:set",
    "HCheat:TempDisableDetection",
    "esx:getSharedObject"
}

for i,eventName in ipairs(ForbiddenClientEvents) do
    AddEventHandler(eventName,function()
        if AlreadyTriggered == true then
            CancelEvent()
            return
        end
        vSERVER.AntiCheater("ClientEvents",eventName)
        AlreadyTriggered = true
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK CAM (NOT WORKING)
-----------------------------------------------------------------------------------------------------------------------------------------
--[[Citizen.CreateThread(function()
	while true do
        if CheckCam then
            local x,y,z
            local ped = PlayerPedId()
            if IsGameplayCamRendering () then
                x,y,z = table.unpack(GetGameplayCamCoord())
            else
                local cam = GetRenderingCam()
                x,y,z = table.unpack(GetCamCoord(cam))
            end
            local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),x,y,z)
            local CheckFirstPerson = N_0xee778f8c7e1142e2(ped)
            local CheckCinematicCam = IsCinematicCamRendering(ped)
            local vehicle = GetVehiclePedIsUsing(ped)
            if distancia > 20.0 and CheckFirstPerson ~= 4 and not CheckCinematicCam and not IsPedInAnyVehicle(PlayerPedId(),true) then
               --vSERVER.AntiCheater("Cam",distancia)
            end
        end
        Citizen.Wait(1000)
	end
end)

RegisterNetEvent('checkcam')
AddEventHandler('checkcam',function(check)
    CheckCam = check
end)]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLE AIM ASSIST FROM CONTROLLER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local boolean,hash = GetCurrentPedWeapon(PlayerPedId(),1)
        local weapongroup = GetWeapontypeGroup(hash)
        if boolean and weapongroup ~= -728555052 then
            SetPlayerLockon(PlayerId(),false)
        else 
            SetPlayerLockon(PlayerId(),true)
        end
        Citizen.Wait(1)
	end
end)

Citizen.CreateThread(function()
    while true do
        SetPlayerTargetingMode(3)
        Citizen.Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTER NUI CALL BACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("loadNuis",function(data,cb)
	vSERVER.AntiCheaterMenu("AntiCopy")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCREENSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('screenshot:ac')
AddEventHandler('screenshot:ac',function(reason)
    exports['screenshot-basic']:requestScreenshotUpload('http://51.81.48.107:3555/upload','files[]',function(data)
        local resp = json.decode(data)
        vSERVER.Screenshot(resp.files[1].url,reason)
    end)
end)