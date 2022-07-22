local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local sBuffer = {}
local vBuffer = {}
local seatbelt = false
local ExNoCarro = false
local voice = 1
local timedown = 0
local hour = 0
local minute = 0
local month = ""
local varday = "th"
local dayOfMonth = 0
local disableshuffle = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLESHUFFLE
-----------------------------------------------------------------------------------------------------------------------------------------
function disableSeatShuffle(flag)
	disableshuffle = flag
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CalculateTimeToDisplay
-----------------------------------------------------------------------------------------------------------------------------------------
function calculateTime()
	hour = GetClockHours()
	minute = GetClockMinutes()
	if hour <= 9 then
		hour = "0" .. hour
	end
	if minute <= 9 then
		minute = "0" .. minute
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CalculateDateToDisplay
-----------------------------------------------------------------------------------------------------------------------------------------
function calculateDate()
	month = GetClockMonth()
	dayOfMonth = GetClockDayOfMonth()
	if month == 0 then
		month = "Jan"
	elseif month == 1 then
		month = "Feb"
	elseif month == 2 then
		month = "Mar"
	elseif month == 3 then
		month = "Apr"
	elseif month == 4 then
		month = "May"
	elseif month == 5 then
		month = "Jun"
	elseif month == 6 then
		month = "Jul"
	elseif month == 7 then
		month = "Aug"
	elseif month == 8 then
		month = "Sep"
	elseif month == 9 then
		month = "Oct"
	elseif month == 10 then
		month = "Nov"
	elseif month == 11 then
		month = "Dec"
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOKOVOIP
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterNetEvent('tokovoip')
AddEventHandler('tokovoip',function(status)
	voice = status
end)]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(200)
		local ped = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(ped, false))
		local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x, y, z))

		calculateTime()
		calculateDate()

		if dayOfMonth == 1 then
			varday = "st"
		elseif dayOfMonth == 2 then
			varday = "nd"
		elseif dayOfMonth == 3 then
			varday = "rd"
		else
			varday = "th"
		end

		if IsPauseMenuActive() or IsScreenFadedOut() then
			SendNUIMessage({ active = false })
		else
			local direction
			local directions = { [0] = "N", [45] = "NW", [90] = "W", [135] = "SW", [180] = "S", [225] = "SE", [270] = "E", [315] = "NE", [360] = "N" }
			for k, v in pairs(directions) do
				direction = GetEntityHeading(ped)
				if math.abs(direction - k) < 22.5 then
					direction = v
					break
				end
			end

			local vida = GetEntityHealth(ped) - 100
			local colete = GetPedArmour(ped)
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				local speed = GetEntitySpeed(vehicle) * 2.236936
				local gasolina = GetVehicleFuelLevel(vehicle)
				local rpm = GetVehicleCurrentRpm(vehicle) * 1000
				SendNUIMessage({ active = true, vida = (vida / 2), colete = colete, car = true, mph = parseInt(speed), gasolina = parseInt(gasolina), belt = seatbelt, dia = dayOfMonth, vdia = varday, mes = month, hora = hour, minuto = minute, voice = parseInt(voice), rpm = parseInt(rpm), compass = direction, street = street })
			else
				SendNUIMessage({ active = true, vida = (vida / 2), colete = colete, car = false, dia = dayOfMonth, vdia = varday, mes = month, hora = hour, minuto = minute, voice = parseInt(voice) })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADAR
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			--if not IsRadarEnabled() then
			DisplayRadar(true)
			--end
		else
			--if not IsEntityPlayingAnim(ped,"cellphone@","cellphone_text_in",3) then
			DisplayRadar(false)
			seatbelt = false
			--end
		end
		if IsRadarEnabled() then
			SetRadarZoom(1200)
		end
		Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
IsCar = function(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 15 and vc <= 20)
end

Fwv = function(entity)
	local hr = GetEntityHeading(entity) + 90.0
	if hr < 0.0 then
		hr = 360.0 + hr
	end
	hr = hr * 0.0174533
	return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

CreateThread(function()
	while true do

		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped)
		local idle = 500
		if car ~= 0 and (ExNoCarro or IsCar(car)) then
			idle = 5
			ExNoCarro = true
			if seatbelt and disableshuffle then
				if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
					if GetIsTaskActive(ped, 165) then
						SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
					end
				end
				DisableControlAction(0, 75)
			end

			sBuffer[2] = sBuffer[1]
			sBuffer[1] = GetEntitySpeed(car)

			if sBuffer[2] ~= nil and not seatbelt and GetEntitySpeedVector(car, true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityHealth(ped, GetEntityHealth(ped) - 100)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, vBuffer[2].x, vBuffer[2].y, vBuffer[2].z)
				TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped), 4160)
				timedown = 10
			end

			vBuffer[2] = vBuffer[1]
			vBuffer[1] = GetEntityVelocity(car)

			if IsControlJustReleased(1, 47) and IsInputDisabled(0) then
				if seatbelt then
					TriggerEvent("vrp_sound:source", "unbelt", 0.5)
					SetTimeout(1000, function()
						seatbelt = false
						TriggerEvent("cancelando", false, false)
					end)
				else
					TriggerEvent("vrp_sound:source", "belt", 0.5)
					SetTimeout(1000, function()
						seatbelt = true
						TriggerEvent("cancelando", false, false)
					end)
				end
			end
		elseif ExNoCarro then
			ExNoCarro = false
			seatbelt = false
			sBuffer[1], sBuffer[2] = 0.0, 0.0
		end
		Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMEDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(1000)
		local ped = PlayerPedId()
		if timedown > 0 and GetEntityHealth(ped) > 101 then
			timedown = timedown - 1
			if timedown == 1 then
				ClearPedTasks(ped)
				ClearPedSecondaryTask(ped)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RAGDOLL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local idle = 500
		local ped = PlayerPedId()
		if timedown > 1 and GetEntityHealth(ped) > 101 then
			idle = 1
			SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
		end
		Wait(idle)
	end
end)
--[[CreateThread(function()
	while true do
		Wait(100)
		local ped = PlayerPedId()
		if timedown > 1 and GetEntityHealth(ped) > 101 then
			if not IsEntityPlayingAnim(ped,"anim@heists@ornate_bank@hostages@hit","hit_react_die_loop_ped_a",3) then
				vRP.playAnim(false,{"anim@heists@ornate_bank@hostages@hit","hit_react_die_loop_ped_a"},true)
			end
		end
	end
end)]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local idle = 500
		if timedown > 0 then
			idle = 1
			DisableControlAction(0, 20, true)
			DisableControlAction(0, 29, true)
			DisableControlAction(0, 57, true)
			DisableControlAction(0, 105, true)
			DisableControlAction(0, 167, true)
			DisableControlAction(0, 170, true)
			DisableControlAction(0, 187, true)
			DisableControlAction(0, 188, true)
			DisableControlAction(0, 189, true)
			DisableControlAction(0, 190, true)
			DisableControlAction(0, 288, true)
			DisableControlAction(0, 289, true)
		end
		Wait(idle)
	end
end)
