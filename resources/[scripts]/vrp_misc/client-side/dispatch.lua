-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIAR TREM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SwitchTrainTrack(0, true)
	SwitchTrainTrack(3, true)
	N_0x21973bbf8d17edfa(0, 120000)
	SetRandomTrains(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DENSITY NPCS 2
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(1)
		SetPedDensityMultiplierThisFrame(1.0)
		SetVehicleDensityMultiplierThisFrame(0.05)
		SetSomeVehicleDensityMultiplierThisFrame(1.0)
		SetRandomVehicleDensityMultiplierThisFrame(1.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.35)
		SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIGHTS
-----------------------------------------------------------------------------------------------------------------------------------------
local lights = {
	--ROXOS
	{ 103.01, -1938.72, 30.80, 76, 6, 79, 50.0, 1.0 },
	--AMARELOS
	{ 336.98, -2042.08, 31.30, 245, 242, 5, 50.0, 1.0 },
	--VERMELHOS
	{ -183.46, -1615.13, 33.76, 155, 0, 0, 100.0, 1.0 },
	--MARABUNTAS
	--{ 1226.33,-1626.2,49.81,0,0,255,100.0,1.0 },
	--CAMPINHO
	{ 771.18, -233.62, 66.12, 255, 255, 255, 50.0, 1.0 },
}

CreateThread(function()
	while true do
		Wait(1)
		for k, v in ipairs(lights) do
			local x, y, z, r, g, b, range, intensity = table.unpack(v)
			if GetClockHours() > 20 or GetClockHours() < 6 then
				DrawLightWithRangeAndShadow(x, y, z, r, g, b, range, intensity, 0.1)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPATCH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for i = 1, 120 do
		EnableDispatchService(i, false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIMINUIR DANO X NA MOTO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local idle = 500
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			SetPedConfigFlag(PlayerPedId(), 35, false)
			idle = 1
			local vehicle = GetVehiclePedIsIn(ped)
			if (GetPedInVehicleSeat(vehicle, -1) == ped or GetPedInVehicleSeat(vehicle, 0) == ped) and GetVehicleClass(vehicle) == 8 then
				N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.02)
			end
		else
			N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.8)
		end
		Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESABILITAR A CORONHADA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local idle = 500
		local ped = PlayerPedId()
		if IsPedArmed(ped, 6) then
			idle = 1
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
		else
			DisableControlAction(0, 140, true)
		end
		Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVER ARMA ABAIXO DE 40MPH DENTRO DO CARRO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(1000)
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				local speed = GetEntitySpeed(vehicle) * 2.236936
				if speed >= 40 then
					SetPlayerCanDoDriveBy(PlayerId(), false)
				else
					SetPlayerCanDoDriveBy(PlayerId(), true)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTOURAR OS PNEUS SE O CARRO CAPOTAR
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local veh = GetVehiclePedIsUsing(PlayerPedId())
		local roll = GetEntityRoll(veh)
		if roll > 75.0 or roll < -75.0 then
			if GetVehicleClass(veh) ~= 8 and GetVehicleClass(veh) ~= 13 then
				local tyre = math.random(4)
				if math.random(100) <= 90 then
					if tyre == 1 then
						if not IsVehicleTyreBurst(veh, 0, false) then
							SetVehicleTyreBurst(veh, 0, true, 1000.0)
						end
					elseif tyre == 2 then
						if not IsVehicleTyreBurst(veh, 1, false) then
							SetVehicleTyreBurst(veh, 1, true, 1000.0)
						end
					elseif tyre == 3 then
						if not IsVehicleTyreBurst(veh, 4, false) then
							SetVehicleTyreBurst(veh, 4, true, 1000.0)
						end
					elseif tyre == 4 then
						if not IsVehicleTyreBurst(veh, 5, false) then
							SetVehicleTyreBurst(veh, 5, true, 1000.0)
						end
					end
				end
			end
		end
		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIFT
-----------------------------------------------------------------------------------------------------------------------------------------
local activated = false
CreateThread(function()
	while true do
		Wait(1)
		local ped = PlayerPedId()
		veh = GetVehiclePedIsIn(ped, false)
		if IsControlJustPressed(0, 21) and IsPedInAnyVehicle(ped, false) and not activated and IsInputDisabled(0) then
			if GetPedInVehicleSeat(veh, -1) == ped and IsVehicleOnAllWheels(veh) then
				if (GetVehicleClass(veh) >= 0 and GetVehicleClass(veh) <= 7) or GetVehicleClass(veh) == 9 then
					if GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDragCoeff") < 50.0 then
						activated = true
						DriftEnable()
					end
				end
			end
		end
		if IsControlJustReleased(0, 21) and IsPedInAnyVehicle(ped, false) and activated and IsInputDisabled(0) then
			if GetPedInVehicleSeat(veh, -1) == ped and IsVehicleOnAllWheels(veh) then
				if (GetVehicleClass(veh) >= 0 and GetVehicleClass(veh) <= 7) or GetVehicleClass(veh) == 9 then
					if GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDragCoeff") >= 50.0 then
						activated = false
						DriftDisable()
					end
				end
			end
		end
		if veh ~= GetVehiclePedIsIn(ped, true) and activated then
			activated = false
			veh = GetVehiclePedIsIn(ped, true)
			DriftDisable()
		end
	end
end)

function DriftEnable()
	SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDragCoeff", GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDragCoeff") + 90.22)
	if GetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront") == 0.0 then
		SetVehicleEnginePowerMultiplier(veh, 190.0)
	else
		SetVehicleEnginePowerMultiplier(veh, 100.0)
	end
	SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", GetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia") + 0.31)
	SetVehicleHandlingFloat(veh, "CHandlingData", "fSteeringLock", GetVehicleHandlingFloat(veh, "CHandlingData", "fSteeringLock") + 25.0)
	SetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMax", GetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMax") - 1.1)
	SetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMin", GetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMin") - 0.4)
	SetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveLateral", GetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveLateral") + 2.5)
	SetVehicleHandlingFloat(veh, "CHandlingData", "fLowSpeedTractionLossMult", GetVehicleHandlingFloat(veh, "CHandlingData", "fLowSpeedTractionLossMult") - 0.57)
