local menu_state = {}

function tvRP.openMenuData(menudata)
	SendNUIMessage({ act = "open_menu", menudata = menudata })
end

function tvRP.closeMenu()
	SendNUIMessage({ act = "close_menu" })
end

function tvRP.getMenuState()
	return menu_state
end

local menu_celular = false
RegisterNetEvent("status:celular")
AddEventHandler("status:celular", function(status)
	menu_celular = status
	-- if not IsPedInAnyVehicle(PlayerPedId()) then
	-- 	DisplayRadar(true)
	-- end
end)

local agachar = false
function tvRP.getAgachar()
	return agachar
end

CreateThread(function()
	while true do
		Wait(1)
		if menu_celular then
			BlockWeaponWheelThisFrame()
			DisableControlAction(0, 16, true)
			DisableControlAction(0, 17, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 29, true)
			DisableControlAction(0, 56, true)
			DisableControlAction(0, 57, true)
			DisableControlAction(0, 73, true)
			DisableControlAction(0, 166, true)
			DisableControlAction(0, 167, true)
			DisableControlAction(0, 170, true)
			DisableControlAction(0, 182, true)
			DisableControlAction(0, 187, true)
			DisableControlAction(0, 188, true)
			DisableControlAction(0, 189, true)
			DisableControlAction(0, 190, true)
			DisableControlAction(0, 243, true)
			DisableControlAction(0, 245, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 288, true)
			DisableControlAction(0, 289, true)
			DisableControlAction(0, 344, true)
		end
	end
end)

function tvRP.prompt(title, default_text)
	SendNUIMessage({ act = "prompt", title = title, text = tostring(default_text) })
	SetNuiFocus(true)
end

function tvRP.request(id, text, time)
	SendNUIMessage({ act = "request", id = id, text = tostring(text), time = time })
end

RegisterNUICallback("menu", function(data, cb)
	if data.act == "close" then
		vRPserver._closeMenu(data.id)
	elseif data.act == "valid" then
		vRPserver._validMenuChoice(data.id, data.choice, data.mod)
	end
end)

RegisterNUICallback("menu_state", function(data, cb)
	menu_state = data
end)

RegisterNUICallback("prompt", function(data, cb)
	if data.act == "close" then
		SetNuiFocus(false)
		vRPserver._promptResult(data.result)
	end
end)

RegisterNUICallback("request", function(data, cb)
	if data.act == "response" then
		vRPserver._requestResult(data.id, data.ok)
	end
end)

RegisterNUICallback("init", function(data, cb)
	SendNUIMessage({ act = "cfg", cfg = {} })
	TriggerEvent("vRP:NUIready")
end)

function tvRP.setDiv(name, css, content)
	SendNUIMessage({ act = "set_div", name = name, css = css, content = content })
end

function tvRP.setDivContent(name, content)
	SendNUIMessage({ act = "set_div_content", name = name, content = content })
end

function tvRP.removeDiv(name)
	SendNUIMessage({ act = "remove_div", name = name })
end

function tvRP.loadAnimSet(dict)
	RequestAnimSet(dict)
	while not HasAnimSetLoaded(dict) do
		Wait(10)
	end
	SetPedMovementClipset(PlayerPedId(), dict, 0.25)
end

