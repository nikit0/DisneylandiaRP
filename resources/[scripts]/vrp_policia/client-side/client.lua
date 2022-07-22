-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
src = {}
Tunnel.bindInterface("vrp_policia", src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REANIMAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('reanimar')
AddEventHandler('reanimar', function()
	local handle, ped = FindFirstPed()
	local finished = false
	local reviver = nil
	repeat
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance <= 1.5 and reviver == nil then
			reviver = ped
			TriggerEvent("cancelando", true, true)
			vRP._playAnim(false, { "amb@medic@standing@tendtodead@base", "base" }, { "mini@cpr@char_a@cpr_str", "cpr_pumpchest" }, true)
			TriggerEvent("progress", 15000, "reanimando")
			SetTimeout(15000, function()
				SetEntityHealth(reviver, 300)
				local newped = ClonePed(reviver, GetEntityHeading(reviver), true, true)
				TaskWanderStandard(newped, 10.0, 10)
				local model = GetEntityModel(reviver)
				SetModelAsNoLongerNeeded(model)
				Citizen.InvokeNative(0xAD738C3085FE7E11, reviver, true, true)
				TriggerServerEvent("trydeleteped", PedToNet(reviver))
				vRP._stopAnim(false)
				TriggerServerEvent("reanimar:pagamento1")
				TriggerEvent("cancelando", false, false)
			end)
			finished = true
		end
		finished, ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /RMASCARA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("rmascara")
AddEventHandler("rmascara", function()
	SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /RCHAPEU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("rchapeu")
AddEventHandler("rchapeu", function()
	ClearPedProp(PlayerPedId(), 0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET & REMOVE ALGEMAS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkSurrendered()
	local ped = PlayerPedId()
	if IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(ped, "random@arrests", "kneeling_arrest_idle", 3) or IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3) or IsPedRagdoll(ped) then
		return true
	else
		return false
	end
end

RegisterNetEvent("setalgemas")
AddEventHandler("setalgemas", function()
	local ped = PlayerPedId()
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(ped, 7, 41, 0, 2)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		SetPedComponentVariation(ped, 7, 25, 0, 2)
	end
end)

RegisterNetEvent("removealgemas")
AddEventHandler("removealgemas", function()
	SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)
end)
--------------------------------------------------------------------------------------------------------------------------------------------------
-- CARREGAR
--------------------------------------------------------------------------------------------------------------------------------------------------
other = nil
drag = false
carregado = false
RegisterNetEvent("carregar")
AddEventHandler("carregar", function(p1)
	other = p1
	drag = not drag
end)

CreateThread(function()
	while true do
		Wait(1)
		if drag and other then
			local ped = GetPlayerPed(GetPlayerFromServerId(other))
			Citizen.InvokeNative(0x6B9BBD38AB0796DF, PlayerPedId(), ped, 4103, 11816, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			carregado = true
		else
			if carregado then
				DetachEntity(PlayerPedId(), true, false)
				carregado = false
			end
		end
	end
end)

CreateThread(function()
	while true do
		if IsControlJustPressed(0, 47) and IsInputDisabled(0) and not IsPedInAnyVehicle(PlayerPedId()) then
			TriggerServerEvent("vrp_policia:algemar")
		end
		if IsControlJustPressed(0, 74) and IsInputDisabled(0) and not IsPedInAnyVehicle(PlayerPedId()) then
			TriggerServerEvent("vrp_policia:carregar")
		end
		if IsControlJustPressed(0, 11) and IsInputDisabled(0) then
			TriggerServerEvent("1020Police")
		end
		Wait(1)
	end
end)
--------------------------------------------------------------------------------------------------------------------------------------------------
-- DISPAROS
--------------------------------------------------------------------------------------------------------------------------------------------------
local blacklistedWeapons = {
	"WEAPON_DAGGER",
	"WEAPON_BAT",
	"WEAPON_BALL",
	"WEAPON_SNOWBALL",
	"WEAPON_BOTTLE",
	"WEAPON_CROWBAR",
	"WEAPON_FLASHLIGHT",
	"WEAPON_GOLFCLUB",
	"WEAPON_HAMMER",
	"WEAPON_HATCHET",
	"WEAPON_KNUCKLE",
	"WEAPON_KNIFE",
	"WEAPON_MACHETE",
	"WEAPON_SWITCHBLADE",
	"WEAPON_NIGHTSTICK",
	"WEAPON_WRENCH",
	"WEAPON_BATTLEAXE",
	"WEAPON_POOLCUE",
	"WEAPON_STONE_HATCHET",
	"WEAPON_STUNGUN",
	"WEAPON_FLARE",
	"GADGET_PARACHUTE",
	"WEAPON_FIREEXTINGUISHER",
	"WEAPON_PETROLCAN",
	"WEAPON_RAYPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_HEAVYSNIPER_MK2",
	"WEAPON_FIREWORK",
	"WEAPON_BZGAS",
	"WEAPON_MUSKET"
}

CreateThread(function()
	while true do
		Wait(1)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsUsing(ped)
		local blacklistweapon = false
		local x, y, z = table.unpack(GetEntityCoords(ped))

		for k, v in ipairs(blacklistedWeapons) do
			if GetSelectedPedWeapon(ped) == GetHashKey(v) or not vehicle then
				blacklistweapon = true
			end
		end

		if IsPedShooting(ped) and not blacklistweapon then
			TriggerServerEvent('atirando', x, y, z)
		end

		blacklistweapon = false
	end
end)

local blips = {}
RegisterNetEvent('notificacao')
AddEventHandler('notificacao', function(x, y, z, user_id)
	--local distance = GetDistanceBetweenCoords(x,y,z,-186.1,-893.5,29.3,true)
	--if distance <= 2100 then
	if not DoesBlipExist(blips[user_id]) then
		--PlaySoundFrontend(-1,"Enter_1st","GTAO_FM_Events_Soundset",false)
		--TriggerEvent('chatMessage',"911",{64,64,255},"Disparos de arma de fogo aconteceram, verifique o ocorrido.")

		TriggerEvent("NotifyPush", { code = 10, title = "Ocorrência em andamento", x = x, y = y, z = z, badge = "Disparos de arma de fogo" })
		blips[user_id] = AddBlipForCoord(x, y, z)
		SetBlipScale(blips[user_id], 0.5)
		SetBlipSprite(blips[user_id], 10)
		SetBlipColour(blips[user_id], 49)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Disparos de arma de fogo")
		EndTextCommandSetBlipName(blips[user_id])
		SetBlipAsShortRange(blips[user_id], false)
		SetTimeout(30000, function()
			if DoesBlipExist(blips[user_id]) then
				RemoveBlip(blips[user_id])
			end
		end)
	end
	--end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONE
-----------------------------------------------------------------------------------------------------------------------------------------
local cone = nil
RegisterNetEvent('cone')
AddEventHandler('cone', function(nome)
	local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -0.94)
	local prop = "prop_mp_cone_02"
	local h = GetEntityHeading(PlayerPedId())
	if nome ~= "d" then
		cone = CreateObject(GetHashKey(prop), coord.x, coord.y - 0.5, coord.z, true, true, true)
		PlaceObjectOnGroundProperly(cone)
		SetModelAsNoLongerNeeded(cone)
		Citizen.InvokeNative(0xAD738C3085FE7E11, cone, true, true)
		SetEntityHeading(cone, h)
		FreezeEntityPosition(cone, true)
		SetEntityAsNoLongerNeeded(cone)
	else
		if DoesObjectOfTypeExistAtCoords(coord.x, coord.y, coord.z, 0.9, GetHashKey(prop), true) then
			cone = GetClosestObjectOfType(coord.x, coord.y, coord.z, 0.9, GetHashKey(prop), false, false, false)
			Citizen.InvokeNative(0xAD738C3085FE7E11, cone, true, true)
			SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(cone))
			DeleteObject(cone)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARREIRA
-----------------------------------------------------------------------------------------------------------------------------------------
local barreira = nil
RegisterNetEvent('barreira')
AddEventHandler('barreira', function(nome)
	local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.5, -0.94)
	local prop = "prop_mp_barrier_02b"
	local h = GetEntityHeading(PlayerPedId())
	if nome ~= "d" then
		barreira = CreateObject(GetHashKey(prop), coord.x, coord.y - 0.95, coord.z, true, true, true)
		PlaceObjectOnGroundProperly(barreira)
		SetModelAsNoLongerNeeded(barreira)
		Citizen.InvokeNative(0xAD738C3085FE7E11, barreira, true, true)
		SetEntityHeading(barreira, h - 180)
		FreezeEntityPosition(barreira, true)
		SetEntityAsNoLongerNeeded(barreira)
	else
		if DoesObjectOfTypeExistAtCoords(coord.x, coord.y, coord.z, 0.9, GetHashKey(prop), true) then
			barreira = GetClosestObjectOfType(coord.x, coord.y, coord.z, 0.9, GetHashKey(prop), false, false, false)
			Citizen.InvokeNative(0xAD738C3085FE7E11, barreira, true, true)
			SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(barreira))
			DeleteObject(barreira)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPIKE
-----------------------------------------------------------------------------------------------------------------------------------------
local spike = nil
RegisterNetEvent('spike')
AddEventHandler('spike', function(nome)
	local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.5, 0.0)
	local prop = "p_ld_stinger_s"
	local h = GetEntityHeading(PlayerPedId())
	if nome ~= "d" then
		spike = CreateObject(GetHashKey(prop), coord.x, coord.y, coord.z, true, true, true)
		PlaceObjectOnGroundProperly(spike)
		SetModelAsNoLongerNeeded(spike)
		Citizen.InvokeNative(0xAD738C3085FE7E11, spike, true, true)
		SetEntityHeading(spike, h - 180)
		FreezeEntityPosition(spike, true)
		SetEntityAsNoLongerNeeded(spike)
	else
		if DoesObjectOfTypeExistAtCoords(coord.x, coord.y, coord.z, 0.9, GetHashKey(prop), true) then
			spike = GetClosestObjectOfType(coord.x, coord.y, coord.z, 0.9, GetHashKey(prop), false, false, false)
			Citizen.InvokeNative(0xAD738C3085FE7E11, spike, true, true)
			SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(spike))
			DeleteObject(spike)
		end
	end
end)

CreateThread(function()
	while true do
		local idle = 500
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		local vcoord = GetEntityCoords(veh)
		local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -0.94)
		if IsPedInAnyVehicle(PlayerPedId()) then
			idle = 1
			if DoesObjectOfTypeExistAtCoords(vcoord.x, vcoord.y, vcoord.z, 0.9, GetHashKey("p_ld_stinger_s"), true) then
				SetVehicleTyreBurst(veh, 0, true, 1000.0)
				SetVehicleTyreBurst(veh, 1, true, 1000.0)
				SetVehicleTyreBurst(veh, 2, true, 1000.0)
				SetVehicleTyreBurst(veh, 3, true, 1000.0)
				SetVehicleTyreBurst(veh, 4, true, 1000.0)
				SetVehicleTyreBurst(veh, 5, true, 1000.0)
				SetVehicleTyreBurst(veh, 6, true, 1000.0)
				SetVehicleTyreBurst(veh, 7, true, 1000.0)
				if DoesObjectOfTypeExistAtCoords(coord.x, coord.y, coord.z, 0.9, GetHashKey("p_ld_stinger_s"), true) then
					spike = GetClosestObjectOfType(coord.x, coord.y, coord.z, 0.9, GetHashKey("p_ld_stinger_s"), false, false, false)
					Citizen.InvokeNative(0xAD738C3085FE7E11, spike, true, true)
					SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(spike))
					DeleteObject(spike)
				end
			end
		end
		Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local prisioneiro = false
