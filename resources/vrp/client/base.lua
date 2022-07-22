local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")

tvRP = {}
local players = {}
Tunnel.bindInterface("vRP", tvRP)
vRPserver = Tunnel.getInterface("vRP")
Proxy.addInterface("vRP", tvRP)

local user_id
function tvRP.setUserId(_user_id)
	user_id = _user_id
end

function tvRP.getUserId()
	return user_id
end

function tvRP.getUserHeading()
	return GetEntityHeading(PlayerPedId())
end

function tvRP.teleport(x, y, z)
	SetEntityCoords(PlayerPedId(), x + 0.0001, y + 0.0001, z + 0.0001, 1, 0, 0, 1)
	vRPserver._updatePos(x, y, z)
end

function tvRP.clearWeapons()
	RemoveAllPedWeapons(PlayerPedId(), true)
end

function tvRP.getPosition()
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	return x, y, z
end

function tvRP.isInside()
	local x, y, z = tvRP.getPosition()
	return not (GetInteriorAtCoords(x, y, z) == 0)
end

function tvRP.getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
	local pitch = GetGameplayCamRelativePitch()
	local x = -math.sin(heading * math.pi / 180.0)
	local y = math.cos(heading * math.pi / 180.0)
	local z = math.sin(pitch * math.pi / 180.0)
	local len = math.sqrt(x * x + y * y + z * z)
	if len ~= 0 then
		x = x / len
		y = y / len
		z = z / len
	end
	return x, y, z
end

function tvRP.addPlayer(player)
	players[player] = true
end

function tvRP.removePlayer(player)
	players[player] = nil
end

function tvRP.getPlayers()
	return players
end

function tvRP.getNearestPlayers(radius)
	local r = {}
	local ped = GetPlayerPed(i)
	local pid = PlayerId()
	local px, py, pz = tvRP.getPosition()

	for k, v in pairs(players) do
		local player = GetPlayerFromServerId(k)
		if player ~= pid and NetworkIsPlayerConnected(player) then
			local oped = GetPlayerPed(player)
			local x, y, z = table.unpack(GetEntityCoords(oped, true))
			local distance = GetDistanceBetweenCoords(x, y, z, px, py, pz, true)
			if distance <= radius then
				r[GetPlayerServerId(player)] = distance
			end
		end
	end
	return r
end

function tvRP.getNearestPlayer(radius)
	local p = nil
	local players = tvRP.getNearestPlayers(radius)
	local min = radius + 0.0001
	for k, v in pairs(players) do
		if v < min then
			min = v
			p = k
		end
	end
	return p
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARANIM
-----------------------------------------------------------------------------------------------------------------------------------------
local animActived = false
local animDict = nil
local animName = nil
local animFlags = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.playAnim(upper, seq, looping)
	tvRP.stopAnimActived()

	local ped = PlayerPedId()
	if seq.task then
		tvRP.stopAnim(true)
		if seq.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then
			local x, y, z = table.unpack(GetEntityCoords(ped))
			TaskStartScenarioAtPosition(ped, seq.task, x, y, z - 1, GetEntityHeading(ped), 0, 0, false)
		else
			TaskStartScenarioInPlace(ped, seq.task, 0, not seq.play_exit)
		end
	else
		tvRP.stopAnim(upper)

		local flags = 0

		if upper then
			flags = flags + 48
		end

		if looping then
			flags = flags + 1
		end

		CreateThread(function()
			RequestAnimDict(seq[1])
			while not HasAnimDictLoaded(seq[1]) do
				RequestAnimDict(seq[1])
				Wait(10)
			end

			if HasAnimDictLoaded(seq[1]) then
				animDict = seq[1]
				animName = seq[2]
				animFlags = flags
				if flags == 49 then
					animActived = true
				end
				TaskPlayAnim(ped, seq[1], seq[2], 3.0, 3.0, -1, flags, 0, 0, 0, 0)
			end
		end)
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
		Wait(4)
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
-- STOPANIMACTIVED
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.stopAnimActived()
	animActived = false
end

function tvRP.stopAnim(upper)
	anims = {}
	if upper then
		ClearPedSecondaryTask(PlayerPedId())
	else
		ClearPedTasks(PlayerPedId())
	end
end

function tvRP.playSound(dict, name)
	PlaySoundFrontend(-1, dict, name, false)
end

function tvRP.stopSound()
	return StopSound(tvRP.playSound(dict, name))
end

function tvRP.playScreenEffect(name, duration)
	if duration < 0 then
		StartScreenEffect(name, 0, true)
	else
		StartScreenEffect(name, 0, true)

		CreateThread(function()
			Wait(math.floor((duration + 1) * 1000))
			StopScreenEffect(name)
		end)
	end
end

AddEventHandler("playerSpawned", function()
	TriggerServerEvent("vRPcli:playerSpawned")
end)

CreateThread(function()
	while true do
		Wait(1)
		if NetworkIsSessionStarted() then
			TriggerServerEvent("Queue:playerActivated")
			return
		end
	end
end)