function tvRP.CarregarAnim(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Wait(10)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CARREGAR OBJETO
-----------------------------------------------------------------------------------------------------------------------------------------
local apontar = false
local animActived = false
local animDict = nil
local animName = nil
local animFlags = 0

local object = nil
local object2 = nil
function tvRP.CarregarObjeto(dict, anim, prop, flag, hand, pos1, pos2, pos3, pos4, pos5, pos6)
	tvRP.stopAnimActived()

	if DoesEntityExist(object) then
		TriggerServerEvent("trydeleteobj", ObjToNet(object))
		object = nil
	end

	local ped = PlayerPedId()

	RequestModel(GetHashKey(prop))
	while not HasModelLoaded(GetHashKey(prop)) do
		Wait(10)
	end

	if pos1 then
		if dict ~= "" then
			tvRP.CarregarAnim(dict)
			TaskPlayAnim(ped, dict, anim, 3.0, 3.0, -1, flag, 0, 0, 0, 0)
		end
		local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
		object = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z, true, true, true)
		SetEntityCollision(object, false, false)
		AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, hand), pos1, pos2, pos3, pos4, pos5, pos6, true, true, false, true, 1, true)
	else
		tvRP.CarregarAnim(dict)
		TaskPlayAnim(ped, dict, anim, 3.0, 3.0, -1, flag, 0, 0, 0, 0)
		local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
		object = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z, true, true, true)
		SetEntityCollision(object, false, false)
		AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, hand), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	end
	SetEntityAsMissionEntity(object, true, true)
	SetEntityAsNoLongerNeeded(object)

	NetworkRegisterEntityAsNetworked(object)
	while not NetworkGetEntityIsNetworked(object) do
		Wait(10)
	end

	animDict = dict
	animName = anim
	animFlags = flag
	animActived = true

	local netid = ObjToNet(object)
	SetNetworkIdExistsOnAllMachines(netid, true)
	NetworkSetNetworkIdDynamic(netid, true)
	SetNetworkIdCanMigrate(netid, false)
	for _, i in ipairs(GetActivePlayers()) do
		SetNetworkIdSyncToPlayer(netid, i, true)
	end
end

function tvRP.CarregarObjeto2(dict, anim, prop, flag, hand, pos1, pos2, pos3, pos4, pos5, pos6)
	tvRP.stopAnimActived()

	if DoesEntityExist(object2) then
		TriggerServerEvent("trydeleteobj", ObjToNet(object2))
		object2 = nil
	end

	local ped = PlayerPedId()

	RequestModel(GetHashKey(prop))
	while not HasModelLoaded(GetHashKey(prop)) do
		Wait(10)
	end

	if pos1 then
		if dict ~= "" then
			tvRP.CarregarAnim(dict)
			TaskPlayAnim(ped, dict, anim, 3.0, 3.0, -1, flag, 0, 0, 0, 0)
		end
		local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
		object2 = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z, true, true, true)
		SetEntityCollision(object2, false, false)
		AttachEntityToEntity(object2, ped, GetPedBoneIndex(ped, hand), pos1, pos2, pos3, pos4, pos5, pos6, true, true, false, true, 1, true)
	else
		tvRP.CarregarAnim(dict)
		TaskPlayAnim(ped, dict, anim, 3.0, 3.0, -1, flag, 0, 0, 0, 0)
		local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
		object2 = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z, true, true, true)
		SetEntityCollision(object2, false, false)
		AttachEntityToEntity(object2, ped, GetPedBoneIndex(ped, hand), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	end
	SetEntityAsMissionEntity(object2, true, true)
	SetEntityAsNoLongerNeeded(object2)

	NetworkRegisterEntityAsNetworked(object2)
	while not NetworkGetEntityIsNetworked(object2) do
		Wait(10)
	end

	animDict = dict
	animName = anim
	animFlags = flag
	animActived = true

	local netid = ObjToNet(object2)
	SetNetworkIdExistsOnAllMachines(netid, true)
	NetworkSetNetworkIdDynamic(netid, true)
	SetNetworkIdCanMigrate(netid, false)
	for _, i in ipairs(GetActivePlayers()) do
		SetNetworkIdSyncToPlayer(netid, i, true)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if not IsEntityPlayingAnim(ped, animDict, animName, 3) and animActived then
			TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, animFlags, 0, 0, 0, 0)
		end
		Wait(500)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLOCK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 500
		if animActived then
			timeDistance = 4
			DisableControlAction(0, 16, true)
			DisableControlAction(0, 17, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 327, true)
			BlockWeaponWheelThisFrame()
		end
		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE OBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.DeletarObjeto(status)
	if status == "one" then
		tvRP.stopAnim(true)
	elseif status == "two" then
		tvRP.stopAnim(false)
	else
		tvRP.stopAnim(true)
		tvRP.stopAnim(false)
	end

	animActived = false
	TriggerEvent("binoculos", false)
	if DoesEntityExist(object) then
		TriggerServerEvent("trydeleteobj", ObjToNet(object))
		object = nil
	end
	if DoesEntityExist(object2) then
		TriggerServerEvent("trydeleteobj", ObjToNet(object2))
		object2 = nil
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATE CAM
-----------------------------------------------------------------------------------------------------------------------------------------
local cam = false
function tvRP.SetCameraCoords()
	CreateThread(function()
		local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetCamActive(cam, true)
		RenderScriptCams(true, true, 500, true, true)
		AttachCamToPedBone(cam, PlayerPedId(), 31085, 0, 0, 1.0, true)
		SetCamFov(cam, 90.0)
		SetCamRot(cam, -90.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)
	end)