end

function DriftDisable()
	SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDragCoeff", GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDragCoeff") - 90.22)
	SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", GetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia") - 0.31)
	SetVehicleHandlingFloat(veh, "CHandlingData", "fSteeringLock", GetVehicleHandlingFloat(veh, "CHandlingData", "fSteeringLock") - 25.0)
	SetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMax", GetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMax") + 1.1)
	SetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMin", GetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMin") + 0.4)
	SetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveLateral", GetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveLateral") - 2.5)
	SetVehicleHandlingFloat(veh, "CHandlingData", "fLowSpeedTractionLossMult", GetVehicleHandlingFloat(veh, "CHandlingData", "fLowSpeedTractionLossMult") + 0.57)
	SetVehicleEnginePowerMultiplier(veh, 0.0)
	SetVehicleModKit(veh, 0)
	SetVehicleMod(veh, 11, GetVehicleMod(veh, 11), true)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {
	{ 265.64, -1261.30, 29.29, 361, 41, "Posto de Gasolina", 0.4 },
	{ 819.65, -1028.84, 26.40, 361, 41, "Posto de Gasolina", 0.4 },
	{ 1208.95, -1402.56, 35.22, 361, 41, "Posto de Gasolina", 0.4 },
	{ 1181.38, -330.84, 69.31, 361, 41, "Posto de Gasolina", 0.4 },
	{ 620.84, 269.10, 103.08, 361, 41, "Posto de Gasolina", 0.4 },
	{ 2581.32, 362.03, 108.46, 361, 41, "Posto de Gasolina", 0.4 },
	{ 176.63, -1562.02, 29.26, 361, 41, "Posto de Gasolina", 0.4 },
	{ 176.63, -1562.02, 29.26, 361, 41, "Posto de Gasolina", 0.4 },
	{ -319.29, -1471.71, 30.54, 361, 41, "Posto de Gasolina", 0.4 },
	{ 1784.32, 3330.55, 41.25, 361, 41, "Posto de Gasolina", 0.4 },
	{ 49.418, 2778.79, 58.04, 361, 41, "Posto de Gasolina", 0.4 },
	{ 263.89, 2606.46, 44.98, 361, 41, "Posto de Gasolina", 0.4 },
	{ 1039.95, 2671.13, 39.55, 361, 41, "Posto de Gasolina", 0.4 },
	{ 1207.26, 2660.17, 37.89, 361, 41, "Posto de Gasolina", 0.4 },
	{ 2539.68, 2594.19, 37.94, 361, 41, "Posto de Gasolina", 0.4 },
	{ 2679.85, 3263.94, 55.24, 361, 41, "Posto de Gasolina", 0.4 },
	{ 2005.05, 3773.88, 32.40, 361, 41, "Posto de Gasolina", 0.4 },
	{ 1687.15, 4929.39, 42.07, 361, 41, "Posto de Gasolina", 0.4 },
	{ 1701.31, 6416.02, 32.76, 361, 41, "Posto de Gasolina", 0.4 },
	{ 179.85, 6602.83, 31.86, 361, 41, "Posto de Gasolina", 0.4 },
	{ -94.46, 6419.59, 31.48, 361, 41, "Posto de Gasolina", 0.4 },
	{ -2554.99, 2334.40, 33.07, 361, 41, "Posto de Gasolina", 0.4 },
	{ -1800.37, 803.66, 138.65, 361, 41, "Posto de Gasolina", 0.4 },
	{ -1437.62, -276.74, 46.20, 361, 41, "Posto de Gasolina", 0.4 },
	{ -2096.24, -320.28, 13.16, 361, 41, "Posto de Gasolina", 0.4 },
	{ -724.61, -935.16, 19.21, 361, 41, "Posto de Gasolina", 0.4 },
	{ -526.01, -1211.00, 18.18, 361, 41, "Posto de Gasolina", 0.4 },
	{ -70.21, -1761.79, 29.53, 361, 41, "Posto de Gasolina", 0.4 },
	{ 55.43, -876.19, 30.66, 357, 0, "Garagem", 0.4 },
	{ 317.25, 2623.14, 44.46, 357, 0, "Garagem", 0.4 },
	{ -773.34, 5598.15, 33.60, 357, 0, "Garagem", 0.4 },
	{ 596.40, 90.65, 93.12, 357, 0, "Garagem", 0.4 },
	{ -340.76, 265.97, 85.67, 357, 0, "Garagem", 0.4 },
	{ -2030.01, -465.97, 11.60, 357, 0, "Garagem", 0.4 },
	{ -1184.92, -1510.00, 4.64, 357, 0, "Garagem", 0.4 },
	{ -73.44, -2004.99, 18.27, 357, 0, "Garagem", 0.4 },
	{ 214.02, -808.44, 31.01, 357, 0, "Garagem", 0.4 },
	{ -348.88, -874.02, 31.31, 357, 0, "Garagem", 0.4 },
	{ 67.74, 12.27, 69.21, 357, 0, "Garagem", 0.4 },
	{ 361.90, 297.81, 103.88, 357, 0, "Garagem", 0.4 },
	{ 1156.90, -453.73, 66.98, 357, 0, "Garagem", 0.4 },
	{ 275.17, -345.5, 45.18, 357, 0, "Garagem", 0.4 },
	{ -102.21, 6345.18, 31.57, 357, 0, "Garagem", 0.4 },
	{ -1065.23, -850.06, 5.05, 60, 0, "Departamento Policial", 0.5 },
	{ 1851.45, 3686.71, 34.26, 60, 0, "Departamento Policial", 0.5 },
	{ -448.18, 6011.68, 31.71, 60, 0, "Departamento Policial", 0.5 },
	{ -1034.68, -855.1, 5.06, 60, 29, "Pátio da Policia", 0.5 },
	{ 25.65, -1346.58, 29.49, 52, 4, "Loja de Departamentos", 0.5 },
	{ 2556.75, 382.01, 108.62, 52, 4, "Loja de Departamentos", 0.5 },
	{ 1163.54, -323.04, 69.20, 52, 4, "Loja de Departamentos", 0.5 },
	{ -707.37, -913.68, 19.21, 52, 4, "Loja de Departamentos", 0.5 },
	{ -47.73, -1757.25, 29.42, 52, 4, "Loja de Departamentos", 0.5 },
	{ 373.90, 326.91, 103.56, 52, 4, "Loja de Departamentos", 0.5 },
	{ -3243.10, 1001.23, 12.83, 52, 4, "Loja de Departamentos", 0.5 },
	{ 1729.38, 6415.54, 35.03, 52, 4, "Loja de Departamentos", 0.5 },
	{ 547.90, 2670.36, 42.15, 52, 4, "Loja de Departamentos", 0.5 },
	{ 1960.75, 3741.33, 32.34, 52, 4, "Loja de Departamentos", 0.5 },
	{ 2677.90, 3280.88, 55.24, 52, 4, "Loja de Departamentos", 0.5 },
	{ 1698.45, 4924.15, 42.06, 52, 4, "Loja de Departamentos", 0.5 },
	{ -1820.93, 793.18, 138.11, 52, 4, "Loja de Departamentos", 0.5 },
	{ 1392.46, 3604.95, 34.98, 52, 4, "Loja de Departamentos", 0.5 },
	{ -2967.82, 390.93, 15.04, 52, 4, "Loja de Departamentos", 0.5 },
	{ -3040.10, 585.44, 7.90, 52, 4, "Loja de Departamentos", 0.5 },
	{ 1135.56, -982.20, 46.41, 52, 4, "Loja de Departamentos", 0.5 },
	{ 1165.91, 2709.41, 38.15, 52, 4, "Loja de Departamentos", 0.5 },
	{ -1487.18, -379.02, 40.16, 52, 4, "Loja de Departamentos", 0.5 },
	{ -1222.78, -907.22, 12.32, 52, 4, "Loja de Departamentos", 0.5 },
	{ -560.17, 286.79, 82.17, 93, 4, "Bar", 0.5 },
	{ 128.11, -1284.99, 29.27, 93, 4, "Bar", 0.5 },
	{ 1985.80, 3053.68, 47.21, 93, 4, "Bar", 0.5 },
	{ -430.04, 261.80, 83.00, 93, 4, "Bar", 0.5 },
	{ -80.89, 214.78, 96.55, 93, 4, "Bar", 0.5 },
	{ 224.60, -1511.02, 29.29, 93, 4, "Bar", 0.5 },
	{ -1387.82, -587.80, 30.31, 93, 4, "Bar", 0.5 },
	{ 285.37, -587.86, 43.37, 80, 49, "Hospital", 0.5 },
	{ -248.14, 6332.97, 32.42, 80, 49, "Hospital", 0.5 },
	{ 75.40, -1392.92, 29.37, 73, 4, "Loja de Roupas", 0.5 },
	{ -709.40, -153.66, 37.41, 73, 4, "Loja de Roupas", 0.5 },
	{ -163.20, -302.03, 39.73, 73, 4, "Loja de Roupas", 0.5 },
	{ 425.58, -806.23, 29.49, 73, 4, "Loja de Roupas", 0.5 },
	{ -822.34, -1073.49, 11.32, 73, 4, "Loja de Roupas", 0.5 },
	{ -1193.81, -768.49, 17.31, 73, 4, "Loja de Roupas", 0.5 },
	{ -1450.85, -238.15, 49.81, 73, 4, "Loja de Roupas", 0.5 },
	{ 4.90, 6512.47, 31.87, 73, 4, "Loja de Roupas", 0.5 },
	{ 1693.95, 4822.67, 42.06, 73, 4, "Loja de Roupas", 0.5 },
	{ 126.05, -223.10, 54.55, 73, 4, "Loja de Roupas", 0.5 },
	{ 614.26, 2761.91, 42.08, 73, 4, "Loja de Roupas", 0.5 },
	{ 1196.74, 2710.21, 38.22, 73, 4, "Loja de Roupas", 0.5 },
	{ -3170.18, 1044.54, 20.86, 73, 4, "Loja de Roupas", 0.5 },
	{ -1101.46, 2710.57, 19.10, 73, 4, "Loja de Roupas", 0.5 },
	{ 1692.62, 3759.50, 34.70, 76, 4, "Loja de Armamentos", 0.4 },
	{ 252.89, -49.25, 69.94, 76, 4, "Loja de Armamentos", 0.4 },
	{ 843.28, -1034.02, 28.19, 76, 4, "Loja de Armamentos", 0.4 },
	{ -331.35, 6083.45, 31.45, 76, 4, "Loja de Armamentos", 0.4 },
	{ -663.15, -934.92, 21.82, 76, 4, "Loja de Armamentos", 0.4 },
	{ -1305.18, -393.48, 36.69, 76, 4, "Loja de Armamentos", 0.4 },
	{ -1118.80, 2698.22, 18.55, 76, 4, "Loja de Armamentos", 0.4 },
	{ 2568.83, 293.89, 108.73, 76, 4, "Loja de Armamentos", 0.4 },
	{ -3172.68, 1087.10, 20.83, 76, 4, "Loja de Armamentos", 0.4 },
	{ 21.32, -1106.44, 29.79, 76, 4, "Loja de Armamentos", 0.4 },
	{ 811.19, -2157.67, 29.61, 76, 4, "Loja de Armamentos", 0.4 },
	{ -815.59, -182.16, 37.56, 71, 4, "Salão de Beleza", 0.5 },
	{ 139.21, -1708.96, 29.30, 71, 4, "Salão de Beleza", 0.5 },
	{ -1282.00, -1118.86, 7.00, 71, 4, "Salão de Beleza", 0.5 },
	{ 1934.11, 3730.73, 32.85, 71, 4, "Salão de Beleza", 0.5 },
	{ 1211.07, -475.00, 66.21, 71, 4, "Salão de Beleza", 0.5 },
	{ -34.97, -150.90, 57.08, 71, 4, "Salão de Beleza", 0.5 },
	{ -280.37, 6227.01, 31.70, 71, 4, "Salão de Beleza", 0.5 },
	{ -1213.44, -331.02, 37.78, 207, 0, "Banco", 0.5 },
	{ -351.59, -49.68, 49.04, 207, 0, "Banco", 0.5 },
	{ 235.12, 216.84, 106.28, 207, 0, "Banco", 0.5 },
	{ 313.47, -278.81, 54.17, 207, 0, "Banco", 0.5 },
	{ 149.35, -1040.53, 29.37, 207, 0, "Banco", 0.5 },
	{ -2962.60, 482.17, 15.70, 207, 0, "Banco", 0.5 },
	{ -112.81, 6469.91, 31.62, 207, 0, "Banco", 0.5 },
	{ 1175.74, 2706.80, 38.09, 207, 0, "Banco", 0.5 },
	{ 1322.64, -1651.97, 52.27, 75, 4, "Tatuagens", 0.4 },
	{ -1153.67, -1425.68, 4.95, 75, 4, "Tatuagens", 0.4 },
	{ 322.13, 180.46, 103.58, 75, 4, "Tatuagens", 0.4 },
	{ -3170.07, 1075.05, 20.82, 75, 4, "Tatuagens", 0.4 },
	{ 1864.63, 3747.73, 33.03, 75, 4, "Tatuagens", 0.4 },
	{ -293.71, 6200.04, 31.48, 75, 4, "Tatuagens", 0.4 },
	{ 336.96, 176.14, 103.16, 135, 4, "Cinema", 0.4 },
	{ -1612.35, -1180.02, 0.31, 266, 4, "Embarcações", 0.5 },
	{ -1522.91, 1501.84, 110.65, 266, 4, "Embarcações", 0.5 },
	{ 1336.21, 4278.94, 31.05, 266, 4, "Embarcações", 0.5 },
	{ -183.69, 795.89, 197.35, 266, 4, "Embarcações", 0.5 },
	{ -803.62, -224.19, 37.23, 225, 4, "Concessionária", 0.4 },
	{ -305.31, 6118.07, 31.5, 225, 4, "Concessionária", 0.4 },
	{ -69.41, 62.85, 71.9, 225, 3, "Concessionária VIP", 0.4 },
	{ 938.35, -969.75, 39.8, 402, 17, "Mecânica", 0.7 },
	{ 110.6, 6625.94, 31.79, 402, 17, "Mecânica", 0.7 },
	{ 1769.07, 3330.31, 41.44, 402, 17, "Mecânica", 0.7 },
	{ -70.93, -801.04, 44.22, 408, 4, "Imobiliária", 0.5 },
	{ -1194.45, -1189.33, 7.69, 408, 4, "Escritório", 0.5 },
	{ -1007.12, -486.67, 39.97, 408, 4, "Escritório", 0.5 },
	{ -1913.48, -574.11, 11.43, 408, 4, "Escritório", 0.5 },
	{ 242.99, -392.82, 46.31, 79, 0, "Tribunal", 0.4 },
	{ 1054.88, -501.88, 62.96, 120, 0, "Bairro Lucas Samir", 0.5 },
	-- { 1874.57,276.49,165.53,84,59,"Vermelhos",0.5 },
	-- { 1475.85,-112.63,142.86,84,46,"Amarelos",0.5 },
	-- { 2070.16,-4.74,213.07,84,27,"Roxos",0.5 },
	{ -1816.72, -1193.83, 14.30, 68, 13, "Central | Pescadores", 0.5 },
	{ -1097.51, -2506.22, 15.46, 67, 13, "Central | Carteiros", 0.5 },
	{ -421.66, 6137.39, 31.88, 67, 13, "Central | Carteiros", 0.5 },
	{ -349.84, -1569.79, 25.22, 318, 13, "Central | Lixeiros", 0.5 },
	{ 909.34, -177.30, 74.21, 198, 13, "Central | Taxistas", 0.5 },
	{ -33.23, 6455.41, 31.48, 198, 13, "Central | Taxistas", 0.5 },
	{ 455.15, -601.45, 28.53, 513, 13, "Central | Motoristas", 0.5 },
	{ -199.97, 6234.33, 31.51, 513, 13, "Central | Motoristas", 0.5 },
	{ 1218.74, -1266.87, 36.42, 285, 13, "Central | Lenhadores", 0.5 },
	{ 173.10, -26.04, 68.34, 499, 13, "Central | Leiteiros", 0.5 },
	{ -421.75, -2171.22, 11.33, 310, 13, "Central | Contrabandistas", 0.5 },
	-- { -287.81,-1062.71,27.20,458,13,"Central | Assassinos",0.5 },
	{ -399.25, 4711.35, 264.88, 442, 13, "Central | Caçadores", 0.5 },
	{ 1054.13, -1952.76, 32.09, 477, 13, "Central | Mineradores", 0.5 },
	{ 1240.15, -3173.54, 7.10, 477, 13, "Central | Caminhoneiro", 0.5 },
	{ 751.89, 6458.85, 31.53, 479, 13, "Central | Fazendeiros", 0.5 },
	{ -741.05, 5593.12, 41.65, 36, 4, "Teleférico", 0.5 },
	{ 562.38, 2741.57, 42.87, 273, 4, "PetShop", 0.4 },
	{ -5853.25, 1151.59, 7.61, 197, 48, "Ilha dos Solteiros", 0.5 },
	{ -658.1, -857.51, 24.5, 459, 4, "Eletrônicos", 0.6 },
	{ 93.28, -230.01, 54.67, 403, 4, "Farmácia", 0.6 },
}

