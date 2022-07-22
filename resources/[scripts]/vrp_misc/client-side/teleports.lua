local Teleport = {
	["COMEDY"] = {
		positionFrom = { -430.04, 261.80, 83.00 },
		positionTo = { -458.92, 284.85, 78.52 }
	},
	["TELEFERICO"] = {
		positionFrom = { -741.06, 5593.12, 41.65 },
		positionTo = { 446.15, 5571.72, 781.18 }
	},
	["HOSPITALHELIPONTO"] = {
		positionFrom = { 338.58, -583.8, 74.17 },
		positionTo = { 332.32, -595.64, 43.29 }
	},
	["MOTOCLUB"] = {
		positionFrom = { -80.89, 214.78, 96.55 },
		positionTo = { 1120.96, -3152.57, -37.06 }
	},
	["IMOBILIARIA"] = {
		positionFrom = { -70.93, -801.04, 44.22 },
		positionTo = { -75.71, -827.08, 243.39 }
	},
	["ESCRITORIO2"] = {
		positionFrom = { -1194.46, -1189.31, 7.69 },
		positionTo = { 1173.55, -3196.68, -39.00 }
	},
	["ESCRITORIO3"] = {
		positionFrom = { -1007.12, -486.67, 39.97 },
		positionTo = { -1003.05, -477.92, 50.02 }
	},
	["ESCRITORIO4"] = {
		positionFrom = { -1913.48, -574.11, 11.43 },
		positionTo = { -1902.05, -572.42, 19.09 }
	},
	["GALAXY"] = {
		positionFrom = { -1569.42, -3017.35, -74.40 },
		positionTo = { 4.35, 220.43, 107.72 }
	},
	["WARARENAVIP"] = {
		positionFrom = { 2819.62, -3935.27, 185.84 },
		positionTo = { -253.61, -1991.89, 30.15 }
	},
}

CreateThread(function()
	while true do
		local idle = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local x, y, z = table.unpack(GetEntityCoords(ped))
			for k, v in pairs(Teleport) do
				if Vdist(v.positionFrom[1], v.positionFrom[2], v.positionFrom[3], x, y, z) <= 3 then
					idle = 5
					DrawMarker(23, v.positionFrom[1], v.positionFrom[2], v.positionFrom[3] - 0.98, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.4, 0, 255, 0, 50, 0, 0, 0, 1)
					if IsControlJustPressed(0, 38) and IsInputDisabled(0) then
						DoScreenFadeOut(1000)
						TriggerEvent("vrp_sound:source", "enterexithouse", 0.5)
						SetTimeout(1400, function()
							SetEntityCoords(ped, v.positionTo[1], v.positionTo[2], v.positionTo[3] - 0.50)
							Wait(750)
							DoScreenFadeIn(1000)
						end)
					end
				end

				if Vdist(v.positionTo[1], v.positionTo[2], v.positionTo[3], x, y, z) <= 3 then
					idle = 5
					DrawMarker(23, v.positionTo[1], v.positionTo[2], v.positionTo[3] - 0.98, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.4, 0, 255, 0, 50, 0, 0, 0, 1)
					if IsControlJustPressed(0, 38) and IsInputDisabled(0) then
						DoScreenFadeOut(1000)
						TriggerEvent("vrp_sound:source", "enterexithouse", 0.5)
						SetTimeout(1400, function()
							SetEntityCoords(ped, v.positionFrom[1], v.positionFrom[2], v.positionFrom[3] - 0.50)
							Wait(750)
							DoScreenFadeIn(1000)
						end)
					end
				end
			end
		end
		Wait(idle)
	end
end)
