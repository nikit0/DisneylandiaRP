-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local sysColor = 1
local sysBlips = {}
local sysSystem = {}
local sysService = ""
local sysActived = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_sysblips:ToggleService")
AddEventHandler("vrp_sysblips:ToggleService",function(service,color)
	sysActived = not sysActived
	sysService = tostring(service)
	sysColor = parseInt(color)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_sysblips:ClearBlips")
AddEventHandler("vrp_sysblips:ClearBlips",function()
	sysActived = false
	for k,v in pairs(sysSystem) do
		RemoveBlip(sysBlips[k])
		sysBlips[k] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_sysblips:RemoveBlips")
AddEventHandler("vrp_sysblips:RemoveBlips",function(status)
	if DoesBlipExist(sysBlips[status]) then
		RemoveBlip(sysBlips[status])
		sysBlips[status] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_sysblips:UpdateBlips")
AddEventHandler("vrp_sysblips:UpdateBlips",function(status)
	sysSystem = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADUPDATEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if sysActived and sysService ~= "Corredor" then
			for k,v in pairs(sysSystem) do
				if DoesBlipExist(sysBlips[k]) then
					RemoveBlip(sysBlips[k])
					sysBlips[k] = nil
				end

				sysBlips[k] = AddBlipForCoord(v[3],v[4],v[5])
				SetBlipSprite(sysBlips[k],1)
				SetBlipScale(sysBlips[k],0.6)
				SetBlipColour(sysBlips[k],v[2])
				SetBlipAsShortRange(sysBlips[k],false)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v[1])
				EndTextCommandSetBlipName(sysBlips[k])
			end
		end
		Citizen.Wait(200)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADUPDATEPOS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if sysActived then
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),false))
			TriggerServerEvent("vrp_sysblips:UpdateCoords",x,y,z,sysService,sysColor)
		end
		Citizen.Wait(500)
	end
end)