CreateThread(function()
	for _, v in pairs(blips) do
		local blip = AddBlipForCoord(v[1], v[2], v[3])
		SetBlipSprite(blip, v[4])
		SetBlipAsShortRange(blip, true)
		SetBlipColour(blip, v[5])
		SetBlipScale(blip, v[7])
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v[6])
		EndTextCommandSetBlipName(blip)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASERTIME
-----------------------------------------------------------------------------------------------------------------------------------------
local tasertime = false
CreateThread(function()
	while true do
		Wait(100)
		local ped = PlayerPedId()
		if IsPedBeingStunned(ped) then
			SetPedToRagdoll(ped, 10000, 10000, 0, 0, 0, 0)
		end

		if IsPedBeingStunned(ped) and not tasertime then
			tasertime = true
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
		elseif not IsPedBeingStunned(ped) and tasertime then
			tasertime = false
			SetTimeout(5000, function()
				SetTimecycleModifier("hud_def_desat_Trevor")
				SetTimeout(10000, function()
					SetTimecycleModifier("")
					SetTransitionTimecycleModifier("")
					StopGameplayCamShaking()
				end)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKLIST WEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
blackWeapons = {
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_FLAREGUN",
	"WEAPON_MARKSMANPISTOL",
	--"WEAPON_REVOLVER_MK2",
	"WEAPON_DOUBLEACTION",
	--"WEAPON_RAYPISTOL",
	"WEAPON_SMG_MK2",
	--"WEAPON_MACHINEPISTOL",
	"WEAPON_MINISMG",
	"WEAPON_RAYCARBINE",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_ASSAULTSHOTGUN",
	"WEAPON_BULLPUPSHOTGUN",
	"WEAPON_HEAVYSHOTGUN",
	"WEAPON_DBSHOTGUN",
	"WEAPON_AUTOSHOTGUN",
	"WEAPON_ASSAULTRIFLE_MK2",
	--"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_BULLPUPRIFLE_MK2",
	--"WEAPON_COMPACTRIFLE",
	"WEAPON_MG",
	"WEAPON_COMBATMG",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_SNIPERRIFLE",
	"WEAPON_HEAVYSNIPER",
	--"WEAPON_HEAVYSNIPER_MK2",
	"WEAPON_MARKSMANRIFLE",
	"WEAPON_MARKSMANRIFLE_MK2",
	--"WEAPON_RPG",
	"WEAPON_GRENADELAUNCHER",
	"WEAPON_GRENADELAUNCHER_SMOKE",
	"WEAPON_MINIGUN",
	--"WEAPON_FIREWORK",
	"WEAPON_RAILGUN",
	"WEAPON_HOMINGLAUNCHER",
	"WEAPON_COMPACTLAUNCHER",
	"WEAPON_RAYMINIGUN",
	"WEAPON_GRENADE",
	--"WEAPON_BZGAS",
	"WEAPON_MOLOTOV",
	--"WEAPON_STICKYBOMB",
	"WEAPON_PROXMINE",
	"WEAPON_PIPEBOMB",
	--"WEAPON_BALL",
	--"WEAPON_SNOWBALL",
	"WEAPON_SMOKEGRENADE"
}

CreateThread(function()
	while true do
		Wait(1000)
		for k, v in ipairs(blackWeapons) do
			if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(v) then
				RemoveWeaponFromPed(PlayerPedId(), GetHashKey(v))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DAMAGE WALK MODE
-----------------------------------------------------------------------------------------------------------------------------------------
local hurt = false
CreateThread(function()
	while true do
		Wait(500)
		local ped = PlayerPedId()
		if not IsEntityInWater(ped) then
			if GetEntityHealth(ped) <= 149 then
				setHurt()
			elseif hurt and GetEntityHealth(ped) >= 150 then
				setNotHurt()
			end
		end
	end
end)

function setHurt()
	hurt = true
	RequestAnimSet("move_m@injured")
	SetPedMovementClipset(PlayerPedId(), "move_m@injured", true)
	SetTimecycleModifier("damage")
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
	DisableControlAction(0, 21)
	DisableControlAction(0, 22)
end

function setNotHurt()
	hurt = false
	SetTimecycleModifier("")
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
	ResetPedMovementClipset(PlayerPedId(), 0.0)
	ResetPedWeaponMovementClipset(PlayerPedId())
	ResetPedStrafeClipset(PlayerPedId())
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COOLDOWN BUNNYHOP
-----------------------------------------------------------------------------------------------------------------------------------------
local bunnyhop = 0
CreateThread(function()
	while true do
		Wait(5000)
		if bunnyhop > 0 then
			bunnyhop = bunnyhop - 5
		end
	end
end)

CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if IsPedJumping(ped) and bunnyhop <= 0 then
			bunnyhop = 5
		end
		if bunnyhop > 0 then
			DisableControlAction(0, 22, true)
		end
		Wait(5)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COOLDOWN MELEE COMBAT
-----------------------------------------------------------------------------------------------------------------------------------------
local melee = 0
CreateThread(function()
	while true do
		Wait(3000)
		if melee > 0 then
			melee = melee - 3
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1)
		local ped = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(ped))
		if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") then
			if IsShockingEventInSphere(112, x, y, z, 1.0) then
				melee = 3
				if melee > 0 then
					DisableControlAction(0, 24, true)
				end
			end
		end
	end
end)