end

function tvRP.DeleteCam()
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 500, true, true)
	DestroyCam(cam, false)
	cam = nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PARTICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.PtfxThis(asset)
	RequestNamedPtfxAsset(asset)
	while not HasNamedPtfxAssetLoaded(asset) do
		Wait(10)
	end
	UseParticleFxAssetNextCall(asset)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COOLDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
local cooldown = 0
CreateThread(function()
	while true do
		Wait(1000)
		if cooldown > 0 then
			cooldown = cooldown - 1
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1)
		local ped = PlayerPedId()
		if menu_state.opened then
			DisableControlAction(0, 75)
		end
		if IsControlJustPressed(0, 172) and IsInputDisabled(0) then SendNUIMessage({ act = "event", event = "UP" }) if menu_state.opened then tvRP.playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET") end end
		if IsControlJustPressed(0, 173) and IsInputDisabled(0) then SendNUIMessage({ act = "event", event = "DOWN" }) if menu_state.opened then tvRP.playSound("NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET") end end
		if IsControlJustPressed(0, 174) and IsInputDisabled(0) then SendNUIMessage({ act = "event", event = "LEFT" }) if menu_state.opened then tvRP.playSound("NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET") end end
		if IsControlJustPressed(0, 175) and IsInputDisabled(0) then SendNUIMessage({ act = "event", event = "RIGHT" }) if menu_state.opened then tvRP.playSound("NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET") end end
		if IsControlJustPressed(0, 176) and IsInputDisabled(0) then SendNUIMessage({ act = "event", event = "SELECT" }) if menu_state.opened then tvRP.playSound("SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET") end end
		if IsControlJustPressed(0, 177) and IsInputDisabled(0) then SendNUIMessage({ act = "event", event = "CANCEL" }) end
		if IsControlJustPressed(0, 246) and IsInputDisabled(0) then SendNUIMessage({ act = "event", event = "Y" }) end
		if IsControlJustPressed(0, 303) and IsInputDisabled(0) then SendNUIMessage({ act = "event", event = "U" }) end

		-- CRUZAR O BRACO (F1)
		if IsControlJustPressed(0, 288) and IsInputDisabled(0) then
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
				if IsEntityPlayingAnim(ped, "anim@heists@heist_corona@single_team", "single_team_loop_boss", 3) then
					StopAnimTask(ped, "anim@heists@heist_corona@single_team", "single_team_loop_boss", 2.0)
					tvRP.stopAnimActived()
				else
					tvRP.playAnim(true, { "anim@heists@heist_corona@single_team", "single_team_loop_boss" }, true)
				end
			end
		end

		-- AGUARDAR (F2)
		if IsControlJustPressed(0, 289) and IsInputDisabled(0) then
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
				if IsEntityPlayingAnim(ped, "mini@strip_club@idles@bouncer@base", "base", 3) then
					StopAnimTask(ped, "mini@strip_club@idles@bouncer@base", "base", 2.0)
					tvRP.stopAnimActived()
				else
					tvRP.playAnim(true, { "mini@strip_club@idles@bouncer@base", "base" }, true)
				end
			end
		end

		-- DEDO DO MEIO (F3)
		if IsControlJustPressed(0, 170) and IsInputDisabled(0) then
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
				if IsEntityPlayingAnim(ped, "anim@mp_player_intupperfinger", "idle_a_fp", 3) then
					StopAnimTask(ped, "anim@mp_player_intupperfinger", "idle_a_fp", 2.0)
					tvRP.stopAnimActived()
				else
					tvRP.playAnim(true, { "anim@mp_player_intupperfinger", "idle_a_fp" }, true)
				end
			end
		end

		-- AJOELHAR (F5)
		if IsControlJustPressed(0, 166) and IsInputDisabled(0) then
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
				if IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3) then
					StopAnimTask(ped, "random@arrests@busted", "idle_a", 2.0)
					tvRP.stopAnimActived()
				else
					tvRP.playAnim(false, { "random@arrests", "idle_2_hands_up" }, false)
					Wait(4000)
					tvRP.playAnim(false, { "random@arrests", "kneeling_arrest_idle" }, false)
					Wait(500)
					tvRP.playAnim(false, { "random@arrests@busted", "enter" }, false)
					Wait(1000)
					tvRP.playAnim(false, { "random@arrests@busted", "idle_a" }, true)
					Wait(100)
				end
			end
		end

		-- PARA TODAS AS ANIMAÇÕES (F6)
		if IsControlJustPressed(0, 167) and IsInputDisabled(0) then
			if cooldown < 1 then
				cooldown = 20
				if GetEntityHealth(ped) > 101 then
					if not menu_state.opened then
						tvRP.DeletarObjeto()
						tvRP.stopAnimActived()
						tvRP.DeleteCam()
						ClearPedTasks(ped)
						TriggerServerEvent("vrp_inventory:Cancel")
					end
				end
			end
		end

		-- MÃOS NA CABEÇA (F10)
		if IsControlJustPressed(0, 57) and IsInputDisabled(0) then
			if GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
				if IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3) then
					StopAnimTask(ped, "random@arrests@busted", "idle_a", 2.0)
					tvRP.stopAnimActived()
				else
					tvRP.playAnim(true, { "random@arrests@busted", "idle_a" }, true)
				end
			end
		end

		-- BLZ (DEL)
		if IsControlJustPressed(0, 178) and IsInputDisabled(0) then
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
				tvRP.playAnim(true, { "anim@mp_player_intincarthumbs_upbodhi@ps@", "enter" }, false)
				tvRP.stopAnimActived()
			end
		end

		-- ASSOBIAR (ARROW DOWN)
		if IsControlJustPressed(0, 187) and IsInputDisabled(0) then
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
				tvRP.playAnim(true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
				tvRP.stopAnimActived()
			end
		end

		-- JOIA (ARROW LEFT)
		if IsControlJustPressed(0, 189) and IsInputDisabled(0) then
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
				tvRP.playAnim(true, { "anim@mp_player_intupperthumbs_up", "enter" }, false)
				tvRP.stopAnimActived()
			end
		end

		-- FACEPALM (ARROW RIGHT)
		if IsControlJustPressed(0, 190) and IsInputDisabled(0) then
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
				tvRP.playAnim(true, { "anim@mp_player_intcelebrationmale@face_palm", "face_palm" }, false)
				tvRP.stopAnimActived()
			end
		end

		-- SAUDACAO (ARROW UP)
		if IsControlJustPressed(0, 188) and IsInputDisabled(0) then
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
				tvRP.playAnim(true, { "anim@mp_player_intcelebrationmale@salute", "salute" }, false)
				tvRP.stopAnimActived()
			end
		end

		-- LEVANTAR A MAO (X)
		if IsControlJustPressed(0, 73) and IsInputDisabled(0) then
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_celular then
				--SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true)
				if IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3) then
					StopAnimTask(ped, "random@mugging3", "handsup_standing_base", 2.0)
					tvRP.stopAnimActived()
				else
					tvRP.playAnim(true, { "random@mugging3", "handsup_standing_base" }, true)
				end
			end
		end

		-- LIGAR O MOTOR (Z)
		if IsControlJustPressed(0, 20) and IsInputDisabled(0) then
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped, false)
				if GetPedInVehicleSeat(vehicle, -1) == ped then
					tvRP.DeletarObjeto()
					local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E, vehicle)
					SetVehicleEngineOn(vehicle, not running, true, true)
					if running then
						SetVehicleUndriveable(vehicle, true)
					else
						SetVehicleUndriveable(vehicle, false)
					end
				end
			end
		end

		-- APONTAR O DEDO (B)
		if IsControlJustPressed(0, 29) and IsInputDisabled(0) then
			if GetEntityHealth(ped) > 101 and not menu_celular then
				animActived = false
				tvRP.CarregarAnim("anim@mp_point")
				if not apontar then
					SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
					SetPedConfigFlag(ped, 36, 1)
					Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
					apontar = true
				else
					Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
					if not IsPedInjured(ped) then
						ClearPedSecondaryTask(ped)
					end
					if not IsPedInAnyVehicle(ped) then
						SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
					end
					SetPedConfigFlag(ped, 36, 0)
					ClearPedSecondaryTask(ped)
					apontar = false
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO DO APONTAR
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(1)
		local ped = PlayerPedId()
		if apontar then
			local camPitch = GetGameplayCamRelativePitch()
			if camPitch < -70.0 then
				camPitch = -70.0
			elseif camPitch > 42.0 then
				camPitch = 42.0
			end
			camPitch = (camPitch + 70.0) / 112.0

			local camHeading = GetGameplayCamRelativeHeading()
			local cosCamHeading = Cos(camHeading)
			local sinCamHeading = Sin(camHeading)
			if camHeading < -180.0 then
				camHeading = -180.0
			elseif camHeading > 180.0 then
				camHeading = 180.0
			end
			camHeading = (camHeading + 180.0) / 360.0

			local blocked = 0
			local nn = 0
			local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
			local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
			nn, blocked, coords, coords = GetRaycastResult(ray)

			Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
			Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOLSTER
