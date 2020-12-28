-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getHealth()
	return GetEntityHealth(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.setHealth(health)
	SetEntityHealth(PlayerPedId(),parseInt(health))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETFRIENDLYFIRE
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.setFriendlyFire(flag)
	NetworkSetFriendlyFireOption(flag)
	SetCanAttackFriendly(PlayerPedId(),flag,flag)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOCAUTEVAR
-----------------------------------------------------------------------------------------------------------------------------------------
local nocauteado = false
local deathtimer = 600
local deathextratimer = 1800
local bodybag = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOCAUTEADO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local ped = PlayerPedId()
		if GetEntityHealth(ped) <= 101 and deathtimer >= 0 then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			if not nocauteado then	
				NetworkResurrectLocalPlayer(x,y,z,GetEntityHeading(ped),true,false)
				deathtimer = 600
				deathextratimer = deathtimer + 1800
				nocauteado = true
				vRPserver._updateHealth(101)
				SetEntityHealth(ped,101)
				SetEntityInvincible(ped,true)
				if IsPedInAnyVehicle(ped) then
					TaskLeaveVehicle(ped,GetVehiclePedIsIn(ped),4160)
				end
				TriggerEvent("DLGames:tuneOff",true)
				TriggerServerEvent("vrp_inventory:Cancel")
			else
				if deathtimer > 0 then
					DrawText3Ds(x,y,z-0.5,"~r~"..deathtimer.."  ~w~ML DE SANGUE, AGUARDE POR ATENDIMENTO MEDICO",340)
				else
					if deathextratimer > 0 then
						DrawText3Ds(x,y,z-0.5,"PRESSIONE  ~g~E  ~w~PARA ACEITAR SUA MORTE, VOCE TEM  ~r~"..deathextratimer.."  ~w~ML DE SANGUE",340)
					end
				end
				SetPedToRagdoll(ped,1000,1000,0,0,0,0)
				SetEntityHealth(ped,101)
				BlockWeaponWheelThisFrame()
				DisableControlAction(0,21,true)
				DisableControlAction(0,22,true)
				DisableControlAction(0,23,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,29,true)
				DisableControlAction(0,32,true)
				DisableControlAction(0,33,true)
				DisableControlAction(0,34,true)
				DisableControlAction(0,35,true)
				DisableControlAction(0,47,true)
				DisableControlAction(0,56,true)
				DisableControlAction(0,58,true)
				DisableControlAction(0,73,true)
				DisableControlAction(0,75,true)
				DisableControlAction(0,137,true)
				DisableControlAction(0,140,true)
				DisableControlAction(0,141,true)
				DisableControlAction(0,142,true)
				DisableControlAction(0,143,true)
				DisableControlAction(0,166,true)
				DisableControlAction(0,167,true)
				DisableControlAction(0,168,true)
				DisableControlAction(0,169,true)
				DisableControlAction(0,170,true)
				DisableControlAction(0,177,true)
				DisableControlAction(0,182,true)
				DisableControlAction(0,187,true)
				DisableControlAction(0,188,true)
				DisableControlAction(0,189,true)
				DisableControlAction(0,190,true)
				DisableControlAction(0,243,true)
				--DisableControlAction(0,245,true)
				DisableControlAction(0,257,true)
				DisableControlAction(0,263,true)
				DisableControlAction(0,264,true)
				DisableControlAction(0,268,true)
				DisableControlAction(0,269,true)
				DisableControlAction(0,270,true)
				DisableControlAction(0,271,true)
				DisableControlAction(0,288,true)
				DisableControlAction(0,289,true)
				DisableControlAction(0,311,true)
				DisableControlAction(0,344,true)
				--[[if not IsEntityPlayingAnim(ped,"missarmenian2","corpse_search_exit_ped",3) then
					tvRP.playAnim(false,{"missarmenian2","corpse_search_exit_ped"},true)
				end]]
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PED ARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		local ped = PlayerPedId()
		if GetPedArmour(ped) < 1 then
			SetPedComponentVariation(ped,9,0,0,2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local ped = PlayerPedId()
		if GetEntityHealth(ped) <= 101 and deathtimer <= 0 then
			if deathextratimer <= 0 then
				tvRP.personDeath()
				TriggerEvent("resetBleeding")
				TriggerEvent("resetDiagnostic")
				TriggerServerEvent("clearInventory")
				deathtimer = 600
				deathextratimer = 1800
				nocauteado = false
				ClearPedBloodDamage(ped)
				SetEntityInvincible(ped,false)
				DoScreenFadeOut(1000)
				SetEntityHealth(ped,150)
				SetPedArmour(ped,0)
				Citizen.Wait(1000)
				SetEntityCoords(ped,-1038.68+0.0001,-2738.62+0.0001,13.82+0.0001,1,0,0,1)
				FreezeEntityPosition(ped,true)
				SetTimeout(5000,function()
					FreezeEntityPosition(ped,false)
					Citizen.Wait(1000)
					SetEntityVisible(ped,true,true)
					DoScreenFadeIn(1000)	
				end)
			else
				if IsControlJustPressed(0,38) and IsInputDisabled(0) then
					tvRP.personDeath()
					TriggerEvent("resetBleeding")
					TriggerEvent("resetDiagnostic")
					TriggerServerEvent("clearInventory")
					deathtimer = 600
					deathextratimer = 1800
					nocauteado = false
					ClearPedBloodDamage(ped)
					SetEntityInvincible(ped,false)
					DoScreenFadeOut(1000)
					SetEntityHealth(ped,150)
					SetPedArmour(ped,0)
					Citizen.Wait(1000)
					SetEntityCoords(ped,-1038.68+0.0001,-2738.62+0.0001,13.82+0.0001,1,0,0,1)
					FreezeEntityPosition(ped,true)
					SetTimeout(5000,function()
						FreezeEntityPosition(ped,false)
						Citizen.Wait(1000)
						SetEntityVisible(ped,true,true)
						DoScreenFadeIn(1000)
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTHRECHARGE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		SetPlayerHealthRechargeMultiplier(PlayerId(),0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEATHTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if nocauteado and deathtimer > 0 then
			deathtimer = deathtimer - 1
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEATHEXTRATIMER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if nocauteado and deathextratimer > 0 then
			deathextratimer = deathextratimer - 1
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERSON DEATH EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("personDeath")
AddEventHandler("personDeath",function()
	if deathtimer > 0 or deathextratimer > 0 then
		deathtimer = 0
		deathextratimer = 0
	end      
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESET TIMER EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetTimer")
AddEventHandler("resetTimer",function()
	if deathtimer > 0 then
		deathtimer = 600
	else
		if deathextratimer > 0 then
			deathtimer = 600
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISINCOMA
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.isInComa()
	return nocauteado
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NETWORKRESSURECTION
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.killGod()
	nocauteado = false
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	NetworkResurrectLocalPlayer(x,y,z,GetEntityHeading(ped),true,false)
	ClearPedBloodDamage(ped)
	SetEntityInvincible(ped,false)
	SetEntityHealth(ped,110)
	ClearPedTasks(ped)
	ClearPedSecondaryTask(ped)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NETWORKPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.PrisionGod()
	local ped = PlayerPedId()
	if GetEntityHealth(ped) <= 101 then
		nocauteado = false
		TriggerEvent("resetBleeding")
        TriggerEvent("resetDiagnostic")
		ClearPedBloodDamage(ped)
		SetEntityInvincible(ped,false)
		SetEntityHealth(ped,150)
		ClearPedTasks(ped)
		ClearPedSecondaryTask(ped)	
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERSON DEATH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.personDeath()
	RequestModel("xm_prop_body_bag")
	while not HasModelLoaded("xm_prop_body_bag") do
		Citizen.Wait(10)
	end
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	bodybag = CreateObject(GetHashKey("xm_prop_body_bag"),x,y,z,true,true,true)
	PlaceObjectOnGroundProperly(bodybag)
	SetModelAsNoLongerNeeded(bodybag)
	Citizen.InvokeNative(0xAD738C3085FE7E11,bodybag,true,true)
	SetEntityAsNoLongerNeeded(bodybag)
	SetEntityVisible(ped,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text,size)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/size
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end