local reducaopenal = false

RegisterNetEvent('prisioneiro')
AddEventHandler('prisioneiro', function(status)
	prisioneiro = status
	reducaopenal = false
	local ped = PlayerPedId()
	if prisioneiro then
		SetEntityInvincible(ped, true)
		FreezeEntityPosition(ped, true)
		SetEntityVisible(ped, false, false)
		SetTimeout(10000, function()
			SetEntityInvincible(ped, false)
			FreezeEntityPosition(ped, false)
			SetEntityVisible(ped, true, false)
		end)
	end
end)

CreateThread(function()
	while true do
		Wait(5000)
		if prisioneiro then
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 1700.5, 2605.2, 45.5, true)
			if distance >= 150 then
				SetEntityCoords(PlayerPedId(), 1680.1, 2513.0, 45.5)
				TriggerEvent("Notify", "aviso", "O agente penitenciário encontrou você tentando escapar.")
			end
		end
	end
end)

CreateThread(function()
	while true do
		local idle = 500
		if prisioneiro then
			idle = 1
			local distance1 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 1691.59, 2566.05, 45.56, true)
			local distance2 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 1669.51, 2487.71, 45.82, true)

			if GetEntityHealth(PlayerPedId()) <= 101 then
				reducaopenal = false
				vRP._DeletarObjeto()
			end

			if distance1 <= 100 and not reducaopenal then
				DrawMarker(21, 1691.59, 2566.05, 45.56, 0, 0, 0, 0, 180.0, 130.0, 1.0, 1.0, 0.5, 255, 0, 0, 100, 1, 0, 0, 1)
				if distance1 <= 1.2 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA PEGAR A CAIXA", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
					if IsControlJustPressed(0, 38) and IsInputDisabled(0) and not IsPedInAnyVehicle(PlayerPedId()) then
						reducaopenal = true
						ResetPedMovementClipset(PlayerPedId(), 0.0)
						SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
						vRP._CarregarObjeto("anim@heists@box_carry@", "idle", "hei_prop_heist_box", 50, 28422)
					end
				end
			end

			if distance2 <= 101 and reducaopenal then
				DrawMarker(21, 1669.51, 2487.71, 45.82, 0, 0, 0, 0, 180.0, 130.0, 1.0, 1.0, 0.5, 255, 0, 0, 100, 1, 0, 0, 1)
				if distance2 <= 1.2 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA ENTREGAR A CAIXA", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
					if IsControlJustPressed(0, 38) and IsInputDisabled(0) and not IsPedInAnyVehicle(PlayerPedId()) then
						reducaopenal = false
						TriggerServerEvent("diminuirpena1")
						vRP._DeletarObjeto()
					end
				end
			end
		end
		Wait(idle)
	end
