-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vCLIENT = Tunnel.getInterface("chat")
-----------------------------------------------------------------------------------------------------------------------------------------
-- MESSAGEENTERED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("chat:messageEntered")
AddEventHandler("chat:messageEntered",function(message)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			TriggerClientEvent("chatText",source,"^0"..identity["name"].." "..identity["firstname"]..": "..message)

			local players = vRPC.nearestPlayers(source,10)
			if players then
				for _,v in pairs(players) do
					TriggerClientEvent("chatText",v[2],"^0"..identity["name"].." "..identity["firstname"]..": "..message)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMANDFALLBACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("__cfx_internal:commandFallback")
AddEventHandler("__cfx_internal:commandFallback",function(command)
	if not command then
		return
	end

	CancelEvent()
end)