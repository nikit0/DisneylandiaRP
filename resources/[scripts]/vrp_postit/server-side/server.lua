-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_postit", src)
vCLIENT = Tunnel.getInterface("vrp_postit")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local idgens = Tools.newIDGenerator()
local postits = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEND POSTIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("postit:send")
AddEventHandler("postit:send", function(text)
	local source = source
	local user_id = vRP.getUserId(source)
	local id = idgens:gen()
	local x, y, z = vRPclient.getPosition(source)
	if id then
		exports["pd-inventory"]:consumeItem(user_id, "postit", 1, true)
		vRPclient._playAnim(source, true, { "pickup_object", "pickup_low" }, false)
		Wait(1500)
		postits[id] = { user_id = parseInt(user_id), text = text, x = x, y = y, z = z, time = 1800 }
		vCLIENT.postitsPlayers(-1, id, postits[id])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PICKUP POSTIT
-----------------------------------------------------------------------------------------------------------------------------------------
function src.pickupPostits(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, "admin.permissao") then
			TriggerClientEvent("postit:init", source, postits[id].text)
			TriggerClientEvent("Notify", source, "sucesso", "Postado pelo passaporte <b>" .. postits[id].user_id .. "</b>.", 8000)
		else
			TriggerClientEvent("postit:init", source, postits[id].text)
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- POSTIT TIMEDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(10000)
		for k, v in pairs(postits) do
			if postits[k].time > 0 then
				postits[k].time = postits[k].time - 10
				if postits[k].time <= 0 then
					postits[k] = nil
					idgens:free(k)
					vCLIENT.removePostits(-1, k)
				end
			end
		end
	end
end)