-----------------------------------------------------------------------------------------------------------------------------------------
local Weapons = {
	-- NORMAL
	"WEAPON_PISTOL",

	-- POLICE
	"WEAPON_COMBATPISTOL",
	"WEAPON_REVOLVER_MK2",

	-- ILLEGAL
	"WEAPON_PISTOL_MK2",
	"WEAPON_MACHINEPISTOL"
}

CreateThread(function()
	while true do
		Wait(1)
		local ped = PlayerPedId()
		if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, true) then
			if CheckWeapon(ped) then
				if holstered then
					tvRP.playAnim(true, { "rcmjosh4", "josh_leadout_cop2" }, false)
					Wait(600)
					ClearPedTasks(ped)
					holstered = false
				end
			elseif not CheckWeapon(ped) then
				if not holstered then
					tvRP.playAnim(true, { "rcmjosh4", "josh_leadout_cop2" }, false)
					Wait(500)
					ClearPedTasks(ped)
					holstered = true
				end
			end
		end
	end
end)

function CheckWeapon(ped)
	for i = 1, #Weapons do
		if GetHashKey(Weapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCCLEAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncclean")
AddEventHandler("syncclean", function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleDirtLevel(v, 0.0)
				SetVehicleUndriveable(v, false)
				--tvRP.DeletarObjeto()
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDELETEPED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncdeleteped")
AddEventHandler("syncdeleteped", function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToPed(index)
		if DoesEntityExist(v) then
			Citizen.InvokeNative(0xAD738C3085FE7E11, v, true, true)
			SetPedAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
			DeletePed(v)
		end
	end
end)
