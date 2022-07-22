-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_postit", src)
vSERVER = Tunnel.getInterface("vrp_postit")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local postits = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INIT POSTIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("postit:init")
AddEventHandler("postit:init", function(text)
	SetNuiFocus(true, true)
	SendNUIMessage({ type = "postit:init", status = true, text = text })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEND POSTIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("postit:send", function(data)
	TriggerServerEvent("postit:send", data.text)
	SetNuiFocus(false, false)
	SendNUIMessage({ type = "postit:init", status = false })
	vRP._DeletarObjeto()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ERROR POSTIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("postit:error", function(data)
	TriggerEvent("Notify", "negado", data.error)
	SetNuiFocus(false, false)
	SendNUIMessage({ type = "postit:init", status = false })
	vRP._DeletarObjeto()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXIT POSTIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("postit:exit", function(data)
	SetNuiFocus(false, false)
	SendNUIMessage({ type = "postit:init", status = false })
	vRP._DeletarObjeto()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE POSTIT
-----------------------------------------------------------------------------------------------------------------------------------------
function src.removePostits(id)
	if postits[id] ~= nil then
		postits[id] = nil
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- POSTIT PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.postitsPlayers(id, marker)
	postits[id] = marker
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- POSTIT MARKERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local idle = 500
		local ped = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(ped))
		for k, v in pairs(postits) do
			local distance = Vdist(v.x, v.y, v.z, x, y, z)
			if distance <= 10 then
				idle = 1
				DrawMarker(25, v.x, v.y, v.z - 1.0, 0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.5, 255, 0, 0, 15, 0, 0, 2, 0, 0, 0, 0)
				DrawText3Ds(v.x, v.y, v.z - 0.80, "~g~POSTIT", 300)
				if IsControlJustPressed(1, 38) and distance <= 1 and IsInputDisabled(0) then
					vSERVER.pickupPostits(k)
					vRP._CarregarObjeto("amb@world_human_clipboard@male@base", "base", "prop_notepad_01", 49, 60309, -0.05, 0.0, 0.0, 90.0, 0.0, 0.0)
				end
			end
		end
		Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x, y, z, text, size)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	SetTextFont(4)
	SetTextScale(0.35, 0.35)
	SetTextColour(255, 255, 255, 150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / size
	DrawRect(_x, _y + 0.0125, 0.01 + factor, 0.03, 0, 0, 0, 80)
end
