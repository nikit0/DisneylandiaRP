-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_pets", src)
Proxy.addInterface("vrp_pets", src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local GUI = {}
GUI.Time = 0

local ped = {}
local model = {}
local status = 100

local animation = {}
local inanimation = false
local isAttached = false
local come = 0
local following = false

local object = {}
local objCoords = nil
local balle = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local idle = 500
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 562.33, 2741.59, 42.87, true)
		if distance < 3 then
			idle = 1
			DrawMarker(21, 562.33, 2741.59, 42.87 - 0.6, 0, 0, 0, 0.0, 0, 0, 0.5, 0.5, 0.4, 255, 0, 0, 50, 0, 0, 0, 1)
			if distance < 1 then
				if IsControlJustPressed(0, 38) and IsInputDisabled(0) then
					TriggerServerEvent("vrp_pets:buypet")
				end
			else
				vRP.closeMenu()
			end
		end
		Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /pets
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pets", function(source, args)
	--if not IsPedSittingInAnyVehicle(PlayerPedId()) then
	TriggerServerEvent("vrp_pets:petMenu", status, come, isInVehicle)
	GUI.Time = GetGameTimer()
	--end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAMA PET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_pets:callPet")
AddEventHandler("vrp_pets:callPet", function(data)
	if (data == "rottweiler") then
		model = -1788665315
		come = 1
		spawnpet()
	elseif (data == "gato") then
		model = 1462895032
		come = 1
		spawnpet()
	elseif (data == "lobo") then
		model = 1682622302
		come = 1
		spawnpet()
	elseif (data == "coelho") then
		model = -541762431
		come = 1
		spawnpet()
	elseif (data == "husky") then
		model = 1318032802
		come = 1
		spawnpet()
	elseif (data == "porco") then
		model = -1323586730
		come = 1
		spawnpet()
	elseif (data == "poodle") then
		model = 1125994524
		come = 1
		spawnpet()
	elseif (data == "pug") then
		model = 1832265812
		come = 1
		spawnpet()
	elseif (data == "retriever") then
		model = 882848737
		come = 1
		spawnpet()
	elseif (data == "caoalsatian") then
		model = 1126154828
		come = 1
		spawnpet()
	elseif (data == "westie") then
		model = -1384627013
		come = 1
		spawnpet()
	end
	GiveWeaponToPed(PlayerPedId(), GetHashKey('WEAPON_BALL'), 1, false, true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DAR COMIDA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_pets:givefood")
AddEventHandler("vrp_pets:givefood", function()
	local coords1 = GetEntityCoords(PlayerPedId())
	local coords2 = GetEntityCoords(ped)
	local distance = GetDistanceBetweenCoords(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z, true)
	if distance < 2 then
		if status < 100 then
			status = status + math.random(2, 15)
			TriggerEvent("Notify", "sucesso", "Você deu ração ao seu animal de estimação.")
			TriggerServerEvent('vrp_pets:alimentar')
			if status > 100 then
				status = 100
			end
			vRP.closeMenu()
		else
			TriggerEvent("Notify", "aviso", "O seu animal de estimação já está cheio.")
		end
	else
		TriggerEvent("Notify", "aviso", "O seu animal de estimação está muito longe.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANEXAR E DESANEXAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_pets:attachdettach")
AddEventHandler("vrp_pets:attachdettach", function()
	if not IsPedSittingInAnyVehicle(ped) then
		if isAttached == false then
			attached()
			isAttached = true
		else
			detached()
			isAttached = false
		end
		--detached()
	else
		TriggerEvent("Notify", "importante", "Você não pode colocar seu pet neste veículo.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLOCAR E TIRAR DO VEICULO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_pets:enterleaveveh")
AddEventHandler("vrp_pets:enterleaveveh", function()
	local coords = GetEntityCoords(PlayerPedId())
	local vehicle = GetVehiclePedIsUsing(PlayerPedId())
	local coords2 = GetEntityCoords(ped)
	local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, coords2.x, coords2.y, coords2.z, true)
	if not isInVehicle then
		if IsPedSittingInAnyVehicle(PlayerPedId()) then
			if distance < 3 then
				attached()
				Wait(200)
				if IsVehicleSeatFree(vehicle, 0) then
					SetPedIntoVehicle(ped, vehicle, 0)
					isInVehicle = true
				elseif IsVehicleSeatFree(vehicle, 1) then
					SetPedIntoVehicle(ped, vehicle, 1)
					isInVehicle = true
				elseif IsVehicleSeatFree(vehicle, 2) then
					SetPedIntoVehicle(ped, vehicle, 2)
					isInVehicle = true
				end
				vRP._CarregarAnim('creatures@rottweiler@amb@world_dog_sitting@base')
				TaskPlayAnim(ped, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 8.0, -8, -1, 1, 0, false, false, false)
				vRP.closeMenu()
			else
				TriggerEvent("Notify", "aviso", "O seu animal de estimação está muito longe do veículo.")
			end
		else
			TriggerEvent("Notify", "importante", "Você precisa estar dentro do veículo.")
		end
	else
		if distance < 3 then
			if not IsPedSittingInAnyVehicle(PlayerPedId()) then
				SetEntityCoords(ped, coords.x + 1, coords.y + 1, coords.z - 1, 1, 0, 0, 1)
				Wait(100)
				detached()
				isInVehicle = false
				vRP.closeMenu()
			else
				TriggerEvent("Notify", "importante", "Você precisa estar fora do veículo.")
			end
		else
			TriggerEvent("Notify", "aviso", "Você está muito longe do veículo.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCURAR A BOLA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_pets:findball")
AddEventHandler("vrp_pets:findball", function()
	object = GetClosestObjectOfType(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, 190.0, GetHashKey('w_am_baseball'))
	if DoesEntityExist(object) then
		balle = true
		objCoords = GetEntityCoords(object)
		TaskGoToCoordAnyMeans(ped, objCoords.x, objCoords.y, objCoords.z, 5.0, 0, 0, 786603, 0xbf800000)
		local GroupHandle = GetPlayerGroup(PlayerId())
		SetGroupSeparationRange(GroupHandle, 1.9)
		SetPedNeverLeavesGroup(ped, false)
	else
		TriggerEvent("Notify", "importante", "Você precisa jogar uma bola antes.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEAD DA BOLA
-----------------------------------------------------------------------------------------------------------------------------------------
local getball = false
CreateThread(function()
	while true do
		local idle = 500
		if balle == true then
			idle = 5
			local coords1 = GetEntityCoords(PlayerPedId())
			local coords2 = GetEntityCoords(ped)
			local distance = GetDistanceBetweenCoords(objCoords.x, objCoords.y, objCoords.z, coords2.x, coords2.y, coords2.z, true)
			local distance2 = GetDistanceBetweenCoords(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z, true)
			if distance < 0.5 then
				AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 17188), 0.120, 0.010, 0.010, 5.0, 150.0, 0.0, true, true, false, true, 1, true)
				TaskGoToCoordAnyMeans(ped, coords1.x, coords1.y, coords1.z, 5.0, 0, 0, 786603, 0xbf800000)
				balle = false
				getball = true
			end
		end
		if getball == true then
			idle = 5
			local coords1 = GetEntityCoords(PlayerPedId())
			local coords2 = GetEntityCoords(ped)
			local distance2 = GetDistanceBetweenCoords(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z, true)
			if distance2 < 1.5 then
				DetachEntity(object, false, false)
				Wait(50)
				SetEntityAsMissionEntity(object)
				DeleteEntity(object)
				GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BALL"), 1, false, true)
				local GroupHandle = GetPlayerGroup(PlayerId())
				SetGroupSeparationRange(GroupHandle, 999999.9)
				SetPedNeverLeavesGroup(ped, true)
				SetPedAsGroupMember(ped, GroupHandle)
				getball = false
			end
		end
		Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEGUIR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_pets:followme")
AddEventHandler("vrp_pets:followme", function()
	if come == 1 then
		if not following then
			if not IsPedSittingInAnyVehicle(ped) then
				following = true
				TaskFollowToOffsetOfEntity(ped, GetPlayerPed(PlayerId()), 0.5, 0.0, 0.0, 5.0, -1, 0.0, 1)
				TriggerEvent("Notify", "sucesso", "Seu animal de estimação está seguindo você.")
			else
				TriggerEvent("Notify", "importante", "Seu animal de estimação precisa estar fora do veículo.")
			end
		else
			following = false
			ClearPedTasks(ped)
			TriggerEvent("Notify", "aviso", "Seu animal de estimação parou de seguir você.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEAD DO FOLLOWME
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(1)
		if IsControlJustPressed(1, 244) and IsInputDisabled(0) then
			TriggerEvent("vrp_pets:followme")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MANDAR PRA CASA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_pets:goHome")
AddEventHandler("vrp_pets:goHome", function()
	local GroupHandle = GetPlayerGroup(PlayerId())
	local coords = GetEntityCoords(PlayerPedId())
	if not IsPedSittingInAnyVehicle(ped) then
		SetGroupSeparationRange(GroupHandle, 1.9)
		SetPedNeverLeavesGroup(ped, false)
		TaskGoToCoordAnyMeans(ped, coords.x + 40, coords.y, coords.z, 5.0, 0, 0, 786603, 0xbf800000)
		Wait(5000)
		DeleteEntity(ped)
		come = 0
	else
		TriggerEvent("Notify", "importante", "Seu animal de estimação precisa estar fora do veículo.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENTAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_pets:seat")
AddEventHandler("vrp_pets:seat", function(method)
	if method == 1 then
		vRP._CarregarAnim('creatures@rottweiler@amb@world_dog_sitting@base')
		TaskPlayAnim(ped, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 8.0, -8, -1, 1, 0, false, false, false)
		inanimation = true
	elseif method == 2 then
		vRP._CarregarAnim('creatures@carlin@amb@world_dog_sitting@idle_a')
		TaskPlayAnim(ped, 'creatures@carlin@amb@world_dog_sitting@idle_a', 'idle_b', 8.0, -8, -1, 1, 0, false, false, false)
		inanimation = true
	elseif method == 3 then
		vRP._CarregarAnim('creatures@retriever@amb@world_dog_sitting@idle_a')
		TaskPlayAnim(ped, 'creatures@retriever@amb@world_dog_sitting@idle_a', 'idle_c', 8.0, -8, -1, 1, 0, false, false, false)
		inanimation = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEITAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_pets:laydown")
AddEventHandler("vrp_pets:laydown", function(method)
	if method == 1 then
		vRP._CarregarAnim('creatures@rottweiler@amb@sleep_in_kennel@')
		TaskPlayAnim(ped, 'creatures@rottweiler@amb@sleep_in_kennel@', 'sleep_in_kennel', 8.0, -8, -1, 1, 0, false, false, false)
		inanimation = true
	elseif method == 2 then
		vRP._CarregarAnim('creatures@cat@amb@world_cat_sleeping_ground@idle_a')
		TaskPlayAnim(ped, 'creatures@cat@amb@world_cat_sleeping_ground@idle_a', 'idle_a', 8.0, -8, -1, 1, 0, false, false, false)
		inanimation = true
	elseif method == 3 then
		vRP._CarregarAnim('creatures@coyote@amb@world_coyote_rest@idle_a')
		TaskPlayAnim(ped, 'creatures@coyote@amb@world_coyote_rest@idle_a', 'idle_a', 8.0, -8, -1, 1, 0, false, false, false)
		inanimation = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LEVANTAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_pets:standup")
AddEventHandler("vrp_pets:standup", function()
	ClearPedTasks(ped)
	inanimation = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENU GERAL DO PET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_pets:orders")
AddEventHandler("vrp_pets:orders", function(data)
	TriggerServerEvent("vrp_pets:ordersMenu", data, model, inanimation)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD DE MORTE DO ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(math.random(30000, 60000))
		if come == 1 then
			status = status - 1
		end
		if status == 0 then
			TriggerServerEvent('vrp_pets:dead')
			DeleteEntity(ped)
			TriggerEvent("Notify", "negado", "Seu animal de estimação está morto! Da próxima vez lembre-se de dar comida.")
			come = 3
			status = "Morto"
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function attached()
	local playerPed = PlayerPedId()
	local GroupHandle = GetPlayerGroup(PlayerId())
	SetGroupSeparationRange(GroupHandle, 1.9)
	SetPedNeverLeavesGroup(ped, false)
	FreezeEntityPosition(ped, true)
end

function detached()
	local playerPed = PlayerPedId()
	local GroupHandle = GetPlayerGroup(PlayerId())
	SetGroupSeparationRange(GroupHandle, 999999.9)
	SetPedNeverLeavesGroup(ped, true)
	SetPedAsGroupMember(ped, GroupHandle)
	FreezeEntityPosition(ped, false)
end

function spawnpet()
	RequestModel(model)
	while (not HasModelLoaded(model)) do
		Wait(1)
	end
	local playerPed = PlayerPedId()
	local LastPosition = GetEntityCoords(playerPed)
	local GroupHandle = GetPlayerGroup(PlayerId())
	vRP._playAnim(true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
	SetTimeout(5000, function()
		ped = CreatePed(28, model, LastPosition.x + 1, LastPosition.y + 1, LastPosition.z - 1, 1, 1)
		SetPedAsGroupLeader(playerPed, GroupHandle)
		SetPedAsGroupMember(ped, GroupHandle)
		SetPedNeverLeavesGroup(ped, true)
		SetPedCanBeTargetted(ped, false)
		SetEntityAsMissionEntity(ped, true, true)
		status = math.random(40, 60)

		local blip = AddBlipForEntity(ped)
		SetBlipAsFriendly(blip, true)
		SetBlipSprite(blip, 442)
		SetBlipScale(blip, 0.6)
		SetBlipColour(blip, 3)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring("Pet"))
		EndTextCommandSetBlipName(blip)

		Wait(5)
		attached()
		Wait(5)
		detached()
	end)
end