end)

CreateThread(function()
	while true do
		local idle = 500
		if reducaopenal then
			idle = 1
			BlockWeaponWheelThisFrame()
			DisableControlAction(0, 21, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 29, true)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 33, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 35, true)
			DisableControlAction(0, 56, true)
			DisableControlAction(0, 58, true)
			DisableControlAction(0, 73, true)
			DisableControlAction(0, 75, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 166, true)
			DisableControlAction(0, 167, true)
			DisableControlAction(0, 170, true)
			DisableControlAction(0, 177, true)
			DisableControlAction(0, 182, true)
			DisableControlAction(0, 187, true)
			DisableControlAction(0, 188, true)
			DisableControlAction(0, 189, true)
			DisableControlAction(0, 190, true)
			DisableControlAction(0, 243, true)
			DisableControlAction(0, 244, true)
			DisableControlAction(0, 245, true)
			DisableControlAction(0, 246, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 268, true)
			DisableControlAction(0, 269, true)
			DisableControlAction(0, 270, true)
			DisableControlAction(0, 271, true)
			DisableControlAction(0, 288, true)
			DisableControlAction(0, 289, true)
			DisableControlAction(0, 303, true)
			DisableControlAction(0, 311, true)
			DisableControlAction(0, 344, true)
		end
		Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text, font, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end
