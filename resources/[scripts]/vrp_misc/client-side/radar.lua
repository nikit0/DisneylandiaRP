-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local radar = {
	shown = false,
	freeze = false,
	info = "INICIANDO O SISTEMA DO <b>RADAR</b> 1",
	info2 = "INICIANDO O SISTEMA DO <b>RADAR</b> 2"
}

CreateThread(function()
	while true do
		local veh = GetVehiclePedIsIn(PlayerPedId())
		if radar.shown then
			if radar.freeze == false then
				local coordA = GetOffsetFromEntityInWorldCoords(veh, 0.0, 1.0, 1.0)
				local coordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, 105.0, 0.0)
				local frontcar = StartShapeTestCapsule(coordA, coordB, 3.0, 10, veh, 7)
				local a, b, c, d, e = GetShapeTestResult(frontcar)

				if IsEntityAVehicle(e) then
					local fmodel = GetDisplayNameFromVehicleModel(GetEntityModel(e))
					local fvspeed = GetEntitySpeed(e) * 2.236936
					local fplate = GetVehicleNumberPlateText(e)
					radar.info = "<b>PLACA:</b> " .. fplate .. " <b>MODELO:</b> " .. fmodel .. " <b>VELOCIDADE:</b> MPH " .. math.ceil(fvspeed)
				end

				local bcoordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, -105.0, 0.0)
				local rearcar = StartShapeTestCapsule(coordA, bcoordB, 3.0, 10, veh, 7)
				local f, g, h, i, j = GetShapeTestResult(rearcar)

				if IsEntityAVehicle(j) then
					local bmodel = GetDisplayNameFromVehicleModel(GetEntityModel(j))
					local bvspeed = GetEntitySpeed(j) * 2.236936
					local bplate = GetVehicleNumberPlateText(j)
					radar.info2 = "<b>PLACA:</b> " .. bplate .. " <b>MODELO:</b> " .. bmodel .. " <b>VELOCIDADE:</b> MPH " .. math.ceil(bvspeed)
				end
			end
			SendNUIMessage({ radar = radar.shown, info = radar.info })
			SendNUIMessage({ radar = radar.shown, info2 = radar.info2 })
		end

		if not IsPedInAnyVehicle(PlayerPedId()) and radar.shown then
			radar.shown = false
			SendNUIMessage({ radar = radar.shown })
		end
		Wait(200)
	end
end)

CreateThread(function()
	while true do
		if IsControlJustPressed(1, 306) and IsInputDisabled(0) and IsPedInAnyPoliceVehicle(PlayerPedId()) then
			if radar.shown then
				radar.shown = false
				SendNUIMessage({ radar = radar.shown })
			else
				radar.shown = true
			end
		end

		if IsControlJustPressed(1, 301) and IsInputDisabled(0) and IsPedInAnyPoliceVehicle(PlayerPedId()) then
			if radar.freeze then
				radar.freeze = false
			else
				radar.freeze = true
			end
		end
		Wait(5)
	end
end)
