-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local lastTackleTime = 0
local isTackling = false
local isGettingTackled = false
local isRagdoll = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD TACKLE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		if IsPedJumping(ped) and IsControlJustReleased(0,51) and IsInputDisabled(0) and not isTackling and GetGameTimer() - lastTackleTime > 10 * 2000 then
			Citizen.Wait(10)
			
			local closestPlayer = GetClosestPlayer()
			if closestPlayer.distance ~= -1 and closestPlayer.distance <= 2.0 and not isTackling and not isGettingTackled and not IsPedInAnyVehicle(ped) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer.playerid)) then
				isTackling = true
				lastTackleTime = GetGameTimer()

				TriggerServerEvent("vrp_tackle:tryTackle",closestPlayer.playerid)
			end
		end

		if isRagdoll then
			SetPedToRagdoll(ped,1000,1000,0,0,0,0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER TACKLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_tackle:playTackle")
AddEventHandler("vrp_tackle:playTackle", function()
	TriggerEvent("cancelando",true,true)
	vRP._playAnim(false,{"missmic2ig_11","mic_2_ig_11_intro_goon"},false)
	
	Citizen.Wait(3000)
	TriggerEvent("cancelando",false,false)
	vRP.stopAnim(false)
	isTackling = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET PLAYER TACKLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_tackle:getTackled")
AddEventHandler("vrp_tackle:getTackled",function(target)
	isGettingTackled = true

	local ped = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	TriggerEvent("cancelando",true,true)
	vRP._playAnim(false,{"missmic2ig_11","mic_2_ig_11_intro_p_one"},false)
	AttachEntityToEntity(ped,targetPed,11816,0.25,0.5,0.0,0.5,0.5,180.0,false,false,false,false,2,false)

	Citizen.Wait(3000)
	DetachEntity(ped,true,false)

	isRagdoll = true
	Citizen.Wait(4000)
	TriggerEvent("cancelando",false,false)
	isRagdoll = false
	isGettingTackled = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET CLOSEST PLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function GetClosestPlayer()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped,0)
    local closestDistance = -1
    local closestPlayer = -1

    for _,v in pairs(GetActivePlayers()) do
        if GetPlayerPed(v) ~= ped then
            local targetCoords = GetEntityCoords(GetPlayerPed(v),0)
            local distance = GetDistanceBetweenCoords(targetCoords["x"],targetCoords["y"],targetCoords["z"],pedCoords["x"],pedCoords["y"],pedCoords["z"],true)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = GetPlayerServerId(v)
                closestDistance = distance
            end
        end
    end

    return { playerid = closestPlayer, distance = closestDistance }
end